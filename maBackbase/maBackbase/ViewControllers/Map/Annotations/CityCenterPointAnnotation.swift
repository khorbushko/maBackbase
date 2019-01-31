//
//  CityCenterPointAnnotation.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/31/19.
//  Copyright © 2019 - present. All rights reserved.
//

import MapKit
import UIKit

final class CityCenterPointAnnotation: NSObject, MKAnnotation {

    class var identifier: String {
        get {
            return String(describing: CityCenterPointAnnotation.self)
        }
    }

    var coordinate: CLLocationCoordinate2D
    let title: String?
    let country: String

    var subtitle: String?

    var image: UIImage? {
        get {
            return UIImage(named: "pin")
        }
    }

    // MARK: - LifeCycle

    init(city: City) {
        coordinate = city.coordinate.point
        title = city.name
        country = city.country

        let lat = city.coordinate.latitude
        let lon = city.coordinate.longitude
        let latString = String(format: NSLocalizedString("listViewController.cell.latitude", comment: ""), lat)
        let lonString = String(format: NSLocalizedString("listViewController.cell.lontitude", comment: ""), lon)
        let stringToReturn = latString + ", " + lonString

        let contryDescription = String(format: NSLocalizedString("mapView.annotation.country", comment: ""), city.country)

        subtitle = contryDescription + stringToReturn
    }
}
