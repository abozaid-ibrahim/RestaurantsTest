//
//  NSAttributedString.swift
//  TakeawayTest
//
//  Created by abuzeid on 19.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

public extension NSAttributedString {
    static func text<T>(with value: T, and icon: String) -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: icon)
        attachment.bounds = CGRect(x: 0, y: -2, width: 15, height: 15)
        let attachmentStr = NSAttributedString(attachment: attachment)
        let iconedString = NSMutableAttributedString(string: "")
        iconedString.append(attachmentStr)
        iconedString.append(NSMutableAttributedString(string: " \(value)"))
        return iconedString
    }
}
