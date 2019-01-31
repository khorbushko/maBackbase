//
//  TableViewCollectionBuildItem.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/31/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

class TableViewCollectionBuildItem: CollectionBuildItem {

    class var classType: UITableViewCell.Type {
        get {
            fatalError("use subclass of CollectionBuildItem")
        }
    }

    func dequeueCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let item = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath)
        (item as? Buildable)?.setupWith(self)
        return item
    }

    class func registerForUseIn(_ tableView: UITableView) {
        tableView.register(classType.nib, forCellReuseIdentifier: classType.identifier)
    }
}
