//
//  HomeNavigationController.swift
//  Product Discovery
//
//  Created by Kent DANG on 8/31/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import UIKit

class HomeNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
