//
//  FirstViewController.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit

class PARequestVC: UIViewController {
    @IBOutlet private weak var dollarAmountLabel: UITextField!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction private func didTapRequest(sender: AnyObject) {
        guard let dollarAmount = dollarAmountLabel?.text, let text = descriptionTextView?.text else { return }
        
        let event = PAEvent(description: text, amount_cents: NSNumber(int: Int32(dollarAmount)!), avatars: [], state: .Sent)
        
        PAUser.currentUser.createEvent(event) { (success) in
            
        }
    }
    
}

