//
//  Double.swift
//  Product Discovery
//
//  Created by Kent DANG on 9/2/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import Foundation

extension Double {
    static func formattedCurrency(of value: Double?, currencyCode: String) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.numberStyle = .currencyAccounting
        formatter.maximumFractionDigits = 0
        formatter.currencyCode = currencyCode
        guard let value = value, let text = formatter.string(from: NSNumber(value: value)) else { return "Chưa cập nhật" }
        return text
    }
    
    func formattedCurrency(currencyCode: String) -> String {
        return Double.formattedCurrency(of: self, currencyCode: currencyCode)
    }
}
