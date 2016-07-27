//
//  PACameraManager.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit
import AVFoundation

protocol PACameraManagerDelegate : class {
    func cameraSessionConfigurationDidComplete()
    func cameraSessionDidBegin()
    func cameraSessionDidStop()
}

class PACameraManager: NSObject {

    weak var delegate: PACameraManagerDelegate?

    var session: AVCaptureSession!
    var sessionQueue: dispatch_queue_t!
    var stillImageOutput: AVCaptureStillImageOutput?

    init(delegate: PACameraManagerDelegate) {
        super.init()
        
        self.delegate = delegate

        setObservers()
        initializeSession()
    }

    deinit {
        removeObservers()
    }

    // MARK: Session

    private func initializeSession() {
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetHigh
        sessionQueue = dispatch_queue_create("camera session", DISPATCH_QUEUE_SERIAL)

        dispatch_async(sessionQueue) { [weak self] () -> Void in
            self?.session.beginConfiguration()
            self?.addVideoInput()
            self?.addStillImageOutput()
            self?.session.commitConfiguration()

            dispatch_async(dispatch_get_main_queue(), { [weak self] () -> Void in
                self?.delegate?.cameraSessionConfigurationDidComplete()
            })
        }
    }

    func startCamera() {
        dispatch_async(sessionQueue) { [weak self] () -> Void in
            self?.session.startRunning()
        }
    }

    func stopCamera() {
        dispatch_async(sessionQueue) { [weak self] () -> Void in
            self?.session.stopRunning()
        }
    }

    func captureStillImage(completed: (image: UIImage?) -> Void) {
        if let imageOutput = stillImageOutput {
            dispatch_async(sessionQueue, { () -> Void in

                var videoConnection: AVCaptureConnection?
                for connection in imageOutput.connections {
                    let c = connection as! AVCaptureConnection

                    for port in c.inputPorts {
                        let p = port as! AVCaptureInputPort
                        if p.mediaType == AVMediaTypeVideo {
                            videoConnection = c;
                            break
                        }
                    }

                    if videoConnection != nil {
                        break
                    }
                }

                if videoConnection != nil {
                    imageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (imageSampleBuffer: CMSampleBufferRef?, error) -> Void in
                        if let imageSampleBuffer = imageSampleBuffer {
                            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer)
                            let image: UIImage? = UIImage(data: imageData!)!

                            dispatch_async(dispatch_get_main_queue()) {
                                completed(image: image)
                            }
                        }
                        else {
                            dispatch_async(dispatch_get_main_queue()) {
                                completed(image: nil)
                            }
                        }
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        completed(image: nil)
                    }
                }
            })
        }
        else {
            completed(image: nil)
        }
    }

    // MARK: Configuration

    private func addVideoInput() {
        let device : AVCaptureDevice = deviceWithMediaTypeWithPosition(AVMediaTypeVideo, position: AVCaptureDevicePosition.Back)
        do {
            let input = try AVCaptureDeviceInput(device: device)
            try device.lockForConfiguration()

            if device.isFlashModeSupported(.Auto) {
                device.flashMode = .Auto
            }

            if session.canAddInput(input) {
                session.addInput(input)
            }
        }
        catch {
            print(error)
        }
    }

    private func addStillImageOutput() {
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]

        if self.session.canAddOutput(stillImageOutput) {
            session.addOutput(stillImageOutput)
        }
    }

    private func deviceWithMediaTypeWithPosition(mediaType: NSString, position: AVCaptureDevicePosition) -> AVCaptureDevice {
        let devices: NSArray = AVCaptureDevice.devicesWithMediaType(mediaType as String)
        var captureDevice: AVCaptureDevice = devices.firstObject as! AVCaptureDevice
        for device in devices {
            let d = device as! AVCaptureDevice
            if d.position == position {
                captureDevice = d
                break;
            }
        }
        return captureDevice
    }

    // MARK: Observers

    private func setObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PACameraManager.sessionDidStart(_:)), name: AVCaptureSessionDidStartRunningNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PACameraManager.sessionDidStop(_:)), name: AVCaptureSessionDidStopRunningNotification, object: nil)
    }

    private func removeObservers() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func sessionDidStart(notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue()) { [weak self] () -> Void in
            self?.delegate?.cameraSessionDidBegin()
        }
    }

    func sessionDidStop(notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue()) { [weak self] () -> Void in
            self?.delegate?.cameraSessionDidStop()
        }
    }

}
