//
//  CityTableViewSectionItem.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/31/19.
//  Copyright © 2019 - present. All rights reserved.
//

import Foundation

final class CityTableViewSectionItem: CollectionSectionItem<TableViewCollectionBuildItem> {

    // MARK: - LifeCycle

    init(_ data: [City]) {
        let buildItems: [TableViewCollectionBuildItem] = CityTableViewSectionItem.setupSectionItemsWith(data)

        super.init(buildItems)
    }

    // MARK: - Private

    private class func setupSectionItemsWith(_ data: [City]) -> [TableViewCollectionBuildItem] {
        let buildItems: [TableViewCollectionBuildItem] = data.compactMap({ CityTableViewCellBuildItem($0) })

        return buildItems
    }
}
