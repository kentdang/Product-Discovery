//
//  SearchServiceTests.swift
//  Product DiscoveryTests
//
//  Created by Kent DANG on 9/2/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import XCTest
@testable import Product_Discovery

class SearchServiceTests: XCTestCase {
    let networking = PDNetworkManagerMock()
    lazy var service = SearchService(limit: 10, network: networking)
    
    func testSearch_NoData() {
        networking.data = nil
        service.search(for: "")
        XCTAssert(service.data.result.products.isEmpty, "search is incorrect for case no data")
    }
    
    func testSearch_ValidData() {
        networking.data = DataPool.searchP1
        service.search(for: "")
        XCTAssert(service.data.result.products.count == 10, "search is incorrect for case valid data")
    }
    
    func testSearch_WrongData() {
        networking.data = DataPool.wrongSearch
        service.search(for: "")
        XCTAssert(service.data.result.products.isEmpty, "search is incorrect for case wrong data")
    }
    
    func testSearch_FailedResponse() {
        networking.data = DataPool.failedSearch
        service.search(for: "")
        XCTAssert(service.data.result.products.isEmpty, "search is incorrect for case failed response")
    }
    
    func testClear() {
        networking.data = DataPool.searchP1
        service.search(for: "")
        service.clear()
        XCTAssert(service.data.result.products.isEmpty, "clear is incorrect")
    }
    
    func testLoadMore() {
        networking.data = DataPool.searchP1
        service.search(for: "")
        networking.data = DataPool.searchP2
        service.loadMore()
        XCTAssert(service.data.result.products.count == 20, "loadMore is incorrect")
        networking.data = DataPool.searchP3
        service.loadMore()
        XCTAssert(service.data.result.products.count == 29, "loadMore is incorrect")
        service.loadMore()
        XCTAssert(service.data.result.products.count == 29, "loadMore is incorrect")
    }
}
