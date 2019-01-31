//
//  UITableViewCell+BuildItem.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/31/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

extension UITableViewCell {

    // MARK: - UITableViewCell+BuildItems

    class var identifier: String {
        get {
            return String(describing: self)
        }
    }

    class var nib: UINib {
        get {
            return UINib(nibName: self.identifier, bundle: nil)
        }
    }

    class func register(for tableView: UITableView) {
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }
}
