//
//  RideNowDiverDisplayViewController.swift
//  NewPj1
//
//  Created by IT-aswaqqnet on 1/6/18.
//  Copyright © 2018 Aswaqqnet.com. All rights reserved.
//

import UIKit
import GooglePlaces

import GoogleMaps
import Firebase

import FirebaseDatabase
import FirebaseAuth

import GeoFire

import SwiftyJSON
import Alamofire

import SDWebImage

class RideNowDiverDisplayViewController: UIViewController ,GMSMapViewDelegate, CLLocationManagerDelegate {
    
    var selectDriverID = ""
        var refval: DatabaseReference!
    
    let placeholderImage = UIImage(named: "img.jpg")
    var drivImg = ""
    var driveid = ""
    var drivename = ""
    var drivephno = ""
    
    var locationManager = CLLocationManager()
    
    var locationStart = CLLocation()
    var locationEnd = CLLocation()
    
    var clintReqID = ""
    
    var geofireRef: DatabaseReference!
    
    @IBOutlet weak var mapView1: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        geofireRef = Database.database().reference().child("DriverLoc")
        
        let uid = selectDriverID
        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        geoFire?.getLocationForKey(uid, withCallback: { (location, error) in
            if (error != nil) {
                print("An error occurred getting the location for user: \(String(describing: error?.localizedDescription))")
            } else if (location != nil) {
                print("Location for user is [\(location?.coordinate.latitude ?? 90.873636), \(location?.coordinate.longitude ?? 23.44555)]")
                self.locationEnd = CLLocation(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
                
                // print(location?.coordinate.latitude ?? 34.343434)
            } else {
                print("GeoFire does not contain a location for user")
            }
        })
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        //Your map initiation code
        let camera = GMSCameraPosition.camera(withLatitude: -7.9293122, longitude: 112.5879156, zoom: 15.0)
        
        self.mapView1.camera = camera
        self.mapView1.delegate = self
        self.mapView1?.isMyLocationEnabled = true
        self.mapView1.settings.myLocationButton = true
        self.mapView1.settings.compassButton = true
        self.mapView1.settings.zoomGestures = true
        
        refval = Database.database().reference().child("DriverDet")
        print("Display driver view loaded")
        print("Selected driver ID")
        print("Selected driver ID:"+selectDriverID)
        
        createMarker(titleMarker: "Location Start", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: 37.331676 , longitude: -122.030189 )
        locationStart = CLLocation(latitude: 37.331676, longitude: -122.030189)
        
        
        createMarker(titleMarker: "Location End", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: locationEnd.coordinate.latitude, longitude: locationEnd.coordinate.longitude)
        
        self.drawPath(startLocation: locationStart, endLocation: locationEnd)
        
        viewImgIn()
        
       
        self.refval.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            print(snapshot.childrenCount)
            let value = snapshot.value as? NSDictionary
            
            let s1 = value?["Proimage"] as? String ?? ""
            self.drivImg = self.User(username: s1)
            
            let s2 = value?["emailid"] as? String ?? ""
            self.driveid = self.User(username: s2)
            
            let s3 = value?["name"] as? String ?? ""
            self.drivename = self.User(username: s3)
            
            let s4 = value?["phno"] as? String ?? ""
            self.drivephno = self.User(username: s4)
            
            
            
            print("mm val:::"+self.selectDriverID)
            
            self.downloadImage.sd_setShowActivityIndicatorView(true)
            self.downloadImage.sd_setIndicatorStyle(.whiteLarge)
            
            
            self.downloadImage.sd_setImage(with: URL(string: self.drivImg), placeholderImage: self.placeholderImage)
            
            
            
        }, withCancel: { (error) in
            print(error.localizedDescription)
        })
        
        
    }
    
    
    
    // MARK: function for create a marker pin on map
    func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.icon = iconMarker
        marker.map = mapView1
    }
    
    //MARK: - this is function for create direction path, from start location to desination location
    
    func drawPath(startLocation: CLLocation, endLocation: CLLocation)
    {
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        
        Alamofire.request(url).responseJSON { response in
            
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response serialization
            do
            {
                let json = try JSON(data: response.data!)
                let routes = json["routes"].arrayValue
                
                // print route using Polyline
                for route in routes
                {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeWidth = 4
                    polyline.strokeColor = UIColor.red
                    polyline.map = self.mapView1
                    
                    print("rt v::: ")
                    print(routeOverviewPolyline)
                }
                
                
            }
            catch
            {
                print("Error parsing json")
            }
            
        }
    }
    
    func showdriverdet()
    {
        
    }
    
    
    @IBAction func PrintVal(_ sender: UIButton) {
        
        print("driv img: "+drivImg)
        print("id: "+driveid)
        print("name: "+drivename)
        print("drivphno: "+drivephno)
        
        
    }
    
    func viewImgIn()
    {
        
        let uid = selectDriverID
        
        self.refval.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            print(snapshot.childrenCount)
            let value = snapshot.value as? NSDictionary
            
            let s1 = value?["Proimage"] as? String ?? ""
            self.drivImg = self.User(username: s1)
            
            let s2 = value?["emailid"] as? String ?? ""
            self.driveid = self.User(username: s2)
            
            let s3 = value?["name"] as? String ?? ""
            self.drivename = self.User(username: s3)
            
            let s4 = value?["phno"] as? String ?? ""
            self.drivephno = self.User(username: s4)
            
            
            
            print("mm val:::"+self.selectDriverID)
            
            self.downloadImage.sd_setShowActivityIndicatorView(true)
            self.downloadImage.sd_setIndicatorStyle(.whiteLarge)
            
            
            self.downloadImage.sd_setImage(with: URL(string: self.drivImg), placeholderImage: self.placeholderImage)
            
            
            
        }, withCancel: { (error) in
            print(error.localizedDescription)
        })
        
    }
    
    @IBOutlet weak var downloadImage: UIImageView!
    
    @IBAction func mm(_ sender: UIButton) {
        
        
        let uid = selectDriverID
        
        self.refval.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            print(snapshot.childrenCount)
            let value = snapshot.value as? NSDictionary
            
            let s1 = value?["Proimage"] as? String ?? ""
            self.drivImg = self.User(username: s1)
            
            let s2 = value?["emailid"] as? String ?? ""
            self.driveid = self.User(username: s2)
            
            let s3 = value?["name"] as? String ?? ""
            self.drivename = self.User(username: s3)
            
            let s4 = value?["phno"] as? String ?? ""
            self.drivephno = self.User(username: s4)

            
            
            print("mm val:::"+self.selectDriverID)
            
            self.downloadImage.sd_setShowActivityIndicatorView(true)
            self.downloadImage.sd_setIndicatorStyle(.whiteLarge)
            
            
            self.downloadImage.sd_setImage(with: URL(string: self.drivImg), placeholderImage: self.placeholderImage)
            
            
            
        }, withCancel: { (error) in
            print(error.localizedDescription)
        })
        
        
    }
    
    func User(username: String) -> String {
        return username
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
