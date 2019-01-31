//
//  TableViewDataProvider.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/31/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

class TableViewDataProvider: NSObject {

    @IBOutlet internal weak var tableView: UITableView! {
        didSet {
            registerBuildItemsType()
        }
    }

    internal var buildItemTypes: [TableViewCollectionBuildItem.Type] {
        get {
            return []
        }
    }

    internal var buildHeaderFooterTypes: [UITableViewHeaderFooterView.Type] {
        get {
            return []
        }
    }

    internal var items: [CollectionSectionItem<TableViewCollectionBuildItem>] = []

    // MARK: - Private

    private func registerBuildItemsType() {
        buildItemTypes.forEach({ [weak self] in
            if let strong = self {
                $0.registerForUseIn(strong.tableView)
            }
        })

        buildHeaderFooterTypes.forEach({ [weak self] in
            if let strong = self {
                $0.register(for: strong.tableView)
            }
        })
    }
}
