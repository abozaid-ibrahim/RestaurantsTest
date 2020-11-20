//
//  RestaurantTableCell.swift
//  TakeawayTest
//
//  Created by abuzeid on 19.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import RxSwift
import UIKit

typealias ButtonAction = () -> Void

final class RestaurantTableCell: UITableViewCell {
    private let favouriteImage = UIImage(named: "favorite")
    private let unFavouriteImage = UIImage(named: "unfavorite")
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var costLabel: UILabel!
    @IBOutlet private var distanceLabel: UILabel!
    @IBOutlet private var deliveryLabel: UILabel!
    @IBOutlet private var popularityLabel: UILabel!
    @IBOutlet private var averageProductPriceLabel: UILabel!

    @IBOutlet private var favouriteView: UIImageView!
    @IBOutlet private var ratingBar: RatingBar!
    private var favouriteChanged: ButtonAction?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        ratingBar.isIndicator = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(toggleFavourite(_:)))
        favouriteView.addGestureRecognizer(recognizer)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        favouriteChanged = nil
    }

    func setData(for restaurant: Restaurant, onFavourite: @escaping ButtonAction) {
        favouriteChanged = onFavourite
        nameLabel.text = restaurant.name
        statusLabel.text = restaurant.status.rawValue.capitalized
        statusLabel.backgroundColor = restaurant.status.color.withAlphaComponent(0.2)
        ratingBar.rating = CGFloat(restaurant.sortingValues.ratingAverage)
        favouriteView.image = restaurant.isFavourite ? favouriteImage : unFavouriteImage
        deliveryLabel.attributedText = .text(with: restaurant.sortingValues.deliveryCosts.formattedPrice,
                                             and: "delivery")
        costLabel.attributedText = .text(with: "Min. \(restaurant.sortingValues.minCost.formattedPrice)",
                                         and: "money-bag")
        popularityLabel.attributedText = .text(with: "Pop: \(restaurant.sortingValues.popularity)",
                                               and: "like")
        distanceLabel.attributedText = .text(with: restaurant.sortingValues.distance.formattedDistance,
                                             and: "distance")
    }

    @objc private func toggleFavourite(_ sender: UITapGestureRecognizer) {
        favouriteChanged?()
    }
}

extension Status {
    var color: UIColor {
        switch self {
        case .closed:
            return .red
        case .statusOpen:
            return .green
        case .orderAhead:
            return .yellow
        }
    }
}
