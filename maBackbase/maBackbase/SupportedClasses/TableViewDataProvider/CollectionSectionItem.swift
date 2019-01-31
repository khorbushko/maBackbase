//
//  CollectionSectionItem.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/31/19.
//  Copyright © 2019 - present. All rights reserved.
//

import Foundation

class CollectionSectionItem<T: CollectionBuildItem> {

    internal (set) var titleLocalizationKey: String?
    internal (set) var items: [T] = []

    var itemsInSection: Int {
        get {
            return items.count
        }
    }

    subscript(_ item: Int) -> T {
        assert(item < items.count, "invalid subscript logic for CollectionSectionItem")
        assert(item >= 0, "invalid subscript logic for CollectionSectionItem")

        return items[item]
    }

    // MARK: - Life Cycle

    init(_ items: [T], titleLocalizationKey: String? = nil) {
        self.items = items
        self.titleLocalizationKey = titleLocalizationKey
    }
}
