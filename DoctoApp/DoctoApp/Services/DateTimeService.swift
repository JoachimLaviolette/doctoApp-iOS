//
//  DateTimeService.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 14/12/2019.
//  Copyright © 2019 LAVIOLETTE JOACHIM. All rights reserved.
//

import Foundation

class DateTimeService {
    // Return the current date
    static func GetCurrentDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return formatter.string(from: Date())
    }

    // Return the current date
    static func GetCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"

        return formatter.string(from: Date())
    }

    // Return the current time
    static func GetCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        return formatter.string(from: Date())
    }

    // Return the current year
    private func GetCurrentYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        return formatter.string(from: Date())
    }

    // Get the current date + the number of given days
    static func GetDateFromCurrent(daysToAdd: Int) -> String {
        let date = Calendar.current.date(byAdding: .day, value: daysToAdd, to: Date())!
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        
        return formatter.string(from: date)
    }

    // Must be in format {Day, Month 7}
   static func GetDayFromDate(date: String) -> String {
        return date.substring(fromIndex: 0, toIndex: date.index(of: ",")!.encodedOffset)
   }
}
