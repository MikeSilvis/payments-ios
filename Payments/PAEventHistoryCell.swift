//
//  PAHistoryCell.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit
import SDWebImage

class PAEventHistoryCell: UITableViewCell {
    @IBOutlet private weak var descriptionImageView: UIImageView!
    @IBOutlet private weak var amountLabel: UILabel?
    @IBOutlet private weak var avatarStackView: UIStackView? {
        didSet {
            avatarStackView?.transform = CGAffineTransformMakeScale(-1, 1)
        }
    }
    
    var event : PAEvent? {
        didSet {
            guard let event = event else { return }
            
            amountLabel?.text = event.dollarAmount()
            amountLabel?.textColor = event.state.color()
            descriptionImageView?.sd_setImageWithURL(event.photoURL)
            
            for view in (avatarStackView?.subviews ?? []) {
                view.removeFromSuperview()
            }
            
            for member in (event.members ?? []) {
                let avatarView = PAAvatarView()
                avatarView.person = member
                
                avatarView.snp_makeConstraints(closure: { (make) in
                    make.width.equalTo(32)
                    make.height.equalTo(32)
                })
                
                avatarStackView?.addArrangedSubview(avatarView)
            }
        }
    }

}
