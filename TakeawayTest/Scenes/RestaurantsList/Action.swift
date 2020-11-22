//
//  Action.swift
//  TakeawayTest
//
//  Created by abuzeid on 20.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import RxCocoa

struct Action {
    let error = PublishRelay<String>()
    let search = BehaviorRelay<String?>(value: .none)
    let isLoading = BehaviorRelay<Bool>(value: true)
    let uiData = BehaviorRelay<[Restaurant]>(value: [])
    let sortingType = BehaviorRelay<SortingCreteria>(value: .ratingAverage)
}
