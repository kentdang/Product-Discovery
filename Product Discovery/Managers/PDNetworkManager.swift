//
//  PDNetworkManager.swift
//  Product Discovery
//
//  Created by Kent DANG on 8/30/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import Foundation

class PDNetworkManager: PDNetworking {
    private let session = URLSession(configuration: .default)
    
    let parseQueue: DispatchQueue? = .main
    
    func loadTask(request: PDRequest, completion: @escaping (PDResult<Data>) -> Void) -> PDNetworkingTask {
        return session.dataTask(with: request.value) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let data = data {
                    completion(.success(data))
                } else {
                    completion(.failure(PDNetworkError.noData))
                }
            }
        }
    }
}
