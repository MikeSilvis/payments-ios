//
//  PACreditCardsVC.swift
//  Payments
//
//  Created by Fahim Ferdous on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit
import Stripe

class PACreditCardsVC: UIViewController {

    let paymentContext = STPPaymentContext()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        paymentContext.hostViewController = self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
    }

}
