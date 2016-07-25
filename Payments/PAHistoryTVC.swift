//
//  PAHistoryTVC.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit

class PAHistoryTVC: UITableViewController {

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histories().count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath) as! PAHistoryCell
        cell.history = histories()[indexPath.row]

        return cell
    }
    
    private func histories() -> [PAHistory] {
        return [
            PAHistory(description: "for all the Tequilla", amount: "23", state: .Received, friends: []),
            PAHistory(description: "for all the booz", amount: "123", state: .Sent, friends: [])
        ]
    }

}
