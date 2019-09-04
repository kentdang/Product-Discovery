//
//  DataPool.swift
//  Product DiscoveryTests
//
//  Created by Kent DANG on 9/2/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import Foundation
@testable import Product_Discovery

extension FileManager {
    static func jsonData(from filename: String, bundle: Bundle = Bundle(for: DataPool.self)) -> Data? {
        guard let fileURL = bundle.url(forResource: filename, withExtension: "json"),
            let data = try? Data(contentsOf: fileURL) else { return nil }
        return data
    }
    
    static func jsonDictionary(from filename: String, bundle: Bundle = Bundle(for: DataPool.self)) -> [String: Any]? {
        guard let data = jsonData(from: filename, bundle: bundle), let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments), let dict = json as? [String: Any] else { return nil }
        return dict
    }
}

class DataPool {
    static let productDetail = FileManager.jsonData(from: "ProductDetail")!
    static let wrongProductDetail = FileManager.jsonData(from: "WrongProductDetail")!
    static let failedProductDetail = FileManager.jsonData(from: "FailedProductDetail")!
    static let searchP1 = FileManager.jsonData(from: "SearchP1")!
    static let searchP2 = FileManager.jsonData(from: "SearchP2")!
    static let searchP3 = FileManager.jsonData(from: "SearchP3")!
    static let wrongSearch = FileManager.jsonData(from: "WrongSearch")!
    static let failedSearch = FileManager.jsonData(from: "FailedSearch")!
}

class PDNetworkManagerMock: PDNetworking {
    var parseQueue: DispatchQueue?
    
    var data: Data?
    
    func loadTask(request: PDRequest, completion: @escaping (PDResult<Data>) -> Void) -> PDNetworkingTask {
        return PDNetworkingTaskMock(completion: completion, data: data)
    }
}

class PDNetworkingTaskMock: PDNetworkingTask {
    var completion: ((PDResult<Data>) -> Void)?
    let data: Data?
    
    init(completion: @escaping (PDResult<Data>) -> Void, data: Data?) {
        self.completion = completion
        self.data = data
    }
    func start() {
        guard let data = data else {
            completion?(.failure(PDNetworkError.noData))
            return
        }
        completion?(.success(data))
    }
    func stop() {
        completion = nil
    }
}

extension PDResult {
    var isSuccess: Bool {
        switch self {
        case .success: return true
        default: return false
        }
    }
}
