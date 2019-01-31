//
//  CityTableViewCellBuildItem.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/31/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

final class CityTableViewCellBuildItem: TableViewCollectionBuildItem {

    var city: City? {
        get {
            return dataObject as? City
        }
    }

    var cityDisplayName: String? {
        get {
            var stringToReturn: String?
            if let cityName = city?.name,
                let cityCountry = city?.country {
                stringToReturn = cityName + ", " + cityCountry
            }
            return stringToReturn
        }
    }

    var cityLocationDisplayInfo: String? {
        get {
            var stringToReturn: String?
            if let lat = city?.coordinate.latitude,
                let lon = city?.coordinate.longitude {
                let latString = String(format: NSLocalizedString("listViewController.cell.latitude", comment: ""), lat)
                let lonString = String(format: NSLocalizedString("listViewController.cell.lontitude", comment: ""), lon)
                stringToReturn = latString + ", " + lonString
            }
            return stringToReturn
        }
    }

    // MARK: - TableViewCollectionBuildItem

    override var identifier: String {
        get {
            return CityTableViewCell.identifier
        }
    }

    override var nib: UINib {
        get {
            return CityTableViewCell.nib
        }
    }

    override class var classType: UITableViewCell.Type {
        get {
            return CityTableViewCell.self
        }
    }

    override func expectedHeight(_ data: Any? = nil) -> CGFloat {
        return 44
    }
}
