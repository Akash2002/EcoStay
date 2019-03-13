//
//  ReviewPlaceDetailViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 3/8/19.
//  Copyright © 2019 Akash Veerappan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ReviewCell: UITableViewCell {
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var reviewedByNameLabel: UILabel!
}

class Review {
    var review: String = ""
    var reviewedByName: String = ""
    init(review: String, reviewedByName: String) {
        self.review = review
        self.reviewedByName = reviewedByName
    }
}

class ReviewPlaceDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var reviews = [Review]()
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ReviewCell
        cell.reviewLabel.text = "\"" + reviews[indexPath.row].reviewedByName + "\""
        cell.reviewedByNameLabel.text = reviews[indexPath.row].review
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference().observe(.value) { (snapshot) in
            for name in snapshot.children {
                Database.database().reference().child((name as? DataSnapshot)!.key).observe(.value, with: { (snapshot) in
                    if let val = snapshot.value as? [String: Any] {
                        if val["Leased Places"] != nil {
                            Database.database().reference().child((name as? DataSnapshot)!.key).child("Leased Places").child(SearchViewController.seguePlace.name).observe(.value, with: { (snapshot) in
                                if let val = snapshot.value as? [String: Any] {
                                    if val["Reviews"] != nil {
                                        Database.database().reference().child((name as? DataSnapshot)!.key).child("Leased Places").child(SearchViewController.seguePlace.name).child("Reviews").observe(.value, with: { (snapshot) in
                                            if let val = snapshot.value as? [String: Any] {
                                                for nameKey in snapshot.children {
                                                    if nameKey != nil {
                                                        print((nameKey as? DataSnapshot)!.key)
                                                        var review = Review(review: (nameKey as? DataSnapshot)!.key, reviewedByName: val[(nameKey as? DataSnapshot)!.key] as! String)
                                                        self.reviews.append(review)
                                                        DispatchQueue.main.async(execute: {
                                                            self.tableView.reloadData()
                                                        })
                                                    }
                                                }
                                            }
                                        })
                                        
                                    }
                                }
                            })
                        }
                    }
                })
            }
        }
        
        
    }
    

}
