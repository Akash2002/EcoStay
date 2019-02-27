//
//  LeaseDetailViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 1/27/19.
//  Copyright © 2019 Akash Veerappan. All rights reserved.


import UIKit
import FirebaseDatabase
import FirebaseAuth

class OptionsCell: UITableViewCell {
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
}

class LeaseDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var options = ["More Information", "Amenities", "Gallery", "Reviews"]
    var details = ["","3","20","4.5"]
    var firstTimeBooking = false
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "double", for: indexPath) as! OptionsCell
        cell.descLabel.text = options[indexPath.row]
        cell.detailLabel.text = details[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch options[indexPath.row] {
            case "More Information":
                performSegue(withIdentifier: "toInfoSegue", sender: self)
        case "Amenities":
            performSegue(withIdentifier: "toAmenities", sender: self)
            default: break
        }
    }
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableWrapperView: UIView!
    
    var place = Place()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        place = SearchViewController.seguePlace
    
        titleLabel.text = place.name
        priceLabel.text = "$" + place.price + "/night"
        
        mainView.layer.cornerRadius = 10
        mainView.layer.shadowColor = UIColor(rgb: 0xE1E1E2).cgColor
        mainView.layer.shadowOffset = CGSize(width:2.0,height: 4.0)
        mainView.layer.shadowRadius = 2.0
        mainView.layer.shadowOpacity = 0.5
        mainView.layer.masksToBounds = false;
        
        tableView.layer.cornerRadius = 10
        tableView.layer.shadowColor = UIColor(rgb: 0xE1E1E2).cgColor
        tableView.layer.shadowOffset = CGSize(width:2.0,height: 4.0)
        tableView.layer.shadowRadius = 2.0
        tableView.layer.shadowOpacity = 0.5
        tableView.layer.masksToBounds = false;
        
        
        tableWrapperView.layer.cornerRadius = 10
        tableWrapperView.layer.shadowColor = UIColor(rgb: 0xE1E1E2).cgColor
        tableWrapperView.layer.shadowOffset = CGSize(width:2.0,height: 4.0)
        tableWrapperView.layer.shadowRadius = 2.0
        tableWrapperView.layer.shadowOpacity = 0.5
        tableWrapperView.layer.masksToBounds = false;
        
        
    }
    
    @IBAction func bookmarkPlace(_ sender: Any) {
        Database.database().reference().child((Auth.auth().currentUser?.uid)!).observe(.value) { (snapshot) in
            if let val = snapshot.value as? [String: Any?] {
                if val["BookmarkedPlaces"] != nil {
                    Database.database().reference().child((Auth.auth().currentUser?.uid)!).child("BookmarkedPlaces").observe(.value, with: { (snapshot) in
                        for places in snapshot.children {
                            if (places as? DataSnapshot)?.key != self.place.name {
                                 Database.database().reference().child((Auth.auth().currentUser?.uid)!).child("BookmarkedPlaces").child(self.place.name).setValue(0)
                                
                            } else {
                                if (!self.firstTimeBooking) {
                                    CustomAlert().showAlert(headingAlert: "Already Saved", messageAlert: "You have already saved " + self.place.name + ".", actionTitle: "Ok", viewController: self, handleAction: { (action) in
                                        
                                    })
                                }
                            }
                        }
                    })
                   
                } else {
                    Database.database().reference().child((Auth.auth().currentUser?.uid)!).child("BookmarkedPlaces").child(self.place.name).setValue(0)
                }
            }
        }
    }
    

}

