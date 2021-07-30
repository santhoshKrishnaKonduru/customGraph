//
//  LaunchViewController.swift
//  GraphPOC
//
//  Created by Santhosh Konduru on 19/03/21.
//

import UIKit
import ObjectMapper

class LaunchViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var apiWrapper = AlamofireAPIWrapper.sharedInstance
    var appData = AppData.sharedInstance
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getAllCountries()
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    func getCountryImages() {
        activityIndicator.startAnimating()
        apiWrapper.getAllCountiesFlags { (response) in
            if let jsonArray = response.responseObject as? JSONArray {
                self.loadAllCountryImagesResponse(response: jsonArray)
            }
        }
    }
    
    
    func loadAllCountryImagesResponse(response: JSONArray) {
        appData.countryFlags = Mapper<CountryFlag>().mapArray(JSONObject: response)!
        self.getAllCountries()
    }
    
    func getAllCountries() {
        activityIndicator.startAnimating()
        apiWrapper.getAllCountries { (response) in
            if let jsonArray = response.responseObject as? JSONArray {
                self.loadCountryResponse(response: jsonArray)
            }
        }
    }
    
    func loadCountryResponse(response: JSONArray) {
        appData.countries = Mapper<Country>().mapArray(JSONObject: response)
        appData.filterdCountries = Array(appData.countries?.suffix(5) ?? [])
        print(appData.filterdCountries, "data is h")
        self.getWorldCovidData()
    }
    
    func getWorldCovidData() {
        AppData.sharedInstance.getWorldCovidData {
                self.activityIndicator.stopAnimating()
                let graphDetailsVC = GraphDetailsViewController.instantiate(fromAppStoryboard: .Main)
                self.navigationController?.pushViewController(graphDetailsVC, animated: true)
        }
    }
    
    
  
    
  
}
