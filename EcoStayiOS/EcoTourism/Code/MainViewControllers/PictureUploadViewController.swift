//
//  PictureUploadViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 1/27/19.
//  Copyright © 2019 Akash Veerappan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class PictureUploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePickerController: UIImagePickerController = UIImagePickerController()
    var imageToBeUploaded: UIImage = UIImage()
    var storageReference = Storage.storage().reference()

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finish", style: .done, target: self, action: #selector(finishClicked))
        
    }
    
    @objc func finishClicked () {
        
    }
    
    @IBAction func onAddClicked(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Photo source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePickerController.sourceType = .camera
            } else {
                print("Camera not Available")
            }
            
            self.present(self.imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (alertAction) in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        if let imageData = imageToBeUploaded.jpegData(compressionQuality: 0.6) {
            let imageStorageRef = Storage.storage().reference()
            var uid = UUID().uuidString
            let newImageRef = imageStorageRef.child(uid)
            newImageRef.putData(imageData, metadata: nil) { (metadata, err) in
                if let e = err {
                    print(e)
                    return
                } else {
                    newImageRef.downloadURL(completion: { (url, error) in
                        if let err = error {
                            print(err)
                        } else {
                            Database.database().reference().child((Auth.auth().currentUser?.uid)!).child("Leased Places").child(LeaseViewController.nameOfPlace).child("Images").child(uid).setValue(url?.absoluteString)
                        }
                        
                    })
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = tempImage
        imageToBeUploaded = tempImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
