//
//  RegisterViewController.swift
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
import FirebaseStorage
import GeoFire


class RegisterViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var eid: UITextField!
    @IBOutlet weak var pwd: UITextField!
    @IBOutlet weak var phno: UITextField!
    var refval: DatabaseReference!
    
    var userid = ""
    
    var imageReference: StorageReference {
        return Storage.storage().reference().child("images")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refval = Database.database().reference().child("CustomerDet")
        
        
    }
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBAction func importImage(_ sender: UIButton) {
        
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false
        
        self.present(image, animated: true)
        {
            //After it is complete
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            myImageView.image = image
        }
        else
        {
            //Error message
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func displayAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func RegisterFun(_ sender: UIButton) {
        
        if eid.text == "" || pwd.text == "" {
            displayAlert(title: "Missing Information", message: "You must provide both a email and password")
        } else {
            if let email = eid.text {
                if let password = pwd.text {
                    
                    // SIGN UP
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            self.displayAlert(title: "Error", message: error!.localizedDescription)
                        } else {
                            print("Sign Up Success")
                            Auth.auth().signIn(withEmail: self.eid.text!, password: self.pwd.text!, completion: { (user, error) in
                                if error != nil {
                                    self.displayAlert(title: "Error", message: error!.localizedDescription)
                                } else {
                                    
                                    let key = Auth.auth().currentUser?.uid
                                    self.userid = key!
                                    let filename = self.userid+".jpg"
                                    
                                    guard let image = self.myImageView.image else { return }
                                    guard let imageData = UIImageJPEGRepresentation(image, 1) else { return }
                                    
                                    let uploadImageRef = self.imageReference.child(filename)
                                    
                                    let uploadTask = uploadImageRef.putData(imageData, metadata: nil) { (metadata, error) in
                                        print("UPLOAD TASK FINISHED")
                                        print(metadata ?? "NO METADATA")
                                        print(error ?? "NO ERROR")
                                    }
                                    
                                    
                                    let rideRequestDictionary:[String:Any] = ["email":email,"mobno":self.phno.text,"propic":filename,"id":key]
                                    
                                    
                                    
                                    self.refval.child(key!).setValue(rideRequestDictionary)
                                    
                                    uploadTask.observe(.progress) { (snapshot) in
                                        print(snapshot.progress ?? "NO MORE PROGRESS")
                                    }
                                    
                                    uploadTask.resume()

                                    
                                    
                                    //self.displayAlert(title: "Success", message: "Login in success")
                                    
                                    //self.newPage1()
                                }
                            })
                            self.displayAlert(title: "MSG", message: "Sign Up Success Login now")
                            
                            
                        }
                    })
                    
                }
            }
        }
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
