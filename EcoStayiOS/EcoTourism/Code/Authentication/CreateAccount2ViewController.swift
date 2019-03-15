//
//  CreateAccount2ViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 1/14/19.
//  Copyright © 2019 Akash Veerappan. All rights reserved.
//

import UIKit
import Firebase

class CreateAccount2ViewController: UIViewController {

    @IBOutlet weak var createAccount: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordReentryField: UITextField!
    var authentication = Auth.auth()
    var validPwd: Bool = false
    var databaseReference: DatabaseReference = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createAccount.layer.cornerRadius = 10
     
    }
    
    @IBAction func createAccount(_ sender: Any) {
        if (passwordField.text != nil) {
            if (passwordField.text?.count ?? 0 == 0) {
                showAlert(headingAlert: "Password Missing", messageAlert: "The password field is left blank. Please enter your password.", actionTitle: "Ok") { (action) in
                }
            } else {
                if (passwordField.text?.count ?? 0 > 5) {
                    if (passwordReentryField.text != nil) {
                        if passwordReentryField.text?.count ?? 0 == 0 {
                            showAlert(headingAlert: "Re-entry Password Field is left blank", messageAlert: "The re-entry password field is left blank. Please enter your password again.", actionTitle: "Ok") { (action) in
                            }
                        } else {
                            if (passwordReentryField.text?.count ?? 0 > 5) {
                                if (passwordReentryField.text == passwordField.text) {
                                    validPwd = true
                                    CreateAccount1ViewController.user.pwd = passwordReentryField.text ?? ""
                                } else {
                                    showAlert(headingAlert: "Passwords don't Match", messageAlert: "The passwords entered do not match eachother. Please retry.", actionTitle: "Retry") { (action) in
                                    }
                                }
                            } else {
                                showAlert(headingAlert: "Password Too Short", messageAlert: "The password entered is too short. Please re-enter your password.", actionTitle: "Retry") { (action) in
                                }
                            }
                        }
                    }
                } else {
                    showAlert(headingAlert: "Password Too Short", messageAlert: "The password entered is too short. Please re-enter your password.", actionTitle: "Retry") { (action) in
                    }
                }
            }
        }
        if (CreateAccount1ViewController.validName && CreateAccount1ViewController.validEmail && CreateAccount1ViewController.validDOB && CreateAccount1ViewController.validPhone && validPwd) {
            authentication.createUser(withEmail: CreateAccount1ViewController.user.email, password: CreateAccount1ViewController.user.pwd) { (user, error) in
                if (error != nil) {
                    self.showAlert(headingAlert: "Authentication Error", messageAlert: (error?.localizedDescription)!, actionTitle: "Retry") { (action) in
                    }
                } else {
                    self.storeData()
                    var storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let userVC: UIViewController = storyBoard.instantiateViewController(withIdentifier: "homeVC")
                    self.present(userVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    func showAlert (headingAlert: String, messageAlert: String, actionTitle: String, handleAction: @escaping (_ action: UIAlertAction) -> ()) {
        var alert: UIAlertController = UIAlertController(title: headingAlert, message: messageAlert, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: handleAction))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func storeData() {
        databaseReference = databaseReference.child((authentication.currentUser?.uid)!)
        databaseReference.child(DBGlobal.Name.rawValue).setValue(CreateAccount1ViewController.user.name)
        databaseReference.child(DBGlobal.Email.rawValue).setValue(CreateAccount1ViewController.user.email)
        databaseReference.child(DBGlobal.Phone.rawValue).setValue(CreateAccount1ViewController.user.phone)
        databaseReference.child(DBGlobal.DateOfBirth.rawValue).setValue(CreateAccount1ViewController.user.dob)
    }

}
