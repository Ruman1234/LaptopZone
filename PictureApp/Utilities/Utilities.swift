//
//  Utilities.swift
//  PictureApp
//
//  Created by Apple on 6/22/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Accelerate
import Foundation
import SystemConfiguration

var MaxEmailLength = 245

class Utilites {
    
    static func ShowAlert (title:String , message :String, view : UIViewController){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
        }))
        
        view.present(alert, animated: true)
        
    }
    
    static func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    
    static func isValid(email:NSString) -> Bool {
        
        let emailRegex:String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTestPredicate:NSPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        let validEmail:Bool = emailTestPredicate.evaluate(with: email)
        
        if (validEmail && email.length <= MaxEmailLength) {
            return true
        } else {
            return false
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height-100, width: 200, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 10.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}
extension UISwitch {
    
    func set(width: CGFloat, height: CGFloat) {
        
        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51
        
        let heightRatio = height / standardHeight
        let widthRatio = width / standardWidth
        
        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
}


extension UIImage{
    func resizeImageUsingVImage(size:CGSize) -> UIImage? {
        let cgImage = self.cgImage!
        var format = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 32, colorSpace: nil, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue), version: 0, decode: nil, renderingIntent: CGColorRenderingIntent.defaultIntent)
        var sourceBuffer = vImage_Buffer()
        defer {
            free(sourceBuffer.data)
        }
        var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgImage, numericCast(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        // create a destination buffer
        let scale = self.scale
        let destWidth = Int(size.width)
        let destHeight = Int(size.height)
        let bytesPerPixel = self.cgImage!.bitsPerPixel/8
        let destBytesPerRow = destWidth * bytesPerPixel
        let destData = UnsafeMutablePointer<UInt8>.allocate(capacity: destHeight * destBytesPerRow)
        defer {
//            destData.deallocate(capacity: destHeight * destBytesPerRow)
            destData.deallocate()
        }
        var destBuffer = vImage_Buffer(data: destData, height: vImagePixelCount(destHeight), width: vImagePixelCount(destWidth), rowBytes: destBytesPerRow)
        // scale the image
        error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, numericCast(kvImageHighQualityResampling))
        guard error == kvImageNoError else { return nil }
        // create a CGImage from vImage_Buffer
        var destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, numericCast(kvImageNoFlags), &error)?.takeRetainedValue()
        guard error == kvImageNoError else { return nil }
        // create a UIImage
        let resizedImage = destCGImage.flatMap { UIImage(cgImage: $0, scale: 0.0, orientation: self.imageOrientation) }
        destCGImage = nil
        return resizedImage
    }
}


class GridView: UIView
{
    private var path = UIBezierPath()
    fileprivate var gridWidthMultiple: CGFloat
    {
        return 3
    }
    fileprivate var gridHeightMultiple : CGFloat
    {
        return 3
    }
    
    fileprivate var gridWidth: CGFloat
    {
        return bounds.width/CGFloat(gridWidthMultiple)
    }
    
    fileprivate var gridHeight: CGFloat
    {
        return bounds.height/CGFloat(gridHeightMultiple)
    }
    
    fileprivate var gridCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    fileprivate func drawGrid()
    {
        path = UIBezierPath()
        path.lineWidth = 1.0
        
        for index in 1...Int(gridWidthMultiple) - 1
        {
            let start = CGPoint(x: CGFloat(index) * gridWidth, y: 0)
            let end = CGPoint(x: CGFloat(index) * gridWidth, y:bounds.height)
            
            let startx = CGPoint(x: 0, y: CGFloat(index) * gridHeight)
            let endx = CGPoint(x:bounds.height , y:CGFloat(index) * gridHeight)
            
            path.move(to: startx)
            path.addLine(to: endx)
            
            path.move(to: start)
            path.addLine(to: end)
        }
      
        //Close the path.
        path.close()
        
    }
    
    override func draw(_ rect: CGRect)
    {
        drawGrid()
        
        // Specify a border (stroke) color.
        UIColor.white.setStroke()
        path.stroke()
    }
    
    
    
    
}


extension String {
    
    func index(at position: Int, from start: Index? = nil) -> Index? {
        let startingIndex = start ?? startIndex
        return index(startingIndex, offsetBy: position, limitedBy: endIndex)
    }
    
    func character(at position: Int) -> Character? {
        guard position >= 0, let indexPosition = index(at: position) else {
            return nil
        }
        return self[indexPosition]
    }
}
class ImageZoomView: UIScrollView, UIScrollViewDelegate {
    
    var imageView: UIImageView!
    var gestureRecognizer: UITapGestureRecognizer!
    
    convenience init(frame: CGRect, image: UIImage?) {
        self.init(frame: frame)
        
        var imageToUse: UIImage
        
        if let image = image {
            imageToUse = image
        } else if let url = Bundle.main.url(forResource: "image", withExtension: "jpeg"),
            let data = try? Data(contentsOf: url),
            let fileImage = UIImage(data: data) {
            imageToUse = fileImage
        } else {
            fatalError("No image was passed in and failed to find an image at the path.")
        }
        
        // Creates the image view and adds it as a subview to the scroll view
        imageView = UIImageView(image: imageToUse)
        imageView.frame = frame
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
        setupScrollView(image: imageToUse)
        setupGestureRecognizer()
    }
    
    // Sets the scroll view delegate and zoom scale limits.
    // Change the `maximumZoomScale` to allow zooming more than 2x.
    func setupScrollView(image: UIImage) {
        delegate = self
        
        minimumZoomScale = 1.0
        maximumZoomScale = 2.0
    }
    
    // Sets up the gesture recognizer that receives double taps to auto-zoom
    func setupGestureRecognizer() {
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        gestureRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(gestureRecognizer)
    }
    
    // Handles a double tap by either resetting the zoom or zooming to where was tapped
    @IBAction func handleDoubleTap() {
        if zoomScale == 1 {
            zoom(to: zoomRectForScale(maximumZoomScale, center: gestureRecognizer.location(in: gestureRecognizer.view)), animated: true)
        } else {
            setZoomScale(1, animated: true)
        }
    }
    
    // Calculates the zoom rectangle for the scale
    func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        let newCenter = convert(center, from: imageView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    // Tell the scroll view delegate which view to use for zooming and scrolling
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

// Create a ImageZoomView and present it in the live view
