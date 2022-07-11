//
//  LocationMessage.swift
//  Raya
//
//  Created by Yahya haj ali  on 25/04/2022.
//


import Foundation
import CoreLocation
import MessageKit

class LocationMessage: NSObject, LocationItem {
    var location: CLLocation
    var size: CGSize
    
    init (location: CLLocation) {
        self.location = location
        self.size = CGSize(width: 240, height: 240)
    }
    
}
