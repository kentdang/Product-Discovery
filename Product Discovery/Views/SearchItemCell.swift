//
//  SearchItemCell.swift
//  Product Discovery
//
//  Created by Kent DANG on 8/31/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import UIKit
import Kingfisher

class SearchItemCell: UITableViewCell {
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var sellPriceLabel: UILabel!
    @IBOutlet private weak var supplierSalePriceLabel: UILabel!
    @IBOutlet private weak var promotionLabel: UILabel!
    
    func configure(product: Product) {
        productImageView.kf.cancelDownloadTask()
        productImageView.image = nil
        productImageView.kf.setImage(with: product.imageURL, placeholder: UIImage.defaultProductImage)
        nameLabel.text = product.name
        sellPriceLabel.text = product.price.priceText
        if let saleOff = product.price.saleOff {
            supplierSalePriceLabel.attributedText = saleOff.oldPriceText
            promotionLabel.text = "-\(Int(saleOff.percent))%"
            promotionLabel.superview?.isHidden = false
        } else {
            supplierSalePriceLabel.attributedText = nil
            promotionLabel.text = ""
            promotionLabel.superview?.isHidden = true
        }
    }
}
