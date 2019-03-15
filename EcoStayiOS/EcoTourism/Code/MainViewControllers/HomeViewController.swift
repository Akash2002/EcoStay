//
//  HomeViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 1/18/19.
//  Copyright © 2019 Akash Veerappan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class FinishedPlace {
    var name = ""
    var fromWhen = ""
    var toWhen = ""
    
    init(name: String, fromWhen: String, toWhen: String) {
        self.name = name
        self.fromWhen = fromWhen
        self.toWhen = toWhen
    }
}

class PopularCellView: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
}

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var places: [Place] = []
    static var personName = ""
    static var userIDKey = ""
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if places.count < 10 {
            return places.count
        } else {
            return 10
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularCell", for: indexPath) as! PopularCellView
        
        places = places.sorted(by: {$0.popularityConstant > $1.popularityConstant})
        cell.nameLabel.text = places[indexPath.row].name
        cell.addressLabel.text = places[indexPath.row].address
        cell.priceLabel.text = places[indexPath.row].price
        cell.ratingLabel.text = places[indexPath.row].rating
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SearchViewController.seguePlace = places[indexPath.row]
        performSegue(withIdentifier: "toPlaceDetailsFromHome", sender: self)
    }
    
    @IBOutlet weak var viewEmulator: UIView!
    var databaseReference = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateCollectionView()
        getPersonName()
        
        Database.database().reference().child(Auth.auth().currentUser!.uid).observe(.value) { (snapshot) in
            if let val = snapshot.value as? [String: Any] {
                self.nameLabel.text = val["Name"] as! String
            }
        }
        
    }
    
    func getPersonName () {
        Database.database().reference().child((Auth.auth().currentUser?.uid)!).observe(.value) { (snapshot) in
            if let val = snapshot.value as? [String: Any] {
                HomeViewController.personName = val["Name"] as! String
                print(val["Name"])
            }
        }
    }
    
    func populateCollectionView() {
        databaseReference.observe(.value) { (snapshot) in
            self.places.removeAll()
            print("IN 1")
            for c in snapshot.children {
                var userId = (c as? DataSnapshot)?.key ?? ""
                self.databaseReference.child(userId).observe(.value, with: { (snapshot) in
                    self.places.removeAll()
                    print("IN 2")
                    if let val = snapshot.value as? [String: Any?] {
                        var personName = val[DBGlobal.Name.rawValue]
                        if val[DBGlobal.LeasedPlaces.rawValue] != nil {
                            self.databaseReference.child(userId).child(DBGlobal.LeasedPlaces.rawValue).observe(.value, with: { (snapshot) in
                                self.places.removeAll()
                                print("IN 3")
                                for c in snapshot.children {
                                    self.databaseReference.child(userId).child(DBGlobal.LeasedPlaces.rawValue).child(((c as? DataSnapshot)?.key)!).observe(.value, with: { (snapshot) in
                                        var place = Place()
                                        print("IN 4")
                                        if let placeVal = snapshot.value as? [String: Any?] {
                                            if placeVal[DBGlobal.Specific.Address.rawValue] != nil {
                                                if placeVal[DBGlobal.Specific.Description.rawValue] != nil {
                                                    if placeVal[DBGlobal.Specific.Price.rawValue] != nil {
                                                        if placeVal[DBGlobal.Specific.Rating.rawValue] != nil {
                                                            if placeVal[DBGlobal.Specific.RatingNum.rawValue] != nil {
                                                                if placeVal[DBGlobal.Specific.Amenities.rawValue] != nil {
                                                                    self.databaseReference.child(userId).child(DBGlobal.LeasedPlaces.rawValue).child(((c as? DataSnapshot)?.key)!).child(DBGlobal.Specific.Amenities.rawValue).observe(.value, with: { (snapshot) in
                                                                        if let amenityVal = snapshot.value as? [String: Int] {
                                                                            var tempAmenities: [Amenity] = []
                                                                            var i = 0
                                                                            for c in amenityVal {
                                                                                var tempAmenity = Amenity(name: c.key, quantity: c.value)
                                                                                tempAmenities.append(tempAmenity)
                                                                                i += 1
                                                                            }
                                                                            if (i > 0) {
                                                                                print("HELLO")
                                                                                place.amenities = tempAmenities
                                                                                print("Place: \(place.amenities.description)")
                                                                            }
                                                                        }
                                                                        place.name = (c as? DataSnapshot)?.key as! String
                                                                        place.address = "Address: " + (placeVal[DBGlobal.Specific.Address.rawValue] as! String)
                                                                        place.desc = placeVal[DBGlobal.Specific.Description.rawValue] as! String
                                                                        place.price = (placeVal[DBGlobal.Specific.Price.rawValue] as! String)
                                                                        HomeViewController.userIDKey = userId
                                                                        if let ratingval = Double(placeVal[DBGlobal.Specific.Rating.rawValue] as! String) {
                                                                            if let ratingnum = Double(placeVal[DBGlobal.Specific.RatingNum.rawValue] as! String) {
                                                                                if ratingnum != 0 {
                                                                                    place.rating = "⭑ " + String(ratingval/ratingnum)
                                                                                } else {
                                                                                    place.rating =  "⭑ 0"
                                                                                }
                                                                            }
                                                                            if let numRented = Double(placeVal[DBGlobal.Specific.NumRented.rawValue] as! String) {
                                                                                place.popularityConstant = String(numRented * ratingval)
                                                                            }
                                                                        }
                                                                        
                                                                        place.admin = personName as! String
                                                                        
                                                                        var c = 0
                                                                        for p in self.places {
                                                                            if p.name != place.name {
                                                                                c += 1
                                                                            }
                                                                        }
                                                                        if c == self.places.count {
                                                                            self.places.append(place)
                                                                        }
                                                                        
                                                                        DispatchQueue.main.async(execute: {
                                                                            self.collectionView.reloadData()
                                                                        })
                                                                        
                                                                    })
                                                                }
                                                                
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
