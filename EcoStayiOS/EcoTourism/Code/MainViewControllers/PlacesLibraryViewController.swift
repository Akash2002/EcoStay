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
    @IBOutlet weak var numRentedLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
}

class RentedPlace {
    var title = ""
    var fromToDate = ""
    var status = ""
    
    init(title: String, fromToDate: String, status: String) {
        self.title = title
        self.fromToDate = fromToDate
        self.status = status
    }
    
    init(title: String, fromToDate: String) {
        self.title = title
        self.fromToDate = fromToDate
    }
    
    init() {
        
    }
}

class PlacesLibraryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var segmentValue = ""
    var place = RentedPlace()
    var leasedPlaces = [Place]()
    var rentedPlaces = [RentedPlace]()
    var savedPlaces = [String]()
    var alert = CustomAlert()
    static var reviewPlace = ""
    static var seguePlace = Place()
    
    var dbRef = Database.database().reference().child(Auth.auth().currentUser!.uid)
    
    var segmentHeaders = ["Rented", "Listed", "Saved"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentValue = "Rented"
        processDataLeased()
        processDataSaved()
        processDataRented()
        
        alert.hasRated = false
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentValue {
            case "Listed":
                return leasedPlaces.count
            case "Saved":
                return savedPlaces.count
            case "Rented":
                return rentedPlaces.count
            default:
                return rentedPlaces.count
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if segmentValue == "Rented" {
            let rate = UITableViewRowAction(style: .normal, title: "Rate") { (action, indexPath) in
                self.alert.ratingActionSheet(place: self.rentedPlaces[indexPath.row], headingAlert: "Rate", messageAlert: "Rate", actionTitle: "Submit", viewController: self, navigationController: self.navigationController!)
            }
            let review = UITableViewRowAction(style: .normal, title: "Review") { (action, indexPath) in
                self.performSegue(withIdentifier: "toReviewSegue", sender: self)
                PlacesLibraryViewController.reviewPlace = self.rentedPlaces[indexPath.row].title
            }
            rate.backgroundColor = UIColor(red: 0, green: 100, blue: 148)
            review.backgroundColor = UIColor(red: 199, green: 49, blue: 79)
            return [review, rate]
        } else if segmentValue == "Saved" {
            let delete = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
                Database.database().reference().child(Auth.auth().currentUser!.uid).child("BookmarkedPlaces").child(self.savedPlaces[indexPath.row]).removeValue()
                
                self.navigationController?.popViewController(animated: true)
                
            }
            delete.backgroundColor = .red
            return [delete]
        } else {
            let delete = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
                Database.database().reference().child(Auth.auth().currentUser!.uid).child("Leased Places").child(self.leasedPlaces[indexPath.row].name).removeValue()
                
                self.navigationController?.popViewController(animated: true)
            }
            delete.backgroundColor = .red
            return [delete]
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlaceLibraryCell
        switch segmentValue {
            case "Rented":
                var status = rentedPlaces[indexPath.row].status
                cell.titleLabel.text = rentedPlaces[indexPath.row].title
                cell.fromToDateLabel.text = rentedPlaces[indexPath.row].fromToDate
                cell.numRentedLabel.text = status
                
                if status == "Upcoming" {
                    cell.numRentedLabel.textColor = UIColor(red: 0, green: 100, blue: 148)
                } else if status == "Past" {
                    cell.numRentedLabel.textColor = UIColor(red: 199, green: 49, blue: 79)
                } else {
                    cell.numRentedLabel.textColor = UIColor(red: 0, green: 164, blue: 85)
                }
                
                cell.fromToDateLabel.isHidden = false
                cell.ratingLabel.isHidden = true
                cell.numRentedLabel.isHidden = false
                return cell
            case "Listed":
                cell.titleLabel.text = leasedPlaces[indexPath.row].name
                cell.fromToDateLabel.text = "$" + leasedPlaces[indexPath.row].price + "/night"
                cell.numRentedLabel.text = "Num Rented: " + leasedPlaces[indexPath.row].numRented
                cell.numRentedLabel.textColor = UIColor(red: 111, green: 113, blue: 121)
                
                cell.ratingLabel.text = "⭑ \(leasedPlaces[indexPath.row].rating)"
                cell.fromToDateLabel.isHighlighted = false
                cell.ratingLabel.isHidden = false
                cell.numRentedLabel.isHidden = false
                return cell
            case "Saved":
                cell.titleLabel.text = savedPlaces[indexPath.row]
                cell.fromToDateLabel.isHidden = true
                cell.ratingLabel.isHidden = true
                cell.numRentedLabel.isHidden = true
                return cell
            default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch segmentValue {
        case "Listed":
            PlacesLibraryViewController.seguePlace = leasedPlaces[indexPath.row]
            performSegue(withIdentifier: "toEditListedPlace", sender: self)
        default:
            PlacesLibraryViewController.seguePlace = Place()
        }
    }
    
    @IBAction func onSegmentValueChange(_ sender: Any) {
        segmentValue = segmentHeaders[segmentControl.selectedSegmentIndex]
        tableView.reloadData()
    }
    
    
    
    func processDataRented() {
        dbRef.observe(.value) { (snapshot) in
            self.rentedPlaces.removeAll()
            if let value = snapshot.value as? [String: Any?] {
                if value["BookedPlaces"] != nil {
                    self.rentedPlaces.removeAll()
                    self.dbRef.child("BookedPlaces").observe(.value, with: { (snapshot) in
                        for place in snapshot.children {
                            self.dbRef.child("BookedPlaces").child((place as? DataSnapshot)!.key).observe(.value, with: { (snapshot) in
                                if let val = snapshot.value as? [String: Any?] {
                                    
                                    if val["ToWhen"] != nil {
                                        if val["FromWhen"] != nil {
                                            var dateTo = DateUtility.getDateDate(date: val["ToWhen"] as! String)
                                            var dateFrom = DateUtility.getDateDate(date: val["FromWhen"] as! String)
                                            var currentDate = DateUtility.getDateDate(date: DateUtility.getCurrentDate())
                                            var place = RentedPlace(title: (place as? DataSnapshot)!.key, fromToDate: (val["FromWhen"] as! String) + " - " + (val["ToWhen"] as! String))
                                            
                                            if DateUtility.isDateGreater(placeHolderDate: dateTo, dateToBeCompared: currentDate) {
                                                place.status = "Past"
                                            }
                                            
                                            if DateUtility.isDateInRange(date1: dateFrom, date2: dateTo, compareDate: currentDate) {
                                                place.status = "Current"
                                            }
                                            
                                            if DateUtility.isDateGreater(placeHolderDate: currentDate, dateToBeCompared: dateFrom) {
                                                place.status = "Upcoming"
                                            }
                                            
                                            self.rentedPlaces.append(place)
                                            
                                            DispatchQueue.main.async(execute: {
                                                self.tableView.reloadData()
                                            })
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
    
    func processDataSaved () {
        dbRef.observe(.value) { (snapshot) in
            self.savedPlaces.removeAll()
            if let value = snapshot.value as? [String: Any?] {
                if value["BookmarkedPlaces"] != nil {
                    self.dbRef.child("BookmarkedPlaces").observe(.value, with: { (snapshot) in
                        for places in snapshot.children {
                            self.savedPlaces.append(((places as? DataSnapshot)?.key)!)
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
            self.leasedPlaces.removeAll()
            if let val = snapshot.value as? [String: Any?] {
                if val[DBGlobal.LeasedPlaces.rawValue] != nil {
                    self.dbRef.child(DBGlobal.LeasedPlaces.rawValue).observe(.value, with: { (snapshot) in
                        self.leasedPlaces.removeAll()
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
                                                                        self.leasedPlaces.append(place)
                                                                        
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
