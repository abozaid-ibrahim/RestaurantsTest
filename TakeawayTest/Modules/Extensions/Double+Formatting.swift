//
//  Double+Formatting.swift
//  TakeawayTest
//
//  Created by abuzeid on 20.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

public extension Double {
    private var locale: Locale { return Locale(identifier: "en_DE") }
    var formattedPrice: String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = locale
        return currencyFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }

    var formattedDistance: String {
        let formatter = MeasurementFormatter()
        formatter.locale = locale
        let distanceInMeters = Measurement(value: self, unit: UnitLength.meters)
        return formatter.string(from: distanceInMeters)
    }
}
