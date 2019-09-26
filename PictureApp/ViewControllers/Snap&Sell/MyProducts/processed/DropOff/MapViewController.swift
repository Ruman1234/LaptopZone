//
//  MapViewController.swift
//  SnapToSell
//
//  Created by Apple on 8/30/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController , CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager  = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            
        }
        self.mapView.showsUserLocation = true
        
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
        }
    }
   

}
