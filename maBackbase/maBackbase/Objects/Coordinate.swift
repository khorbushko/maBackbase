//
//  Coordinate.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/30/19.
//  Copyright © 2019 - present. All rights reserved.
//

import Foundation
import CoreLocation

/**

 Representation of coordinate for city

 ## raw:

     {
         "lon":10.48753,
         "lat":55.285309
     }
 
 */

struct Coordinate {

    let latitude: Double
    let longitude: Double

    var point: CLLocationCoordinate2D {
        get {
            let poi = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            return poi
        }
    }
}

extension Coordinate: Decodable {

    enum CoordinateError: Error {

        case invalidValueRange
    }

    private enum CoordinateDecodeKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }

    // MARK: - Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CoordinateDecodeKeys.self)

        let latitudeValue: Double = try container.decode(Double.self, forKey: .latitude)
        let longitudeValue: Double = try container.decode(Double.self, forKey: .longitude)

        if latitudeValue.insideRange((-90.0...90.0)),
            longitudeValue.insideRange((-180.0...180.0)) {
            latitude = latitudeValue
            longitude = longitudeValue
        } else {
            throw CoordinateError.invalidValueRange
        }
    }
}
