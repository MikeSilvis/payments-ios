//
//  PAFeedVC.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit

class PAFeedVC: UIViewController {
    private weak var feedTVC : PAFeedHistoryTVC?

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}
