//
//  LocationManager.swift
//  VK2
//
//  Created by  Алёна Бенецкая on 07.12.2017.
//  Copyright © 2017  Алёна Бенецкая. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: class {
    func locationManager(_ locationManager: LocationManager, location: CLLocationCoordinate2D)
}

class LocationManager: NSObject {
    static let instance = LocationManager()
    private override init(){}
    
    weak var delegate: LocationManagerDelegate?
    let geoCoder = CLGeocoder()
    
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    func startUpdateLocation() {
        locationManager.startUpdatingLocation()
    }
    
}

extension LocationManager : CLLocationManagerDelegate {
    
    func locationManager (_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print (locations[0].coordinate)
        guard let location = locations.last else {return}
        delegate?.locationManager(self, location: locations[0].coordinate)
        geoCoder.reverseGeocodeLocation(location) { mark, error in
            print(mark?.last?.addressDictionary)
        }
        
    }
    
    
}
