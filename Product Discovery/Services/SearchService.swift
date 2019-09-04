//
//  SearchService.swift
//  Product Discovery
//
//  Created by Kent DANG on 8/30/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import Foundation

protocol SearchServiceDelegate: class {
    func searchServiceDidLoadNewData(_ service: SearchService)
    func searchService(_ service: SearchService, didAddData amount: Int)
}

class SearchService {
    private static let path = "api/search"
    private let network: PDNetworking
    private(set) var data: SearchResponse = .empty
    private(set) var query: String = ""
    let limit: Int
    private var currentTask: PDNetworkingTask?
    
    weak var delegate: SearchServiceDelegate?
    
    init(limit: Int, network: PDNetworking) {
        self.limit = limit
        self.network = network
    }
    
    func search(for query: String) {
        self.query = query
        currentTask?.stop()
        currentTask = SearchService.search(for: query, limit: limit, with: network) { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success(let response):
                this.data = response
                this.delegate?.searchServiceDidLoadNewData(this)
            case .failure(let error): print(error)
            }
            this.currentTask = nil
        }
        currentTask?.start()
    }
    
    func loadMore() {
        guard currentTask == nil && data.extra.page > 0 && data.result.products.count < data.extra.totalItems else { return }
        currentTask = SearchService.search(for: query, page: data.extra.page + 1, limit: limit, with: network) { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success(let response):
                let old = this.data
                this.data = old.appending(other: response)
                this.delegate?.searchService(this, didAddData: this.data.result.products.count - old.result.products.count)
            case .failure(let error): print(error)
            }
            this.currentTask = nil
        }
        currentTask?.start()
    }
    
    func clear() {
        data = .empty
    }
}

private extension SearchService {
    static func search(for query: String, page: Int = 1, limit: Int = 10, with network: PDNetworking, completion: @escaping (PDResult<SearchResponse>) -> Void) -> PDNetworkingTask {
        let request = PDService.request(for: path, parameters: ["channel": "pv_showroom", "visitorId": "", "q": query, "terminal": "CP01", "_page": page, "_limit": limit])
        let resource = PDResource<SearchResponse>(request: request) { data -> PDResult<SearchResponse> in
            do {
                let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
                return .success(searchResponse)
            } catch {
                if let failedResponse = try? JSONDecoder().decode(PDService.FailedResponse.self, from: data) {
                    PDLog.log(failedResponse.error)
                    return .failure(failedResponse.error)
                }
                PDLog.log(error)
                return .failure(error)
            }
        }
        return network.loadTask(resource: resource, completion: completion)
    }
}
