//
//  RideNowTempViewController.swift
//  NewPj1
//
//  Created by IT-aswaqqnet on 12/27/17.
//  Copyright © 2017 Aswaqqnet.com. All rights reserved.
//

import UIKit
import FirebaseStorage

import SDWebImage

class RideNowTempViewController: UIViewController {

    
    let filename = "Yp3Ht2jpL5WDVjhZXcM4LUM7qp33.jpg"
    
    var imageReference: StorageReference {
        return Storage.storage().reference().child("images")
    }
    
    
    
    
    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var downloadImage: UIImageView!
    
    
   
    // Reference to an image file in Firebase Storage
    // let reference = storageRef.child("images/stars.jpg")
    
    // UIImageView in your ViewController
    // let imageView: downloadImage = self.imageView
    
    // Placeholder image
    //let placeholderImage = UIImage(named: "placeholder.jpg")
    
    
    
    
    
    @IBAction func onUploadTapped(_ sender: Any) {
        
        guard let image = uploadImage.image else { return }
        guard let imageData = UIImageJPEGRepresentation(image, 1) else { return }
        
        let uploadImageRef = imageReference.child(filename)
        
        let uploadTask = uploadImageRef.putData(imageData, metadata: nil) { (metadata, error) in
            print("UPLOAD TASK FINISHED")
            print(metadata ?? "NO METADATA")
            print(error ?? "NO ERROR")
        }
        
        uploadTask.observe(.progress) { (snapshot) in
            print(snapshot.progress ?? "NO MORE PROGRESS")
        }
        
        uploadTask.resume()

    }
    
    @IBAction func onDownloadTapped(_ sender: Any) {
        
        
        
        /*
        // Reference to an image file in Firebase Storage
        let reference = imageReference.child("images/stars.jpg")
        

        let placeholderImage = UIImage(named: "img.jpg")
        
        
        downloadImage.sd_setShowActivityIndicatorView(true)
        downloadImage.sd_setIndicatorStyle(.whiteLarge)
        
        
        downloadImage.sd_setImage(with: URL(string: "https://firebasestorage.googleapis.com/v0/b/hlacab-b8d9a.appspot.com/o/images%2FW2Op33psZ2c3L300GeyVDPJPlmo2.jpg?alt=media&token=506d4f59-7993-4af3-bc10-b6560d0f8327"), placeholderImage: placeholderImage)
        
        */
        
        
        let downloadImageRef = imageReference.child(filename)
        
        // Create a reference to the file you want to download
        //let islandRef = storageRef.child("images/island.jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        downloadImageRef.getData(maxSize: 12 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                self.downloadImage.image = image
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
