//
//  CameraViewController.swift
//  PictureApp
//
//  Created by Apple on 6/26/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import AVFoundation


class CameraViewController: UIViewController ,AVCapturePhotoCaptureDelegate,UIGestureRecognizerDelegate {
    
//    @IBOutlet weak var previewCamera: UIView!
    @IBOutlet weak var captureBtn: UIButton!
    @IBOutlet var backBtn: UIBarButtonItem!
    @IBOutlet weak var gridView: GridView!
    
    @IBOutlet weak var previewCamera: UIImageView!
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    var img = [UIImage]()
    
    let minimumZoom: CGFloat = 1.0
    let maximumZoom: CGFloat = 3.0
    var lastZoomFactor: CGFloat = 1.0
    var homeViewController = HomeViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(self.getCaptureResolution())
        
        let a = self.navigationController?.viewControllers[0] as! HomeViewController
        homeViewController = a
        self.navigationItem.leftBarButtonItem = self.backBtn
        self.gridView.isHidden = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        
        self.captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            
            stillImageOutput = AVCapturePhotoOutput()
            
            stillImageOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
                
            }
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewCamera.bounds
            }
            
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    
    private func getCaptureResolution() -> CGSize {
        
        var resolution = CGSize(width: 0, height: 0)
         let device = AVCaptureDevice.default(for: AVMediaType.video)
        
        
   
        if let formatDescription = device?.activeFormat.formatDescription {
            let dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription)
            resolution = CGSize(width: CGFloat(dimensions.width), height: CGFloat(dimensions.height))

                resolution = CGSize(width: resolution.height, height: resolution.width)

        }
        
        return resolution
    }
    
    func configureCameraForHighestFrameRate(device: AVCaptureDevice) {
        
        var bestFormat: AVCaptureDevice.Format?
        var bestFrameRateRange: AVFrameRateRange?
        
        for format in device.formats {
            for range in format.videoSupportedFrameRateRanges {
                if range.maxFrameRate > bestFrameRateRange?.maxFrameRate ?? 0 {
                    bestFormat = format
                    bestFrameRateRange = range
                }
            }
        }
        
        if let bestFormat = bestFormat,
            let bestFrameRateRange = bestFrameRateRange {
            do {
                try device.lockForConfiguration()
                
                // Set the device's active format.
                device.activeFormat = bestFormat
                
                // Set the device's min/max frame duration.
                let duration = bestFrameRateRange.minFrameDuration
                device.activeVideoMinFrameDuration = duration
                device.activeVideoMaxFrameDuration = duration
                
                device.unlockForConfiguration()
            } catch {
                // Handle error.
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let screenSize = self.previewCamera.bounds.size
        if let touchPoint = touches.first {
            let x = touchPoint.location(in: self.previewCamera).y / screenSize.height
            let y = 1.0 - touchPoint.location(in: self.previewCamera).x / screenSize.width
            let focusPoint = CGPoint(x: x, y: y)
            
            guard let device = AVCaptureDevice.default(for: AVMediaType.video)
                else {
                    print("Unable to access back camera!")
                    return
            }
            
            
                do {
                    try device.lockForConfiguration()
                    
                    device.focusPointOfInterest = focusPoint
                    //device.focusMode = .ContinuousAutoFocus
                    device.focusMode = .autoFocus
                    //device.focusMode = .Locked
                    device.exposurePointOfInterest = focusPoint
                    device.exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure
                    device.unlockForConfiguration()
                }
                catch {
                    // just ignore
                }
            
        }

    }
    
    @IBAction func pinchToZoom(_ sender: UIPinchGestureRecognizer) {

        guard let device = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
        
        func minMaxZoom(_ factor: CGFloat) -> CGFloat {
            return min(min(max(factor, minimumZoom), maximumZoom), device.activeFormat.videoMaxZoomFactor)
        }
        
        func update(scale factor: CGFloat) {
            do {
                try device.lockForConfiguration()
                defer { device.unlockForConfiguration() }
                device.videoZoomFactor = factor
            } catch {
                print("\(error.localizedDescription)")
            }
        }
        
        let newScaleFactor = minMaxZoom(sender.scale * lastZoomFactor)
        
        switch sender.state {
        case .began: fallthrough
        case .changed: update(scale: newScaleFactor)
        case .ended:
            lastZoomFactor = minMaxZoom(newScaleFactor)
            update(scale: lastZoomFactor)
        default: break
        }
    }
    
    
    
    func setupLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resize
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewCamera.layer.addSublayer(videoPreviewLayer)
        
    }
    
    
    @IBAction func captureImage(_ sender: Any) {
        
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        
        let image = UIImage(data: imageData)
        self.img.append(image!)
        
        
        if homeViewController.pictures.count < 12{
            
//            for im in img {
                homeViewController.pictures.append(image!)
//            }
            
        }else{
            self.navigationController?.popToViewController(homeViewController, animated: true)
//            self.navigationController!.popToRootViewController(animated: true)
        }
        
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
//        let a = self.navigationController?.viewControllers[0] as! HomeViewController
//        for im in img {
//            a.pictures.append(im)
//        }
        
        self.navigationController!.popToRootViewController(animated: true)
        
    }
    
    
    @IBAction func flashBtn(_ sender: Any) {
        
        guard let device = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
        
        
        do {
            try device.lockForConfiguration()
            if device.torchMode == .on{
                device.torchMode = .off
            }else{
                device.torchMode = .on
            }
            
            device.unlockForConfiguration()
        }
        catch {
            // just ignore
        }
    }
    
    
    @IBAction func grid(_ sender: Any) {
        
        if self.gridView.isHidden{
            self.gridView.isHidden = false
        }else{
            self.gridView.isHidden = true
        }
        
    }
    
    
}

