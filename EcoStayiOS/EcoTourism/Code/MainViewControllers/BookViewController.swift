//
//  BookViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 2/15/19.
//  Copyright © 2019 Akash Veerappan. All rights reserved.
//

import UIKit
import JTAppleCalendar
import FirebaseDatabase
import FirebaseAuth

class BookViewController: UIViewController {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthYearLabel: UILabel!
    
    var bookedAlreadyBool = false
    
    var selectedDates: [Date] = []
    var dateRange: [Date] = []
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        calendarView.visibleDates { (visibleDates) in
            var monthYearText = ""
            let date = visibleDates.monthDates.first!.date
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            monthYearText += dateFormatter.string(from: date)
            dateFormatter.dateFormat = "YYYY"
            monthYearText += " " + dateFormatter.string(from: date)
            self.monthYearLabel.text = monthYearText
        }
        
        calendarView.allowsMultipleSelection = true
        calendarView.isRangeSelectionUsed = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(onNextClicked))
        
        determineAvailability()
        
        print(bookedAlreadyBool)
        
    }
    
    @objc func onNextClicked () {
            var count = 0
            if selectedDates.count > 0 {
               selectedDates = selectedDates.sorted(by: { $0.compare($1) == .orderedAscending })
                if selectedDates.count > 0 {
                    for i in stride(from: 1, to: selectedDates.count, by: 1) {
                        if (DateUtility.getDuration(date1: selectedDates[i-1], date2: selectedDates[i]) == 1) {
                            
                            count += 1
                        }
                    }
                    if (count == selectedDates.count - 1) {
                        
                        Database.database().reference().child(Auth.auth().currentUser!.uid).observe(.value) { (snapshot) in
                            if let value = snapshot.value as? [String: Any?] {
                                if value["BookedPlaces"] != nil {
                                    Database.database().reference().child(Auth.auth().currentUser!.uid).child("BookedPlaces").observe(.value, with: { (snapshot) in
                                        for placeNameKey in snapshot.children {
                                            if (placeNameKey as? DataSnapshot)!.key != SearchViewController.seguePlace.name {
                                                Database.database().reference().child((Auth.auth().currentUser?.uid)!).child("BookedPlaces").child(SearchViewController.seguePlace.name).child("FromWhen").setValue(DateUtility.getDateString(date: self.selectedDates[0]))
                                                Database.database().reference().child((Auth.auth().currentUser?.uid)!).child("BookedPlaces").child(SearchViewController.seguePlace.name).child("ToWhen").setValue(DateUtility.getDateString(date: self.selectedDates[self.selectedDates.count - 1]))
                                            } else {
                                                CustomAlert().showAlert(headingAlert: "Already Booked", messageAlert: "This place has already been booked. Please visit your profile to view your current rentals.", actionTitle: "Ok", viewController: self) { (action) in
                                                }
                                            }
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            } else {
                CustomAlert().showAlert(headingAlert: "No day selected", messageAlert: "Please select a day or a range of days", actionTitle: "Ok", viewController: self) { (action) in
                    
                }
                
            }
        
    }
}


extension BookViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let parameters: ConfigurationParameters = ConfigurationParameters(startDate: DateUtility.getDateDate(date: DateUtility.getCurrentDate()), endDate: DateUtility.getDateDate(date: "01/22/2020"))
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateViewCell
        cell.dateLabel.text = cellState.text
        if cellState.isSelected {
            cell.selectedView.isHidden = false
            cell.selectedView.layer.cornerRadius = 20
            cell.selectedView.layer.shadowColor = UIColor.gray.cgColor
            cell.selectedView.layer.shadowOffset = CGSize.zero
            cell.selectedView.layer.shadowOpacity = 0.5
            cell.selectedView.layer.shadowRadius = 5.0
            cell.dateLabel.textColor = UIColor.white
            cell.layer.masksToBounds = false
        } else {
            cell.selectedView.isHidden = true
            
        }
        
        if cellState.dateBelongsTo != .thisMonth {
            cell.dateLabel.textColor = UIColor(rgb: 0xE5E6EF)
        } else {
            cell.dateLabel.textColor = UIColor(rgb: 0x8790AC)
        }
        
        for d in dateRange {
            if d == date {
                cell.dateLabel.textColor = UIColor(rgb: 0xE5E6EF)
            }
        }
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? DateViewCell else {return}
        if cell.dateLabel.textColor != UIColor(rgb: 0xE5E6EF) {
            cell.selectedView.isHidden = false
            cell.selectedView.layer.cornerRadius = 20
            cell.selectedView.layer.shadowColor = UIColor.gray.cgColor
            cell.selectedView.layer.shadowOffset = CGSize.zero
            cell.selectedView.layer.shadowOpacity = 0.5
            cell.selectedView.layer.shadowRadius = 5.0
            cell.dateLabel.textColor = UIColor.white
            cell.layer.masksToBounds = false
            selectedDates.append(cellState.date)
        } else {
            cell.selectedView.isHidden = true
        }
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? DateViewCell else {return}
        cell.selectedView.isHidden = true
        if cellState.dateBelongsTo != .thisMonth {
            cell.dateLabel.textColor = UIColor(rgb: 0xE5E6EF)
        } else {
            cell.dateLabel.textColor = UIColor(rgb: 0x8790AC)
        }
        var pos = 0
        for d in selectedDates {
            if d == cellState.date {
                selectedDates.remove(at: pos)
            }
            pos += 1
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        var monthYearText = ""
        let date = visibleDates.monthDates.first!.date
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        monthYearText += dateFormatter.string(from: date)
        dateFormatter.dateFormat = "YYYY"
        monthYearText += " " + dateFormatter.string(from: date)
        monthYearLabel.text = monthYearText
    }
    
    func bookedAlready () {
        
    }
    
    func determineAvailability() {
        count = 0
        let dbRef = Database.database().reference()
        dbRef.observe(.value) { (snapshot) in
            for uid in snapshot.children {
                dbRef.child((uid as? DataSnapshot)!.key).observe(.value, with: { (snapshot) in
                    if let value = snapshot.value as? [String: Any?] {
                        if value["BookedPlaces"] != nil {
                            dbRef.child((uid as? DataSnapshot)!.key).child("BookedPlaces").observe(.value, with: { (snapshot) in
                                for placeKey in snapshot.children {
                                    if (placeKey as? DataSnapshot)!.key ==  SearchViewController.seguePlace.name {
                                        
                                        dbRef.child((uid as? DataSnapshot)!.key).child("BookedPlaces").child(SearchViewController.seguePlace.name).observe(.value, with: { (snapshot) in
                                            
                                            if let value = snapshot.value as? [String: Any?] {
                                                
                                                let fromDate = DateUtility.getDateDate(date: value["FromWhen"] as! String)
                                                let toDate = DateUtility.getDateDate(date: value["ToWhen"] as! String)
                                                
                                                var tempDateRange = DateUtility.getDateRange(from: fromDate, to: toDate)
                                                
                                                for d in tempDateRange {
                                                    self.dateRange.append(d)
                                                }
                                                
                                                self.count+=1
                                                
                                                DispatchQueue.main.async(execute: {
                                                    self.calendarView.reloadData()
                                                })
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


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
