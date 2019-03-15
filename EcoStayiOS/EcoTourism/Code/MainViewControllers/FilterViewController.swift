//
//  FilterViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 3/12/19.
//  Copyright © 2019 Akash Veerappan. All rights reserved.
//

import UIKit
import TTRangeSlider

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var types = ["House","Town Home", "Cabin", "Cottage", "Hut", "Treehouse"]
    var selectedTypes: [Int: String] = [:]
    
    @IBOutlet weak var priceRangeSlider: TTRangeSlider!
    @IBOutlet weak var ratingRangeSlider: TTRangeSlider!
    
    var minPrice = 0
    var maxPrice = 0
    var minRating = 0
    var maxRating = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = types[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            selectedTypes.removeValue(forKey: indexPath.row)
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            selectedTypes[indexPath.row] = types[indexPath.row]
        }
        print(selectedTypes)
    }
    
    @IBAction func priceRangeChanged(_ sender: TTRangeSlider) {
        minPrice = Int(sender.selectedMinimum)
        maxPrice = Int(sender.selectedMaximum)
    }
    
    @IBAction func ratingRangeChanged(_ sender: TTRangeSlider) {
        minRating = Int(sender.selectedMinimum)
        maxRating = Int(sender.selectedMaximum)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceRangeSlider.enableStep = true
        priceRangeSlider.step = 1
        ratingRangeSlider.enableStep = true
        ratingRangeSlider.step = 1
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        
        SearchViewController.filterOptionType = selectedTypes
        SearchViewController.priceRange = (minPrice, maxPrice)
        SearchViewController.ratingRange = (Double(minRating), Double(maxRating))
        SearchViewController.didFilter = true
        
        SearchViewController().updateTableViewWithFilterOptions()
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true) {
            
        }
    }
    
}
