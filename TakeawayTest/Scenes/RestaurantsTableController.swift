//
//  RestaurantsTableController.swift
//  TakeawayTest
//
//  Created by abuzeid on 19.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import UIKit

final class RestaurantsTableController: UITableViewController {
    private let viewModel: RestaurantsViewModelType
    private var dataList: [Restaurant] = []

    init(with viewModel: RestaurantsViewModelType = RestaurantsViewModel() ) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = ActivityIndicatorFooterView()
        tableView.register(RestaurantTableCell.self)
    }
}

// MARK: - Table view data source

extension RestaurantsTableController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: RestaurantTableCell.self, for: indexPath)
        cell.setData(for: dataList[indexPath.row])
        return cell
    }
}

// MARK: - Private

private extension RestaurantsTableController {
    var indicator: ActivityIndicatorFooterView? {
        return tableView.tableFooterView as? ActivityIndicatorFooterView
    }

  
}
