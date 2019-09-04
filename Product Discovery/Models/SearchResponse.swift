//
//  SearchResponse.swift
//  Product Discovery
//
//  Created by Kent DANG on 8/31/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import Foundation
import UIKit

struct Status: Codable {
    let sale: String
    let publish: Bool
    
    var isEnabled: Bool {
        return publish && sale == "hang_ban"
    }
    
    var text: String {
        switch sale {
        case "ngung_kinh_doanh": return "Ngừng kinh doanh"
        case "hang_ban": return "Hàng có sẵn"
        default: return "Chưa cập nhật"
        }
    }
    
    var style: (backgroundColor: UIColor, textColor: UIColor) {
        return isEnabled ? (backgroundColor: .main, textColor: .white) : (backgroundColor: .tableBackground, textColor: .detailSubText)
    }
}

struct Price: Codable {
    static let defaultCurrencyCode = "VND"
    let sellPrice: Double?
    let supplierSalePrice: Double?
    
    var currencyCode: String {
        return Price.defaultCurrencyCode
    }
    
    var priceText: String {
        return Double.formattedCurrency(of: sellPrice, currencyCode: currencyCode)
    }
    
    var saleOff: (oldPriceText: NSAttributedString, percent: Double)? {
        guard let sellPrice = sellPrice, let supplierSalePrice = supplierSalePrice, sellPrice >= 0 && sellPrice < supplierSalePrice else { return nil }
        let text = supplierSalePrice.formattedCurrency(currencyCode: currencyCode)
        let attributedText = NSAttributedString(string: text, attributes: [.strikethroughColor: UIColor.detailSubText, .strikethroughStyle: NSUnderlineStyle.single.rawValue, .foregroundColor: UIColor.detailSubText])
        return (oldPriceText: attributedText, percent: (supplierSalePrice - sellPrice) * 100 / supplierSalePrice)
    }
}

struct Image: Codable {
    let url: String
    let priority: Int
}

struct Product: Codable {
    let sku: String
    let name: String
    let displayName: String
    let url: String?
    let status: Status
    let images: [Image]
    let price: Price
    
    var imageURL: URL? {
        return URL(string: images.sorted { $0.priority < $1.priority }.first?.url ?? "")
    }
}

struct SearchResponse: Codable {
    let result: Result
    let extra: Extra
    
    static let empty = SearchResponse(result: .empty, extra: .empty)
}

extension SearchResponse {
    struct Result: Codable {
        let products: [Product]
        
        static let empty = Result(products: [])
    }
    
    struct Extra: Codable {
        let totalItems: Int
        let page: Int
        let pageSize: Int
        
        static let empty = Extra(totalItems: .max, page: 0, pageSize: 0)
    }
}

extension SearchResponse {
    func appending(other: SearchResponse) -> SearchResponse {
        var products = self.result.products
        products.append(contentsOf: other.result.products)
        return SearchResponse(result: Result(products: products), extra: other.extra)
    }
}
