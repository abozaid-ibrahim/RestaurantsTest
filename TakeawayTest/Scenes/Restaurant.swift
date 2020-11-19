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

struct Restaurant: Codable {
    let name: String
    let status: Status
    let sortingValues: SortingValues
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
