//
//  UITableView.swift
//  Product Discovery
//
//  Created by Kent DANG on 8/31/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import UIKit

extension UITableView {
    public func registerNib<T: UITableViewCell>(aClass: T.Type, bundle: Bundle? = nil) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: bundle)
        register(nib, forCellReuseIdentifier: name)
    }
    
    public func registerClass<T: UITableViewCell>(aClass: T.Type) {
        let name = String(describing: aClass)
        register(aClass, forCellReuseIdentifier: name)
    }
    
    public func registerNib<T: UITableViewHeaderFooterView>(aClass: T.Type, bundle: Bundle? = nil) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: bundle)
        register(nib, forHeaderFooterViewReuseIdentifier: name)
    }
    
    public func registerClass<T: UITableViewHeaderFooterView>(aClass: T.Type) {
        let name = String(describing: aClass)
        register(aClass, forHeaderFooterViewReuseIdentifier: name)
    }
    
    public func dequeue<T: UITableViewCell>(aClass: T.Type) -> T {
        let name = String(describing: aClass)
        return dequeueReusableCell(withIdentifier: name) as! T
    }
    
    public func dequeue<T: UITableViewCell>(aClass: T.Type, indexPath: IndexPath) -> T {
        let name = String(describing: aClass)
        return dequeueReusableCell(withIdentifier: name, for: indexPath) as! T
    }
    
    public func dequeue<T: UITableViewHeaderFooterView>(aClass: T.Type) -> T {
        let name = String(describing: aClass)
        return dequeueReusableHeaderFooterView(withIdentifier: name) as! T
    }
}
