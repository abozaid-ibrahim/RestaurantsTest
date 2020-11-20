//
//  AppNavigator.swift
//  TakeawayTest
//
//  Created by abuzeid on 19.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

final class AppNavigator {
    static let shared = AppNavigator()
    private static var navigator: UINavigationController!

    private init() {}

    func set(window: UIWindow) {
        AppNavigator.navigator = UINavigationController(rootViewController: Destination.restaurants.controller)
        AppNavigator.navigator.setNavigationBarHidden(false, animated: true)
        window.rootViewController = AppNavigator.navigator
        window.makeKeyAndVisible()
    }

    func push(_ dest: Destination) -> UIViewController {
        let controller = dest.controller
        AppNavigator.navigator.pushViewController(controller, animated: true)
        return controller
    }
}
