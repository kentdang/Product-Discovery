//
//  NotificationCenter.swift
//  Product Discovery
//
//  Created by Kent DANG on 9/2/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import Foundation

extension NotificationCenter {
    enum Key: String {
        case amountInCartDidChange
    }
    
    class func pdName(_ key: Key) -> Notification.Name {
        return Notification.Name("PDUserDefaults.\(key.rawValue)")
    }
    
    class func post(key: Key, object: Any? = nil, userInfo: [AnyHashable : Any]? = nil) {
        NotificationCenter.default.post(name: pdName(key), object: object, userInfo: userInfo)
    }
    
    class func addObserver(_ observer: Any, selector: Selector, key: Key, object: Any? = nil) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: pdName(key), object: object)
    }
}
