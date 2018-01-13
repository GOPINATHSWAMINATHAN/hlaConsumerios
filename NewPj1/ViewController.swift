//
//  ViewController.swift
//  NewPj1
//
//  Created by IT-aswaqqnet on 12/24/17.
//  Copyright © 2017 Aswaqqnet.com. All rights reserved.
//


import UIKit
import GooglePlaces

import GoogleMaps
import Firebase

import FirebaseDatabase
import FirebaseAuth

import GeoFire


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 12.5
    var userLocation = CLLocationCoordinate2D()
    
    //var placesClient: GMSPlacesClient!
    //var locationManager = CLLocationManager()
    //var userLocation = CLLocationCoordinate2D()
    var refval: DatabaseReference!
    var geofireRef: DatabaseReference!
    var geofireRef1: DatabaseReference!
    var nearbyUsers = [String]()
    
    
    
    var locval = String()

    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    // A default location to use when location permission is not granted.
    let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    func displayAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        /*
        let email1 = "customer1@gmail.com"
        let pwd1 = "123456"
        
        Auth.auth().signIn(withEmail: email1, password: pwd1, completion: { (user, error) in
            if error != nil {
                self.displayAlert(title: "Error", message: error!.localizedDescription)
            } else {
                
                self.displayAlert(title: "Success", message: "Login in success")
                
                
            }
        })
        
        */
        
        
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        // Create a map.
        
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        
        mapView = GMSMapView.map(withFrame: mapview1.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
       
        
        //mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        
        
        // Add the map to the view, hide it until we've got a location update.
        mapview1.addSubview(mapView)
        mapView.isHidden = true
        

        /*
        // Create a map.
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true
        */
        
        refval = Database.database().reference().child("RideRequests")
        
        geofireRef = Database.database().reference().child("CustLoc")
        
        geofireRef1 = Database.database().reference().child("DriverDet")
        
        
    }
    
    
    @IBAction func RnowData(_ sender: UIButton) {
        /*
        let uid = Auth.auth().currentUser?.uid
        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        geoFire?.getLocationForKey(uid, withCallback: { (location, error) in
            if (error != nil) {
                print("An error occurred getting the location for user: \(String(describing: error?.localizedDescription))")
            } else if (location != nil) {
                print("Location for user is [\(location?.coordinate.latitude ?? 90.873636), \(location?.coordinate.longitude ?? 23.44555)]")
                // print(location?.coordinate.latitude ?? 34.343434)
            } else {
                print("GeoFire does not contain a location for user")
            }
        })
        */
        //findNearbyUsers()
        
        performSegue(withIdentifier: "segueNow", sender: self)
        
    }
    
    func findNearbyUsers()
    {
        print("FNU")
        let uid = Auth.auth().currentUser?.uid
        
        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        let center = CLLocation(latitude: self.userLocation.latitude, longitude: self.userLocation.longitude)
        
        let circleQuery = geoFire?.query(at: center, withRadius: 0.6)
        
        
        _ = circleQuery!.observe(.keyEntered, with: { (key, location) in
            
            if !self.nearbyUsers.contains(key!) && key! != uid {
                self.nearbyUsers.append(key!)
            }
            
        })
        

        
        
        //Execute this code once GeoFire completes the query!
        circleQuery?.observeReady({
            
            for user in self.nearbyUsers {
                
                self.geofireRef1.child("/\(user)").observe(.value, with: { snapshot in
                    let value = snapshot.value as? NSDictionary
                    
                    print("vallll:::")
                    self.Proimages = (value!["emailid"] as? String)!
                    self.emailids = (value!["emailid"] as? String)!
                    self.names = (value!["emailid"] as? String)!
                    self.phnos = (value!["emailid"] as? String)!
                    print(value!["emailid"] ?? "ds")
                    print(value!["Proimage"] ?? "fs")
                })
            }
            
        })
        
        
    }
    
    
    var Proimages = "fr"
    var emailids = "fr"
    var names = "fr"
    var phnos = "fr"
    
    
    @IBAction func RlaterData(_ sender: UIButton) {
    
        performSegue(withIdentifier: "segue", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if(segue.identifier == "segue")
        {
            
            let secondController = segue.destination as! RideLater1ViewController
            
            //secondController.getDataF = userLocation
            
            //new
            
            secondController.getDataF = mapView.camera.target
            
            print("center:")
            print(mapView.camera.target)
            
            print("User Loc:")
            print(userLocation)
            
        }
        
        if(segue.identifier == "segueNow")
        {
            
            let secondController = segue.destination as! RideNowMainViewController
            
            //secondController.getDataF = userLocation
            
            //new
            
            secondController.getDataF = mapView.camera.target
            
            print("center:")
            print(mapView.camera.target)
            
            print("User Loc:")
            print(userLocation)
        }
 
        
    }

    
    
    
    @IBOutlet weak var mapview1: UIView!
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        userLocation = center
        
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            //mapView.animate(to: camera)
        }
        
        
        let geoFire = GeoFire(firebaseRef: geofireRef)
        let uid = Auth.auth().currentUser?.uid
        
        geoFire?.setLocation(CLLocation(latitude: self.userLocation.latitude, longitude: self.userLocation.longitude), forKey: uid) { (error) in
            if (error != nil) {
                print("An error occured: \(String(describing: error))")
            } else {
                print("Saved location successfully!")
            }
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }


}

