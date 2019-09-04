//
//  DBManager.swift
//  Product Discovery
//
//  Created by Kent DANG on 8/30/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import CoreData

class PDDatabase {
    static let database = PDDatabase()
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Product_Discovery")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    @discardableResult
    func create<T: NSManagedObject>(class: T.Type, in context: NSManagedObjectContext) -> T {
        let object = NSEntityDescription.insertNewObject(forEntityName: String(describing: T.self), into: context) as! T
        context.insert(object)
        return object
    }
    
    func fetchObjects<T: NSFetchRequestResult>(predicate: NSPredicate?, in context: NSManagedObjectContext) -> [T] {
        let fetch = NSFetchRequest<T>(entityName: String(describing: T.self))
        fetch.predicate = predicate
        do {
            return try context.fetch(fetch)
        } catch {
            print(error)
            return []
        }
    }
}

extension SavedProductDetail {
    class func fetchItem(sku: String, in context: NSManagedObjectContext) -> SavedProductDetail? {
        return PDDatabase.database.fetchObjects(predicate: NSPredicate(format: "sku = %@", sku), in: context).first
    }
    
    class func createOrUpdate(from detail: ProductDetail, in context: NSManagedObjectContext) {
        let object = fetchItem(sku: detail.sku, in: context) ?? PDDatabase.database.create(class: SavedProductDetail.self, in: context)
        object.sku = detail.sku
        object.attributeGroups = AttributeGroups(value: detail.attributeGroups)
    }
}

extension NSManagedObject {
    class func fetchAll<T: NSManagedObject>(in context: NSManagedObjectContext) -> [T] {
        return PDDatabase.database.fetchObjects(predicate: nil, in: context)
    }
}
