//
//  DoubleTests.swift
//  Product DiscoveryTests
//
//  Created by Kent DANG on 9/2/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import XCTest
@testable import Product_Discovery

class DoubleTests: XCTestCase {
    func testFormattedCurrency() {
        let khongDong: Double = 0
        XCTAssert(khongDong.formattedCurrency(currencyCode: "VND") == "0 ₫", "formattedCurrency is incorrect for 0 VND")
        let muoiNgan: Double = 10000
        XCTAssert(muoiNgan.formattedCurrency(currencyCode: "VND") == "10.000 ₫", "formattedCurrency is incorrect for 10.000 VND")
        let baTrieuLeBayNgan: Double = 3007000
        XCTAssert(baTrieuLeBayNgan.formattedCurrency(currencyCode: "VND") == "3.007.000 ₫", "formattedCurrency is incorrect for 3.007.000 VND")
    }
}
