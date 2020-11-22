//
//  NetworkError.swift
//  TakeawayTest
//
//  Created by abuzeid on 19.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
enum NetworkError: LocalizedError {
    case badRequest
    case noData
    case failedToParseData
    var errorDescription: String? {
        switch self {
        case .failedToParseData:
            return "Technical Difficults, we can't fetch the data"
        case .noData:
            return "Something went wrong"
        case .badRequest:
            return "Check your request parameters"
        }
    }
}
