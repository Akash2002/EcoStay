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
        getData()
        
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
    
    func getData() {
        databaseReference.observe(.value) { (snapshot) in
            for c in snapshot.children {
                var userID = (c as? DataSnapshot)?.key ?? ""
                print(userID)
                self.databaseReference.child(userID).observe(.value, with: { (snapshot) in
                    if let val = snapshot.value as? [String:Any?] {
                        if val["Leased Places"] != nil {
                            print("DO")
                            self.databaseReference.child(userID).child("Leased Places").observe(.value, with: { (snapshot) in
                                for c in snapshot.children {
                                    var place: Place = Place()
                                    place.name = (c as? DataSnapshot)?.key ?? ""
                                    self.databaseReference.child(userID).child("Leased Places").child(place.name).observe(.value, with: { (snapshot) in
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
