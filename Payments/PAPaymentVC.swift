//
//  PAPaymentVC.swift
//  Payments
//
//  Created by Mike Silvis on 7/26/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit

class PAPaymentVC: UIViewController {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var event : PAEvent? {
        didSet {
            amountLabel?.text = event?.dollarAmount()
            descriptionLabel?.text = event?.description
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func didTapCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction private func didTapPay(sender: AnyObject) {
    }
}
