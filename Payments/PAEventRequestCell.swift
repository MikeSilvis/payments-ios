//
//  PAEventRequestCell.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit

class PAEventRequestCell: UICollectionViewCell {
    @IBOutlet private weak var overlayView: UIView?
    @IBOutlet private weak var amountLabel: UILabel?
    @IBOutlet private weak var eventImageView: UIImageView?
    @IBOutlet private weak var requesterAvatarView: PAAvatarView!

    var event : PAEvent? {
        didSet {
            amountLabel?.text = event?.dollarAmount()
            eventImageView?.sd_setImageWithURL(event?.photoURL)
        }
    }
    
}
