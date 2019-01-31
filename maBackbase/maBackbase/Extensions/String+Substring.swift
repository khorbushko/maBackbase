//
//  String+Substring.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/31/19.
//  Copyright © 2019 - present. All rights reserved.
//

import Foundation

extension String {

    subscript (searchableRange: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, searchableRange.lowerBound)),
                                            upper: min(count, max(0, searchableRange.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
