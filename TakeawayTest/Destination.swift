//
//  Destination.swift
//  TakeawayTest
//
//  Created by abuzeid on 19.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

enum Destination {
    case restaurants
    case filter
    var controller: UIViewController {
        switch self {
        case .filter:
            let filterController = UIViewController()

            return filterController
        case .restaurants:
            return RestaurantsTableController()
        }
    }
}
