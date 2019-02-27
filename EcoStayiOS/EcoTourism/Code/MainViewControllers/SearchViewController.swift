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
    var admin: String = ""
    
    init(name: String, address: String, desc: String, price: String, rating: String, ratingNum: String, admin: String) {
        self.name = name
        self.address = address
        self.desc = desc
        self.price = price
        self.rating = rating
        self.ratingNum = ratingNum
        self.admin = admin
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
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    
}

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var viewBgLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cellLabelColor: UILabel!
    
    static var seguePlace: Place = Place()
    
    var searchController = UISearchController(searchResultsController: nil)
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: PlaceCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PlaceCell
        cell.nameLabel.text = places[indexPath.row].name
        cell.priceLabel.text = "$" + places[indexPath.row].price + "/night"
        cell.ratingLabel.text = places[indexPath.row].rating
        cell.layer.cornerRadius = 5
        cell.imageView.layer.cornerRadius = 5
        
        cell.mainView.layer.cornerRadius = 10
        cell.mainView.layer.borderWidth = 1.0
        cell.mainView.layer.borderColor = UIColor.clear.cgColor
        cell.mainView.layer.masksToBounds = true;
        
        cell.layer.shadowColor = UIColor(rgb: 0xE1E1E2).cgColor
        cell.layer.shadowOffset = CGSize(width:2.0,height: 4.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false;
        
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
    
    let leftAndRightPaddings: Double = 4.0
    let numberOfItemsPerRow: Double = 2.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5)
        
        uid = (auth.currentUser?.uid)!
        loadData();
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Places"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
    func loadData() {
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
                                                                            place.rating = (placeVal[DBGlobal.Specific.Rating.rawValue] as! String)
                                                                            place.ratingNum = (placeVal[DBGlobal.Specific.RatingNum.rawValue] as! String)
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
                                                                            
                                                                            self.collectionView.reloadData()
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
