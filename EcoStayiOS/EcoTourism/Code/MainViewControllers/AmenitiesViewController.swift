//
//  AmenitiesViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 11/20/18.
//  Copyright © 2018 Akash Veerappan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AmenitiesCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
}

class Amenity {
    var name: String = ""
    var quantity: String = ""
}


class AmenitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var amenities: [Amenity] = []
    var pickerArray: [Int] = [1,2,3,4,5]
    
    var auth: Auth = Auth.auth()
    var databaseReference: DatabaseReference = Database.database().reference()
    var uid = ""
    
    @IBOutlet weak var amenitiesField: UITextField!
    @IBOutlet weak var quantityLabel: UITextField!
    
    @IBOutlet weak var editView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.layer.cornerRadius = 10
        editView.layer.cornerRadius = 10
        
        uid = (auth.currentUser?.uid)!
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return amenities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AmenitiesCell
        cell?.nameLabel.text = amenities[indexPath.row].name
        cell?.quantityLabel.text = amenities[indexPath.row].quantity
        return cell ?? UITableViewCell()
    }
    @IBAction func onAddClicked(_ sender: Any) {
        var amenity: Amenity = Amenity()
        if amenitiesField.text?.count ?? 0 > 0 {
            amenity.name = amenitiesField.text!
            if quantityLabel.text?.count ?? 0 == 1 {
                amenity.quantity = quantityLabel.text!
                amenities.append(amenity)
                tableView.reloadData()
            }
        }
    }
    
    @IBAction func onNextButtonClicked(_ sender: Any) {
        for amenity in amenities {
            print("Hello")
            databaseReference.child(uid).child("Leased Places").child(LeaseViewController.nameOfPlace).child("Amenities").child(amenity.name).setValue(amenity.quantity)
        }
    }
    

}
