//
//  TakeawayTestTests.swift
//  TakeawayTestTests
//
//  Created by abuzeid on 19.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import RxCocoa
import RxSwift
import RxTest
import XCTest

@testable import TakeawayTest

final class TakeawayTestTests: XCTestCase {
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!

    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0, resolution: 0.001)
    }

    func testLoadingDataFromCachAndSearch() throws {
        SharingScheduler.mock(scheduler: scheduler) {
            let viewModel = RestaurantsViewModel(with: LoaderMocking(), scheduler: scheduler)
            let uiModel = scheduler.createObserver([Restaurant].self)
            viewModel.observer.dataSource.bind(to: uiModel).disposed(by: disposeBag)
            scheduler.scheduleAt(100, action: { viewModel.loadData() })
            scheduler.scheduleAt(700, action: { viewModel.observer.search.accept("kf") })
            scheduler.scheduleAt(1000, action: { viewModel.observer.search.accept("pizza") })
            scheduler.start()
            let streamValues: [Recorded<Event<[Restaurant]>>] = [.next(0, []),
                                                                 .next(101 , LoaderMocking.items),
                                                                 .next(700 + viewModel.searchDebounceTime, [LoaderMocking.kfc]),
                                                                 .next(1000 + viewModel.searchDebounceTime, [])]
            XCTAssertEqual(uiModel.events, streamValues)
        }
    }

    func testSetAndUnsetFavouriteThenOrderRestaurants() throws {
        let viewModel = RestaurantsViewModel(with: LoaderMocking(), scheduler: scheduler)
        let uiModel = scheduler.createObserver([Restaurant].self)
        viewModel.observer.dataSource.bind(to: uiModel).disposed(by: disposeBag)
        scheduler.scheduleAt(100, action: { viewModel.loadData() })
        scheduler.scheduleAt(200, action: { viewModel.toggleFavourite(at: 2) })
        scheduler.scheduleAt(300, action: { viewModel.toggleFavourite(at: 1) })
        scheduler.scheduleAt(400, action: { viewModel.toggleFavourite(at: 1) })
        scheduler.start()
        var rudi = LoaderMocking.rudi
        rudi.isFavourite.toggle()
        var mac = LoaderMocking.mac
        mac.isFavourite.toggle()
        let streamValues: [Recorded<Event<[Restaurant]>>]
        streamValues = [.next(0, []),
                        .next(101, LoaderMocking.items),
                        .next(200, [rudi, LoaderMocking.mac, LoaderMocking.kfc, LoaderMocking.burger]),
                        .next(300, [mac, rudi, LoaderMocking.kfc, LoaderMocking.burger]),
                        .next(400, [mac, LoaderMocking.kfc, LoaderMocking.rudi, LoaderMocking.burger])]
        XCTAssertEqual(uiModel.events, streamValues)
    }

    func testDifferentSortingCreteria() throws {
        let viewModel = RestaurantsViewModel(with: LoaderMocking(), scheduler: scheduler)
        let uiModel = scheduler.createObserver([Restaurant].self)
        viewModel.observer.dataSource.bind(to: uiModel).disposed(by: disposeBag)
        scheduler.scheduleAt(1, action: { viewModel.loadData() })
        scheduler.scheduleAt(10, action: { viewModel.observer.sortingType.accept(.minimumCost) })
        scheduler.scheduleAt(20, action: { viewModel.observer.sortingType.accept(.bestMatch) })
        scheduler.start()
        let streamValues: [Recorded<Event<[Restaurant]>>]
        streamValues = [.next(0, []),
                        .next(2, [LoaderMocking.mac, LoaderMocking.kfc, LoaderMocking.rudi, LoaderMocking.burger]),
                        .next(10, [LoaderMocking.mac, LoaderMocking.rudi, LoaderMocking.kfc, LoaderMocking.burger]),
                        .next(20, [LoaderMocking.mac, LoaderMocking.kfc, LoaderMocking.rudi, LoaderMocking.burger])]
        XCTAssertEqual(uiModel.events, streamValues)
    }
}

final class LoaderMocking: RestaurantsDataSource {
    static let burger = Restaurant.mock(name: "Burger", status: .closed, minCost: 100, rate: 4, bestMatch: 1)
    static let mac = Restaurant.mock(name: "Mac", status: .statusOpen, minCost: 200, rate: 3, bestMatch: 50)
    static let kfc = Restaurant.mock(name: "KFC", status: .orderAhead, minCost: 400, rate: 2, bestMatch: 100)
    static let rudi = Restaurant.mock(name: "Rudi", status: .orderAhead, minCost: 300, rate: 1, bestMatch: 99)
    static let items = [mac, kfc, rudi, burger]
    func loadRestaurants() -> Observable<[Restaurant]> {
        return Observable<[Restaurant]>.create({ observer in
            observer.onNext(LoaderMocking.items)
            observer.onCompleted()
            return Disposables.create()
        })
    }
}

extension Restaurant {
    static func mock(name: String, status: Status, minCost: Double, rate: Double, bestMatch: Double) -> Restaurant {
        let sorting = SortingValues(bestMatch: bestMatch,
                                    newest: 0,
                                    ratingAverage: rate,
                                    distance: 0,
                                    popularity: 0,
                                    averageProductPrice: 0,
                                    deliveryCosts: 0,
                                    minCost: minCost)
        return Restaurant(name: name, status: status, sortingValues: sorting, isFavourite: false)
    }
}
