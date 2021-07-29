//
//  MapVC.swift
//  GraphPOC
//
//  Created by BitCot Technologies on 28/07/21.
//

import UIKit
import GoogleMaps
import Toast_Swift

class MapVC: UIViewController {
    typealias complitionhandler = () -> Void
    //MARK: Outlets
    @IBOutlet weak var vwMap: GMSMapView!
    @IBOutlet weak var flagView: UIView!
    @IBOutlet var lblFlags:[UILabel]?
    
    //MARK: Variables
    let nib = UINib(nibName: "CustomMarkerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomMarkerView
    var tappedMarker = GMSMarker()
    var appData = AppData.sharedInstance
    var markerData: CLLocationCoordinate2D?
    var placeMark: CLPlacemark!
    let geoCoder = CLGeocoder()
    var arrFlag = [String]()
    var count = Int()
    var complitionhandler:complitionhandler?
    var zoom = Float(4)
    var markerCountryData = [Covid]()
    var selectedFullData = FullData()
    var totalCovidData = [FullData]()
    var delegate: UpdateProtocol?
    var selectedCountry: Country?
    var arrCountries: [Country]?
    override var shouldAutorotate: Bool {
        self.nib.removeFromSuperview()
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscapeLeft,.landscapeRight,.portrait]
    }
    
    //MARK: Default Function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //MARK: Actions
    @IBAction func btnBackAction(_ sender: UIButton){
        self.dismiss(animated: true){
            self.delegate?.dataFor(self.arrCountries ?? [])
        }
    }
    
    @IBAction func bntListAction(_ sender: UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "SelectedCovidDataVC") as! SelectedCovidDataVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func btnAddAction(_ sender: UIButton){
        if !self.arrFlag.contains(self.flag(from: self.markerCountryData.last?.CountryCode ?? "🏳️")){
            self.setflagInsideArray(self.markerCountryData.last?.CountryCode ?? "🏳️")
            self.view.makeToast("Add country")
        }else{
            self.view.makeToast("already exist")
        }
    }
    
    //MARK: Functions
    fileprivate func configureUI() {
        print(totalCovidData)
        for index in 0...5{
            print(self.flag(from: self.totalCovidData[safe: index]?.covidData?.last?.CountryCode ?? "🏳️"))
            if  self.totalCovidData[safe: index] != nil{
                self.arrFlag.append(self.flag(from: self.totalCovidData[safe: index]?.covidData?.last?.CountryCode ?? "🏳️"))
            }else{
                self.arrFlag.append("🏳️")
            }
        }
        self.setFlag(self.arrFlag)
        self.showProgress(message: "loading....")
        self.flagView.addShadow(color: #colorLiteral(red: 0.02548495308, green: 0.02617123723, blue: 0.1849866807, alpha: 1))
        self.flagView.addCornerRadius(radius: 6.0)
    }
    
}

//MARK:  GMSMapViewDelegate
extension MapVC: GMSMapViewDelegate{
    func setMap(){
        self.appData.countries?.forEach { Country in
            self.vwMap.animate(toZoom: self.zoom)
            if let data = getCountriesCordinates.sharedInstanse.dic[Country.ISO2 ?? ""] {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude:data.latitude, longitude: data.longitude)
                marker.title = Country.name
                marker.userData = data
                DispatchQueue.main.async {
                    marker.map = self.vwMap
                }
            }
        }
    }
    //empty the default infowindow
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
    // reset custom infowindow whenever marker is tapped
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.nib.removeFromSuperview()
        self.markerData = marker.userData as? CLLocationCoordinate2D
        let location = CLLocation(latitude: self.markerData?.latitude ?? 0.0, longitude: self.markerData?.longitude ?? 0.0)
        self.setMarkerOnMap(location, marker)
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        guard let data = self.markerData else {return}
        let location = CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            self.nib.center = mapView.projection.point(for: location)
        })
        self.zoom = mapView.camera.zoom
    }
    
    // take care of the close event
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.nib.removeFromSuperview()
    }
    
    func setMarkerOnMap(_ location: CLLocation, _ marker: GMSMarker){
        geoCoder.reverseGeocodeLocation(location, completionHandler: {  (placemarks, error) -> Void in
            guard let index = self.appData.countries?.firstIndex(where: { Country in
                if Country.ISO2 ==  placemarks?[0].isoCountryCode{return true}else{return false}
            })else{return}
            if let data = self.appData.countries?[index]{
                self.vwMap.camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: self.zoom)
                self.vwMap.animate(toZoom: self.zoom)
                self.showProgress(message: "loading...")
                self.appData.getCovidData(by: data) { covidData in
                    self.markerCountryData = covidData?.covidData ?? []
                    self.selectedFullData = covidData ?? FullData()
                    self.nib.setCustomMarkerViewdata(self.markerCountryData)
                    self.nib.btnAddIntoList.addTarget(self, action: #selector(self.btnAddAction(_:)), for: .touchUpInside)
                    self.view.addSubview(self.nib)
                }
            }
            self.selectedCountry = self.appData.countries?[index]
        })
    }
    
    func setflagInsideArray(_ code: String){
        if self.count <= 4{
            self.arrFlag.remove(at: self.count)
            self.arrCountries?.remove(at: self.count)
          
            if self.markerCountryData.last?.CountryCode == nil{
                self.arrFlag.insert("🏳️", at: self.count)
            }else{
                self.arrFlag.insert(self.flag(from: code), at: self.count)
                self.arrCountries?.insert(self.selectedCountry!, at: self.count)
            }
            self.count += 1
        }else{
            self.count = 0
            self.arrFlag.remove(at: self.count)
            self.arrCountries?.remove(at: self.count)
            self.arrCountries?.insert(self.selectedCountry!, at: self.count)
            self.arrFlag.insert(self.flag(from: self.markerCountryData.last?.CountryCode ?? "🏳️"), at: self.count)
            self.count += 1
        }
        self.setFlag(self.arrFlag)
    }
    
    func setFlag(_ arr: [String]) {
        var index = 0
        for flag in arr.prefix(5){
            self.lblFlags?[index].text = flag
            index += 1
        }
        index = 0
       
    }
   
}

