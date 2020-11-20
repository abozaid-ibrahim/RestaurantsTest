//
//  SortingController.swift
//  TakeawayTest
//
//  Created by abuzeid on 20.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import RxSwift
import UIKit

final class SortingController: UITableViewController {
    private var dataList: [SortingCreteria] = SortingCreteria.allCases
    private (set)var disposeBag = DisposeBag()
    let selectedFilter: PublishSubject<SortingCreteria> = .init()
    init() {
        super.init(style: .plain)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
}

// MARK: - Table view data source

extension SortingController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: SortingCell.self, for: indexPath)
        cell.textLabel?.text = dataList[indexPath.row].title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFilter.onNext(dataList[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Private

private extension SortingController {
    func setupTableView() {
        tableView.register(SortingCell.self, forCellReuseIdentifier: SortingCell.identifier)
        tableView.rowHeight = 40
        tableView.tableFooterView = UIView()
    }
}

enum SortingCreteria: String, CaseIterable {
    case bestMatch
    case newest
    case ratingAverage
    case distance
    case popularity
    case averageProductPrice
    case deliveryCosts
    case minimumCost
    var title: String {
        switch self {
        case .bestMatch:
            return "Best Match"
        case .newest:
            return "Newest"
        case .ratingAverage:
            return "Rating average"
        case .distance:
            return "Distance"
        case .popularity:
            return "Popularity"
        case .averageProductPrice:
            return "Average product price"
        case .deliveryCosts:
            return "Delivery costs"
        case .minimumCost:
            return "Minimum cost"
        }
    }
}
