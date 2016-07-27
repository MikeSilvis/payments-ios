//
//  PAPaymentNC.swift
//  Payments
//
//  Created by Mike Silvis on 7/26/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit

class PAPaymentNC: UINavigationController {
    
    private var event : PAEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let vc = viewControllers.first as? PAPaymentVC {
            vc.event = event
        }
    }

    class func instance(event : PAEvent) -> PAPaymentNC {
        let vc = UIStoryboard(name: "Payment", bundle: nil).instantiateInitialViewController() as! PAPaymentNC
        vc.event = event
        
        return vc
    }
}
