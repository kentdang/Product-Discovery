//
//  ProductTechnicalSpecsCell.swift
//  Product Discovery
//
//  Created by Kent DANG on 9/1/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import UIKit

class ProductTechnicalSpecsCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    
    func configure(name: String, value: String, backgroundColor: UIColor) {
        nameLabel.text = name
        valueLabel.text = value
        contentView.backgroundColor = backgroundColor
    }
}
