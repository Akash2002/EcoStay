//
//  ListedPlaceEditViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 3/10/19.
//  Copyright © 2019 Akash Veerappan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AmenityEditCell: UITableViewCell{
    @IBOutlet weak var amenityLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
}

class ListedPlaceEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var descriptionLabel: UITextField!
    @IBOutlet weak var addressLabel: UITextField!
    @IBOutlet weak var priceLabel: UITextField!
    @IBOutlet weak var amenityField: UITextField!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var customAlert = CustomAlert()
    var isPrice = false
    var isAddr = false
    var isDesc = false
    
    var amenitiesPickerOptions: [String] = ["Bedroom","Kitchen","Bathrooms", "Conservation Parks", "Gardens", "Trail", "Pond"]
    var amenities: [Amenity] = []

    var auth: Auth = Auth.auth()
    var databaseReference: DatabaseReference = Database.database().reference()
    var uid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = PlacesLibraryViewController.seguePlace.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Confirm", style: .done, target: self, action: #selector(onConfirmClicked))
        
        uid = (auth.currentUser?.uid)!
        
        var pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        amenityField.inputView = pickerView
        
        updateVals()
        updateTable()
        
    }
    
    @objc func onConfirmClicked() {
        
        if (descriptionLabel.text?.count ?? 0 > 0) {
            if ((descriptionLabel.text?.count)! >= 25) {
                isDesc = true
            } else {
                customAlert.showAlert(headingAlert: "Description too short", messageAlert: "Please enter a description of atleast 25 characters", actionTitle: "Retry", viewController: self) { (alert) in
                    
                }
            }
        } else {
            customAlert.showAlert(headingAlert: "Description left blank", messageAlert: "Please enter the description of the place you are selling for rent", actionTitle: "Retry", viewController: self) { (alert) in
                
            }
        }
        
        if addressLabel.text?.count ?? 0 > 0 {
            if (addressLabel.text?.count)! > 00 {
                isAddr = true
            } else {
                customAlert.showAlert(headingAlert: "Address too short", messageAlert: "Please enter an address of atleast 3 characters", actionTitle: "Retry", viewController: self) { (alert) in
                    
                }
            }
        } else {
            customAlert.showAlert(headingAlert: "Address left blank", messageAlert: "Please enter the address of the place you are selling for rent", actionTitle: "Retry", viewController: self) { (alert) in
                
            }
        }
        
        if priceLabel.text?.count ?? 0 > 0 {
            if Int(priceLabel.text!) != nil {
                if Int(priceLabel.text!)! > 25 {
                    if Int(priceLabel.text!)! < 500 {
                        isPrice = true
                    } else {
                        customAlert.showAlert(headingAlert: "Price too high", messageAlert: "Please enter a price below $500 for a night", actionTitle: "Retry", viewController: self) { (alert) in
                            
                        }
                    }
                } else {
                    customAlert.showAlert(headingAlert: "Price too low", messageAlert: "Please enter a price of atleast $25", actionTitle: "Retry", viewController: self) { (alert) in
                        
                    }
                }
                
            } else {
                customAlert.showAlert(headingAlert: "Price invalid", messageAlert: "Please enter the price properly", actionTitle: "Retry", viewController: self) { (alert) in
                    
                }
            }
        } else {
            customAlert.showAlert(headingAlert: "Price left blank", messageAlert: "Please enter the price of the place you are selling for rent", actionTitle: "Retry", viewController: self) { (alert) in
                
            }
        }
        
        if ((isPrice && isDesc && isAddr)) {
            processData()
            navigationController?.popViewController(animated: true)
        }
    }
    
    func processData () {
        var databaseReference = Database.database().reference().child(Auth.auth().currentUser!.uid).child("Leased Places").child(PlacesLibraryViewController.seguePlace.name)
        databaseReference.child(DBGlobal.Specific.Price.rawValue).setValue(priceLabel.text)
        databaseReference.child(DBGlobal.Specific.Address.rawValue).setValue(addressLabel.text)
        databaseReference.child(DBGlobal.Specific.Description.rawValue).setValue(descriptionLabel.text)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return amenitiesPickerOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return amenitiesPickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        amenityField.text = amenitiesPickerOptions[row]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return amenities.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var delete = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            Database.database().reference().child((Auth.auth().currentUser?.uid)!).child("Leased Places").child(PlacesLibraryViewController.seguePlace.name).child("Amenities").child(self.amenities[indexPath.row].name).removeValue()
        }
        delete.backgroundColor = .red
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("RUN)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AmenityEditCell
        cell?.amenityLabel.text = amenities[indexPath.row].name
        cell?.quantityLabel.text = String(amenities[indexPath.row].quantity)
        return cell ?? UITableViewCell()
    }
    
    @IBAction func addClicked(_ sender: Any) {
        Database.database().reference().child((Auth.auth().currentUser?.uid)!).child("Leased Places").child(PlacesLibraryViewController.seguePlace.name).child("Amenities").child((amenityField.text?.description)!).setValue(getDesiredSubstringInt(string: (quantityLabel.text!)))
    }
    
    @IBAction func onStepperValueChanged(_ sender: Any) {
        print("SETEPPER CHANGED")
        quantityLabel.text = "x " + Int((sender as! UIStepper).value).description
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func getDesiredSubstringInt(string: String) -> Int {
        var newString: String = ""
        for s in string {
            if s != "x" && s != " " {
                newString = String(s)
            }
        }
        if let converted = Int(newString) {
            return converted
        } else {
            return 0
        }
    }
    
    func updateVals () {
        Database.database().reference().child((Auth.auth().currentUser?.uid)!).child("Leased Places").child(PlacesLibraryViewController.seguePlace.name).observe(.value) { (snapshot) in
            if let val = snapshot.value as? [String: Any] {
                self.descriptionLabel.text = val["Description"] as! String
                self.addressLabel.text = val["Address"] as! String
                self.priceLabel.text = val["Price"] as! String
            }
        }
    }
    
    func updateTable() {
        Database.database().reference().child((Auth.auth().currentUser?.uid)!).child("Leased Places").child(PlacesLibraryViewController.seguePlace.name).child("Amenities").observe(.value) { (snapshot) in
            self.amenities.removeAll()
            if let val = snapshot.value as? [String: Any] {
                for key in snapshot.children {
                    var amenity = Amenity(name: (key as? DataSnapshot)!.key, quantity: val[(key as? DataSnapshot)!.key] as! Int)
                    self.amenities.append(amenity)
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                }
            }
        }
    }

}
