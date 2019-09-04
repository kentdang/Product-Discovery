//
//  ProductServiceTests.swift
//  Product DiscoveryTests
//
//  Created by Kent DANG on 9/2/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import XCTest
@testable import Product_Discovery

class ProductServiceTests: XCTestCase {
    let networking = PDNetworkManagerMock()
    lazy var service = ProductService(network: networking)
    
    func testGetDetail_NoData() {
        networking.data = nil
        service.getDetail(for: "") {
            XCTAssert(!$0.isSuccess, "getDetail is incorrect for case no data")
        }
    }
    
    func testGetDetail_ValidData() {
        networking.data = DataPool.productDetail
        service.getDetail(for: "") {
            XCTAssert($0.isSuccess, "getDetail is incorrect for case valid data")
        }
    }
    
    func testGetDetail_WrongData() {
        networking.data = DataPool.wrongProductDetail
        service.getDetail(for: "") {
            XCTAssert(!$0.isSuccess, "getDetail is incorrect for case wrong data")
        }
    }
    
    func testGetDetail_FailedResponse() {
        networking.data = DataPool.failedProductDetail
        service.getDetail(for: "") {
            XCTAssert(!$0.isSuccess, "getDetail is incorrect for case failed response")
        }
    }
}
