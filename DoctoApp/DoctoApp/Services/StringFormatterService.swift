//
//  StringFormatterService.swift
//  DoctoApp
//
//  Created by LAVIOLETTE JOACHIM on 03/12/2019.
//  Copyright © 2019 LAVIOLETTE JOACHIM. All rights reserved.
//

class StringFormatterService {
    // Capitalize the given string
    public static func Capitalize(str: String?) -> String {
        if str == nil { return "" }
        if str!.isEmpty { return "" }

        return str!.substring(fromIndex: 0, toIndex: 1).uppercased() + str!.substring(fromIndex: 1).lowercased()
    }

    // Capitalize the given string
    public static func CapitalizeOnly(str: String?) -> String {
        if str == nil { return "" }
        if str!.isEmpty { return "" }

        return str!.substring(fromIndex: 0, toIndex: 1).uppercased() + str!.substring(fromIndex: 1)
    }
}

extension String {
    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    func substring(fromIndex: Int, toIndex: Int) -> String {
        return self[min(fromIndex, length) ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)), upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        
        return String(self[start ..< end])
    }
}
