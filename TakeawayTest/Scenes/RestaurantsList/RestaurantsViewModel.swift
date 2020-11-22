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
    var observer: Action { get }
    func loadData()
    func toggleFavourite(at position: Int)
}

final class RestaurantsViewModel: RestaurantsViewModelType {
    private let disposeBag = DisposeBag()
    private let dataLoader: RestaurantsDataSource
    private let scheduler: SchedulerType
    private(set) var cache: [Restaurant] = []
    let observer = Action()
    init(with dataLoader: RestaurantsDataSource = RestaurantsLocalLoader(),
         scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        self.dataLoader = dataLoader
        self.scheduler = scheduler
        subscribeForUIInputs()
    }

    func toggleFavourite(at position: Int) {
        guard let index = cache.firstIndex(where: { $0 == self.observer.dataSource.value[position] }) else { return }
        cache[index].isFavourite.toggle()
        sortAndUpdateUI()
    }

    func loadData() {
        observer.isLoading.accept(true)
        dataLoader.loadRestaurants()
            .subscribeOn(scheduler)
            .subscribe(onNext: { [unowned self] in self.cache = $0 },
                       onError: { [unowned self] in self.observer.error.accept($0.localizedDescription) },
                       onCompleted: { [unowned self] in
                           self.sortAndUpdateUI()
                           self.observer.isLoading.accept(false)
                       })
            .disposed(by: disposeBag)
    }
}

private extension RestaurantsViewModel {
    func sortAndUpdateUI() {
        let name = observer.search.value ?? ""
        let dataList = (name.isEmpty ? cache : cache.filter { $0.name.lowercased().contains(name.lowercased()) })
            .sorted(by: observer.sortingType.value)
            .sortedByStatus()
            .sortedByFavourite()
        observer.dataSource.accept(dataList)
    }

    func subscribeForUIInputs() {
        observer.search.distinctUntilChanged()
            .debounce(.milliseconds(200), scheduler: SharingScheduler.make())
            .filter { $0 != nil }
            .subscribeOn(scheduler)
            .subscribe(onNext: { [unowned self] _ in self.sortAndUpdateUI() })
            .disposed(by: disposeBag)

        observer.sortingType.bind(onNext: { [unowned self] _ in self.sortAndUpdateUI() })
            .disposed(by: disposeBag)
    }
}
