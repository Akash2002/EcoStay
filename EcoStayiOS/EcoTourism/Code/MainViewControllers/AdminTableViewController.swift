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
        cell?.textLabel?.text = places[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var delete = UITableViewRowAction(style: .normal, title: "Delete") { (snapshot, indexPath) in
            Database.database().reference().observe(.value) { (snapshot) in
                for i in snapshot.children {
                    Database.database().reference().child((i as? DataSnapshot)!.key).observe(.value, with: { (snapshot) in
                        if let val = snapshot.value as? [String: Any] {
                            if val["Leased Places"] != nil {
                                Database.database().reference().child((i as? DataSnapshot)!.key).child("Leased Places").observe(.value, with: { (snapshot) in
                                    for place in snapshot.children {
                                        print("Count: \(self.places.count) and Index: \(indexPath.row)")
                                        if (indexPath.row < self.places.count) {
                                            if (place as? DataSnapshot)!.key == self.places[indexPath.row] {
                                                Database.database().reference().child((i as? DataSnapshot)!.key).child("Leased Places").child((place as? DataSnapshot)!.key).removeValue()
                                                print(self.places[indexPath.row])
                                            }
                                        }
                                    }
                                })
                            }
                        }
                    })
                }
            }
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
