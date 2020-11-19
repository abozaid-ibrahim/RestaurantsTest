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

final class RestaurantsTableController: UITableViewController {
    private let viewModel: RestaurantsViewModelType
    private var dataList: [Restaurant] { viewModel.dataList }
    private let disposeBag = DisposeBag()

    init(with viewModel: RestaurantsViewModelType = RestaurantsViewModel()) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        bindToViewModel()
        viewModel.loadData(with: .none)
    }
}

// MARK: - Table view data source

extension RestaurantsTableController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: RestaurantTableCell.self, for: indexPath)
        cell.setData(for: dataList[indexPath.row],
                     onFavourite: { [unowned self] in self.viewModel.toggleFavourite(at: indexPath.row) })
        return cell
    }
}

// MARK: - Private

private extension RestaurantsTableController {
    var indicator: ActivityIndicatorFooterView? {
        return tableView.tableFooterView as? ActivityIndicatorFooterView
    }

    func setupTableView() {
        tableView.tableFooterView = ActivityIndicatorFooterView()
        tableView.register(RestaurantTableCell.self)
        tableView.rowHeight = 140
    }

    func bindToViewModel() {
        viewModel.reload
            .asDriver(onErrorJustReturn: .none)
            .drive(onNext: { [unowned self] in
                if case let TableReload.row(row) = $0 {
                    self.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
                } else if case TableReload.all = $0 {
                    self.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        viewModel.error
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [unowned self] in self.show(error: $0) })
            .disposed(by: disposeBag)

        viewModel.isLoading
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [unowned self] in
                self.tableView.sectionFooterHeight = $0 ? 80 : 0
                self.indicator?.set(isLoading: $0)
            })
            .disposed(by: disposeBag)
    }
}
