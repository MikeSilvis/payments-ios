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
    
    var person : PAFriend? {
        didSet {
            print("coming here with: \(imageView) and \(person?.photoURL)")
            
//            imageView?.sd_setImageWithURL(person?.photoURL)
            imageView?.image = UIImage(named: "second")
        }
    }
    
    override func nibName() -> String {
        return "PAAvatarView"
    }
}
