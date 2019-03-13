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

class GalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var images = [UIImage] ()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GalleryCollectionViewCell
        cell.imageView.image = images[indexPath.row]
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    func getData() {
        Database.database().reference().child(SearchViewController.seguePlace.adminKey).child(DBGlobal.LeasedPlaces.rawValue).child(SearchViewController.seguePlace.name).child("Images").observe(.value) { (snapshot) in
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
        }
    }

}
