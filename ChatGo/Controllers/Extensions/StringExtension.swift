//
//  StringExtension.swift
//  ChatGo
//
//  Created by Rasyadh Abdul Aziz on 07/03/19.
//  Copyright © 2019 rasyadh. All rights reserved.
//

import UIKit

extension String {
    func toDate(format: String = "") -> Date? {
        _ = TimeZone.current.secondsFromGMT(for: Date.init(timeIntervalSinceNow: 3600*24*60)) / 3600
        
        var stringDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "id_ID")
        
        if format == "" {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            stringDate = self
        }
        else if format == "yyyy-MM-dd HH:mm" {
            dateFormatter.dateFormat = format
            let index = self.index(self.startIndex, offsetBy: format.count)
            stringDate = String(self[..<index])
        }
        else if format == "yyyy-MM-dd'T'HH:mm:ss.SSSZ" {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            stringDate = self
        }
        else if format == "yyyy-MM-dd" {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            stringDate = self
        }
        else {
            dateFormatter.dateFormat = format
            stringDate = self
        }
        
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        if let date = dateFormatter.date(from: stringDate) {
            return date
        }
        else {
            return nil
        }
    }
    
    func isValidEmail() -> Bool {
        let emailRegexString: String = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegexString)
        return emailTest.evaluate(with: self)
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func UTCToLocal(fromFormat: String, toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = toFormat
        
        return dateFormatter.string(from: dt!)
    }
}

extension NSAttributedString {
    convenience init?(html: String) {
        guard let data = html.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            return nil
        }
        guard let attributedString = try? NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else {
            return nil
        }
        self.init(attributedString: attributedString)
    }
}
