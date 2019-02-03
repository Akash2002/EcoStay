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
    var quantity: Int = 0
    
    init(name: String, quantity: Int) {
        self.name = name
        self.quantity = quantity
    }
    
    init () {
        
    }
    
    func toString() -> String {
        return self.name + ": " + String(self.quantity)
    }
}


class AmenitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var tableView: UITableView!
    var amenities: [Amenity] = []
    
    var auth: Auth = Auth.auth()
    var databaseReference: DatabaseReference = Database.database().reference()
    var uid = ""
    
    @IBOutlet weak var amenitiesField: UITextField!
    @IBOutlet weak var quantityLabel: UILabel!
    
    var amenitiesPickerOptions: [String] = ["Bedroom","Kitchen","Lamps","Toiletries","AC Plugs"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uid = (auth.currentUser?.uid)!
        
        var pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        amenitiesField.inputView = pickerView
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
        amenitiesField.text = amenitiesPickerOptions[row]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return amenities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AmenitiesCell
        cell?.nameLabel.text = amenities[indexPath.row].name
        cell?.quantityLabel.text = String(amenities[indexPath.row].quantity)
        return cell ?? UITableViewCell()
    }
    
    @IBAction func onAddClicked(_ sender: Any) {
        print("Added")
        var amenity: Amenity = Amenity()
        if amenitiesField.text?.count ?? 0 > 0 {
            amenity.name = amenitiesField.text!
            amenity.quantity = getDesiredSubstringInt(string: quantityLabel.text!)
            amenities.append(amenity)
            tableView.reloadData()
        }
    }
    
    @IBAction func onNextClicked(_ sender: Any) {
        if !(amenities.count > 0) {
            CustomAlert().showAlert(headingAlert: "Not enough Amenities", messageAlert: "Please add more amenities for the customers to stay.", actionTitle: "Retry", viewController: self) { (action) in
                
            }
        } else {
            for amenity in amenities {
                print(LeaseViewController.nameOfPlace)
                print("Hello")
                databaseReference.child(uid).child("Leased Places").child(LeaseViewController.nameOfPlace).child("Amenities").child(amenity.name).setValue(amenity.quantity)
            }
            
            performSegue(withIdentifier: "ToPicturesSegue", sender: self)
        }
        
    }
    
    @IBAction func onStepperValueChanged(_ sender: Any) {
        quantityLabel.text = "x " + Int(stepper.value).description
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
    
}
