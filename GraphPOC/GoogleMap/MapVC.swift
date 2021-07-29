//
//  MapVC.swift
//  GraphPOC
//
//  Created by BitCot Technologies on 28/07/21.
//

import UIKit
import GoogleMaps

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
    var arrFlag = ["🏳️","🏳️","🏳️","🏳️","🏳️"]
    var count = Int()
    var complitionhandler:complitionhandler?
    var zoom = Float(4)
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
        self.showProgress(message: "loading....")
        self.flagView.addShadow(color: #colorLiteral(red: 0.02548495308, green: 0.02617123723, blue: 0.1849866807, alpha: 1))
        self.flagView.addCornerRadius(radius: 6.0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    //MARK: Actions
    @IBAction func btnBackAction(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    @IBAction func bntListAction(_ sender: UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "SelectedCovidDataVC") as! SelectedCovidDataVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
        
        
    }
    
    @IBAction func btnAddAction(_ sender: UIButton){
        if !self.arrFlag.contains(self.flag(from: self.placeMark.isoCountryCode ?? "🏳️")){
            self.setflagInsideArray(self.placeMark.isoCountryCode ?? "🏳️")
        }
        
        //   let isExist = DataBaseHelper.sharedInstance.fetchCovidData().contains(where: { covidData in
        //            if data.country?.ISO2 == covidData.iso{
        //                return true
        //            }else{
        //                return false
        //            }
        //        })
        //
        //        if isExist{
        //            self.showAnnouncmentYesNo(withMessage: "Already exist this country. Do you want to add again?") {
        //                DataBaseHelper.sharedInstance.saveData(data) { msg in
        //                    self.showAnnouncment(withMessage: msg)
        //                }
        //            }
        //        }else{
        //            DataBaseHelper.sharedInstance.saveData(data) { msg in
        //                self.showAnnouncment(withMessage: msg)
        //            }
        //        }
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
        self.vwMap.camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: self.zoom)
        self.vwMap.animate(toZoom: self.zoom)
        if let data = self.markerData {
            let location = CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)
            print(mapView.projection.point(for: location))
        }
        self.setMarkerView(marker) { view in
            self.view.addSubview(view)
        }
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        guard let data = self.markerData else {
            return
        }
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
    
    func setMarkerView(_ marker: GMSMarker, complition: @escaping (UIView) -> Void){
        if let cordinate = marker.userData as? CLLocationCoordinate2D{
            let location = CLLocation(latitude: cordinate.latitude, longitude: cordinate.longitude)
            geoCoder.reverseGeocodeLocation(location, completionHandler: {  (placemarks, error) -> Void in
                self.placeMark = placemarks?[0]
                self.nib.setCustomMarkerViewdata(self.placeMark)
                self.nib.btnAddIntoList.addTarget(self, action: #selector(self.btnAddAction(_:)), for: .touchUpInside)
                DispatchQueue.main.async {
                    complition(self.nib)
                }
            })
        }
    }
    
    func setflagInsideArray(_ code: String){
        if self.count <= 4{
            self.arrFlag.remove(at: self.count)
            if self.placeMark.isoCountryCode == nil{
                self.arrFlag.insert("🏳️", at: self.count)
            }else{
                self.arrFlag.insert(self.flag(from: code), at: self.count)
            }
            self.count += 1
        }else{
            self.count = 0
            self.arrFlag.remove(at: self.count)
            self.arrFlag.insert(self.flag(from: self.placeMark.isoCountryCode ?? "🏳️"), at: self.count)
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

