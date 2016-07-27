//
//  PAPaymentVC.swift
//  Payments
//
//  Created by Mike Silvis on 7/26/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit

class PAPaymentVC: UIViewController {
    
    @IBOutlet private weak var amountLabel: UILabel? {
        didSet {
            amountLabel?.text = event?.dollarAmount()
        }
    }
    @IBOutlet private weak var descriptionLabel: UILabel? {
        didSet {
            descriptionLabel?.text = event?.description
        }
    }
    
    var event : PAEvent? {
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
