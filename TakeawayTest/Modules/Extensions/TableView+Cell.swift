//
//  TableView+Cell.swift
//  TakeawayTest
//
//  Created by abuzeid on 19.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

public extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

public extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) {
        let nib = UINib(nibName: T.identifier, bundle: Bundle(for: T.self))
        register(nib, forCellReuseIdentifier: T.identifier)
    }
}
