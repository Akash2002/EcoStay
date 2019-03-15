//
//  DateUtility.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 2/11/19.
//  Copyright © 2019 Akash Veerappan. All rights reserved.
//

import Foundation

class DateUtility {
    
    
    static func getCurrentDate () -> String {
        let date = Date()
        
        var cal: Calendar = Calendar.current
        let hour = cal.component(.hour, from: date)
        let minute = cal.component(.minute, from: date)
        
        let year = cal.component(.year, from: date)
        let month = cal.component(.month, from: date)
        let day = cal.component(.day, from: date)
        
        return String(month) + "-" + String(day) + "-" + String(year)
    }
    
    static func getDateDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if let d: Date = dateFormatter.date(from: date) {
            return d
        } else {
            return Date()
        }
    }
    
    static func getDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if var d: String = dateFormatter.string(from: date) {
            return d
        } else {
            return "Error Decoding Date"
        }
    }
    
    static func getDuration (date1: Date, date2: Date) -> Int {
        let form = DateComponentsFormatter()
        form.maximumUnitCount = 2
        form.unitsStyle = .full
        form.allowedUnits = [.year, .month, .day]
        var s = form.string(from: date1, to: date2)!
        print ("Duration: " + s)
        var dIndex = s.index(of: " ")
        s = s.substring(to: dIndex!)
        return Int(s)!
    }
    
    static func getDateRange (from: Date, to: Date) -> [Date] {
        var dates = [Date]()
        var fromDate = from
        while fromDate <= to {
            dates.append(fromDate)
            fromDate = Calendar.current.date(byAdding: .day, value: 1, to: fromDate)!
        }
        return dates
    }
    
    static func isDateInRange (date1: Date, date2: Date, compareDate: Date) -> Bool {
        if (compareDate <= date2) && (compareDate >= date1) {
            return true
        } else {
            return false
        }
    }
    
    static func isDateGreater (placeHolderDate: Date, dateToBeCompared: Date) -> Bool {
        if (dateToBeCompared > placeHolderDate) {
            return true
        } else {
            return false
        }
    }
    
    static func addDaysToDate (date: Date, numDaysToBeAdded: Int) -> String {
        var cal: Calendar = Calendar.current
        var newDate = cal.date(byAdding: Calendar.Component.day, value: numDaysToBeAdded, to: date)!
        var tyear = cal.component(Calendar.Component.year, from: newDate)
        var tmonth = cal.component(Calendar.Component.month, from: newDate)
        var tday = cal.component(Calendar.Component.day, from: newDate)
        var completeDateString2 = String(tmonth) + "-" + String(tday) + "-" + String(tyear);
        return completeDateString2
    }
    
}
