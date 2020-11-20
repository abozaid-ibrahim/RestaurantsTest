//
//  RestaurantsViewModel.swift
//  TakeawayTest
//
//  Created by abuzeid on 19.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol RestaurantsViewModelType {
    var dataList: [Restaurant] { get }
    var error: PublishSubject<String> { get }
    var searchFor: PublishSubject<String> { get }
    var isLoading: PublishSubject<Bool> { get }
    var reload: PublishSubject<TableReload> { get }
    func searchCanceled()
    func sort(by type: SortingCreteria)
    func loadRestaurants(with name: String)
    func toggleFavourite(at position: Int)
}

final class RestaurantsViewModel: RestaurantsViewModelType {
    private let disposeBag = DisposeBag()
    private let dataLoader: RestaurantsDataSource
    let error = PublishSubject<String>()
    let searchFor = PublishSubject<String>()
    let isLoading = PublishSubject<Bool>()
    let isSearchLoading = PublishSubject<Bool>()
    let loadPreviousSearches = PublishSubject<String>()

    private(set) var reload = PublishSubject<TableReload>()
    private(set) var dataList: [Restaurant] = []
    private(set) var cachedData: [Restaurant] = []
    private(set) var sortingType: SortingCreteria?

    init(with dataLoader: RestaurantsDataSource = RestaurantsLocalLoader()) {
        self.dataLoader = dataLoader
        bindForSearch()
    }

    func searchCanceled() {
        dataList = cachedData
        sortAndUpdateUI()
    }

    func sort(by type: SortingCreteria) {
        sortingType = type
        sortAndUpdateUI()
    }

    func loadRestaurants(with name: String) {
        guard cachedData.isEmpty else {
            name.isEmpty ? searchCanceled() : filter(by: name)
            return
        }
        loadDataForFirstTime(name)
    }

    func toggleFavourite(at position: Int) {
        dataList[position].isFavourite.toggle()
        reload.onNext(.row(position))
        /// since we don't have a remote  api I want to updated my cached data.
        guard let index = cachedData.firstIndex(where: { $0 == self.dataList[position] }) else { return }
        cachedData[index].isFavourite.toggle()
    }
}

// MARK: private

private extension RestaurantsViewModel {
    func filter(by name: String) {
        dataList = cachedData
            .filter { $0.name.lowercased().contains(name.lowercased()) }
        sortAndUpdateUI()
    }

    func sortAndUpdateUI() {
        dataList = dataList
            .sorted(by: sortingType)
            .sortedByStatus()
        reload.onNext(.all)
    }

    func bindForSearch() {
        searchFor.distinctUntilChanged()
            .debounce(.milliseconds(250), scheduler: SharingScheduler.make())
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.loadRestaurants(with: text)
            }).disposed(by: disposeBag)
    }

    func loadDataForFirstTime(_ name: String) {
        isLoading.onNext(true)
        dataLoader.loadRestaurants()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.cachedData = data
                self.dataList = data
                name.isEmpty ? self.sortAndUpdateUI() : self.filter(by: name)
                self.isLoading.onNext(false)
            }, onError: { [weak self] error in
                self?.error.onNext(error.localizedDescription)
                self?.isLoading.onNext(false)
            }).dispose()
    }
}

extension Array where Element == Restaurant {
    func sortedByStatus() -> [Restaurant] {
        return sorted(by: { $0.status.priority < $1.status.priority })
    }

    func sorted(by: SortingCreteria?) -> [Restaurant] {
        guard let sort = by else {
            return self
        }
        /// try to use object key path
        switch sort {
        case .bestMatch:
            return sorted(by: { $0.sortingValues.bestMatch > $1.sortingValues.bestMatch })
        case .averageProductPrice:
            return sorted(by: { $0.sortingValues.averageProductPrice > $1.sortingValues.averageProductPrice })
        case .newest:
            return sorted(by: { $0.sortingValues.newest > $1.sortingValues.newest })
        case .ratingAverage:
            return sorted(by: { $0.sortingValues.ratingAverage > $1.sortingValues.ratingAverage })
        case .distance:
            return sorted(by: { $0.sortingValues.distance > $1.sortingValues.distance })
        case .popularity:
            return sorted(by: { $0.sortingValues.popularity > $1.sortingValues.popularity })
        case .deliveryCosts:
            return sorted(by: { $0.sortingValues.deliveryCosts > $1.sortingValues.deliveryCosts })
        case .minimumCost:
            return sorted(by: { $0.sortingValues.minCost > $1.sortingValues.minCost })
        }
    }
}
