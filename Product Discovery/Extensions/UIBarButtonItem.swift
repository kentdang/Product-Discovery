//
//  UIBarButtonItem.swift
//  Product Discovery
//
//  Created by Kent DANG on 9/1/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import UIKit

private var handle: UInt8 = 0

private extension UIBarButtonItem {
    private var badgeLabel: UILabel? {
        return objc_getAssociatedObject(self, &handle) as? UILabel
    }
    
    @discardableResult
    func createBadgeLabel() -> Bool {
        guard let view = self.value(forKey: "view") as? UIView else { return false }
        let badgeLabel = UILabel()
        badgeLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        view.addSubview(badgeLabel)
        objc_setAssociatedObject(self, &handle, badgeLabel, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return true
    }
}

extension UIBarButtonItem {
    func setBadgeNumber(_ number: Int, backgroundColor: UIColor = .pumpkinOrange, textColor: UIColor = .white) {
        guard let badgeLabel = badgeLabel else {
            if createBadgeLabel() {
                setBadgeNumber(number, backgroundColor: backgroundColor, textColor: textColor)
            }
            return
        }
        if number > 0 {
            badgeLabel.backgroundColor = backgroundColor
            badgeLabel.textColor = textColor
            badgeLabel.textAlignment = .center
            badgeLabel.text = number < 100 ? "\(number)" : "99+"
            badgeLabel.sizeToFit()
            var size = badgeLabel.frame.size
            size.height = 16
            size.width = max(size.width + 6, size.height)
            let view = badgeLabel.superview!
            badgeLabel.frame = CGRect(origin: CGPoint(x: view.frame.width - size.width, y: 0), size: size)
            badgeLabel.layer.cornerRadius = badgeLabel.bounds.height / 2
            badgeLabel.layer.masksToBounds = true
            badgeLabel.alpha = 1
        } else {
            badgeLabel.alpha = 0
        }
    }
}

