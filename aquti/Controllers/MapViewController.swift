	//
//  ViewController.swift
//  aquti
//
//  Created by Wout Bauwens on 21/12/2017.
//  Copyright © 2017 Wout Bauwens. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var marker = GMSMarker()
    var camera: GMSCameraPosition!
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMapView()
        
        //let myThread = Thread(target: self, selector: #selector(self.update), object: nil)   creating thread does not work to update camera
        //myThread.start()
        update()
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initMapView(){
        
       // manager = LocationService()
        marker.icon = UIImage(named: "Marker.png")
        camera = GMSCameraPosition.camera(withLatitude: LocationService.sharedInstance.currentLocation.coordinate.latitude, longitude: LocationService.sharedInstance.currentLocation.coordinate.longitude, zoom: 16.0)

        // Create a GMSCameraPosition that tells the map to display the
        // coordinate to the current location at zoom level 16.
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        mapView.isMyLocationEnabled = true
      //  mapView.addObserver(self, forKeyPath: "location", options: NSKeyValueObservingOptions.new, context: nil);   observer does not work to update camera
        mapView.settings.setAllGesturesEnabled(false)
        
        self.view = mapView
            
            // Creates a marker in the center of the map.
        marker.position = CLLocationCoordinate2D(latitude: LocationService.sharedInstance.currentLocation.coordinate.latitude, longitude: LocationService.sharedInstance.currentLocation.coordinate.longitude)
        marker.map = mapView
    }
    
    @objc private func update(){
        mapView.animate(to: GMSCameraPosition.camera(withLatitude: LocationService.sharedInstance.currentLocation.coordinate.latitude, longitude: LocationService.sharedInstance.currentLocation.coordinate.longitude, zoom: 16.0))
    }
}
