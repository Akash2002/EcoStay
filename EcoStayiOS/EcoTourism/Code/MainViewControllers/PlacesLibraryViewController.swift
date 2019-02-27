//
//  PlacesLibraryViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 2/17/19.
//  Copyright © 2019 Akash Veerappan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class PlaceLibraryCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fromToDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currentImageView: UIImageView!
    @IBOutlet weak var previousImageView: UIImageView!
    
}

class RentedPlace {
    var title = ""
    var fromToDate = ""
    var current = false
    
    init(title: String, fromToDate: String, current: Bool) {
        self.title = title
        self.fromToDate = fromToDate
        self.current = current
    }
    
    init() {
        
    }
    
}

class PlacesLibraryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var segmentValue = ""
    var place = RentedPlace()
    var rentedPlaces = [RentedPlace]()
    var leasedPlaces = [Place]()
    var savedPlaces = [String]()
    
    var dbRef = Database.database().reference().child(Auth.auth().currentUser!.uid)
    
    var segmentHeaders = ["Rented","Listed","Saved"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentValue = "Rented"
        processDataBooked()
        processDataLeased()
        processDataSaved()
        
        tableView.layer.cornerRadius = 10
        tableView.layer.borderWidth = 2
        tableView.layer.borderColor = UIColor.clear.cgColor
        tableView.layer.masksToBounds = true
        
        print(DateUtility.isDateInRange(date1: DateUtility.getDateDate(date: "01/22/2002"), date2: DateUtility.getDateDate(date: "02/22/2002"), compareDate: DateUtility.getDateDate(date: "02/17/2002")))
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentValue {
        case "Rented":
            return rentedPlaces.count
        case "Listed":
            return leasedPlaces.count
        case "Saved":
            return savedPlaces.count
        default:
            return rentedPlaces.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PlaceLibraryCell
        switch segmentValue {
            case "Rented":
                cell?.titleLabel.text = rentedPlaces[indexPath.row].title
                cell?.fromToDateLabel.text = rentedPlaces[indexPath.row].fromToDate
                if (place.current) {
                    cell?.currentImageView.isHidden = true
                    cell?.previousImageView.isHidden = false
                } else {
                    cell?.currentImageView.isHidden = false
                    cell?.previousImageView.isHidden = true
                }
                return cell!
            case "Listed":
                cell?.titleLabel.text = leasedPlaces[indexPath.row].name
                cell?.fromToDateLabel.text = leasedPlaces[indexPath.row].price
                return cell!
            case "Saved":
                cell?.titleLabel.text = savedPlaces[indexPath.row]
                cell?.fromToDateLabel.isHidden = true
                cell?.currentImageView.isHidden = true
                cell?.previousImageView.isHidden = true
                return cell!
            default: return UITableViewCell()
        }
    }
    
    @IBAction func onSegmentValueChange(_ sender: Any) {
        segmentValue = segmentHeaders[segmentControl.selectedSegmentIndex]
        print("Segment \(segmentValue)")
        tableView.reloadData()
    }
    
    func processDataBooked () {
        dbRef.observe(.value) { (snapshot) in
            if let value = snapshot.value as? [String: Any?] {
                if value["BookedPlaces"] != nil {
                    self.dbRef.child("BookedPlaces").observe(.value, with: { (snapshot) in
                        for places in snapshot.children {
                            self.dbRef.child("BookedPlaces").child((places as? DataSnapshot)!.key).observe(.value, with: { (snapshot) in
                                if let value = snapshot.value as? [String: Any?] {
                                    self.place.title = (places as? DataSnapshot)!.key
                                    self.place.fromToDate = (value["FromWhen"] as! String) + " to " + (value["ToWhen"] as! String)
                                    self.place.current = DateUtility.isDateInRange(date1: DateUtility.getDateDate(date: value["FromWhen"] as! String), date2: DateUtility.getDateDate(date: value["ToWhen"] as! String), compareDate: DateUtility.getDateDate(date: DateUtility.getCurrentDate()))
                                    self.rentedPlaces.append(self.place)
                                    DispatchQueue.main.async(execute: {
                                        self.tableView.reloadData()
                                    })
                                }
                            })
                        }
                    })
                }
            }
        }
    }
    
    func processDataSaved () {
        dbRef.observe(.value) { (snapshot) in
            self.savedPlaces.removeAll()
            if let value = snapshot.value as? [String: Any?] {
                if value["BookmarkedPlaces"] != nil {
                    self.dbRef.child("BookmarkedPlaces").observe(.value, with: { (snapshot) in
                        for places in snapshot.children {
                            self.savedPlaces.append(((places as? DataSnapshot)?.key)!)
                            print("Book saved")
                            DispatchQueue.main.async(execute: {
                                self.tableView.reloadData()
                            })
                        }
                    })
                }
            }
        }
    }
    
    func processDataLeased () {
        dbRef.observe(.value) { (snapshot) in
            if let val = snapshot.value as? [String: Any?] {
                if val[DBGlobal.LeasedPlaces.rawValue] != nil {
                    self.dbRef.child(DBGlobal.LeasedPlaces.rawValue).observe(.value, with: { (snapshot) in
                        for tempPlaces in snapshot.children {
                            self.dbRef.child(DBGlobal.LeasedPlaces.rawValue).child((tempPlaces as? DataSnapshot)!.key).observe(.value, with: { (snapshot) in
                                if let val = snapshot.value as? [String: Any?] {
                                        var place = Place()
                                        if let placeVal = snapshot.value as? [String: Any?] {
                                            if placeVal[DBGlobal.Specific.Address.rawValue] != nil {
                                                if placeVal[DBGlobal.Specific.Description.rawValue] != nil {
                                                    if placeVal[DBGlobal.Specific.Price.rawValue] != nil {
                                                        if placeVal[DBGlobal.Specific.Rating.rawValue] != nil {
                                                            if placeVal[DBGlobal.Specific.RatingNum.rawValue] != nil {
                                                                if placeVal[DBGlobal.Specific.Amenities.rawValue] != nil {
                                                                   print("INTOTHISSHIT")
                                                                    self.dbRef.child(DBGlobal.LeasedPlaces.rawValue).child((tempPlaces as? DataSnapshot)!.key).child(DBGlobal.Specific.Amenities.rawValue).observe(.value, with: { (snapshot) in
                                                                        if let amenityVal = snapshot.value as? [String: Int] {
                                                                            var tempAmenities: [Amenity] = []
                                                                            var i = 0
                                                                            for c in amenityVal {
                                                                                var tempAmenity = Amenity(name: c.key, quantity: c.value)
                                                                                tempAmenities.append(tempAmenity)
                                                                                i += 1
                                                                            }
                                                                            if (i > 0) {
                                                                                place.amenities = tempAmenities
                                                                            }
                                                                        }
                                                                        
                                                                        place.name = (tempPlaces as? DataSnapshot)?.key as! String
                                                                        place.address = "Address: " + (placeVal[DBGlobal.Specific.Address.rawValue] as! String)
                                                                        place.desc = placeVal[DBGlobal.Specific.Description.rawValue] as! String
                                                                        place.price = (placeVal[DBGlobal.Specific.Price.rawValue] as! String)
                                                                        place.rating = (placeVal[DBGlobal.Specific.Rating.rawValue] as! String)
                                                                        place.ratingNum = (placeVal[DBGlobal.Specific.RatingNum.rawValue] as! String)
                                                                        
                                                                        self.leasedPlaces.append(place)
                                                                        
                                                                        print(place.name)
                                                                       
                                                                        DispatchQueue.main.async(execute: {
                                                                            self.tableView.reloadData()
                                                                        })
                                                                    })
                                                                }
                                                                
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
        }
    }
    
}
