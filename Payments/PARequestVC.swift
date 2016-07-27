//
//  FirstViewController.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit
import AVFoundation

class PARequestVC: UIViewController {
    @IBOutlet private weak var cameraView: UIView?

    private var camera : PACameraManager?
    private var preview : AVCaptureVideoPreviewLayer?
    
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

    func snapPhoto(completion: (UIImage?) -> Void) {
        preview?.hidden = true

        camera?.captureStillImage({ (image) -> Void in
            completion(image)
        })
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    //
    // MARK: Actions
    //

    @IBAction private func didTapRequest(sender: AnyObject) {
//        guard let dollarAmount = dollarAmountLabel?.text, let text = descriptionTextView?.text else { return }
//
//        let event = PAEvent(description: text, amount_cents: NSNumber(int: Int32(dollarAmount)!), avatars: [], state: .Sent)
//
//        PAUser.currentUser.createEvent(event) { (success) in
//
//        }
    }
    
    @IBAction private func didTapDone(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction private func didTapReverse(sender: AnyObject) {

    }

    @IBAction private func didTapSnap(sender: AnyObject) {
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

