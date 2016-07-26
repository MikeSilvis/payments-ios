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
        
        handleLoggedOutUser()
    }
    
    //
    // MARK: Helpers
    //
    
    private func handleLoggedOutUser() {
        guard !PAUser.currentUser.isLoggedIn else {
            return
        }
        
        viewControllers = [PARootNC.loginVC()]
    }
    
    //
    // MARK: Class Macros
    //
    
    private class func loginVC() -> PALoginVC {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("loginVCStoryboard") as! PALoginVC
    }
    
    private class func feedVC() -> PAFeedVC {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("feedVCStoryboard") as! PAFeedVC
    }
}
