//
//  MapVC.swift
//  GraphPOC
//
//  Created by BitCot Technologies on 28/07/21.
//

import UIKit
import GoogleMaps
import Toast_Swift
import SDLoader


class MapVC: UIViewController {
    typealias complitionhandler = () -> Void
    //MARK: Outlets
    @IBOutlet weak var vwMap: GMSMapView!
    @IBOutlet weak var flagView: UIView!
    @IBOutlet var lblFlags:[UILabel]?
    
    //MARK: Variables
    let nib = UINib(nibName: "CustomMarkerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomMarkerView
    let sdLoader = SDLoader()
    var tappedMarker = GMSMarker()
    var appData = AppData.sharedInstance
    var markerData: [String]?
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
        self.sdLoader.startAnimating(atView: self.view)
//        self.showProgress(message: "loading....")
        configureUI()
        setMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    override func loadView() {
        super.loadView()
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "Style", withExtension: "json") {
                self.vwMap.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
                self.showErrorAlertWithMsg(msg: "Unable to find style.json")
            }
        } catch {
            self.showErrorAlertWithMsg(msg: "One or more of the map styles failed to load. \(error)")
            NSLog("One or more of the map styles failed to load. \(error)")
        }

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
            self.nib.btnAddIntoList.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.2976702217)
            self.nib.btnAddIntoList.isUserInteractionEnabled = false
            self.view.makeToast("Add country")
        }else{
            self.view.makeToast("already exist")
        }
    }
}

//MARK: Functions
extension MapVC{
    fileprivate func configureUI() {
        var isNilFirstIndex = false
        for index in 0...4{
            print(self.flag(from: self.totalCovidData[safe: index]?.covidData?.last?.CountryCode ?? "🏳️"))
            if  self.totalCovidData[safe: index] != nil{
                self.arrFlag.append(self.flag(from: self.totalCovidData[safe: index]?.covidData?.last?.CountryCode ?? "🏳️"))
            }else{
                if !isNilFirstIndex{
                    self.count = index
                    isNilFirstIndex = true
                }
                self.arrFlag.append("🏳️")
            }
        }
        self.setFlag(self.arrFlag)
        self.flagView.addShadow(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        self.flagView.addCornerRadius(radius: 6.0)
    }
    
    func getIsoGodeFromlocal(_ marker: GMSMarker, index: Int){
        if let data = self.appData.countries?[index]{
            self.vwMap.camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: self.zoom)
            self.vwMap.animate(toZoom: self.zoom)
            self.showProgress(message: "loading...")
            self.appData.getCovidData(by: data) { covidData in
                
                print(covidData?.country?.countryFlag)
                self.markerCountryData = covidData?.covidData ?? []
                self.selectedFullData = covidData ?? FullData()
                self.setColorAddButtonOnMap()
                self.nib.setCustomMarkerViewdata(self.markerCountryData)
                self.nib.btnAddIntoList.addTarget(self, action: #selector(self.btnAddAction(_:)), for: .touchUpInside)
                self.view.addSubview(self.nib)
            }
        }
        self.selectedCountry = self.appData.countries?[index]
    }
    
    func setColorAddButtonOnMap(){
        let _ =  self.arrCountries?.contains(where: { Country in
            if Country.ISO2 == self.markerCountryData.last?.CountryCode{
                self.nib.btnAddIntoList.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.2001211984)
                self.nib.btnAddIntoList.isUserInteractionEnabled = false
                return true
            }else{
                self.nib.btnAddIntoList.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
                self.nib.btnAddIntoList.isUserInteractionEnabled = true
                return false
            }
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

//MARK:  GMSMapViewDelegate
extension MapVC: GMSMapViewDelegate{
    func setMap(){
        self.appData.countries!.forEach { Country in
            self.vwMap.animate(toZoom: self.zoom)
            if let data = getCountriesCordinates.sharedInstanse.dic[Country.ISO2 ?? ""] {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude:data.latitude, longitude: data.longitude)
                DispatchQueue.main.async{
                    print(self.appData.countryFlags)
                 let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                    lbl.backgroundColor = .clear
                    lbl.text = self.flag(from: Country.ISO2 ?? "")
                    lbl.textAlignment = .center
                    marker.iconView = lbl
                marker.accessibilityValue = "\(data)"
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
        let cordinate = marker.accessibilityValue?.replacingOccurrences(of: "CLLocationCoordinate2D(latitude: ", with: "").replacingOccurrences(of: " longitude: ", with: "").replacingOccurrences(of: ")", with: "")
        let split = cordinate?.components(separatedBy: ",")
        self.nib.removeFromSuperview()
        self.markerData = split
        let location = CLLocation(latitude: split?[0].toDouble() ?? 0.0, longitude: split?[1].toDouble() ?? 0.0)
        self.setMarkerOnMap(location, marker)
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        defer{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.sdLoader.stopAnimation()
            }
        }
        let location = CLLocationCoordinate2D(latitude: self.markerData?[0].toDouble() ?? 0.0, longitude: self.markerData?[1].toDouble() ?? 0.0)
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
            self.getIsoGodeFromlocal(marker, index: index)
           
        })
    }
   
}

