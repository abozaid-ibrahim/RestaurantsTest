//
//  UIViewController+Error.swift
//  TakeawayTest
//
//  Created by abuzeid on 19.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    func show(error: String) {
        let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

