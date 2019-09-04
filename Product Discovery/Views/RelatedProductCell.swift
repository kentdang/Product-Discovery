//
//  RelatedProductCell.swift
//  Product Discovery
//
//  Created by Kent DANG on 9/2/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import UIKit

class RelatedProductCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var sellPriceLabel: UILabel!
    @IBOutlet private weak var supplierSalePriceLabel: UILabel!
    @IBOutlet private weak var promotionLabel: UILabel!
    @IBOutlet private weak var bottomViewHeight: NSLayoutConstraint!
    
    func configure(product: Product) {
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        imageView.kf.setImage(with: product.imageURL, placeholder: UIImage.defaultProductImage)
        nameLabel.text = product.name
        sellPriceLabel.text = product.price.priceText
        if let saleOff = product.price.saleOff {
            nameLabel.numberOfLines = 1
            supplierSalePriceLabel.attributedText = saleOff.oldPriceText
            promotionLabel.text = "-\(Int(saleOff.percent))%"
            bottomViewHeight.constant = 16
        } else {
            nameLabel.numberOfLines = 2
            supplierSalePriceLabel.attributedText = nil
            promotionLabel.text = ""
            bottomViewHeight.constant = 0
        }
    }
}
