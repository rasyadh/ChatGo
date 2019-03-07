//
//  FormatterExtension.swift
//  ChatGo
//
//  Created by Rasyadh Abdul Aziz on 07/03/19.
//  Copyright © 2019 rasyadh. All rights reserved.
//

import UIKit

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension BinaryInteger {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}

extension Int {
    var formattedWithSeperator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}

extension Date {
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let stringDate = formatter.string(from: self)
        
        return stringDate
    }
    
    func calculateTimeFromToday() -> String {
        func isDateInYear() -> Bool {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            let year = formatter.string(from: self)
            
            let yearToday = Calendar.current.component(.year, from: Date())
            
            return Int(year) == yearToday
        }
        
        let calendar = Calendar.current
        if calendar.isDateInToday(self) {
            return self.toString(format: "HH:mm")
        }
        else if calendar.isDateInYesterday(self) {
            return "Yesterday"
        }
        else if !calendar.isDateInTomorrow(self) {
            return self.toString(format: "dd/MM")
        }
        else if isDateInYear() {
            return self.toString(format: "dd/MM")
        }
        else {
            return self.toString(format: "dd/MM/yyyy")
        }
    }
    
    func calculateFromCurrentTime() -> String {
        let datetime = Date()
        let formatter = DateFormatter()
        var stringHour = ""
        
        formatter.dateFormat = "yyyy-MM-dd"
        if formatter.string(from: datetime) == formatter.string(from: self) {
            formatter.dateFormat = "HH"
            if formatter.string(from: datetime) == formatter.string(from: self) {
                formatter.dateFormat = "mm"
                let currentMinute = formatter.string(from: datetime)
                let stringMinute = formatter.string(from: self)
                let interval = abs(Int(currentMinute)! * 60 - Int(stringMinute)! * 60) / 60
                if interval <= 30 {
                    stringHour = "\(interval)m ago"
                }
            }
            else {
                formatter.dateFormat = "HH:mm"
                stringHour = formatter.string(from: self)
            }
        }
        else {
            formatter.dateFormat = "HH:mm"
            stringHour = formatter.string(from: self)
        }
        
        return stringHour
    }
}

