//
//  PAAvatarView.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit

class PAAvatarView: PADesignableControl {
    @IBOutlet private weak var avatarImageView: UIImageView?
    
    var person : PAFriend? {
        didSet {
            avatarImageView?.sd_setImageWithURL(person?.photoURL)
        }
    }
    
    override func nibName() -> String {
        return "PAAvatarView"
    }
}
