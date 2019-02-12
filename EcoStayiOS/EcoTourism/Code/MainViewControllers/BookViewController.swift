//
//  BookViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 2/11/19.
//  Copyright © 2019 Akash Veerappan. All rights reserved.
//

import UIKit

class BookViewController: UITableViewController {
    var datePickerFrom = UIDatePicker()
    var datePickerTo = UIDatePicker()
    
    @IBOutlet weak var fromDateField: UITextField!
    @IBOutlet weak var toDateField: UITextField!
    
    override func viewDidLoad() {
        
        datePickerFrom = UIDatePicker()
        datePickerFrom.datePickerMode = .dateAndTime
        datePickerFrom.addTarget(self, action: #selector(BookViewController.dateChangedFrom(datePicker:)), for: .valueChanged)
        
        fromDateField.inputView = datePickerFrom
        
        datePickerTo = UIDatePicker()
        datePickerTo.datePickerMode = .dateAndTime
        datePickerTo.addTarget(self, action: #selector(BookViewController.dateChangedTo(datePicker:)), for: .valueChanged)
        
        toDateField.inputView = datePickerTo
        
    }
    
    @objc func dateChangedFrom(datePicker: UIDatePicker) {
        fromDateField.text = DateUtility().getDateString(date: datePicker.date)
    }
    
    @objc func dateChangedTo(datePicker: UIDatePicker) {
        fromDateField.text = DateUtility().getDateString(date: datePicker.date)
    }
    
    
}
