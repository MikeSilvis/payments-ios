//
//  PAHistoryTVC.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit

class PAHistoryTVC: UITableViewController {
    var events : [PAEvent] = [] {
        didSet {
            dispatch_async(dispatch_get_main_queue()) { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        PAUser.currentUser.findEvents { [weak self] (success, events) in
            self?.events = events
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath) as! PAHistoryCell
        cell.event = events[indexPath.row]

        return cell
    }

}
