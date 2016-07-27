//
//  FirstViewController.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit
import AVFoundation

private enum PARequestVCMode : Int {
    case Snap
    case Request

    func cameraEnabled() -> Bool{
        switch self {
        case .Snap:
            return true
        case .Request:
            return false
        }
    }
}

class PARequestVC: UIViewController {
    @IBOutlet private weak var cameraView: UIView?
    @IBOutlet private weak var cameraButton: UIButton?

    private var camera : PACameraManager?
    private var preview : AVCaptureVideoPreviewLayer?
    
    private var mode : PARequestVCMode = .Snap {
        didSet {
            cameraButton?.enabled = mode.cameraEnabled()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeCamera()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        camera?.stopCamera()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        camera?.startCamera()
    }

    private func initializeCamera() {
        camera = PACameraManager(delegate: self)
        establishVideoPreviewArea()
    }

    private func establishVideoPreviewArea() {
        preview = AVCaptureVideoPreviewLayer(session: camera?.session)
        preview?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        for subLayer in (cameraView?.layer.sublayers ?? []) {
            subLayer.removeFromSuperlayer()
        }

        cameraView?.layer.addSublayer(preview!)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        preview?.frame = view.bounds
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

    }

    @IBAction private func didTapSnap(sender: AnyObject) {
        mode = .Request

        camera?.captureStillImage({ [weak self] (image) in
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

extension PARequestVC : PACameraManagerDelegate {
    func cameraSessionConfigurationDidComplete() {
        camera?.startCamera()
    }

    func cameraSessionDidBegin() {

    }

    func cameraSessionDidStop() {

    }
}

