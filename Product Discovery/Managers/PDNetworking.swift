//
//  WSManager.swift
//  Product Discovery
//
//  Created by Kent DANG on 8/30/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import Foundation

struct PDNetworkError: Error {
    let code: Any
    let message: String
    
    var localizedDescription: String {
        return message
    }
}

enum PDResult<T> {
    case success(T)
    case failure(Error)
}

protocol PDRequest {
    var value: URLRequest { get }
}

extension URLRequest: PDRequest {
    var value: URLRequest { return self }
}

protocol PDNetworkingTask: class {
    func start()
    func stop()
}

extension URLSessionDataTask: PDNetworkingTask {
    func start() {
        resume()
    }
    
    func stop() {
        cancel()
    }
}

struct PDResource<A> {
    let request: PDRequest
    let parse: (Data) -> PDResult<A>
}

protocol PDNetworking {
    var parseQueue: DispatchQueue? { get }
    func loadTask(request: PDRequest, completion: @escaping (PDResult<Data>) -> Void) -> PDNetworkingTask
}

extension PDNetworking {
    func loadTask<A>(resource: PDResource<A>, completion: @escaping (PDResult<A>) -> Void) -> PDNetworkingTask {
        return self.loadTask(request: resource.request) { result in
            switch result {
            case let .success(data):
                if let queue = self.parseQueue {
                    queue.async { completion(resource.parse(data)) }
                } else {
                    completion(resource.parse(data))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
