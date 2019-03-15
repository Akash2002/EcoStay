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
    var numRented: String = ""
    var popularityConstant: String = ""
    var type = ""
    var adminKey = ""
    
    init(name: String, address: String, desc: String, price: String, rating: String, ratingNum: String, admin: String, numRented: String, type: String) {
        self.name = name
        self.address = address
        self.desc = desc
        self.price = price
        self.rating = rating
        self.ratingNum = ratingNum
        self.admin = admin
        self.type = type
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
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
}

class SearchViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var viewBgLabel: UILabel!
    @IBOutlet weak var cellLabelColor: UILabel!
    var tableViewController = UITableViewController()
    
    static var seguePlace: Place = Place()
    
    var filteredArray = [String]()
    var placeNameArray = [String]()
    var filteredPlaceArray = [Place]()
    var filteredOptionDetailPlaceArray = [Place]()
    
    var databaseReference: DatabaseReference = Database.database().reference()
    var auth: Auth = Auth.auth()
    var uid: String = ""
    var places: [Place] = []
    
    let leftAndRightPaddings: Double = 4.0
    let numberOfItemsPerRow: Double = 2.0
    
    var searchController = UISearchController(searchResultsController: nil)
    
    static var filterOptionType: [Int: String] = [:]
    static var ratingRange: (Double, Double) = (0,0)
    static var priceRange = (0,0)
    static var didFilter = false
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredPlaceArray.count
        } else {
            if !SearchViewController.didFilter {
                return places.count
            } else {
                return filteredOptionDetailPlaceArray.count
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if !SearchViewController.didFilter {
            var cell: PlaceCell = tableView.dequeueReusableCell(withIdentifier: "placeTableCell", for: indexPath) as! PlaceCell
            var model = Place()
            if searchController.isActive && searchController.searchBar.text != "" {
                if indexPath.row < filteredPlaceArray.count {
                    model = filteredPlaceArray[indexPath.row]
                }
            } else {
                if !SearchViewController.didFilter {
                    if indexPath.row < places.count {
                        model = places[indexPath.row]
                    }
                } else {
                    if indexPath.row < filteredOptionDetailPlaceArray.count {
                        model = filteredOptionDetailPlaceArray[indexPath.row]
                    }
                }
            }
            
            cell.titleLabel.text = model.name
            cell.priceLabel.text = "$" + model.price + "/night"
            cell.ratingLabel.text = model.rating
            cell.addressLabel.text = model.address
            cell.typeLabel.text = model.type
            
            return cell
            
        } else {
            var cell: PlaceCell = tableView.dequeueReusableCell(withIdentifier: "placeTableCell", for: indexPath) as! PlaceCell
            var model = filteredOptionDetailPlaceArray[indexPath.row]
            if searchController.isActive && searchController.searchBar.text != "" {
                model = filteredPlaceArray[indexPath.row]
            } else {
                model = filteredOptionDetailPlaceArray[indexPath.row]
            }
            
            cell.titleLabel.text = model.name
            cell.priceLabel.text = "$" + model.price + "/night"
            cell.ratingLabel.text = model.rating
            cell.addressLabel.text = model.address
            cell.typeLabel.text = model.type
            
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.isActive && searchController.searchBar.text != "" {
            SearchViewController.seguePlace = filteredPlaceArray[indexPath.row]
        } else {
            if !SearchViewController.didFilter {
                SearchViewController.seguePlace = places[indexPath.row]
            } else {
                 SearchViewController.seguePlace = filteredOptionDetailPlaceArray[indexPath.row]
            }
        }
        performSegue(withIdentifier: "LeasedPlaceDetailSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uid = (auth.currentUser?.uid)!
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Places"
        searchController.searchBar.backgroundColor = UIColor.clear
        searchController.searchBar.searchBarStyle = .minimal
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        tableViewController.tableView.delegate = self
        tableViewController.tableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(onFilterClicked))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(onResetClicked))
        
        navigationItem.title = "Search"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    
    @objc func onResetClicked () {
        SearchViewController.didFilter = false
        tableView.reloadData()
    }
    
    func updateTableViewWithFilterOptions () {
        filteredOptionDetailPlaceArray.removeAll()
        if SearchViewController.didFilter {
            if places != nil {
                for i in stride(from: 0, to: places.count, by: 1) {
                    if let price = Int(places[i].price) {
                        if price >= SearchViewController.priceRange.0 && price <= SearchViewController.priceRange.1 {
                            if let rating = Double(places[i].rating) {
                                if let ratingNum = Double(places[i].ratingNum) {
                                    if ratingNum != 0 {
                                        var ratingValue = (rating/ratingNum)
                                        if ratingValue >= SearchViewController.ratingRange.0 && ratingValue <= SearchViewController.ratingRange.1 {
                                            for (key,value) in SearchViewController.filterOptionType {
                                                if value == places[i].type {
                                                    filteredOptionDetailPlaceArray.append(places[i])
                                                    print(places[i].toString())
                                                    tableView.reloadData()
                                                }
                                            }
                                        }
                                    } else {
                                        for (key,value) in SearchViewController.filterOptionType {
                                            if value == places[i].type {
                                                filteredOptionDetailPlaceArray.append(places[i])
                                                print(places[i].toString())
                                                tableView.reloadData()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    @objc func onFilterClicked () {
        var storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let StoryBoardViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "FilterPage")
        self.present(StoryBoardViewController, animated: true, completion: nil)
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
            for c in snapshot.children {
                var userId = (c as? DataSnapshot)?.key ?? ""
                self.databaseReference.child(userId).observe(.value, with: { (snapshot) in
                    self.places.removeAll()
                    if let val = snapshot.value as? [String: Any?] {
                        var personName = val[DBGlobal.Name.rawValue]
                        if val[DBGlobal.LeasedPlaces.rawValue] != nil {
                            self.databaseReference.child(userId).child(DBGlobal.LeasedPlaces.rawValue).observe(.value, with: { (snapshot) in
                                self.places.removeAll()
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
                                                                            place.adminKey = userId
                                                                            place.price = (placeVal[DBGlobal.Specific.Price.rawValue] as! String)
                                                                            place.type = (placeVal["Type"] as! String)
                                                                            if let ratingNum = Double((placeVal[DBGlobal.Specific.RatingNum.rawValue] as! String)) {
                                                                                if ratingNum != 0 {
                                                                                    place.ratingNum = String(ratingNum)
                                                                                    if let rating = Double((placeVal[DBGlobal.Specific.Rating.rawValue] as! String)) {
                                                                                        place.rating = String(rating/ratingNum)
                                                                                    }
                                                                                } else {
                                                                                    place.ratingNum = String(0)
                                                                                    place.rating = String(0)
                                                                                }
                                                                            }
                                                                            
                                                                            if let numRented = Int((placeVal[DBGlobal.Specific.NumRented.rawValue] as! String)) {
                                                                                if numRented != 0 {
                                                                                    place.numRented = String(numRented)
                                                                                } else {
                                                                                    place.numRented = String(0)
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
                                                                            
                                                                            self.tableView.reloadData()
                                                                            DispatchQueue.main.async(execute: {
                                                                                self.updateTableViewWithFilterOptions()
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
