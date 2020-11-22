//
//  TakeawayTestUITests.swift
//  TakeawayTestUITests
//
//  Created by abuzeid on 19.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import XCTest

final class TakeawayTestUITests: XCTestCase {
    func testNavigationBetweenAppScreens() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
        app.navigationBars["Discover"].buttons["Sort"].tap()
        let sortingTable = app.tables["SortingTable"]
        XCTAssertTrue(sortingTable.exists)
        sortingTable.firstMatch.tap()
        XCTAssertTrue(app.tables["RestaurantsTable"].exists)
    }

    func testLaunchPerformance() throws {
        if #available(iOS 13.0,*) {
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
