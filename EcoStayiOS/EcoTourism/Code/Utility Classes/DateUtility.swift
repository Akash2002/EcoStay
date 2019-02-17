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
        let cal = Calendar.current
        
        let hour = cal.component(.hour, from: date)
        let minute = cal.component(.minute, from: date)
        
        let year = cal.component(.year, from: date)
        let month = cal.component(.month, from: date)
        let day = cal.component(.day, from: date)
        
        return String(month) + "-" + String(day) + "-" + String(year) + " " + String(hour) + ":" + String(minute)
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
        while fromDate < to {
            fromDate = Calendar.current.date(byAdding: .day, value: 1, to: fromDate)!
            dates.append(fromDate)
        }
        return dates
    }
    
}
