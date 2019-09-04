//
//  SearchViewControllerTests.swift
//  Product DiscoveryTests
//
//  Created by Kent DANG on 9/3/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import XCTest
import UIKit
@testable import Product_Discovery

class SearchViewControllerTests: XCTestCase {
    let navigationController = HomeNavigationController()
    weak var controller: SearchViewController!
    let network = PDNetworkManagerMock()
    
    override func setUp() {
        super.setUp()
        let vc = SearchViewController.controllerFromStoryboard(with: network)
        navigationController.viewControllers = [vc]
        controller = vc
        _ = controller.view // To call viewDidLoad
    }
    
    func testTableViewHasDelegateAndDataSource() {
        XCTAssertNotNil(controller.tableView.delegate)
        XCTAssertNotNil(controller.tableView.dataSource)
    }
    
    func testTextDidChange() {
        let expectation = XCTestExpectation(description: "waitForSearch")
        network.data = DataPool.searchP1
        controller.searchBar(controller.navigationItem.titleView as! UISearchBar, textDidChange: "Something")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            XCTAssert(self.controller.tableView.numberOfRows(inSection: 0) == 10, "textDidChange is incorrect")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.4)
    }
    
    func testLoadMoreScrollViewDidEndDecelerating() {
        let expectation = XCTestExpectation(description: "waitForSearch")
        network.data = DataPool.searchP1
        controller.searchBar(controller.navigationItem.titleView as! UISearchBar, textDidChange: "Something")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            XCTAssert(self.controller.tableView.numberOfRows(inSection: 0) == 10, "textDidChange is incorrect")
            self.controller.scrollViewDidEndDecelerating(self.controller.tableView)
            XCTAssert(self.controller.tableView.numberOfRows(inSection: 0) == 20, "scrollViewDidEndDecelerating is incorrect")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testScrollViewDidEndDragging() {
        let expectation = XCTestExpectation(description: "waitForSearch")
        network.data = DataPool.searchP1
        controller.searchBar(controller.navigationItem.titleView as! UISearchBar, textDidChange: "Something")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            XCTAssert(self.controller.tableView.numberOfRows(inSection: 0) == 10, "textDidChange is incorrect")
            self.controller.scrollViewDidEndDragging(self.controller.tableView, willDecelerate: false)
            XCTAssert(self.controller.tableView.numberOfRows(inSection: 0) == 20, "scrollViewDidEndDragging is incorrect")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testDidSelectRow() {
        let expectation = XCTestExpectation(description: "waitForSearch")
        network.data = DataPool.searchP1
        controller.searchBar(controller.navigationItem.titleView as! UISearchBar, textDidChange: "Something")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.controller.tableView(self.controller.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                XCTAssertNotNil(self.navigationController.viewControllers.count == 2, "didSelectRow is incorrect")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.7)
    }
}
