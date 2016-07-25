//
//  PARootTabBarVC.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit

class PARootTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedIndex = 1
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        addAlert()
    }
    
    private func addAlert() {
        let controller = UIAlertController(title: "Money Request", message: "Fahim Ferdous is requesting $23 for Tequilla", preferredStyle: .Alert)
        let acceptAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default) { (action) in
            // TODO
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) in
            // TODO
        }
        
        controller.addAction(acceptAction)
        controller.addAction(cancelAction)
        presentViewController(controller, animated: true, completion: nil)
    }

}
