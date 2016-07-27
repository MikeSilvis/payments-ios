//
//  PAFeedVC.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit
import Stripe

class PAFeedVC: UIViewController, STPPaymentContextDelegate {
    private weak var feedTVC : PAFeedHistoryTVC?

    var paymentContext : STPPaymentContext?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.paymentContext = STPPaymentContext(APIAdapter: StripeAPIClient.sharedClient,
                                               configuration: STPPaymentConfiguration.sharedConfiguration(),
                                               theme: STPTheme.defaultTheme())
        paymentContext?.delegate = self
        paymentContext?.hostViewController = self
        let userInfo = STPUserInformation()
        //userInfo.email = PAUser.currentUser.email
        paymentContext?.prefilledInformation = userInfo
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        PAUser.currentUser.findEvents { [weak self] (success, pendingEvents, pastEvents) in
            self?.feedTVC?.pendingEvents = pendingEvents
            self?.feedTVC?.pastEvents = pastEvents
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if let destVC = segue.destinationViewController as? PAFeedHistoryTVC {
            feedTVC = destVC
        }
  }

    @IBAction func didTapAddCC(sender: AnyObject) {
        self.paymentContext?.presentPaymentMethodsViewController()
    }


    func paymentContext(paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: STPErrorBlock) {

    }

    func paymentContext(paymentContext: STPPaymentContext, didFinishWithStatus status: STPPaymentStatus, error: NSError?) {

    }

    func paymentContextDidChange(paymentContext: STPPaymentContext) {

    }

    func paymentContext(paymentContext: STPPaymentContext, didFailToLoadWithError error: NSError) {
    }
}
