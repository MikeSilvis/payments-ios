//
//  PAHistoryCell.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit

enum PAHistoryCellState : Int {
    case Sent
    case Received
    
    func color() -> UIColor {
        switch self {
        case .Sent:
            return .redColor()
        case .Received:
            return .greenColor()
        }
    }
}

struct PAHistory {
    var description : String
    var amount      : String
    var state       : PAHistoryCellState
    var friends     : [PAFriend]
}

struct PAFriend {
    var name           : String
    var profilePicture : NSURL
}

class PAHistoryCell: UITableViewCell {
    @IBOutlet private weak var amountLabel: UILabel?
    @IBOutlet private weak var descriptionLabel: UILabel?
    @IBOutlet private weak var avatarStackView: UIStackView? {
        didSet {
            avatarStackView?.transform = CGAffineTransformMakeScale(-1, 1)
        }
    }
    
    var history : PAHistory? {
        didSet {
            guard let history = history else { return }
            
            amountLabel?.text = "$\(history.amount)"
            descriptionLabel?.text = history.description
            amountLabel?.textColor = history.state.color()
            
            // TODO : Listen to people
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
