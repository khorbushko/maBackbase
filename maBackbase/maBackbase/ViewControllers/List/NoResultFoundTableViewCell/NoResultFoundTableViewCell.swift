//
//  NoResultFoundTableViewCell.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/31/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

final class NoResultFoundTableViewCell: UITableViewCell, Buildable {

    @IBOutlet private weak var infoLabel: UILabel!

    // MARK: - LifeCycle

    override func prepareForReuse() {
        super.prepareForReuse()

        infoLabel.text = nil
    }

    // MARK: - Buildable

    func setupWith(_ item: CollectionBuildItem) {
        if let item = item as? NoResultFoundTableViewCellBuildItem {
            infoLabel.text = item.infoDisplayText
        }
    }
}
