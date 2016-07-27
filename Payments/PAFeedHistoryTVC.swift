//
//  PAHistoryTVC.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit

class PAFeedHistoryTVC: UITableViewController {
    private var nearbyCVC : PAFeedNearbyCVC? {
        didSet {
            nearbyCVC?.delegate = delegate
        }
    }
    weak var delegate : PAFeedVCDelegate? {
        didSet {
            nearbyCVC?.delegate = delegate
        }
    }
    
    var pendingEvents : [PAEvent] = [] {
        didSet {
            nearbyCVC?.events = pendingEvents
        }
    }
    
    var pastEvents : [PAEvent] = [] {
        didSet {
            dispatch_async(dispatch_get_main_queue()) { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastEvents.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath) as! PAHistoryCell
        cell.event = pastEvents[indexPath.row]

        return cell
    }
    
    //
    // MARK: Helpers
    //
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if let destVC = segue.destinationViewController as? PAFeedNearbyCVC {
            nearbyCVC = destVC
        }
    }

}
