//
//  LocationManager.swift
//  Raya
//
//  Created by Yahya haj ali  on 29/04/2022.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D?
    
    private override init () {
        super.init()
        self.requestLocationAccess()
        
        
    }
    
    func requestLocationAccess() {
        
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
            
        } else {
            print ("We have already location manager")
            
        }
        
    }
    
    
    func startUpdating() {
        
        locationManager!.startUpdatingLocation()
    }
    
    func stopUpdating() {
        
        if locationManager != nil {
            locationManager!.stopUpdatingLocation()
        }
        
    }
    
     //MARK:- Delegate function
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!.coordinate
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("failed to get location", error.localizedDescription)
        
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if manager.authorizationStatus == .notDetermined {
            self.locationManager!.requestWhenInUseAuthorization()
        }
        
    }
    
    
}
