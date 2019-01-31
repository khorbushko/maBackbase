//
//  Storyboard.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/31/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

enum Storyboard: String {

    case main = "Main"

    var board: UIStoryboard? {
        get {
            let storyboard = UIStoryboard(name: self.rawValue, bundle: nil)
            return storyboard
        }
    }
}
