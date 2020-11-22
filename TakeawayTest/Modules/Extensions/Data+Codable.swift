//
//  Data+Codable.swift
//  TakeawayTest
//
//  Created by abuzeid on 19.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
public extension Data {
    func parse<T: Decodable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
}
