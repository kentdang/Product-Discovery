//
//  PDLog.swift
//  Product Discovery
//
//  Created by Kent DANG on 8/31/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import Foundation

class PDLog {
    static func log(_ object: Any) {
        #if DEBUG
        print(object)
        #endif
    }
}
