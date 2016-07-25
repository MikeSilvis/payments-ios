//
//  PAHistoryCell.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit

class PAHistoryCell: UITableViewCell {
    @IBOutlet private weak var amountLabel: UILabel?
    @IBOutlet private weak var descriptionLabel: UILabel?
    @IBOutlet private weak var avatarStackView: UIStackView? {
        didSet {
            avatarStackView?.transform = CGAffineTransformMakeScale(-1, 1)
        }
    }
    
    var event : PAEvent? {
        didSet {
            guard let event = event else { return }
            
            amountLabel?.text = "$\(event.amount)"
            descriptionLabel?.text = event.description
            amountLabel?.textColor = event.state.color()
            
            for view in (avatarStackView?.subviews ?? []) {
                view.removeFromSuperview()
            }
            
            for avatar in event.avatars {
                PAHttpRequest.fetchImage(avatar, completion: { [weak self] (success, image) in
                    let kDefaultImageSize : CGFloat = 32
                    
                    let image = UIImageView(image: image)
                    image.clipsToBounds = true
                    image.contentMode = .ScaleAspectFill
                    image.cornerRadius = kDefaultImageSize / 2
                    image.borderColor = UIColor.lightGrayColor()
                    image.borderWidth = 0.5
                    image.frame = CGRect(x: 0, y: 0, width: kDefaultImageSize, height: kDefaultImageSize)
                    
                    let snapShotImageView = UIImageView(image: image.snapshot())
                    snapShotImageView.shadowOpacity = 0.4
                    snapShotImageView.shadowColor = .blackColor()
                    snapShotImageView.shadowOffset = CGSize(width: 1, height: 1)
                    snapShotImageView.shadowRadius = 1
                    
                    
                    snapShotImageView.mas_remakeConstraints({ (make) in
                        make.height.mas_equalTo()(kDefaultImageSize)
                        make.width.mas_equalTo()(kDefaultImageSize)
                    })
                    
                    self?.avatarStackView?.addArrangedSubview(snapShotImageView)
                    
                })
            }
        }
    }

}
