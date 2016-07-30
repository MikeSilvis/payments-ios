//
//  extension-UINavigationController.swift
//  Payments
//
//  Created by Mike Silvis on 7/29/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func setClear() {
        setBackgroundImage(UIImage(), forBarMetrics: .Default)
        barTintColor = .clearColor()
        shadowImage = UIImage()
        translucent = true
        tintColor = .whiteColor()
    }

    func setDefault() {
        setBackgroundImage(UIImage(), forBarMetrics: .Default)
        barTintColor = .blackColor()
        shadowImage = UIImage()
        translucent = false
    }

}
