//
//  ProductComparePriceViewController.swift
//  Product Discovery
//
//  Created by Kent DANG on 9/1/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import UIKit

class ProductComparePriceViewController: ProductMethodViewController {
    override func updateLayout() {
        delegate?.productMethodViewController(self, didChangeHeight: 100)
    }
}
