//
//  RideLater1ViewController.swift
//  NewPj1
//
//  Created by IT-aswaqqnet on 12/25/17.
//  Copyright © 2017 Aswaqqnet.com. All rights reserved.
//

import UIKit

import GoogleMaps
import GooglePlaces

class RideLater1ViewController: UIViewController, CLLocationManagerDelegate{
    
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 12.5
    var userLocation = CLLocationCoordinate2D()
    
    @IBOutlet weak var PicLoc: GMSMapView!
    
    var getDataF = CLLocationCoordinate2D()
    
    let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Choose Date & Time"
        
        //ResDataTop.text = String(describing: getDataF)
        print(getDataF)
        
        print("lat:")
        print(getDataF.latitude)
        
        print("lng:")
        print(getDataF.longitude)
        
        // Create a map.
        
        let camera = GMSCameraPosition.camera(withLatitude: getDataF.latitude,
                                              longitude: getDataF.longitude,
                                              zoom: zoomLevel)
        
        mapView = GMSMapView.map(withFrame: PicLoc.bounds, camera: camera)
        //mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        PicLoc.addSubview(mapView)
        //mapView.isHidden = true
        
        
        
        //ResDataTop.text = getDataF
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
