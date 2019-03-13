//
//  AmenitiesDescriptionViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 2/7/19.
//  Copyright © 2019 Akash Veerappan. All rights reserved.
//

import UIKit

class AmenitiesDescCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
}

class AmenitiesDescriptionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var amenitiesTableView: UITableView!
    @IBOutlet weak var heading: UILabel!
    
    var amenities = SearchViewController.seguePlace.amenities
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return amenities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: AmenitiesDescCell = tableView.dequeueReusableCell(withIdentifier: "amCell", for: indexPath) as! AmenitiesDescCell
        cell.nameLabel.text = amenities[indexPath.row].name
        cell.quantityLabel.text = String(amenities[indexPath.row].quantity)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for amenity in amenities {
            print(amenity.name)
        }
        navigationItem.title = "Amenities"
    }
    

}
