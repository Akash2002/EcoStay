//
//  CreateAccount1ViewController.swift
//  
//
//  Created by Akash  Veerappan on 11/17/18.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateAccount1ViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordReentryField: UITextField!
    @IBOutlet weak var dateOfBirthField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    var datePicker: UIDatePicker?
    
    static var validEmail: Bool = false
    static var validName: Bool = false
    static var validPhone: Bool = false
    static var validDOB: Bool = false
    
    static var user: User = User()
    var customAlert = CustomAlert()
    
    var authentication = Auth.auth()
    var databaseReference: DatabaseReference = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        dateOfBirthField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(CreateAccount1ViewController.dateChanged(datePicker:)), for: .valueChanged)
        
    }
    
    @objc func dateChanged (datePicker: UIDatePicker) {
        dateOfBirthField.text = getDateString(date: datePicker.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func getDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if var d: String = dateFormatter.string(from: date) {
            return dateFormatter.string(from: date)
        } else {
            return "Error Decoding Date"
        }
    }
    
    @IBAction func nextClicked(_ sender: Any) {
        if (nameField.text != nil) {
            if (nameField.text?.count ?? 0 == 0) {
                customAlert.showAlert(headingAlert: "Name Missing", messageAlert: "The name field left blank. Please enter your name.", actionTitle: "Retry", viewController: self) { (action) in
                }
            } else {
                if (nameField.text?.count ?? 0 >= 1) {
                    CreateAccount1ViewController.user.name = nameField.text ?? ""
                    CreateAccount1ViewController.validName = true
                } else {
                    customAlert.showAlert(headingAlert: "Incorrect Name", messageAlert: "The name field is entered incorrectly. Please re-enter your name.", actionTitle: "Retry", viewController: self) { (action) in
                    }
                }
            }
        }
        
        if (emailField.text != nil) {
            if (emailField.text?.count ?? 0 == 0) {
                customAlert.showAlert(headingAlert: "Email Missing", messageAlert: "The email field is left blank. Please enter your email.", actionTitle: "Ok", viewController: self) { (action) in
                }
            } else {
                if (emailField.text?.count ?? 0 >= 1) {
                    if (emailField.text?.contains("@") ?? false) {
                        if emailField.text?.contains(".com") ?? false {
                            CreateAccount1ViewController.user.email = emailField.text ?? ""
                            CreateAccount1ViewController.validEmail = true
                        } else {
                            customAlert.showAlert(headingAlert: "Incorrect Email", messageAlert: "The email field is entered incorrectly. Please re-enter your email.", actionTitle: "Retry", viewController: self) { (action) in
                            }
                        }
                    } else {
                        customAlert.showAlert(headingAlert: "Incorrect Email", messageAlert: "The email field is entered incorrectly. Please re-enter your email.", actionTitle: "Retry", viewController: self) { (action) in
                        }
                    }
                } else {
                    customAlert.showAlert(headingAlert: "Incorrect Email", messageAlert: "The email field is entered incorrectly. Please re-enter your email.", actionTitle: "Retry", viewController: self) { (action) in
                    }
                }
            }
        }
        
        if (dateOfBirthField.text != nil) {
            if dateOfBirthField.text?.count ?? 0 == 0 {
                customAlert.showAlert(headingAlert: "Date of Birth Missing", messageAlert: "The date of birth field is missing. Please enter your date of birth.", actionTitle: "Ok", viewController: self) { (action) in
                }
            } else {
                if getDateDate(date: (dateOfBirthField?.text)!) == false {
                    customAlert.showAlert(headingAlert: "Invalid Date", messageAlert: "The date entered is invalid. Please enter your date of birth.", actionTitle: "Ok", viewController: self) { (action) in
                    }
                } else {
                    CreateAccount1ViewController.user.dob = dateOfBirthField.text ?? ""
                    CreateAccount1ViewController.validDOB = true
                }
            }
        }
        
        if (phoneField.text != nil) {
            if (phoneField.text?.count ?? 0 == 0) {
                customAlert.showAlert(headingAlert: "Phone Number Missing", messageAlert: "The phone number field has been left blank. Please enter your phone number.", actionTitle: "Ok", viewController: self) { (action) in
                }
            } else {
                if (phoneField.text?.count ?? 0 >= 4 && phoneField.text?.count ?? 0 <= 13) {
                    CreateAccount1ViewController.validPhone = true
                    CreateAccount1ViewController.user.phone = phoneField.text ?? ""
                } else {
                    customAlert.showAlert(headingAlert: "Incorrect Phone Number", messageAlert: "The phone number field is not entered correctly. Please re-enter your phone number.", actionTitle: "Retry", viewController: self) { (action) in
                    }
                }
            }
        }
    }
    
    func getDateDate(date: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if var d: Date = dateFormatter.date(from: date) {
            return true
        } else {
            return false
        }
    }
    
    @IBAction func unwind(_ sender: UIStoryboardSegue) {
        
    }
    
}
