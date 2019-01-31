//
//  CityTableViewCell.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/31/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

final class CityTableViewCell: UITableViewCell, Buildable {

    @IBOutlet private weak var cityDetailsLabel: UILabel!
    @IBOutlet private weak var cityCoordinateInfoLabel: UILabel!

    // MARK: - LifeCycle

    override func prepareForReuse() {
        super.prepareForReuse()

        cityDetailsLabel.text = nil
        cityCoordinateInfoLabel.text = nil
    }

    // MARK: - Buildable

    func setupWith(_ item: CollectionBuildItem) {
        if let item = item as? CityTableViewCellBuildItem {
            cityDetailsLabel.text = item.cityDisplayName
            cityCoordinateInfoLabel.text = item.cityLocationDisplayInfo
        }
    }
}

