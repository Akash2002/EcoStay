//
//  ModTabBar.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 1/18/19.
//  Copyright © 2019 Akash Veerappan. All rights reserved.
//

import Foundation
import UIKit

extension UITabBarController {
    func modifyTabBar (emulator: UIView) {
        self.tabBar.layer.masksToBounds = false
        self.tabBar.layer.shadowOffset = CGSize(width: 0, height: -0.5)
        self.tabBar.layer.shadowRadius = 3
        self.tabBar.layer.shadowColor = emulator.layer.backgroundColor
        self.tabBar.layer.shadowOpacity = 0.7
    }
}
