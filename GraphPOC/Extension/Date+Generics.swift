//
//  Date+Generics.swift
//  skinnyconfidential
//
//  Created by Santosh on 17/04/20.
//  Copyright © 2020 Pixy Bean LLC. All rights reserved.
//

import Foundation

extension Date {
    
    func convertDateToTZFormat() -> String{  //2013-03-29T15:27:00Z
        let timezone = TimeZone(abbreviation: "GMT")
        let dateFormatter = DateFormatter()
     //   dateFormatter.timeZone = timezone
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let dateStr = dateFormatter.string(from: self)
        return dateStr
    }
    
    func nextClassDateFormat() -> String{ // 29 May, 12:00 AM
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy h:mmaa"
        return dateFormatter.string(from: self)
    }
    
    func convertToDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let dateStr = dateFormatter.string(from: self)
        return dateStr
    }
    
    func toMonthString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    
    func toDayString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
    
    func toDayInWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEEE"
        return dateFormatter.string(from: self)
    }
    
    func toYearString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    
    func toDayAndMonthString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: self)
    }

    
    func isGreaterThanDat(dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false

        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }

        //Return Result
        return isGreater
    }

    func isLessThanDat(dateToCompare: Date) -> Bool{
        var isLess = false
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending{
            isLess = true
        }
        return isLess

    }

    func isEqualThanDat(dateToCompare:Date) -> Bool{
        var isEqual = false

        if self.compare(dateToCompare) == ComparisonResult.orderedSame{
            isEqual = true
        }

        return isEqual
    }
    
    mutating func addDays(n: Int)
    {
        let cal = Calendar.current
        self = cal.date(byAdding: .day, value: n, to: self)!
    }
    
    func addDays(days:Int) -> Date{
        // let date = self.dateByAddingTimeInterval(Double(days) * 24 * 60.0 * 60.0)
        let date = self.addingTimeInterval(Double(days) * 24 * 60.0 * 60.0)
        return date
    }
    
    
    func firstDayOfTheMonth() -> Date {
        return Calendar.current.date(from:
                                        Calendar.current.dateComponents([.year,.month], from: self))!
    }
    
    func getAllDays() -> [Date]
    {
        var days = [Date]()
        
        let calendar = Calendar.current
        
        let range = calendar.range(of: .day, in: .month, for: self)!
        
        var day = firstDayOfTheMonth()
        
        for _ in 1...range.count
        {
            days.append(day)
            day.addDays(n: 1)
        }
        
        return days
    }
    
    
    
    func dayOfWeek() -> Int? {
        let cal: Calendar = Calendar.current
        let comp:DateComponents = cal.dateComponents([.weekday], from: self)
        return comp.weekday
    }
    
    func startDateOfTheDay() -> Date{
        let startOfToday = Calendar.current.startOfDay(for: self)
        return startOfToday
    }

    
//    func stringToDate() -> Date{
//        
//        let dateFormatter =  DateFormatter()
//        dateFormatter.dateFormat =  "yyyy-MM-dd"
//        let date = dateFormatter.date(from: self.toString())
//        return date!
//    }
    
    
    
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    var startOfWeek1: Date {
        let date = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        let dslTimeOffset = NSTimeZone.local.daylightSavingTimeOffset(for: date)
        return date.addingTimeInterval(dslTimeOffset)
    }
    
    
    var startOfMonth: Date {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return  calendar.date(from: components)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    var endOfWeek1: Date {
        return Calendar.current.date(byAdding: .second, value: 604799, to: self.startOfWeek1)!
    }
    

      
}


extension TimeInterval {
    
    var minSec: String {
        return String(format:"%02d:%02d", minute, second)
    }
    
    var hour: Int {
        return Int(self/3600)
    }
    
    var minute: Int {
        return Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        return Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        return Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
    
    var converToMinutes: Int {
        return (Int(self.truncatingRemainder(dividingBy: 3600) / 60))
    }
    
    var converToHours: Int {
        return (Int(self.truncatingRemainder(dividingBy: 86400) / 3600))
    }
}


extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

