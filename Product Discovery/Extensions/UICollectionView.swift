//
//  UICollectionView.swift
//  Product Discovery
//
//  Created by Kent DANG on 9/2/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import UIKit

extension UICollectionView {
    public func registerNib<T: UICollectionViewCell>(aClass: T.Type, bundle: Bundle? = nil) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: name)
    }
    
    public func registerClass<T: UICollectionViewCell>(aClass: T.Type) {
        let name = String(describing: aClass)
        register(aClass, forCellWithReuseIdentifier: name)
    }
    
    public func dequeue<T: UICollectionViewCell>(aClass: T.Type, indexPath: IndexPath) -> T {
        let name = String(describing: aClass)
        return dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as! T
    }
}
