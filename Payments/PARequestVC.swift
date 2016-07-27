//
//  FirstViewController.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit
import CameraManager

class PARequestVC: UIViewController {
    @IBOutlet private weak var flashButton: UIButton? {
        didSet {
            flashButton?.setTitle("Flash: \(cameraManager.flashMode.str())", forState: .Normal)
        }
    }
    @IBOutlet private weak var cameraView: UIView?
    @IBOutlet private weak var cameraButton: UIButton?
    @IBOutlet private weak var blurView: UIVisualEffectView? {
        didSet {
            blurView?.layer.masksToBounds = false
            blurView?.layer.shadowRadius = 5
            blurView?.layer.shadowOffset = CGSizeZero
            blurView?.layer.shadowPath = UIBezierPath(rect: blurView!.bounds).CGPath
            blurView?.clipsToBounds = false
            blurView?.layer.shadowOpacity = 0.7
        }
    }
    
    private let cameraManager : CameraManager = {
        let manager = CameraManager()
        manager.cameraDevice = .Back
        manager.cameraOutputMode = .StillImage
        manager.cameraOutputQuality = .Medium
        manager.flashMode = .Auto
        manager.writeFilesToPhoneLibrary = false
        
        return manager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        cameraManager.addPreviewLayerToView(cameraView!)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    //
    // MARK: Actions
    //
    
    @IBAction private func didTapDone(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction private func didTapReverse(sender: AnyObject) {
        cameraManager.cameraDevice = cameraManager.cameraDevice == .Front ? .Back : .Front

    }
    
    @IBAction private func didTapFlash(sender: AnyObject) {
        cameraManager.changeFlashMode()
        
        flashButton?.setTitle("Flash: \(cameraManager.flashMode.str())", forState: .Normal)
    }

    @IBAction private func didTapSnap(sender: AnyObject) {
        cameraManager.capturePictureWithCompletion({ [weak self] (image, error) -> Void in
            self?.performSegueWithIdentifier("confirmSegue", sender: image)
        })
    }

    //
    // MARK: Helpers
    //

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)

        if let destVC = segue.destinationViewController as? PARequestConfirmVC, let image = sender as? UIImage {
            destVC.image = image
        }
    }
}

extension CameraFlashMode {
    func str() -> String {
        switch self {
        case .On:
            return "On"
        case .Auto:
            return "Auto"
        case .Off:
            return "Off"
        }
    }
}

