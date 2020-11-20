//
//  RestaurantsLocalLoader.swift
//  TakeawayTest
//
//  Created by abuzeid on 19.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
protocol RestaurantsDataSource {
    func loadRestaurants(compeletion: @escaping (Result<[Restaurant], NetworkError>) -> Void)
}

final class RestaurantsLocalLoader: RestaurantsDataSource {
    func loadRestaurants(compeletion: @escaping (Result<[Restaurant], NetworkError>) -> Void) {
        do {
            let response = try Bundle.main.decode(RestaurantsResponse.self, from: "RestaurantsData.json")
            compeletion(.success(response.restaurants))
        } catch {
            compeletion(.failure(.noData))
        }
    }
}
