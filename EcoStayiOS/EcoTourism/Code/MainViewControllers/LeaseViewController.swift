//
//  LeaseViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 11/19/18.
//  Copyright © 2018 Akash Veerappan. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth

class LeaseViewController: UIViewController, CLLocationManagerDelegate {
    

    var locationManager: CLLocationManager = CLLocationManager()
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    
    var isName: Bool = false
    var isDesc: Bool = false
    var isAddr: Bool = false
    var isPrice: Bool = false
    
    var customAlert = CustomAlert()
    
    static var nameOfPlace = ""
    
    var auth: Auth = Auth.auth()
    var databaseReference: DatabaseReference = Database.database().reference()
    
    var currentUID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        currentUID = auth.currentUser?.uid ?? ""
        databaseReference = databaseReference.child(currentUID)
        priceField.keyboardType = .numberPad
    }
    
    @IBAction func onMapCoordClick(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        addressField.text = String((locValue.latitude)) + " " + String((locValue.longitude))
        let userLocation = locations.last
        let viewRegion = MKCoordinateRegion(center: ((userLocation?.coordinate)!), latitudinalMeters: 600, longitudinalMeters: 600)
    }
    
    func processData () {
        databaseReference = databaseReference.child("Leased Places").child(nameField.text!)
        databaseReference.child("Price").setValue(priceField.text)
        databaseReference.child("Address").setValue(addressField.text)
        databaseReference.child("Description").setValue(descriptionField.text)
    }
    
    @IBAction func onNextClicked(_ sender: Any) {

        if (nameField.text?.count) ?? 0 > 0 {
            if ((nameField.text?.count)! >= 3) {
                LeaseViewController.nameOfPlace = nameField.text!
                isName = true

            } else {
                customAlert.showAlert(headingAlert: "Name too short", messageAlert: "Please enter a name of atleast 3 characters", actionTitle: "Retry", viewController: self) { (alert) in

                }
            }
        } else {
            customAlert.showAlert(headingAlert: "Name left blank", messageAlert: "Please enter the name of the place you are selling for rent", actionTitle: "Retry", viewController: self) { (alert) in

            }
        }

        if (descriptionField.text?.count ?? 0 > 0) {
            if ((descriptionField.text?.count)! >= 25) {
                isDesc = true
            } else {
                customAlert.showAlert(headingAlert: "Description too short", messageAlert: "Please enter a description of atleast 25 characters", actionTitle: "Retry", viewController: self) { (alert) in

                }
            }
        } else {
            customAlert.showAlert(headingAlert: "Description left blank", messageAlert: "Please enter the description of the place you are selling for rent", actionTitle: "Retry", viewController: self) { (alert) in

            }
        }

        if addressField.text?.count ?? 0 > 0 {
            if (addressField.text?.count)! > 00 {
                isAddr = true
            } else {
                customAlert.showAlert(headingAlert: "Address too short", messageAlert: "Please enter an address of atleast 3 characters", actionTitle: "Retry", viewController: self) { (alert) in

                }
            }
        } else {
            customAlert.showAlert(headingAlert: "Address left blank", messageAlert: "Please enter the address of the place you are selling for rent", actionTitle: "Retry", viewController: self) { (alert) in

            }
        }

        if priceField.text?.count ?? 0 > 0 {
            if Int(priceField.text!) != nil {
                if Int(priceField.text!)! > 25 {
                    if Int(priceField.text!)! < 500 {
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
        
        if (isName && isPrice && isDesc && isAddr) {
            processData()
            self.performSegue(withIdentifier: "segueToAmenities", sender: self)
        }
    }
    
}
