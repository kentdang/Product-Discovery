//
//  ProductDetailImageCell.swift
//  Product Discovery
//
//  Created by Kent DANG on 9/2/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import UIKit

class ProductDetailImageCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    
    func configure(url: String) {
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        imageView.kf.setImage(with: url, placeholder: UIImage.defaultProductImage)
    }
}
