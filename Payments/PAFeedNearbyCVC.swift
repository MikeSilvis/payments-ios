//
//  PAFeedCVC.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit

class PAFeedNearbyCVC: UICollectionViewController {
    private static let reuseIdentifier = "pendingRequestsCell"
    
    var events : [PAEvent] = [] {
        didSet {
            collectionView?.reloadData()
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PAFeedNearbyCVC.reuseIdentifier, forIndexPath: indexPath) as! PAEventRequestCell
        cell.event = events[indexPath.row]
    
        return cell
    }

}
