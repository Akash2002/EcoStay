//
//  ProfileViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 11/18/18.
//  Copyright © 2018 Akash Veerappan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ProfileCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
}

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var hiddenText: UILabel!
    var profileOptions = ["Edit", "Rental History", "Reviews", "Settings", "Logout"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileCell
        cell.label?.text = profileOptions[indexPath.row]
        if (indexPath.row == profileOptions.count - 1) {
            cell.label.textColor = hiddenText.textColor
        }
        return cell
    }
    

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profileSection: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var user: User = User()
    
    var currentUserUID: String = ""
    var auth: Auth = Auth.auth()
    var databaseReference: DatabaseReference = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentUserUID = (auth.currentUser?.uid) ?? ""
        
        if currentUserUID.count > 1 {
            databaseReference = databaseReference.child(currentUserUID)
        }
        
        performProfileDataTransaction()
        tableView.alwaysBounceVertical = false
    }
    
    func performProfileDataTransaction() {
        databaseReference.observe(.value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any?] {
                self.user.email = dict[DBGlobal.Email.rawValue] as? String ?? ""
                self.user.name = dict[DBGlobal.Name.rawValue] as? String ?? ""
                self.user.dob = dict[DBGlobal.DateOfBirth.rawValue] as? String ?? ""
                self.user.phone = dict[DBGlobal.Phone.rawValue] as? String ?? ""
                
                self.nameLabel.text = self.user.name
                self.emailLabel.text = self.user.email
                self.dobLabel.text = self.user.dob
                self.phoneLabel.text = self.user.phone
            }
        }
    }

}
