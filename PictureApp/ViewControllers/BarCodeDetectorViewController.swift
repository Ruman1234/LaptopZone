//
//  BarcodeViewController.swift
//  PictureApp
//
//  Created by Apple on 6/22/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Firebase
import AVFoundation
import FirebaseCore
import FirebaseFirestore


class BarCodeDetectorViewController : UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var imageView :UIImageView!
    
    @IBOutlet var backBtn: UIBarButtonItem!
    @IBOutlet weak var upc: UISwitch!
    @IBOutlet weak var range: UISwitch!
    @IBOutlet weak var coustomRange: UISwitch!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var bottomView: UIView!
    
    let session = AVCaptureSession()
    lazy var vision = Vision.vision()
    var barcodeDetector :VisionBarcodeDetector?
    
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    
    var barcodes = [String]()
    
    var barcodesTypes = String()
    
    var i = 0
    var j = 0
    
    var contactInfo = 0
    var upcBarcode = [String]()
    var type = String()
    var binBArcode = String()
    
    var player: AVAudioPlayer?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.nextBtn.isHidden = true
        self.navigationItem.leftBarButtonItem = backBtn
        startLiveVideo()
        self.barcodeDetector = vision.barcodeDetector()
        
        self.upc.set(width: 35, height: 17)
        self.range.set(width: 35, height: 17)
        self.coustomRange.set(width: 35, height: 17)
        
        
        let upc = UserDefaults.standard.bool(forKey: "upc")
        let range = UserDefaults.standard.bool(forKey: "range")
        let coustomRange = UserDefaults.standard.bool(forKey: "coustomRange")
        
        if type == "bin" || type == "MPN"{
            self.bottomView.isHidden = true
            self.bottomView.isUserInteractionEnabled = false
        }
        
        
        if upc {
            self.upc.isOn = true
            self.barcodesTypes = "upc"
        }
        if range{
            self.range.isOn = true
            self.barcodesTypes = "range"
        }
        if coustomRange {
            self.coustomRange.isOn = true
            self.nextBtn.isHidden = false
            self.barcodesTypes = "coustomRange"
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        if let barcodeDetector = self.barcodeDetector {
            
            let visionImage = VisionImage(buffer: sampleBuffer)
            
            barcodeDetector.detect(in: visionImage) { (barcodes, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                do{
                    for barcode in barcodes! {
                        print(barcode.rawValue!)
                       
                        let docRef =  self.db.collection("Barcodes").document(barcode.rawValue!)
                    
                        docRef.getDocument { (document, error) in
                            
                            
                            if self.type == "bin"{
                                let valueType = barcode.format.rawValue
                                
                                if barcode.rawValue?.character(at: 3) == "-"{
                                    if self.contactInfo == 0 {
                                        guard valueType == 1 else {
                                            self.showToast(message: "Scan Barcode First")
                                            return
                                        }
                                        self.playSound()
                                        self.binBArcode = barcode.rawValue!
                                        self.contactInfo = valueType
                                        
                                        let a = self.navigationController?.viewControllers[0] as! HomeViewController
                                        a.binBarcode = self.binBArcode
                                        self.navigationController!.popToRootViewController(animated: true)
                                        
                                        
                                        return
                                    }
                                }else{
                                    self.showToast(message: "This is not BIN")
                                    return
                                }
                                
                                
                            }else if self.type == "MPN"{
                                let valueType = barcode.format.rawValue
                                if self.contactInfo == 0 {
                                    guard valueType == 1 else {
                                        self.showToast(message: "Scan Barcode First")
                                        return
                                    }
                                    self.playSound()
                                    self.binBArcode = barcode.rawValue!
                                    self.contactInfo = valueType
                                    
                                    let a = self.navigationController?.viewControllers[0] as! HomeViewController
                                    a.MPNBarcode = self.binBArcode
                                    self.navigationController!.popToRootViewController(animated: true)
                                    
                                    
                                    return
                                }
                                
                            }else{
                                if Utilites.isInternetAvailable() && document!.exists{
                                    
                                    self.playSound()
                                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                                    
                                    print("Document data: \(String(describing: document!.data()))")
                                    
                                    let alert = UIAlertController(title: "Document Exist", message: "this Document Exist do you want to update it", preferredStyle: .alert)
                                    
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                        if let a = self.navigationController?.viewControllers[0] as? HomeViewController {
                                            a.documentUpdate = true
                                            a.documentUpdateDAta = document!.data()!
                                            self.navigationController!.popToRootViewController(animated: true)
                                            return
                                        }
                                        
                                    }))
                                    
                                    alert.addAction(UIAlertAction(title: "Cancle", style: .destructive, handler: { (action) in
                                        return
                                    }))
                                    
                                    self.present(alert, animated: true, completion: nil)
                                    
                                
                                    
                                    self.showToast(message: "Document Exist")

                                    return
                                
                                } else {
                                    
                                    let valueType = barcode.format.rawValue
                                    print(valueType)
                                    
                                    if self.type == "bin"{
                                        
                                    }else if self.type == "MPN"{
                                        
                                    }else{
                                        
                                        
                                        if self.contactInfo == 0 {
                                            guard valueType == 1 else {
                                                self.showToast(message: "Scan Barcode First")
                                                return
                                            }
                                            self.playSound()
                                            self.barcodes.append(barcode.rawValue!)
                                            self.contactInfo = valueType
                                            if self.range.isOn{
                                                self.i = Int(self.barcodes[0])!
                                            }
                                        }
                                        
                                        if self.barcodes.contains(barcode.rawValue!){
                                            self.showToast(message: "Barcode Scaned")
                                            self.playSound()
                                            return
                                        }
                                        
                                        if self.upc.isOn{
                                            if self.upcBarcode.count == 0{
                                                if self.upcBarcode.contains(barcode.rawValue!){
                                                    return
                                                }
                                                
                                                if valueType == 512 || valueType == 1024 {
                                                    self.upcBarcode.append(barcode.rawValue!)
                                                    
                                                    if self.coustomRange.isOn || self.range.isOn {
                                                        Constants.UPCBarcode = self.upcBarcode
                                                    }else{
                                                        self.playSound()
                                                        Constants.UPCBarcode = self.upcBarcode
                                                        Constants.barcodes = self.barcodes
                                                        if Constants.UPCBarcode.count < 2 {
                                                            let main = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
                                                            self.navigationController?.pushViewController(main, animated: true)
                                                        }else{
                                                            return
                                                        }
                                                        
                                                        return
                                                    }
                                                }else{
                                                    self.showToast(message: "This is not UPC")
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                        if self.range.isOn{
                                            
                                            
                                            guard valueType == 1 else {
                                                self.showToast(message: "Scan Barcode First")
                                                return
                                            }
                                            
                                            
                                            if self.i == 0 {
                                                self.playSound()
                                                self.showToast(message: "first barcode scaned")
                                                self.i = Int(barcode.rawValue!)!
                                                print(self.i)
                                            }else{
                                                if self.j == 0  && self.j != self.i{
                                                    self.playSound()
                                                    self.j = Int(barcode.rawValue!)!
                                                    if self.i < self.j{
                                                        for bar in self.i...self.j{
                                                            if self.barcodes.contains("\(bar)"){
                                                                
                                                            }else{
                                                                self.barcodes.append("\(bar)")
                                                            }
                                                        }
                                                        Constants.barcodes = self.barcodes
                                                        let main = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
                                                        self.navigationController?.pushViewController(main, animated: true)
                                                        return
                                                    }
                                                   
                                                    return
                                                }else {
                                                    return
                                                }
                                            }
                                        }
                                        
                                        if self.coustomRange.isOn{
                                            self.playSound()
                                            self.barcodes.append(barcode.rawValue!)
                                        }
                                    }
                                }
                            }
                            
                            
                            
                        }
                    }
                }catch{
                    Utilites.ShowAlert(title: "Error", message: "something went wrong", view: self)
                }
                
                
            }
        }
    }

    private func startLiveVideo() {
        
        session.sessionPreset = AVCaptureSession.Preset.photo
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        let deviceInput = try! AVCaptureDeviceInput(device: captureDevice!)
        let deviceOutput = AVCaptureVideoDataOutput()
        deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        session.addInput(deviceInput)
        session.addOutput(deviceOutput)
        
        let imageLayer = AVCaptureVideoPreviewLayer(session: session)
        imageLayer.frame = CGRect(x: 0, y: 0, width: self.imageView.frame.size.width + 100, height: self.imageView.frame.size.height)
        imageLayer.videoGravity = .resizeAspectFill
        imageView.layer.addSublayer(imageLayer)
        
        session.startRunning()
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        
       
        let a = self.navigationController?.viewControllers[0] as! HomeViewController
        
        if self.barcodesTypes == "upc"{
            
        }else if self.barcodesTypes == "range"{
            
        }else if self.barcodesTypes == "coustomRange"{
            
        }
        
        a.barcode = self.barcodes
        a.upcBArcode = self.upcBarcode
        print(self.barcodes)
        self.navigationController!.popToRootViewController(animated: true)
        
    }
    
    @IBAction func barcodeScanType(_ sender: AnyObject) {
        
        if sender.tag == 0 {
            if self.upc.isOn{
                self.barcodesTypes = "upc"
                UserDefaults.standard.set(true, forKey: "upc")
            }else{
                UserDefaults.standard.set(false, forKey: "upc")
            }
            
        }else if sender.tag == 1 {
            if  self.range.isOn{
                self.barcodesTypes = "range"
                UserDefaults.standard.set(true, forKey: "range")
            }else{
                UserDefaults.standard.set(false, forKey: "range")
            }
            
        }else if sender.tag == 2 {
            if self.coustomRange.isOn{
                self.barcodesTypes = "coustomRange"
                self.nextBtn.isHidden = false
                UserDefaults.standard.set(true, forKey: "coustomRange")
            }else{
                self.nextBtn.isHidden = true
                UserDefaults.standard.set(false, forKey: "coustomRange")
            }
            
        }
        
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        
        let main = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        Constants.barcodes = self.barcodes
        self.navigationController?.pushViewController(main, animated: true)
        
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "beep-02", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
