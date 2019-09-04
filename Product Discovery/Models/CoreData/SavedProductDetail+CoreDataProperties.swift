//
//  SavedProductDetail+CoreDataProperties.swift
//  
//
//  Created by Kent DANG on 9/3/19.
//
//

import Foundation
import CoreData


extension SavedProductDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedProductDetail> {
        return NSFetchRequest<SavedProductDetail>(entityName: "SavedProductDetail")
    }

    @NSManaged public var sku: String?
    @NSManaged public var attributeGroups: AttributeGroups?

}
