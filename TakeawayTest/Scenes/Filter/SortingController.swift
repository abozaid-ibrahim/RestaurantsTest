//
//  SortingController.swift
//  TakeawayTest
//
//  Created by abuzeid on 20.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class SortingController: UIViewController {
    private let tableView = UITableView()
    private(set) var disposeBag = DisposeBag()
    let selectedFilter = PublishRelay<SortingCreteria>()

    init() {
        super.init(nibName: nil, bundle: nil)
        title = .sortedBy
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func loadView() {
        view = UIView()
        view.addSubview(tableView)
        tableView.setConstrainsEqualToParentEdges()
        tableView.accessibilityIdentifier = "SortingTable"

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }

    private func setupTableView() {
        tableView.register(SortingCell.self, forCellReuseIdentifier: SortingCell.identifier)
        tableView.tableFooterView = UIView()
        Observable<[SortingCreteria]>
            .from(optional: SortingCreteria.allCases)
            .bind(to: tableView.rx.items(cellIdentifier: SortingCell.identifier)) { _, model, cell in
                cell.textLabel?.text = model.rawValue
            }.disposed(by: disposeBag)

        tableView.rx
            .modelSelected(SortingCreteria.self)
            .subscribe(onNext: { [unowned self] in
                self.selectedFilter.accept($0)
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
}

enum SortingCreteria: String, CaseIterable {
    case bestMatch = "Best Match"
    case newest = "Newest"
    case ratingAverage = "Rating average"
    case distance = "Distance"
    case popularity = "Popularity"
    case averageProductPrice = "Average product price"
    case deliveryCosts = "Delivery costs"
    case minimumCost = "Minimum cost"
}

extension String {
    static var sortedBy: String { "Sort By".localizedCapitalized }
}
