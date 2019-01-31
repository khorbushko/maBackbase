//
//  MapViewControllerDataProvider.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/31/19.
//  Copyright © 2019 - present. All rights reserved.
//

import CoreLocation
import MapKit

final class MapViewControllerDataProvider {

    var mainTitle: String {
        get {
            return city.name
        }
    }

    var subTitle: String {
        get {
            let subtitle = NSLocalizedString("mapViewController.title", comment: "") + city.country
            return subtitle
        }
    }

    private var locationToDisplay: CLLocationCoordinate2D {
        get {
            return city.coordinate.point
        }
    }

    private var city: City

    // MARK: - Lifecycle

    init(city: City) {

        self.city = city
    }

    // MARK: - Public

    func cityRegion() -> MKCoordinateRegion {
        let regionRadius: CLLocationDistance = 1_000
        let coordinateRegion = MKCoordinateRegion(center: locationToDisplay, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        return coordinateRegion
    }

    func annotation() -> MKAnnotation {
        let cityAnnotationPoint = CityCenterPointAnnotation(city: city)
        return cityAnnotationPoint
    }
}
