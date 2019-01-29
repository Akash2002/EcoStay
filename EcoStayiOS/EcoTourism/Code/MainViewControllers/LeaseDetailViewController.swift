//
//  LeaseDetailViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 1/27/19.
//  Copyright © 2019 Akash Veerappan. All rights reserved.


import UIKit

class LeaseDetailViewController: UIViewController {
    
    @IBOutlet weak var priceButtonLabel: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var place = Place()

    override func viewDidLoad() {
        super.viewDidLoad()
        place = SearchViewController.seguePlace
        
        titleLabel.text = place.name
        descriptionLabel.text = place.desc
        
        priceButtonLabel.isEnabled = false
        priceButtonLabel.title = "$" + place.price + "/night"
        
        
        
    }

}
