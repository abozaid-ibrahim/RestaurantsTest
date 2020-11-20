//
//  TableReload.swift
//  TakeawayTest
//
//  Created by abuzeid on 20.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
enum TableReload: Equatable {
    case all
    case row(Int)
    case none
    static func == (lhs: TableReload, rhs: TableReload) -> Bool {
        if case let .row(pos1) = lhs,
            case let .row(pos2) = rhs {
            return pos1 == pos2
        }
        return lhs == rhs
    }
}
