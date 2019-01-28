//
//  SearchViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 12/5/18.
//  Copyright © 2018 Akash Veerappan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class Place {
    var amenities: [Amenity] = []
    var name: String = ""
    var address: String = ""
    var desc: String = ""
    var price: String = ""
    var rating: String = ""
    var ratingNum: String = ""
    
    init(name: String, address: String, desc: String, price: String, rating: String, ratingNum: String) {
        self.name = name
        self.address = address
        self.desc = desc
        self.price = price
        self.rating = rating
        self.ratingNum = ratingNum
    }
    
    init() {
        
    }
    
    func toString() -> String {
        return self.name + " " + self.address + " " + self.desc + " " + self.price + " " + self.rating + " " + self.price + " " + self.ratingNum
    }
    
}

class PlaceCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var imageView: UIImageView!
}

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var viewBgLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var placesTableView: UITableView!
    @IBOutlet weak var cellLabelColor: UILabel!
    
    static var seguePlace: Place = Place()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: PlaceCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PlaceCell
        cell.nameLabel.text = places[indexPath.row].name
        cell.priceLabel.text = places[indexPath.row].price
        cell.ratingLabel.text = places[indexPath.row].rating
        cell.layer.cornerRadius = 5
        cell.cellView.backgroundColor = viewBgLabel.textColor
        cell.cellView.layer.cornerRadius = 5
        cell.imageView.layer.cornerRadius = 5
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SearchViewController.seguePlace = places[indexPath.row]
        performSegue(withIdentifier: "LeasedPlaceDetailSegue", sender: self)
    }
    
    var databaseReference: DatabaseReference = Database.database().reference()
    var auth: Auth = Auth.auth()
    var uid: String = ""
    var places: [Place] = []
    static var passPlace = Place()
    
    let leftAndRightPaddings: Double = 4.0
    let numberOfItemsPerRow: Double = 2.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5)
        collectionView.contentSize = CGSize(width: (collectionView.frame.width - 32)/2, height: collectionView.frame.width/1.5)
        
        uid = (auth.currentUser?.uid)!
        test();
    }
    
    func test() {
        databaseReference.observe(.value) { (snapshot) in
            self.places.removeAll()
            print("IN 1")
            for c in snapshot.children {
                var userId = (c as? DataSnapshot)?.key ?? ""
                self.databaseReference.child(userId).observe(.value, with: { (snapshot) in
                    self.places.removeAll()
                    print("IN 2")
                    if let val = snapshot.value as? [String: Any?] {
                        if val["Leased Places"] != nil {
                            self.databaseReference.child(userId).child("Leased Places").observe(.value, with: { (snapshot) in
                                self.places.removeAll()
                                print("IN 3")
                                for c in snapshot.children {
                                        self.databaseReference.child(userId).child("Leased Places").child(((c as? DataSnapshot)?.key)!).observe(.value, with: { (snapshot) in
                                            //self.places.removeAll()
                                            print("IN 4")
                                            if let placeVal = snapshot.value as? [String: Any?] {
                                                if placeVal["Address"] != nil {
                                                    if placeVal["Description"] != nil {
                                                        if placeVal["Price"] != nil {
                                                            if placeVal["Rating"] != nil {
                                                                if placeVal["RatingNum"] != nil {
                                                                    var place = Place(
                                                                        name: (c as? DataSnapshot)?.key as! String,
                                                                        address: "Address: " + (placeVal["Address"] as! String),
                                                                        desc: placeVal["Description"] as! String,
                                                                        price: "$" + (placeVal["Price"] as! String),
                                                                        rating: "Rating: " + (placeVal["Rating"] as! String),
                                                                        ratingNum: placeVal["RatingNum"] as! String
                                                                    )
                                                                    var c = 0
                                                                    for p in self.places {
                                                                        if p.name != place.name {
                                                                           c += 1
                                                                        }
                                                                    }
                                                                    if c == self.places.count {
                                                                        self.places.append(place)
                                                                    }
                                                                    
                                                                    for p in self.places {
                                                                       
                                                                    }
                                                                    self.collectionView.reloadData()
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            
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
