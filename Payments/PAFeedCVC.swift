//
//  PAFeedCVC.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit

class PAFeedCVC: UICollectionViewController {
    private static let reuseIdentifier = "pendingRequestsCell"
    private var events : [PAEvent] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        PAUser.currentUser.findEvents { [weak self] (success, events) in
            self?.events = events
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PAFeedCVC.reuseIdentifier, forIndexPath: indexPath) as! PAEventRequestCell
        cell.event = events[indexPath.row]
    
        return cell
    }

}
