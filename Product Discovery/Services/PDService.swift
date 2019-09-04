//
//  PDService.swift
//  Product Discovery
//
//  Created by Kent DANG on 8/30/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import Foundation

class PDService {
    static let host = "https://listing-stg.services.teko.vn"
    
    static func serviceURL(for path: String, parameters: [String: Any] = [:]) -> URL {
        var urlString = "\(host)/\(path)"
        let query = parameters.reduce("") { "\($0)\($1.key)=\($1.value)&" }
        if let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), !encodedQuery.isEmpty {
            urlString = "\(urlString)/?\(encodedQuery)"
        }
        return URL(string: urlString)!
    }
    
    static func request(for path: String, parameters: [String: Any] = [:]) -> URLRequest {
        let url = serviceURL(for: path, parameters: parameters)
        var request = URLRequest(url: url, timeoutInterval: 60)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}

extension PDService {
    struct FailedResponse: Codable {
        let code: String
        let message: String
        
        var error: PDNetworkError {
            return PDNetworkError(code: code, message: message)
        }
    }
}
