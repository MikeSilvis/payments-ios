//
//  PAEventRequestCell.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit

class PAEventRequestCell: UICollectionViewCell {
    @IBOutlet private weak var descriptionLabel: UILabel?
    @IBOutlet private weak var amountLabel: UILabel!

    var event : PAEvent? {
        didSet {
            amountLabel?.text = event?.dollarAmount()
            descriptionLabel?.text = event?.description
        }
    }
    
}
