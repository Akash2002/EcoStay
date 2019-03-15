//
//  AlertHelper.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 1/18/19.
//  Copyright © 2019 Akash Veerappan. All rights reserved.
//

import Foundation
import UIKit
import Cosmos
import FirebaseDatabase
import FirebaseAuth

class CustomAlert {
    
    var hasRated = false
    
    func showAlert (headingAlert: String, messageAlert: String, actionTitle: String, viewController: UIViewController, handleAction: @escaping (_ action: UIAlertAction) -> ()) {
        var alert: UIAlertController = UIAlertController(title: headingAlert, message: messageAlert, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: handleAction))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func ratingActionSheet (place: RentedPlace, headingAlert: String, messageAlert: String, actionTitle: String, viewController: UIViewController, navigationController: UINavigationController) {

        let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)

        let margin:CGFloat = 10.0
        let rect = CGRect(x: margin, y: margin, width: alertController.view.bounds.size.width - margin, height: 120)

        let ratingView = CosmosView(frame: rect)
        ratingView.settings.fillMode = .half
        ratingView.settings.starSize = 30
        ratingView.center = CGPoint(x: (rect.width-margin) / 2, y: (rect.height-margin)/2)

        alertController.view.addSubview(ratingView)
            let submitAction = UIAlertAction(title: "Submit", style: .cancel, handler: {(alert: UIAlertAction!) in
                Database.database().reference().observe(.value, with: { (snapshot) in
                    for i in snapshot.children {
                        Database.database().reference().child((i as? DataSnapshot)!.key).observe(.value, with: { (snapshot) in
                            if let value = snapshot.value as? [String: Any] {
                                if value[DBGlobal.LeasedPlaces.rawValue] != nil {
                                    Database.database().reference().child((i as? DataSnapshot)!.key).child(DBGlobal.LeasedPlaces.rawValue).observe(.value, with: { (snapshot) in
                                        for placeKey in snapshot.children {
                                            if (placeKey as? DataSnapshot)!.key == place.title {
                                                Database.database().reference().child((i as? DataSnapshot)!.key).child(DBGlobal.LeasedPlaces.rawValue).child((placeKey as? DataSnapshot)!.key).observe(.value, with: { (snapshot) in
                                                        if let value = snapshot.value as? [String: Any] {

                                                            var ratingNum: Double = 0
                                                            var ratingVal: Double = 0

                                                            if Double(value["RatingNum"] as! String) != nil {
                                                                ratingNum = Double(value["RatingNum"] as! String)!
                                                            }

                                                            if Double(value["Rating"] as! String) != nil {
                                                                ratingVal = Double(value["Rating"] as! String)!
                                                            }

                                                            ratingVal = ratingVal + ratingView.rating
                                                            ratingNum = ratingNum + 1
                                                        Database.database().reference().child((Auth.auth().currentUser?.uid)!).child("BookedPlaces").child(place.title).observe(.value, with: { (snapshot) in
                                                                if let val = snapshot.value as? [String: Any?] {
                                                                    if val["Rated"] != nil {
                                                                        if val["Rated"] as! String == "NO" {
                                                                             Database.database().reference().child((i as? DataSnapshot)!.key).child(DBGlobal.LeasedPlaces.rawValue).child((placeKey as? DataSnapshot)!.key).child(DBGlobal.Specific.Rating.rawValue).setValue(String(ratingVal))
                                                                                    Database.database().reference().child((i as? DataSnapshot)!.key).child(DBGlobal.LeasedPlaces.rawValue).child((placeKey as? DataSnapshot)!.key).child(DBGlobal.Specific.RatingNum.rawValue).setValue(String(ratingNum))
                                                                                
                                                                                Database.database().reference().child(Auth.auth().currentUser!.uid).child("BookedPlaces").child(place.title).child("Rated").setValue("YES")
                                                                                self.hasRated = true
                                                                            navigationController.popViewController(animated: true)

                                                                        } else {
                                                                            if (!self.hasRated) {
                                                                                CustomAlert().showAlert(headingAlert: "Already Rated", messageAlert: "You have already rated " + place.title, actionTitle: "Retry", viewController: viewController, handleAction: { (action) in

                                                                                })
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            })
                                                        } else {
                                                            print("Already Rated")
                                                        }
                                                    
                                                })
                                            }
                                        }
                                    })
                                }
                            }
                        })
                    }
                })
            })

        let writeReviewAction = UIAlertAction(title: "Write Review...", style: .default) { (action) in
            print("Write Review")
        }


        alertController.addAction(submitAction)
        viewController.present(alertController, animated: true, completion: {})
        
    }
    
}
