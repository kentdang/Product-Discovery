//
//  AttributeGroups.swift
//  Product Discovery
//
//  Created by Kent DANG on 9/3/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import Foundation

extension ProductDetail.AttributeGroup {
    var dictionary: [String: Any] {
        return ["priority": priority, "name": name, "value": value]
    }
    
    init?(dictionary: [String: Any]) {
        guard let priority = dictionary["priority"] as? Int, let name = dictionary["name"] as? String, let value = dictionary["value"] as? String else { return nil }
        self.priority = priority
        self.name = name
        self.value = value
    }
}

public class AttributeGroups: NSObject, NSCoding {
    let value: [[String: Any]]
    
    init(value: [ProductDetail.AttributeGroup]) {
        self.value = value.map { $0.dictionary }
        super.init()
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(value, forKey: "value")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        value = aDecoder.decodeObject(forKey: "value") as! [[String: Any]]
    }
}
