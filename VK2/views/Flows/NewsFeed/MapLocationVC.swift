//
//  MapLocationVC.swift
//  VK2
//
//  Created by  Алёна Бенецкая on 07.12.2017.
//  Copyright © 2017  Алёна Бенецкая. All rights reserved.
//

import UIKit
import MapKit

class MapLocationVC: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var currentCity: String = ""
    var currentLocation: CLLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.instance.delegate = self
        LocationManager.instance.startUpdateLocation()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func savePost(_ sender: Any) {
        
        dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapLocationVC: LocationManagerDelegate {
    func locationManager (_ locationManager: LocationManager, location: CLLocationCoordinate2D){
        
        let currentRadius: CLLocationDistance = 1000
        let currentRegion = MKCoordinateRegionMakeWithDistance(location, currentRadius * 2, currentRadius * 2)
        
        mapView.setRegion(currentRegion, animated: true)
        mapView.showsUserLocation = true
//        locationManager.geoCoder.reverseGeocodeLocation(location) { [weak self] mark, error in
//            if mark?.last?.locality != nil {
//                self?.currentCity = (mark?.last?.locality)!
//                self?.currentLocation = location
        
//            }
//        }
    }
    
}
