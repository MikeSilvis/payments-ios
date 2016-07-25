//
//  PAAvatarView.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit

class PAAvatarView: PADesignableControl {
    @IBOutlet weak var imageView: UIImageView?
    
    var friend : PAFriend? {
        didSet {
        }
    }
    
    override func nibName() -> String {
        return "PAAvatarView"
    }
}
