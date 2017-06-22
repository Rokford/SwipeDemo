//
//  CameraManager.swift
//  SwipeDemoSwift
//
//  Created by T556038 on 22/06/17.
//  Copyright © 2017 UBS. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class CameraPreview {
    let captureSession = AVCaptureSession()
    let view: UIView
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice: AVCaptureDevice?
    
    init(view: UIView) {
        self.view = view
    }
    
    // call this in viewDidAppear
    func setup() {
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        if let devices = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .front).devices {
            for device in devices {
                if (device.hasMediaType(AVMediaTypeVideo)) {
                    if(device.position == AVCaptureDevicePosition.front) {
                        captureDevice = device
                        if captureDevice != nil {
                            beginSession()
                        }
                    }
                }
            }
        }
    }
    
    private func beginSession() {
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        guard let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) else {
            print("No preview layer")
            return
        }
        
        previewLayer.frame.size = view.frame.size
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
}
