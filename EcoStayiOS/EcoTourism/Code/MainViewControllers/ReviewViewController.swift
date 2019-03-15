//
//  ReviewViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 3/8/19.
//  Copyright © 2019 Akash Veerappan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ReviewViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reviewField: UITextView!
    
    var hasReviewed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = PlacesLibraryViewController.reviewPlace
        navigationItem.title = "Review"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(onSubmitClick))
        
    }
    
    @objc func onSubmitClick () {
        var userReview = String(reviewField.text)
        if userReview.count > 50 {
            Database.database().reference().observe(.value, with: { (snapshot) in
                for i in snapshot.children {
                    Database.database().reference().child((i as? DataSnapshot)!.key).observe(.value, with: { (snapshot) in
                        if let value = snapshot.value as? [String: Any] {
                            if value[DBGlobal.LeasedPlaces.rawValue] != nil {
                                Database.database().reference().child((i as? DataSnapshot)!.key).child(DBGlobal.LeasedPlaces.rawValue).observe(.value, with: { (snapshot) in
                                    for placeKey in snapshot.children {
                                        if (placeKey as? DataSnapshot)!.key == PlacesLibraryViewController.reviewPlace {
                                            print((placeKey as? DataSnapshot)!.key)
                                            Database.database().reference().child((i as? DataSnapshot)!.key).child(DBGlobal.LeasedPlaces.rawValue).child(PlacesLibraryViewController.reviewPlace).child("Reviews").child(HomeViewController.personName).setValue(userReview)
                                            self.navigationController?.popViewController(animated: true)
                                            }
                                        }
                                    })
                                }
                            }
                        })
                    }
                })
            }
        }
    }

