//
//  ProductDescriptionViewController.swift
//  Product Discovery
//
//  Created by Kent DANG on 9/1/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import UIKit

protocol ProductMethodViewControllerDelegate: class {
    func productMethodViewController(_ controller: UIViewController, didChangeHeight height: CGFloat)
}

class ProductMethodViewController: UIViewController {
    weak var delegate: ProductMethodViewControllerDelegate?
    
    func updateLayout() { }
}

class ProductDescriptionViewController: ProductMethodViewController {
    override func updateLayout() {
        delegate?.productMethodViewController(self, didChangeHeight: 100)
    }
}
