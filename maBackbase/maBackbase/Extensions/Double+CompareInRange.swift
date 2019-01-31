//
//  Double+CompareInRange.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/31/19.
//  Copyright © 2019 - present. All rights reserved.
//

import Foundation

extension Double {

    // MARK: - Double+CompareInRange

    public func insideRange(_ range: ClosedRange<Double>) -> Bool {
        if self >= range.lowerBound && self <= range.upperBound {
            return true
        }
        return false
    }
}
