//
//  UserDefaults.swift
//  Product Discovery
//
//  Created by Kent DANG on 9/2/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import Foundation

extension UserDefaults {
    enum Key: String {
        case amountInCart
    }
    
    class func pdKey(_ key: Key) -> String {
        return "PDUserDefaults.\(key.rawValue)"
    }
    
    class func set(_ value: Any?, forKey key: Key) {
        UserDefaults.standard.set(value, forKey: pdKey(.amountInCart))
        UserDefaults.standard.synchronize()
    }
    
    class func dictionary(forKey: Key) -> [String: Any]? {
        return UserDefaults.standard.dictionary(forKey: pdKey(.amountInCart))
    }
}

extension UserDefaults {
    class var amountInCart: [String: Int] {
        set {
            set(newValue, forKey: .amountInCart)
            NotificationCenter.post(key: .amountInCartDidChange)
        }
        get {
            return dictionary(forKey: .amountInCart) as? [String: Int] ?? [:]
        }
    }
}
