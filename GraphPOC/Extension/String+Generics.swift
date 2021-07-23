//
//  String+Generics.swift
//  skinnyconfidential
//
//  Created by Santosh on 17/04/20.
//  Copyright © 2020 Pixy Bean LLC. All rights reserved.
//

import Foundation
import UIKit

extension String {
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        // let start = startIndex.advancedBy(r.lowerBound)
        let start = self.index(self.startIndex, offsetBy: r.lowerBound)
        
        // let end = start.advancedBy(r.upperBound - r.lowerBound)
        let end = self.index(start, offsetBy: r.upperBound - r.lowerBound)
        return String(self[start ..< end])
        
    }
    
    func stringToDate() -> NSDate{
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        return date! as NSDate
    }
    
    func stringToTZ() -> NSDate{
        let dateFormatter =  DateFormatter()
        dateFormatter.timeZone =  NSTimeZone(abbreviation: "GMT") as TimeZone?
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let date = dateFormatter.date(from: self)
        return date! as NSDate
    }
    
    func isValidPhoneNumber() -> Bool {
        let charcter  = NSCharacterSet(charactersIn: "+0123456789").inverted
        var filtered:NSString!
        let inputString:NSArray = self.components(separatedBy: charcter) as NSArray
        filtered = inputString.componentsJoined(by: "") as NSString?
        return  (self == filtered as String && self.count >= 10)
    }
    
    func isValidPincode() -> Bool {
        if self.count <= 4{
            return true
        }
        else{
            return false
        }
    }
    
    func validateLength() -> Bool{
        if self.count > 0{
            return true
        }
        return false
    }
    
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
    func removeWhiteSpaces() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    
    
    func toDOBDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.date(from:self)
    }
    
    func convertToStringDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.defaultDate
    }
    
    func convertToTZDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssEtc/GMT"
        return dateFormatter.date(from:self)!
    }
    
    var bool: Bool? {
        switch self.lowercased() {
        case "true", "t", "yes", "y", "1":
            return true
        case "false", "f", "no", "n", "0":
            return false
        default:
            return nil
        }
    }
    
    func isValidEmail() -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self.trimWhitespaces())
    }
    
    func trimWhitespaces() -> String{
        if self != ""{
            let trimmedString = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            return trimmedString
        }
        return ""
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard data(using: .utf8) != nil else { return NSAttributedString() }
        do {
            let modifiedFont = "<span style=\"font-family: OpenSans-Regular; font-size: 16.0; \">\(self)</span>"
            let attrStr = try NSAttributedString(
                data: modifiedFont.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html],
                documentAttributes: nil)
            
            return attrStr
        } catch {
            return NSAttributedString()
        }
    }
    
    
    func attributedStringFromHTML(completionBlock: @escaping (NSAttributedString?) ->()) {
        guard let _ = data(using: .utf8) else {
            print("Unable to decode data from html string: \(self)")
            return completionBlock(nil)
        }
        
        //        let options = [NSAttributedString.DocumentAttributeKey.documentType : NSAttributedString.DocumentType.html, NSAttributedString.DocumentAttributeKey.characterEncoding: NSNumber(value:String.Encoding.utf8.rawValue)] as [NSAttributedString.DocumentAttributeKey : Any]
        let modifiedFont = "<span style=\"font-family: OpenSans-Regular; font-size: 16.0; \">\(self)</span>"
        
        
        DispatchQueue.main.async {
            if let attributedString = try? NSAttributedString(data: modifiedFont.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil) {
                completionBlock(attributedString)
            } else {
                print("Unable to create attributed string from html string: \(self)")
                completionBlock(nil)
            }
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

