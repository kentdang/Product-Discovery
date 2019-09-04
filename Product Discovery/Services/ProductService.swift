//
//  SearchService.swift
//  Product Discovery
//
//  Created by Kent DANG on 8/30/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import Foundation

class ProductService {
    private static let path = "api/products"
    private let network: PDNetworking
    
    init(network: PDNetworking) {
        self.network = network
    }
    
    func getDetail(for sku: String, completion: @escaping (PDResult<ProductDetail>) -> Void) {
        ProductService.getDetail(for: sku, with: network, completion: completion)
    }
}

private extension ProductService {
    @discardableResult
    static func getDetail(for sku: String, with network: PDNetworking, completion: @escaping (PDResult<ProductDetail>) -> Void) -> PDNetworkingTask {
        let request = PDService.request(for: "\(path)/\(sku)")
        let resource = PDResource<ProductDetail>(request: request) { data -> PDResult<ProductDetail> in
            do {
                let response = try JSONDecoder().decode(ProductDetailResponse.self, from: data)
                return .success(response.result.product)
            } catch {
                if let failedResponse = try? JSONDecoder().decode(PDService.FailedResponse.self, from: data) {
                    PDLog.log(failedResponse.error)
                    return .failure(failedResponse.error)
                }
                PDLog.log(error)
                return .failure(error)
            }
        }
        let task = network.loadTask(resource: resource, completion: completion)
        task.start()
        return task
    }
}
