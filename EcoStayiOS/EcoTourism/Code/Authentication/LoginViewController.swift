//
//  LoginViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 11/16/18.
//  Copyright © 2018 Akash Veerappan. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var underline: UIView!
    
    var email: String = ""
    var pwd: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modButton()
        self.navigationController?.navigationBar.isHidden = true
        
        testSubstrings()
        
    }
    
    @IBAction func onLoginClicked(_ sender: UIButton) {
        
        var validEmail: Bool = false
        var validPwd: Bool = false
        
        if (emailField.text != nil) {
            if (emailField.text?.count ?? 0 > 6) {
                if (emailField.text?.contains("@") ?? false) {
                    email = emailField.text ?? ""
                    validEmail = true
                }
            }
        }
        
        if (pwdField.text != nil) {
            if (pwdField.text?.count ?? 0 > 6) {
                pwd = pwdField.text ?? ""
                validPwd = true
            }
        }
        
        if (!validEmail && !validPwd) {
            Auth.auth().signIn(withEmail: "akashpalaniappan@gmail.com", password: "akash#123") { (user, error) in
                if error != nil {
                    print("ERR")
                    CustomAlert().showAlert(headingAlert: "Could not sign in.", messageAlert: (error?.localizedDescription)!, actionTitle: "Retry", viewController: self, handleAction: { (action) in
                        
                    })
                } else {
                    self.moveToUserPage()
                }
            }
        }
        
        
    }
    
    func moveToUserPage() {
        var storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let userVC: UIViewController = storyBoard.instantiateViewController(withIdentifier: "homeVC")
        self.present(userVC, animated: true, completion: nil)
    }
    
    func modButton () {
        loginButton.layer.cornerRadius = 8
        loginButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    func modView () {
        loginView.layer.cornerRadius = 10
        loginView.layer.shadowColor = UIColor.black.cgColor
        loginView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        loginView.layer.shadowRadius = 1.7
        loginView.layer.shadowOpacity = 0.5
        underline.layer.cornerRadius = 25
    }
    
    @IBAction func unwindToOne (_ sender: UIStoryboardSegue) {
        
    }
    
    func testSubstrings () {
       
    }
    
}
