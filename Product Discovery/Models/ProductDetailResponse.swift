//
//  ProductDetailResponse.swift
//  Product Discovery
//
//  Created by Kent DANG on 8/31/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import Foundation

struct ProductDetail: Codable {
    let sku: String
    let name: String
    let displayName: String
    let url: String?
    let status: Status
    let images: [Image]
    let price: Price
    var attributeGroups: [AttributeGroup]
}

struct ProductDetailResponse: Codable {
    let result: Result
}

extension ProductDetailResponse {
    struct Result: Codable {
        let product: ProductDetail
    }
}

extension Product {
    var detail: ProductDetail {
        return ProductDetail(sku: sku, name: name, displayName: displayName, url: url, status: status, images: images, price: price, attributeGroups: [])
    }
}

extension ProductDetail {
    struct AttributeGroup: Codable {
        let priority: Int
        let name: String
        let value: String
    }
    
    var sortedAttributeGroups: [AttributeGroup] {
        return attributeGroups.sorted { $0.priority < $1.priority }
    }
}
