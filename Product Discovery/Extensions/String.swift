//
//  String.swift
//  Product Discovery
//
//  Created by Kent DANG on 9/2/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import Foundation
import Kingfisher

extension String: Resource {
    public var cacheKey: String {
        return self
    }
    
    public var downloadURL: URL {
        return URL(string: self) ?? URL(fileURLWithPath: self)
    }
}
