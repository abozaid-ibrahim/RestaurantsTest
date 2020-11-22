//
//  AppDelegate.swift
//  TakeawayTest
//
//  Created by abuzeid on 19.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import RxSwift
import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //debugRxResources()
        return true
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    private func debugRxResources() {
        #if DEBUG
            _ = Observable<Int>.interval(.seconds(2), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
                .subscribe(onNext: { _ in
                    log("\(RxSwift.Resources.total)")
                })
            log("\(RxSwift.Resources.total)")
        #endif
    }
}
