//
//  DateUtility.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 2/11/19.
//  Copyright © 2019 Akash Veerappan. All rights reserved.
//

import Foundation

class DateUtility {
    
    func getCurrentDate () -> String {
        let date = Date()
        let cal = Calendar.current
        
        let hour = cal.component(.hour, from: date)
        let minute = cal.component(.minute, from: date)
        
        let year = cal.component(.year, from: date)
        let month = cal.component(.month, from: date)
        let day = cal.component(.day, from: date)
        
        return String(month) + "/" + String(day) + "/" + String(year) + " " + String(hour) + ":" + String(minute)
    }
    
    func getDateDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if var d: Date = dateFormatter.date(from: date) {
            return d
        } else {
            return Date()
        }
    }
    
    func getDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if var d: String = dateFormatter.string(from: date) {
            return dateFormatter.string(from: date)
        } else {
            return "Error Decoding Date"
        }
    }
    
}
