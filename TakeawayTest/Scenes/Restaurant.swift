//
//  Restaurant.swift
//  TakeawayTest
//
//  Created by abuzeid on 19.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

struct RestaurantsResponse: Codable {
    let restaurants: [Restaurant]
}

struct Restaurant: Equatable {
    let name: String
    let status: Status
    let sortingValues: SortingValues
    var isFavourite: Bool
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        return lhs.name == rhs.name
    }
}

extension Restaurant: Codable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        sortingValues = try values.decode(SortingValues.self, forKey: .sortingValues)
        status = try values.decode(Status.self, forKey: .status)
        isFavourite = false
    }
}

struct SortingValues: Codable {
    let bestMatch: Int
    let newest: Int
    let ratingAverage: Double
    let distance: Int
    let popularity: Int
    let averageProductPrice: Int
    let deliveryCosts: Int
    let minCost: Int
}

enum Status: String, Codable {
    case closed
    case orderAhead = "order ahead"
    case statusOpen = "open"
}
