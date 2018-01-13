//
//  RiderSetViewController.swift
//  NewPj1
//
//  Created by IT-aswaqqnet on 1/13/18.
//  Copyright © 2018 Aswaqqnet.com. All rights reserved.
//



import UIKit
import GooglePlaces

import GoogleMaps
import Firebase

import FirebaseDatabase
import FirebaseAuth

import GeoFire
import FirebaseStorage



class RiderSetViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var imageReference: StorageReference {
        return Storage.storage().reference().child("images")
    }
    
    var refval: DatabaseReference!
    var uid = ""
    
    @IBOutlet weak var driverImg: UIImageView!
    @IBOutlet weak var tbv: UITableView!
    
    let placeholderImage = UIImage(named: "user1.jpg")
    var drivImg = ""
    var driveid = ""
    var drivename = ""
    var drivephno = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        refval = Database.database().reference().child("CustomerDet")
        
        let key = Auth.auth().currentUser?.uid
        uid = key!
        
        self.refval.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            print(snapshot.childrenCount)
            
            let value = snapshot.value as? NSDictionary
            
            let s1 = value?["propic"] as? String ?? ""
            self.drivImg = self.User(username: s1)
            
            let s2 = value?["email"] as? String ?? ""
            self.driveid = self.User(username: s2)
            self.list[1] = self.driveid
            
            
            let s4 = value?["mobno"] as? String ?? ""
            self.drivephno = self.User(username: s4)
            
            
            
            let downloadImageRef = self.imageReference.child(self.drivImg)
            
            // Create a reference to the file you want to download
            //let islandRef = storageRef.child("images/island.jpg")
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            downloadImageRef.getData(maxSize: 12 * 1024 * 1024) { data, error in
                if let error = error {
                    // Uh-oh, an error occurred!
                } else {
                    // Data for "images/island.jpg" is returned
                    let image = UIImage(data: data!)
                    self.driverImg.image = image
                }
            }
            
            
            
        }, withCancel: { (error) in
            print(error.localizedDescription)
        })
        
        print(list[1])
        
    }
    func User(username: String) -> String {
        return username
    }

    
    
    func displayAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    var list = ["Name", "ID", "Logout"]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return(list.count)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = list[indexPath.row]
        
        return(cell)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var val1 = indexPath.row
        print(val1)
        if(val1 == 2)
        {
            do {
                try Auth.auth().signOut()
                //self.displayAlert(title: "Success", message: "logout success")
                performSegue(withIdentifier: "srlogout", sender: self)
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
        
        //performSegue(withIdentifier: "segue", sender: self)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.list[0] = self.driveid
        self.list[1] = self.drivephno
        
        self.tbv.reloadData()
        
       
        
        
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
