//
//  LocationManager.swift
//  CommonLib
//
//  Created by Ashish on 12/04/17.
//  Copyright © 2017 sahil jain. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class LocationManager: NSObject, CLLocationManagerDelegate {

    private static var sharedLocationManager: LocationManager?
    static var sharedInstance: LocationManager {
        if sharedLocationManager == nil {
            sharedLocationManager = LocationManager()
        }
        return sharedLocationManager!
    }
    
    var currentLocation: CLLocation!
    var previousLocation: CLLocation!
    var clLocationManager: CLLocationManager!
    var isBackgroundMode: Bool!
    var deferUpdates: Bool!
    
    static let kLocationDenialNotification = "kLocationDenialNotification"
    static let kLocationUpdateNotification = "LocationUpdateNotification"
    static let kLocationUpdateErrorNotification = "LocationUpdateErroNotification"
    static let kLocationStatusChangeNotification = "LocationStatusChangeNotification"
    static let kPreviousLocationKey = "PreviousLocationKey"
    
    static let kErrorLocationDenialMessage = "You have declined the permission to use location services, Please enable it from settings for better discovery of Mountains and Instructors around you"
    static let kErrorLocationRestrictionMessage = "Application cannot use location services, due to active restrictions on location services. Please enable it from settings for better discovery of Mountains and Instructors around you"
    
    override init() {
        super.init()
        clLocationManager = CLLocationManager()
        clLocationManager.delegate = self
        clLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        if clLocationManager.responds(to: #selector(setter: CLLocationManager.allowsBackgroundLocationUpdates)) {
            clLocationManager.allowsBackgroundLocationUpdates = true
        }
        clLocationManager.pausesLocationUpdatesAutomatically = false
        self.initialize()
        self.registerNotifications()
    }
    
    func initialize() {
        
    }
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationEnterForeground(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    // MARK: - Notification Selector methods with keyboard height
    
    @objc func applicationEnterBackground(_ sender: Notification) {
        isBackgroundMode = true
        self.loadBackgroundMode()
    }
    
    @objc func applicationEnterForeground(_ sender: Notification) {
        isBackgroundMode = false
        self.stopUpdatingLocation()
        clLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        clLocationManager.distanceFilter = kCLDistanceFilterNone
        clLocationManager.startUpdatingLocation()
    }
    
    func requestAuthorization() {
        let status = CLLocationManager.authorizationStatus()
        
        if (status == .notDetermined) {
            let alwaysKey = Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription")
            let whenInUseKey = Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription")
            
            if alwaysKey != nil {
                clLocationManager.requestAlwaysAuthorization()
            } else if whenInUseKey != nil {
                clLocationManager.requestWhenInUseAuthorization()
            } else {
                // At least one of the keys NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription MUST be present in the Info.plist file to use location services on iOS 8+.
                print("To use location services in iOS 8+, your Info.plist must provide a value for either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription.")
            }
        } else if self.isLocationStatusAuthorized() {
            self.getCurrentLocation()
        } else {
            switch (status) {
            case .denied:
                let message = LocationManager.kErrorLocationDenialMessage
                self.postLocationUpdateNotification(isSuccessful: false, errorMsg: message, location: nil)
                break
            case .restricted:
                let message = LocationManager.kErrorLocationRestrictionMessage
                self.postLocationUpdateNotification(isSuccessful: false, errorMsg: message, location: nil)
                break
            default:
            break
            }
        }
    }
    
    func startUpdatingLocation() {
        clLocationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        clLocationManager.stopUpdatingLocation()
    }
    
    func getCurrentLocation() {
        self.stopUpdatingLocation()
        clLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        clLocationManager.distanceFilter = kCLDistanceFilterNone
        clLocationManager.requestAlwaysAuthorization()
        clLocationManager.startUpdatingLocation()
    }

    func loadBackgroundMode() {
        self.stopUpdatingLocation()
        clLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        clLocationManager.distanceFilter = kCLDistanceFilterNone
        clLocationManager.requestAlwaysAuthorization()
        clLocationManager.startUpdatingLocation()
    }
    
    func locationAuthorizationStatus() -> CLAuthorizationStatus {
        let status = CLLocationManager.authorizationStatus()
        return status
    }
    
    func isLocationStatusAuthorized() -> Bool {
        let status: CLAuthorizationStatus = self.locationAuthorizationStatus()
        
        if status == .authorizedAlways {
            return true
        }
        return false
    }
    
    func didAskLocationPermission() -> Bool {
        let status: CLAuthorizationStatus = self.locationAuthorizationStatus()
        
        if status != .notDetermined {
            return true
        }
        return false
    }
    
    func reset() {
        LocationManager.sharedLocationManager = nil
    }
    
    func postDenialOfLocationServices() {
        NotificationCenter.default.post(name: NSNotification.Name(LocationManager.kLocationDenialNotification), object: self, userInfo: nil)
    }
    
    func postLocationUpdateNotification(isSuccessful: Bool, errorMsg:String, location: CLLocation?) {
        //  AlamofireAPIResponse *response = [[AlamofireAPIResponse alloc] initWithResponse:location errorCode:0 errorMessage:errorMsg successful:isSuccessful];
        //NSDictionary* locationInfo = [NSDictionary dictionaryWithObjectsAndKeys:response,@"response", nil];
        //NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        //[nc postNotificationName:kLocationUpdateNotification object:self userInfo:locationInfo];
    }
    
    // MARK: - CLLocationManagerDelegate Methods
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            let message = LocationManager.kErrorLocationDenialMessage
            self.postLocationUpdateNotification(isSuccessful: false, errorMsg: message, location: nil)
            break
        case .restricted:
            let message = LocationManager.kErrorLocationRestrictionMessage
            self.postLocationUpdateNotification(isSuccessful: false, errorMsg: message, location: nil)
            break
        default:
            clLocationManager.startUpdatingLocation()
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        deferUpdates = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager didFailWithError: %@", error)
        switch error {
        case CLError.network: // general, network-related error
            let message = Constants.Error.networkMsg
            self.postLocationUpdateNotification(isSuccessful: false, errorMsg: message, location: nil)
            break
        case CLError.denied:
            let message = LocationManager.kErrorLocationDenialMessage
            self.postLocationUpdateNotification(isSuccessful: false, errorMsg: message, location: nil)
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            let theAccuracy = location.horizontalAccuracy
            if theAccuracy > 0 && theAccuracy < 100 {
                self.currentLocation = location
                print("didUpdateToLocation: %@", self.currentLocation);
                if isBackgroundMode == true {
                    
                } else {
                    self.postLocationUpdateNotification(isSuccessful: true, errorMsg: "", location: location)
                }
            }
        }
    }
    
}
