//
//  CollectionBuildItem.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/31/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

class CollectionBuildItem {

    let uniqueIdentifier: String = UUID().uuidString

    var identifier: String {
        get {
            fatalError("use subclass of CollectionBuildItem")
        }
    }

    var nib: UINib {
        get {
            fatalError("use subclass of CollectionBuildItem")
        }
    }

    var dataObject: Any?

    // MARK: - Life Cycle

    init(_ object: Any) {
        dataObject = object
    }

    init() {
    }

    // MARK: - Public

    func expectedHeight(_ data: Any? = nil) -> CGFloat {
        fatalError("use subclass of CollectionBuildItem")
    }
}
