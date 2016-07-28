//
//  PAFeedVC.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit
import Stripe

protocol PAFeedVCDelegate : class {
    func requestPayment(event : PAEvent)
}

class PAFeedVC: UIViewController, STPPaymentContextDelegate {
    private weak var feedTVC : PAFeedHistoryTVC? {
        didSet {
            feedTVC?.delegate = self
        }
    }

    private lazy var paymentContext : STPPaymentContext = {
        return STPPaymentContext(APIAdapter: StripeAPIClient.sharedClient,
                              configuration: STPPaymentConfiguration.sharedConfiguration(),
                                      theme: STPTheme.defaultTheme()
        )
    }()
    
    private lazy var userInfo : STPUserInformation = {
        let info = STPUserInformation()
        info.email = PAUser.currentUser.email
        
        return info
    }()

    @IBOutlet private weak var ccBarButton: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        paymentContext.delegate = self
        paymentContext.hostViewController = self
        paymentContext.prefilledInformation = userInfo
        
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        PAUser.currentUser.refresh { [weak self] (success) in
            // Don't really care for now
            self?.ccBarButton?.title = PAUser.currentUser.balanceDollarAmount()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        PAEvent.findEvents { [weak self] (success, pendingEvents, pastEvents) in
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
        paymentContext.presentPaymentMethodsViewController()
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

extension PAFeedVC : PAFeedVCDelegate {
    func requestPayment(event: PAEvent) {
        presentViewController(PAPaymentNC.instance(event), animated: true, completion: nil)
    }
}

