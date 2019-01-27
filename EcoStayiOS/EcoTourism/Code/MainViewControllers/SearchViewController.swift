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

class PlacesCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingVal: UILabel!
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var placesTableView: UITableView!
    
    var databaseReference: DatabaseReference = Database.database().reference()
    var auth: Auth = Auth.auth()
    var uid: String = ""
    var places: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uid = (auth.currentUser?.uid)!
        //getData()
        test();
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlacesCell
        cell.addressLabel.text = places[indexPath.row].address
        cell.nameLabel.text = places[indexPath.row].name
        cell.priceLabel.text = places[indexPath.row].price
        cell.ratingVal.text = places[indexPath.row].rating
        return cell
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
                                                                        print(p.toString())
                                                                    }
                                                                    DispatchQueue.main.async(execute: {
                                                                        self.placesTableView.reloadData()
                                                                    })
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
    
    func getData() {
        databaseReference.observe(.value) { (snapshot) in
            for c in snapshot.children {
                print("Async 1")
                var userID = (c as? DataSnapshot)?.key ?? ""
                print(userID)
                self.databaseReference.child(userID).observe(.value, with: { (snapshot) in
                    print("Async 2")
                    if let val = snapshot.value as? [String:Any?] {
                        if val["Leased Places"] != nil {
                            print("DO")
                            self.databaseReference.child(userID).child("Leased Places").observe(.value, with: { (snapshot) in
                                for c in snapshot.children {
                                    print("Async 3")
                                    var place: Place = Place()
                                    place.name = (c as? DataSnapshot)?.key ?? ""
                                    self.databaseReference.child(userID).child("Leased Places").child(place.name).observe(.value, with: { (snapshot) in
                                        print("Async 4")
                                        if let val = snapshot.value as? [String:Any?] {
                                            print(val)
                                            print(val["Description"])
                                            if val["Description"] != nil {
                                                place.desc = val["Description"] as! String
                                            }
                                            if val["Address"] != nil {
                                                print("Address Success")
                                                place.address = val["Address"] as! String
                                            }
                                            if val["RatingNum"] != nil {
                                                place.ratingNum = val["RatingNum"] as! String
                                            }
                                            if val["Rating"] != nil {
                                                place.rating = val["Rating"] as! String
                                            }
                                            if val["Price"] != nil {
                                                place.price = val["Price"] as! String
                                            }
                                            
                                            self.places.append(place)
                                            DispatchQueue.main.async(execute: {
                                                self.placesTableView.reloadData()
                                            })
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
