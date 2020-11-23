//
//  RestaurantsTableController.swift
//  TakeawayTest
//
//  Created by abuzeid on 19.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class RestaurantsTableController: UIViewController {
    private let viewModel: RestaurantsViewModelType
    private let disposeBag = DisposeBag()
    private let tableView = UITableView()
    init(with viewModel: RestaurantsViewModelType = RestaurantsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = .discover
    }

    override func loadView() {
        view = UIView()
        view.addSubview(tableView)
        tableView.setConstrainsEqualToParentEdges()
        tableView.accessibilityIdentifier = "RestaurantsTable"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
        bindToViewModel()
        viewModel.loadData()
    }
}

private extension RestaurantsTableController {
    func setupTableView() {
        navigationItem.rightBarButtonItem = .init(title: .sort,
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(openFilters(_:)))
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = ActivityIndicatorView()
        tableView.register(RestaurantTableCell.self)
        tableView.showsVerticalScrollIndicator = false
        navigationController?.hidesBarsOnSwipe = true
    }

    @objc func openFilters(_ sender: Any) {
        guard let controller = AppNavigator.shared.push(.filter) as? SortingController else { return }
        controller.selectedFilter
            .bind(onNext: { [unowned self] in self.viewModel.observer.sortingType.accept($0) })
            .disposed(by: controller.disposeBag)
    }

    func bindToViewModel() {
        viewModel.observer.dataSource
            .bind(to: tableView.rx.items(cellIdentifier: RestaurantTableCell.identifier,
                                         cellType: RestaurantTableCell.self)) { [unowned self] row, model, cell in
                cell.setData(for: model,
                             onFavourite: { self.viewModel.toggleFavourite(at: row) })
            }.disposed(by: disposeBag)

        viewModel.observer.error
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [unowned self] in self.show(error: $0) })
            .disposed(by: disposeBag)

        viewModel.observer.isLoading
            .asDriver()
            .drive(onNext: { [unowned self] in self.tableView.isLoading($0) })
            .disposed(by: disposeBag)
    }

    func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.rx.value
            .bind(onNext: { [unowned self] in self.viewModel.observer.search.accept($0) })
            .disposed(by: disposeBag)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = .search
        searchController.searchBar.isTranslucent = false
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension String {
    static var sort: String { "Sort".localizedCapitalized }
    static var search: String { "Search".localizedCapitalized }
    static var discover: String { "Discover".localizedCapitalized }
}
