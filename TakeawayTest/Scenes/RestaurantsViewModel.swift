//
//  RestaurantsViewModel.swift
//  TakeawayTest
//
//  Created by abuzeid on 19.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import RxSwift

enum Filter {
    case none
    case name(String)
}
enum TableReload: Equatable {
    case all
    case row(Int)
    case none
}

protocol RestaurantsViewModelType {
    var dataList: [Restaurant] { get }
    var error: PublishSubject<String> { get }
    var searchFor: PublishSubject<String> { get }
    var isLoading: PublishSubject<Bool> { get }
    var reload: PublishSubject<TableReload> { get }
    func searchCanceled()
    func loadData(with filter: Filter)
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
    init(with dataLoader: RestaurantsDataSource = RestaurantsLocalLoader()) {
        self.dataLoader = dataLoader
        bindForSearch()
    }

    func searchCanceled() {
        reload.onNext(.all)
    }

    func loadData(with filter: Filter = .none) {
        switch filter {
        case let .name(text):
            guard !dataList.isEmpty else {
                loadDataForFirstTime()
                return
            }
            let filtered = cachedData.filter { $0.name.lowercased().contains(text.lowercased()) }
            self.dataList = filtered
            reload.onNext(.all)
        case .none:
            loadDataForFirstTime()
        }
    }

    func toggleFavourite(at position: Int){
        self.dataList[position].isFavourite.toggle()
        self.reload.onNext(.row(position))
        //since we don't have a remote  api I want to updated my cached data.
        var item = self.cachedData.first(where: {$0 ==  self.dataList[position]})
        item?.isFavourite.toggle()
    }

   
}

// MARK: private

private extension RestaurantsViewModel {
    func bindForSearch() {
        searchFor.distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.loadData(with: .name(text))
            }).disposed(by: disposeBag)
    }

    func loadDataForFirstTime() {
        isLoading.onNext(true)
        dataLoader.loadRestaurants { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                self.cachedData = data
                self.dataList = data
                self.reload.onNext(.all)
            case let .failure(error):
                self.error.onNext(error.localizedDescription)
            }
            self.isLoading.onNext(false)
        }
    }
}
