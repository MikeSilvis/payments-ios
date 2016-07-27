//
//  PARequestConfirmVC.swift
//  Payments
//
//  Created by Mike Silvis on 7/26/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit

class PARequestConfirmVC: UIViewController {
    @IBOutlet private weak var backgroundImageView: UIImageView? {
        didSet {
            backgroundImageView?.image = image
        }
    }

    @IBOutlet private weak var amountLabel: UITextField?

    var image : UIImage? {
        didSet {
            backgroundImageView?.image = image
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        amountLabel?.becomeFirstResponder()
    }

    @IBAction private func didTapConfirm(sender: AnyObject) {
        guard let amount = amountLabel?.text, let intAmount = Int(amount) else { return }

        let event = PAEvent(photo: image!, amount_cents: intAmount)

        event.create { [weak self] (success) in
            self?.view.endEditing(true)

            self?.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
