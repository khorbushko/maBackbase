//
//  NoResultFoundTableViewCellBuildItem.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/31/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

final class NoResultFoundTableViewCellBuildItem: TableViewCollectionBuildItem {

    var infoDisplayText: String? {
        get {

            let value = NSLocalizedString("listViewController.search.noResult", comment: "")
            return value
        }
    }

    // MARK: - TableViewCollectionBuildItem

    override var identifier: String {
        get {
            return NoResultFoundTableViewCell.identifier
        }
    }

    override var nib: UINib {
        get {
            return NoResultFoundTableViewCell.nib
        }
    }

    override class var classType: UITableViewCell.Type {
        get {
            return NoResultFoundTableViewCell.self
        }
    }

    override func expectedHeight(_ data: Any? = nil) -> CGFloat {
        return 60
    }
}
