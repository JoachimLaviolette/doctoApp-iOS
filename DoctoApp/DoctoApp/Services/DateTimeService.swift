//
//  DateTimeService.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 14/12/2019.
//  Copyright © 2019 LAVIOLETTE JOACHIM. All rights reserved.
//

import Foundation

class DateTimeService {
    static let FORMAT_YYYY_MM_DD: String = "yyyy-MM-dd"
    static let FORMAT_YYYY_MM_DD_HH_MM_SS: String = "yyyy-MM-dd HH:mm:ss"
    static let FORMAT_HH_MM: String = "HH:mm"
    static let FORMAT_YYYY: String = "yyyy"
    static let FORMAT_EEEE_MM_DD_YYYY: String = "EEEE, MMMM d, yyyy"
    
    // Return the current date
    static func GetCurrentDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = FORMAT_YYYY_MM_DD_HH_MM_SS

        return formatter.string(from: Date())
    }

    // Return the current date
    static func GetCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = FORMAT_YYYY_MM_DD

        return formatter.string(from: Date())
    }
    
    // Return the current full date
    static func GetCurrentFullDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = FORMAT_EEEE_MM_DD_YYYY

        return formatter.string(from: Date())
    }

    // Return the current time
    static func GetCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = FORMAT_HH_MM

        return formatter.string(from: Date())
    }
    
    // Compare the given time and return if it is lower  than the current one
    static func IsTimeLowerThanCurrentFromDate(time: Date) -> Bool {
        return time < GetCurrentTime()
    }
    
    // Compare the given time and return if it is lower  than the current one
    static func IsTimeLowerThanCurrentFromString(time: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = FORMAT_HH_MM

        let time: Date = formatter.date(from: time)!
        
        return IsTimeLowerThanCurrentFromDate(time: time)
    }
    
    // Return the current date as a date
    static func GetCurrentDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = FORMAT_YYYY_MM_DD

        return formatter.date(from: formatter.string(from: Date()))!
    }

    // Return the current time as a date
    static func GetCurrentTime() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = FORMAT_HH_MM

        return formatter.date(from: formatter.string(from: Date()))!
    }

    // Return the current year
    private func GetCurrentYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = DateTimeService.FORMAT_YYYY
        
        return formatter.string(from: Date())
    }

    // Get the current date + the number of given days
    static func GetDateFromCurrent(daysToAdd: Int) -> String {
        let date = Calendar.current.date(byAdding: .day, value: daysToAdd, to: Date())!
        let formatter = DateFormatter()
        formatter.dateFormat = FORMAT_EEEE_MM_DD_YYYY
        
        return formatter.string(from: date)
    }

    // Must be in format {Day, Month 7}
   static func GetDayFromDate(date: String) -> String {
        return date.substring(fromIndex: 0, toIndex: date.index(of: ",")!.encodedOffset)
   }
    
    // Return the given time in 24h format
    static func GetTimeIn24H(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = FORMAT_HH_MM
        
        return formatter.string(from: date)
    }
    
    // Get the provided date in the provided format
    static func GetDateTimeInFormatFromStringAsString(date: String, fromFormat: String = FORMAT_EEEE_MM_DD_YYYY, toFormat: String = FORMAT_YYYY_MM_DD) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = fromFormat
        var date: Date = formatter.date(from: date)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        date = calendar.date(from: components)!

        formatter.dateFormat = toFormat
        
        return formatter.string(from: date)
    }
    
    static func GetDateTimeInFormatFromStringAsString(date: String, format: String = FORMAT_YYYY_MM_DD) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        var date: Date = formatter.date(from: date)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        date = calendar.date(from: components)!
        
        return formatter.string(from: date)
    }
    
    // Get the provided date in the provided format
    static func GetDateTimeInFormatFromDateAsString(date: Date, format: String = FORMAT_YYYY_MM_DD) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    // Get the provided date in the provided format
    static func GetDateTimeInFormatFromStringAsDate(date: String, format: String = FORMAT_YYYY_MM_DD) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.date(from: date)!
    }
    
    // Get the provided date in the provided format
    static func GetDateTimeInFormatFromDateAsDate(date: Date, format: String = FORMAT_YYYY_MM_DD) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let date = formatter.string(from: date)
        
        return formatter.date(from: date)!
    }
}
