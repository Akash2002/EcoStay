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

class PlaceCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var amenitiesLabel: UILabel!
    
}

class SearchViewController: UITableViewController, UISearchResultsUpdating {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredPlaceArray.count
        } else {
            return places.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: PlaceCell = tableView.dequeueReusableCell(withIdentifier: "placeTableCell", for: indexPath) as! PlaceCell
        var model = places[indexPath.row]
        if searchController.isActive && searchController.searchBar.text != "" {
            model = filteredPlaceArray[indexPath.row]
        } else {
            model = places[indexPath.row]
        }
        
        cell.titleLabel.text = model.name
        cell.priceLabel.text = "$" + model.price + "/night"
        cell.ratingLabel.text = model.rating
        
        return cell
    }
    
    
    @IBOutlet weak var viewBgLabel: UILabel!
    @IBOutlet weak var cellLabelColor: UILabel!
    var tableViewController = UITableViewController()
    
    static var seguePlace: Place = Place()
    
    var filteredArray = [String]()
    var placeNameArray = [String]()
    var filteredPlaceArray = [Place]()
    
    var searchController = UISearchController(searchResultsController: nil)
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        
        uid = (auth.currentUser?.uid)!
        loadData();
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Places"
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        tableViewController.tableView.delegate = self
        tableViewController.tableView.dataSource = self
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        print("UPDATE")
        filteredPlaceArray = places.filter({$0.name.contains(searchController.searchBar.text!)})
        print(filteredPlaceArray)
        tableView.reloadData()
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
                                                                            
                                                                            self.tableView.reloadData()
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
