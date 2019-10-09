//
//  CameraViewController.swift
//  SnapToSell
//
//  Created by Apple on 8/24/19.
//  Copyright © 2019 Apple. All rights reserved.
//


import UIKit
import AVFoundation
import AssetsLibrary
import ImageIO
import CoreImage
import Photos
import MobileCoreServices


class CameraViewController: UIViewController ,AVCapturePhotoCaptureDelegate,UIGestureRecognizerDelegate  {
    
    //    @IBOutlet weak var previewCamera: UIView!
    @IBOutlet weak var captureBtn: UIButton!
    @IBOutlet var backBtn: UIBarButtonItem!
    @IBOutlet weak var gridView: GridView!
    
    @IBOutlet weak var previewCamera: UIImageView!
    
    @IBOutlet weak var photoImg: UIImageView!
    
    //    @IBOutlet weak var photoBtn: UIButton!
    
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    var img = [UIImage]()
    
    let minimumZoom: CGFloat = 1.0
    let maximumZoom: CGFloat = 3.0
    var lastZoomFactor: CGFloat = 1.0
    var productDetailViewController = ProductDetailViewController()
    var pendingProductDetailViewController = PendingProductDetailViewController()
    
    var contactDetailsViewController = ContactDetailsViewController()
    var uploadViewController = UploadViewController()
    
//    var dekitiewController = De_KittingViewController()
    var orientationValue = 1
    var orientaionArray = [Int]()
    var type = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        print(self.getCaptureResolution())
        self.photoImg.isHidden = true
        self.captureBtn.setGradient()
        self.backBtn()
        self.tabBarController?.tabBar.isHidden = true
//        self.captureBtn.setFont(size: 19)
        if self.type == "pending"{
            let a = self.navigationController?.viewControllers[1] as! PendingProductDetailViewController
            pendingProductDetailViewController = a
            
        }else if self.type == "recycle"{
            let a = self.navigationController?.viewControllers[2] as! ContactDetailsViewController
            contactDetailsViewController = a
            
        }else if self.type == "repair"{
            let a = self.navigationController?.viewControllers[2] as! UploadViewController
            uploadViewController = a
            
        }else{
            let a = self.navigationController?.viewControllers[2] as! ProductDetailViewController
            productDetailViewController = a
            
            
        }

       
        self.navigationItem.leftBarButtonItem = self.backBtn
        //        self.gridView.isHidden = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        
        self.captureSession.sessionPreset = AVCaptureSession.Preset.high
        
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
//        AppUtility.lockOrientation(.all)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCameraOrientation()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIApplication.shared.statusBarOrientation.isLandscape {
            // activate landscape changes
            self.orientationValue = 1
        } else {
            // activate portrait changes
            self.orientationValue = 0
        }
        setCameraOrientation()
    }
    
    @objc func setCameraOrientation() {
        if let connection =  self.videoPreviewLayer?.connection  {
            let currentDevice: UIDevice = UIDevice.current
            let orientation: UIDeviceOrientation = currentDevice.orientation
            let previewLayerConnection : AVCaptureConnection = connection
            if previewLayerConnection.isVideoOrientationSupported {
                let o: AVCaptureVideoOrientation
                switch (orientation) {
                case .portrait: o = .portrait
                case .landscapeRight: o = .landscapeLeft
                case .landscapeLeft: o = .landscapeRight
                case .portraitUpsideDown: o = .portraitUpsideDown
                default: o = .portrait
                }
                print(o)
                previewLayerConnection.videoOrientation = o
                videoPreviewLayer!.frame = self.view.bounds
            }
        }
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
//        settings.flashMode = .auto
        
        
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        //        photo.metadata = ["orientation" : "landscape"]
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        
        
        self.orientaionArray.append(self.orientationValue)
        
        var image = UIImage(data: imageData)
        
        image = image?.fixOrientation()
        image = image?.fixedOrientation()
        
        self.photoImg.isHidden = false
        self.photoImg.image = image
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            
            self.photoImg.isHidden = true
            
        }
        
        if type == "pending"{
            pendingProductDetailViewController.images.append(image!)
        }else if type == "recycle" {
            contactDetailsViewController.images.append(image!)
            if self.contactDetailsViewController.images.count >= 10{
                self.navigationController?.popViewController(animated: true)
            }
            
        }else if type == "repair" {
            uploadViewController.images.append(image!)
            if self.uploadViewController.images.count >= 10{
                self.navigationController?.popViewController(animated: true)
            }
            
        }else {
             productDetailViewController.images.append(image!)
            if self.productDetailViewController.images.count >= 20{
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveToPhotoAlbumWithMetadata(_ image: CGImage, filePath: String) {
        
        let cfPath = CFURLCreateWithFileSystemPath(nil, filePath as CFString, CFURLPathStyle.cfurlposixPathStyle, false)
        
        // You can change your exif type here.
        let destination = CGImageDestinationCreateWithURL(cfPath!, kUTTypeJPEG, 1, nil)
        
        // Place your metadata here.
        // Keep in mind that metadata follows a standard. You can not use custom property names here.
        let tiffProperties = [
            kCGImagePropertyTIFFMake as String: "Your camera vendor",
            kCGImagePropertyTIFFModel as String: "Your camera model"
            ] as CFDictionary
        
        let properties = [
            kCGImagePropertyExifDictionary as String: tiffProperties
            ] as CFDictionary
        
        CGImageDestinationAddImage(destination!, image, properties)
        CGImageDestinationFinalize(destination!)
        
        try? PHPhotoLibrary.shared().performChangesAndWait {
            PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: URL(fileURLWithPath: filePath))
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        
            self.navigationController?.popViewController(animated: true)
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
//                device.torchMode = .auto
                
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

