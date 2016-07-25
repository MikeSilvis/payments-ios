//
//  extension-UIView.swift
//  Gametime
//
//  Created by Matt Banach on 11/25/15.
//
//

import Foundation

extension UIView {
        
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(CGColor: (layer.borderColor ?? UIColor.clearColor().CGColor))
        }
        set {
            layer.borderColor = newValue.CGColor
        }
    }

    @IBInspectable var shadowColor: UIColor {
        get {
            return UIColor(CGColor: (layer.shadowColor ?? UIColor.clearColor().CGColor))
        }
        set {
            layer.shadowColor = newValue.CGColor
        }
    }

    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    func fadeIn() {
        fadeTo(1.0, withDuration: 0.2)
    }
    
    func fadeOut() {
        fadeOut(nil)
    }

    func fadeOut(completion: ((Bool) -> Void)?) {
        fadeTo(0.0, withDuration: 0.2, completion: completion)
    }
    
    func fadeTo(alpha : CGFloat = 1.0, withDuration duration: Double = 0.2) {
        fadeTo(alpha, withDuration: duration, completion: nil)
    }

    func fadeTo(alpha : CGFloat = 1.0, withDuration duration: Double = 0.2, completion completionBlock: ((Bool) -> Void)? ) {
        UIView.animateWithDuration(duration, animations:{ [weak self] () -> Void in
            self?.alpha = alpha
        }, completion:completionBlock)
    }

    func shakeItOff() {
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(self.center.x - 5, self.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(self.center.x + 5, self.center.y))
        self.layer.addAnimation(animation, forKey: "position")
    }

    func rubberBand() {

        // todo: more rubber-y
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(self.center.x - 5, self.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(self.center.x + 5, self.center.y))
        self.layer.addAnimation(animation, forKey: "position")
    }
    
    func bounce() {
        bounceDown()
        bounceUp()
    }
    
    func bounceDown() {
        transform = CGAffineTransformMakeScale(0.975, 0.975)
    }
    
    func bounceUp() {
        UIView.animateWithDuration(0.15) { [weak self] () -> Void in
            self?.transform = CGAffineTransformIdentity
        }
    }
    
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
        drawViewHierarchyInRect(bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }

    // http://stackoverflow.com/questions/9700093/corner-radius-for-a-navigation-bar
    func roundCorner(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSizeMake(radius, radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    }
}
