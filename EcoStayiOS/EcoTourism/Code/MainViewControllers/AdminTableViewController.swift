//
//  AdminTableViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 3/11/19.
//  Copyright © 2019 Akash Veerappan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CustomDeletion {
    
}

class AdminTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var places: [String] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if indexPath.row < places.count {
            cell?.textLabel?.text = places[indexPath.row]
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        print(places[indexPath.row])
        var delete = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            Database.database().reference().observe(.value, with: { (snapshot) in
                for key in snapshot.children {
                    Database.database().reference().child((key as? DataSnapshot)!.key).observe(.value, with: { (snapshot) in
                        if let val = snapshot.value as? [String: Any] {
                            if val["Leased Places"] != nil {
                                Database.database().reference().child((key as? DataSnapshot)!.key).child("Leased Places").observe(.value, with: { (snapshot) in
                                    for placeNameKey in snapshot.children {
                                        if indexPath.row < self.places.count {
                                            if (placeNameKey as? DataSnapshot)!.key == self.places[indexPath.row] {
                                                Database.database().reference().child((key as? DataSnapshot)!.key).child("Leased Places").child((placeNameKey as? DataSnapshot)!.key).removeValue()
                                                return
                                            }
                                        }
                                    }
                                })
                            }
                        }
                    })
                }
            })
        }
        return [delete]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        populateTableView()
        navigationItem.title = "Places"
    }
    
    func populateTableView () {
        Database.database().reference().observe(.value) { (snapshot) in
            self.places.removeAll()
            for i in snapshot.children {
                Database.database().reference().child((i as? DataSnapshot)!.key).observe(.value, with: { (snapshot) in
                    if let val = snapshot.value as? [String: Any] {
                        if val["Leased Places"] != nil {
                            Database.database().reference().child((i as? DataSnapshot)!.key).child("Leased Places").observe(.value, with: { (snapshot) in
                                for place in snapshot.children {
                                    self.places.append((place as? DataSnapshot)!.key)
                                    DispatchQueue.main.async(execute: {
                                        self.tableView.reloadData()
                                    })
                                }
                            })
                        }
                    }
                })
            }
        }
    }
    

}
