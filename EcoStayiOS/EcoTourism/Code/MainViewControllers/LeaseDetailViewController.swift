//
//  LeaseDetailViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 1/27/19.
//  Copyright © 2019 Akash Veerappan. All rights reserved.


import UIKit
import FirebaseDatabase
import FirebaseAuth
import TTGSnackbar

class LeaseDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var options = ["More Information", "Amenities", "Gallery", "Reviews"]
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "double", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch options[indexPath.row] {
            case "More Information":
                performSegue(withIdentifier: "toInfoSegue", sender: self)
            case "Amenities":
                performSegue(withIdentifier: "toAmenities", sender: self)
            case "Gallery":
                performSegue(withIdentifier: "toGallerySegue", sender: self)
            case "Reviews":
                performSegue(withIdentifier: "toReviewDetailSegue", sender: self)
            default: break
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableWrapperView: UIView!
    
    var place = Place()
    var justSaved = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        justSaved = false
        
        place = SearchViewController.seguePlace
    
        titleLabel.text = place.name
        priceLabel.text = "$" + place.price + "/night"
    
    }
    
    @IBAction func bookmarkPlace(_ sender: Any) {
        Database.database().reference().child((Auth.auth().currentUser?.uid)!).child("BookmarkedPlaces").child(self.place.name).setValue(0)
        
        TTGSnackbar.init(message: "Saved " + self.place.name, duration: .short).show()
        
    }
    

}

