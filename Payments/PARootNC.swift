//
//  PARootNC.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit

class PARootNC: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = PAUser.currentUser.isLoggedIn ? [PARootNC.feedVC()] : [PARootNC.loginVC()]
        
        PAUser.currentUser.refresh { (success) in
            // Don't really care for now
        }
    }
    
    //
    // MARK: Class Macros
    //
    
    class func loginVC() -> PALoginVC {
        return UIStoryboard(name: "Authentication", bundle: nil).instantiateInitialViewController() as! PALoginVC
    }
    
    class func feedVC() -> PAFeedVC {
        return UIStoryboard(name: "Feed", bundle: nil).instantiateInitialViewController() as! PAFeedVC
    }
}
