//
//  PADesignableControl.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit

class PADesignableControl : UIView {

    internal var view : UIView!

    private func xibSetup() {
        bounds = defaultBounds()
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName(), bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    internal func nibName() -> String {
        assert(false, "you need to override this please!")
        return ":(" // gonna crash now...
    }

    internal func defaultBounds() -> CGRect {
        return bounds
    }

    init() {
        super.init(frame: CGRectZero)
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        if subviews.count == 0 {
            xibSetup()
        }
    }
}