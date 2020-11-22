//
//  Restaurant+Sorting.swift
//  TakeawayTest
//
//  Created by abuzeid on 21.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
extension Bool {
    var int: Int { return self ? 1 : 0 }
}

extension Array where Element == Restaurant {
    func sortedByStatus() -> [Restaurant] {
        return sorted(by: { $0.status.priority < $1.status.priority })
    }

    func sortedByFavourite() -> [Restaurant] {
        return sorted(by: { $0.isFavourite.int > $1.isFavourite.int })
    }

    func sorted(by: SortingCreteria?) -> [Restaurant] {
        guard let sort = by else {
            return self
        }
        switch sort {
        case .bestMatch:
            return sorted(by: { $0.sortingValues.bestMatch > $1.sortingValues.bestMatch })
        case .averageProductPrice:
            return sorted(by: { $0.sortingValues.averageProductPrice < $1.sortingValues.averageProductPrice })
        case .newest:
            return sorted(by: { $0.sortingValues.newest > $1.sortingValues.newest })
        case .ratingAverage:
            return sorted(by: { $0.sortingValues.ratingAverage > $1.sortingValues.ratingAverage })
        case .distance:
            return sorted(by: { $0.sortingValues.distance < $1.sortingValues.distance })
        case .popularity:
            return sorted(by: { $0.sortingValues.popularity > $1.sortingValues.popularity })
        case .deliveryCosts:
            return sorted(by: { $0.sortingValues.deliveryCosts < $1.sortingValues.deliveryCosts })
        case .minimumCost:
            return sorted(by: { $0.sortingValues.minCost < $1.sortingValues.minCost })
        }
    }
}
