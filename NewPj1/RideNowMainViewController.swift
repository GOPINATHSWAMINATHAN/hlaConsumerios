//
//  RideNowMainViewController.swift
//  NewPj1
//
//  Created by IT-aswaqqnet on 12/30/17.
//  Copyright © 2017 Aswaqqnet.com. All rights reserved.
//



import UIKit
import GooglePlaces

import GoogleMaps
import Firebase

import FirebaseDatabase
import FirebaseAuth

import GeoFire


class RideNowMainViewController: UIViewController {

    @IBOutlet weak var PicLoc: GMSMapView!
    
    var geofireRef: DatabaseReference!
    var geofireRef1: DatabaseReference!
    
    var nearbyUsers = [String]()
    var nbu = ""
    
    @IBAction func callHla(_ sender: UIButton) {
        
        /*
        let key = Auth.auth().currentUser?.uid
        let rideRequestDictionary:[String:Any] = ["ukey": key]
        self.refval1.child(key!).setValue(rideRequestDictionary)
        */
        
        print("FNU")
        let uid = Auth.auth().currentUser?.uid
        print(uid)
        
        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        let center = CLLocation(latitude: getDataF.latitude, longitude: getDataF.longitude)
        
        let circleQuery = geoFire?.query(at: center, withRadius: 5.0)
        
        _ = circleQuery!.observe(.keyEntered, with: { (key, location) in
            
            if !self.nearbyUsers.contains(key!) && key! != uid {
                self.nearbyUsers.append(key!)
            }
            
        })
        
        //Execute this code once GeoFire completes the query!
        circleQuery?.observeReady({
            
            for user in self.nearbyUsers {
                
                self.geofireRef.child("/\(user)").observe(.value, with: { snapshot in
                    //let value = snapshot.value as? NSDictionary
                    let key1 = snapshot.key
                    
                    print("key")
                    print(key1)
                })
            }
            print("values in nearbyuser")
            print(self.nearbyUsers[0])
            self.nbu = self.nearbyUsers[0]
            let rideRequestDictionary:[String:Any] = ["custuid":uid]
            
            self.refval1.child(self.nearbyUsers[0]).updateChildValues(rideRequestDictionary)
            
            let geoFire1 = GeoFire(firebaseRef: self.geofireRef1)
            let uid = Auth.auth().currentUser?.uid
            
            geoFire1?.setLocation(CLLocation(latitude: self.getDataF.latitude, longitude: self.getDataF.longitude), forKey: uid) { (error) in
                if (error != nil) {
                    print("An error occured: \(String(describing: error))")
                } else {
                    print("Saved location successfully!")
                }
            }
            
            self.performSegue(withIdentifier: "ToDispDriver", sender: self)
        })
        
    }
    
    @IBAction func choosedest(_ sender: UIButton) {
        
        performSegue(withIdentifier: "sgpctodest", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "sgpctodest")
        {
            let secondController = segue.destination as! RideNowDestViewController
            //secondController.getDataF = userLocation
            //new
            secondController.getDataF = getDataF
            
            print("center:")
            print(mapView.camera.target)
            
            print("User Loc:")
            print(userLocation)
        }
        if(segue.identifier == "ToDispDriver")
        {
            let secondController = segue.destination as! RideNowDiverDisplayViewController
            secondController.selectDriverID = nbu
        }
    }
    
     var refval1: DatabaseReference!
    
    
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 12.5
    var userLocation = CLLocationCoordinate2D()
    
    let marker = GMSMarker()
    let marker1 = GMSMarker()
    
    var getDataF = CLLocationCoordinate2D()
    
    let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        //self.title = "Choose Date & Time"
        
        //ResDataTop.text = String(describing: getDataF)
        print("Ride now main view loaded")
        print(getDataF)
        
        print("lat:")
        print(getDataF.latitude)
        
        print("lng:")
        print(getDataF.longitude)
        
        refval1 = Database.database().reference().child("DriverReady")
        
        // Create a map.
        
        let camera = GMSCameraPosition.camera(withLatitude: getDataF.latitude,
                                              longitude: getDataF.longitude,
                                              zoom: zoomLevel)
        
        mapView = GMSMapView.map(withFrame: PicLoc.bounds, camera: camera)
        //mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        PicLoc.addSubview(mapView)
        //mapView.isHidden = true
        
        
        //Pic up marker
        marker.position = CLLocationCoordinate2D(latitude: getDataF.latitude, longitude: getDataF.longitude)
        marker.snippet = "PicUp"
        marker.map = mapView
        
        //refval1 = Database.database().reference().child("DriverReady")
        
        geofireRef = Database.database().reference().child("DriverLoc")
        
        
        geofireRef1 = Database.database().reference().child("PicUpLoc")
        
        /*
        //Dest up marker
        marker1.position = CLLocationCoordinate2D(latitude: self.userLocation.latitude, longitude: self.userLocation.longitude)
        marker1.snippet = "Dest"
        marker1.map = mapView
        */
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
