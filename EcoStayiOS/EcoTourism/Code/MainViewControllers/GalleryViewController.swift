//
//  GalleryViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 3/12/19.
//  Copyright © 2019 Akash Veerappan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class GalleryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}

class GalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var images = [UIImage] ()
    
    var spacing: CGFloat = 16.0
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GalleryCollectionViewCell
        cell.layer.cornerRadius = 10
        cell.imageView.layer.cornerRadius = 10
        cell.imageView.image = images[indexPath.row]
        print("Ran")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = 2
        let spacingBetweenCells:CGFloat = 16
        
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        if let collection = self.collectionView{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Gallery"
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView?.collectionViewLayout = layout
        getData()
    }
    
    func getData() {
        if (SearchViewController.seguePlace.adminKey == "") {
            Database.database().reference().child(HomeViewController.userIDKey).child(DBGlobal.LeasedPlaces.rawValue).child(SearchViewController.seguePlace.name).observe(.value) { (snapshot) in
                if let val = snapshot.value as? [String: Any]{
                    if val["Images"] != nil {
                        print("TEST 1 IN")
                        Database.database().reference().child(HomeViewController.userIDKey).child(DBGlobal.LeasedPlaces.rawValue).child(SearchViewController.seguePlace.name).child("Images").observe(.value, with: { (snapshot) in
                            for key in snapshot.children {
                                if let val = snapshot.value as? [String: Any] {
                                    let imageReference = Storage.storage().reference(forURL: val[(key as? DataSnapshot)!.key] as! String)
                                    imageReference.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                                        if let err = error {
                                            print(err)
                                        } else {
                                            let image = UIImage(data: data!)
                                            self.images.append(image!)
                                            DispatchQueue.main.async(execute: {
                                                self.collectionView.reloadData()
                                            })
                                        }
                                    })
                                }
                            }
                        })
                        
                    }
                }
                
            }
        } else {
            Database.database().reference().child(SearchViewController.seguePlace.adminKey).child(DBGlobal.LeasedPlaces.rawValue).child(SearchViewController.seguePlace.name).observe(.value) { (snapshot) in
                if let val = snapshot.value as? [String: Any]{
                    if val["Images"] != nil {
                        print("TEST 1 IN")
                        Database.database().reference().child(HomeViewController.userIDKey).child(DBGlobal.LeasedPlaces.rawValue).child(SearchViewController.seguePlace.name).child("Images").observe(.value, with: { (snapshot) in
                            for key in snapshot.children {
                                if let val = snapshot.value as? [String: Any] {
                                    let imageReference = Storage.storage().reference(forURL: val[(key as? DataSnapshot)!.key] as! String)
                                    imageReference.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                                        if let err = error {
                                            print(err)
                                        } else {
                                            let image = UIImage(data: data!)
                                            self.images.append(image!)
                                            DispatchQueue.main.async(execute: {
                                                self.collectionView.reloadData()
                                            })
                                        }
                                    })
                                }
                            }
                        })
                        
                    }
                }
                
            }
        }
        
    }

}
