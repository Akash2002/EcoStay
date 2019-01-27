//
//  LeaseDetailViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 1/27/19.
//  Copyright © 2019 Akash Veerappan. All rights reserved.
//

import UIKit

class LeaseDetailViewController: UIViewController {
    
    var place = Place()

    override func viewDidLoad() {
        super.viewDidLoad()
        place = SearchViewController.passPlace
        
        self.navigationItem.title = place.name
        
    }
    

}
