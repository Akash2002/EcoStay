//
//  LeaseDetailViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 1/27/19.
//  Copyright © 2019 Akash Veerappan. All rights reserved.


import UIKit

class OptionsCell: UITableViewCell {
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
}

class LeaseDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var options = ["Description", "Amenities", "Gallery", "Reviews"]
    var details = ["","3","20","4.5"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "double", for: indexPath) as! OptionsCell
        cell.descLabel.text = options[indexPath.row]
        cell.detailLabel.text = details[indexPath.row]
        return cell
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var place = Place()

    override func viewDidLoad() {
        super.viewDidLoad()
        place = SearchViewController.seguePlace

        titleLabel.text = place.name
        priceLabel.text = "$" + place.price + "/night"
        
        print(place.amenities)
    }

}

