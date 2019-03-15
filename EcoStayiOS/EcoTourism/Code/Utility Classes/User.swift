//
//  User.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 11/17/18.
//  Copyright © 2018 Akash Veerappan. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String
    var dob: String
    var email: String
    var uid: String
    var pwd: String
    var phone: String
    
    override init () {
        self.name = ""
        self.dob = ""
        self.email = ""
        self.uid = ""
        self.pwd = ""
        self.phone = ""
    }
    
    init(name: String, dob: String, email: String, uid: String, pwd: String, phone: String) {
        self.name = name
        self.dob = dob
        self.email = email
        self.uid = uid
        self.pwd = pwd
        self.phone = phone
    }
    
    

}
