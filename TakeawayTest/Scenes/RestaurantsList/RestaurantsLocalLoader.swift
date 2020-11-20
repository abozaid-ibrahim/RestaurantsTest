//
//  RestaurantsLocalLoader.swift
//  TakeawayTest
//
//  Created by abuzeid on 19.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import RxSwift

protocol RestaurantsDataSource {
    func loadRestaurants() -> Observable<[Restaurant]>
}

final class RestaurantsLocalLoader: RestaurantsDataSource {
    func loadRestaurants() -> Observable<[Restaurant]> {
        return Observable<[Restaurant]>.create({ observer in
            do {
                let response = try Bundle.main.decode(RestaurantsResponse.self, from: "RestaurantsData.json")
                observer.onNext(response.restaurants)
                observer.onCompleted()
            } catch {
                observer.onError(NetworkError.failedToParseData)
            }
            return Disposables.create()
        })
    }
}
