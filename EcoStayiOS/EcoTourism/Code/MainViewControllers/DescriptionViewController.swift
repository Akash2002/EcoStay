//
//  DescriptionViewController.swift
//  
//
//  Created by Akash  Veerappan on 2/7/19.
//

import UIKit

class DescriptionViewController: UIViewController {

    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var heading: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Information"
        desc.text = SearchViewController.seguePlace.desc
        heading.text = SearchViewController.seguePlace.name
    }
    
}
