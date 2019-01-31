//
//  City.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/30/19.
//  Copyright © 2019 - present. All rights reserved.
//

import Foundation

/**
 Representation of city short info

 ## raw

     {
         "country":"DK",
         "name":"Pederstrup",
         "_id":2615199,
         "coord":{
             <DATA>
         }
     }
 */

struct City {

    let country: String
    let name: String
    let uniqId: Int

    let coordinate: Coordinate
}

extension City: Decodable {

    private enum CityDecodeKeys: String, CodingKey {
        case country = "country"
        case name = "name"
        case uniqId = "_id"
        case coordinate = "coord"
    }

    // MARK: - Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CityDecodeKeys.self)

        let countryValue: String = try container.decode(String.self, forKey: .country).lowercased()
        let nameValue: String = try container.decode(String.self, forKey: .name).lowercased()
        let uniqIdValue: Int = try container.decode(Int.self, forKey: .uniqId)
        let coordinateValue: Coordinate = try container.decode(Coordinate.self, forKey: .coordinate)

        country = countryValue
        name = nameValue
        uniqId = uniqIdValue
        coordinate = coordinateValue
    }
}

extension City: Comparable {

    static func == (lhs: City, rhs: City) -> Bool {
        return (lhs.name, lhs.country) ==
            (rhs.name, rhs.country)
    }

    static func < (lhs: City, rhs: City) -> Bool {
        return (lhs.name, lhs.country) <
            (rhs.name, rhs.country)
    }
}
