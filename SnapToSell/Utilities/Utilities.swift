//
//  Utilities.swift
//  SnapToSell
//
//  Created by Apple on 8/23/19.
//  Copyright © 2019 Apple. All rights reserved.
//


import Accelerate
import Foundation
import SystemConfiguration
import SwiftUserDefault
import UIKit

var MaxEmailLength = 245

class Utilites {
    
    static func ShowAlert (title:String , message :String, view : UIViewController){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
        }))
        
        view.present(alert, animated: true)
        
    }
    
    static func ShowAlert (title:String , message :String, view : UIViewController, finished: ((UIAlertAction) -> Void)?){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: finished))
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

extension UIViewController {
    
    
    func setRedStatusBar()  {
         if #available(iOS 13.0, *) {
             let app = UIApplication.shared
             let statusBarHeight: CGFloat = app.statusBarFrame.size.height
             
             let statusbarView = UIView()
             statusbarView.backgroundColor = UIColor.red
             view.addSubview(statusbarView)
           
             statusbarView.translatesAutoresizingMaskIntoConstraints = false
             statusbarView.heightAnchor
                 .constraint(equalToConstant: statusBarHeight).isActive = true
             statusbarView.widthAnchor
                 .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
             statusbarView.topAnchor
                 .constraint(equalTo: view.topAnchor).isActive = true
             statusbarView.centerXAnchor
                 .constraint(equalTo: view.centerXAnchor).isActive = true
           
         } else {
             let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
             statusBar?.backgroundColor = UIColor.red
         }
    }
    
    
    func setGragientBar() {
         let gradientLayer = CAGradientLayer()

            gradientLayer.frame = CGRect(x:0, y:-20, width:375, height:64)
        let colorTop = UIColor(red: 0.99, green: 0.17, blue: 0.03, alpha: 1).cgColor
        
        let colorBottom = UIColor(red: 1, green: 0.49, blue: 0, alpha: 1).cgColor
            gradientLayer.colors = [ colorTop, colorBottom]
    //        gradientLayer.locations = [ 0.0, 1.0]
            
    //                gradientLayer.locations = [0.12, 1]
            
            
            gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
            
            
            gradientLayer.frame = CGRect(x:0, y:-20, width:375, height:self.view.frame.height * 0.06)
            
            let window: UIWindow? = UIApplication.shared.keyWindow
            let view = UIView()
            view.backgroundColor = UIColor.clear
            view.translatesAutoresizingMaskIntoConstraints = false
            view.frame = CGRect(x: 0, y: 0, width: (window?.frame.width)!, height: self.view.frame.height * 0.07)
            view.layer.addSublayer(gradientLayer)
            window?.addSubview(view)
                
    }
    
    func addPAger(totalPage : Int , currentPage : Int) {
        
        let pager = UIPageControl()
        pager.numberOfPages = totalPage
        pager.tintColor = UIColor.gray
        pager.pageIndicatorTintColor = UIColor.gray
        pager.currentPageIndicatorTintColor = .red
        pager.currentPage = currentPage
        let x = (self.view.frame.width / 2) - 75
        pager.frame = CGRect(x: x, y: 50, width: 130, height: 10)
        self.view.addSubview(pager)
        
                                        
    }
    
    
    
    func cancleBtn()  {
        
        let x = self.view.frame.width - 85 
        
        let button = UIButton(frame: CGRect(x: x, y: 45, width: 70, height: 20))
//        button.backgroundColor = .green
        button.setTitleColor(.red, for: .normal)
        button.setTitle("Cancel", for: .normal)
        button.setFont(size: 15)
        button.addTarget(self, action: #selector(logoutUser), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
     func backBtn()  {
            
            let x = 20
            let imageview = UIImageView(frame: CGRect(x: x, y: 46, width: 25, height: 15))
            imageview.image = UIImage(named: "back")
        
            let button = UIButton(frame: CGRect(x: x, y: 46, width: 70, height: 70))
    //        button.backgroundColor = .green
            button.setTitleColor(.red, for: .normal)
//            button.setTitle("Cancle", for: .normal)
//            button.setImage(UIImage(named: "back"), for: .normal)
            
            button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
            self.view.addSubview(imageview)
        
            self.view.addSubview(button)
        }
        
    @objc func back(){
           
           
        self.navigationController?.popViewController(animated: true)
            
    }
    
    @objc func logoutUser(){
        
        if #available(iOS 13.0, *) {
            let a = self.navigationController?.viewControllers[0] as! HomeViewController
            self.navigationController?.popToViewController(a, animated: true)
        } else {
            // Fallback on earlier versions
        }
         
         
    }
    
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func showToast(message : String) {
//        label.intrinsicContentSize.width
//        label.sizeToFit()
        let toastLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.size.height-100, width: self.view.frame.size.width, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Eina-Regular", size: 10.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 6.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
    func addBG()  {
        self.setRedStatusBar()
    
        
        let imageOnTop = UIImageView()
        imageOnTop.image = UIImage(named: "bgtop")
        
        let hight = self.view.frame.height / 3.45
        let width = self.view.frame.width / 1.62
        
        imageOnTop.frame = CGRect(x: 0, y: 0, width: width, height: hight)
        
        let imageOnBottom = UIImageView()
        imageOnBottom.image = UIImage(named: "bottomImg")
        
        self.view.addSubview(imageOnBottom)
        imageOnBottom.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        let trailingConstaint = NSLayoutConstraint(item: imageOnBottom, attribute: .trailing, relatedBy: .lessThanOrEqual, toItem:imageOnBottom.superview , attribute: .trailing, multiplier: 1, constant: -1)
        trailingConstaint.isActive = true
        
        
        let bottomConstaint = NSLayoutConstraint(item: imageOnBottom, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem:imageOnBottom.superview , attribute: .bottom, multiplier: 1, constant: -1)
        bottomConstaint.isActive = true
        
        
        let hieghtConstaint = NSLayoutConstraint(item: imageOnBottom, attribute: .height, relatedBy: .lessThanOrEqual, toItem: self.view, attribute: .height, multiplier: 1, constant: 224)
        hieghtConstaint.isActive = true
        
        let weightConstaint = NSLayoutConstraint(item: imageOnBottom, attribute: .width, relatedBy: .lessThanOrEqual, toItem:self.view , attribute: .width, multiplier: 1, constant: 264)
        weightConstaint.isActive = true
        
        self.view.addConstraint(trailingConstaint)
        self.view.addConstraint(bottomConstaint)
        self.view.addConstraint(hieghtConstaint)
        self.view.addConstraint(weightConstaint)
        self.view.addSubview(imageOnTop)
        
    }
    
    
    
}

extension UIImage {
    func fixedOrientation() -> UIImage? {
        
        guard imageOrientation != UIImage.Orientation.up else {
            //This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }
        
        guard let cgImage = self.cgImage else {
            //CGImage is not available
            return nil
        }
        
        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil //Not able to create CGContext
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
            break
        case .up, .upMirrored:
            break
        }
        
        //Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
    
    func landscapeMode() -> UIImage   {
        
        var transform:CGAffineTransform = .identity
        transform = transform.translatedBy(x: 0, y: size.height).rotated(by: -.pi/2)
        //        transform = transform.translatedBy(x: size.height, y: 0).scaledBy(x: -1, y: 1)
        
        
        let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height),
                            bitsPerComponent: cgImage!.bitsPerComponent, bytesPerRow: 0,
                            space: cgImage!.colorSpace!, bitmapInfo: cgImage!.bitmapInfo.rawValue)!
        ctx.concatenate(transform)
        
        
        ctx.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.width,height: size.height))
        
        return UIImage(cgImage: ctx.makeImage()!)
        
    }
}


extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage;
    }
}



struct CustomUserDefaults {
    
    static let Token = UserDefaultsItem<String>("Token")
    static let userName = UserDefaultsItem<String>("username")
    static let email = UserDefaultsItem<String>("email")
    static let VerifyPaypal = UserDefaultsItem<String>("paypal")
    static let fcm_token = UserDefaultsItem<String>("fcm_token")
    static let userId = UserDefaultsItem<String>("Userid")
    static let password = UserDefaultsItem<String>("password")
    
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
}

extension UITextField {
    
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame:
            CGRect(x: 20, y: 5, width: 20, height: 20))
        iconView.contentMode = .scaleAspectFit
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 30, y: 0, width: 55, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
        print(self.frame.height / 2.04)
        self.layer.cornerRadius = self.frame.height / 2.041
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
        
        self.font = UIFont(name: "Eina03-Regular", size: 13)
    }
    
}


extension UILabel {
    
    func setRegularFont(size : CGFloat)  {
        self.font = UIFont(name: "Eina03-Regular", size: size)
    }
    
    func setSemiBoldFont(size : CGFloat)  {
        self.font = UIFont(name: "Eina-SemiBold", size: size)
    }
    
    func setBoldFont(size : CGFloat)  {
        self.font = UIFont(name: "Eina-Bold", size: size)
    }
    
}


extension UIButton {
    
    func setGradient()  {
//        layer1.locations = [0, 0.5, 1]
//        self.applyGradient(colours: [UIColor.init(rgb: 0xFC2B08) , UIColor.init(rgb: 0xFF3000) , UIColor.init(rgb: 0xFF7C00)], locations: [0, 0.5, 1], startPoint: CGPoint(x: 0.25, y: 0.5), endPoint: CGPoint(x: 0.75, y: 0.5))
        
        self.applyGradient(colours: [
//            UIColor(red: 0.99, green: 0.17, blue: 0.03, alpha: 1),

          UIColor(red: 0.99, green: 0.17, blue: 0.03, alpha: 1),

          UIColor(red: 1, green: 0.19, blue: 0, alpha: 1),

          UIColor(red: 1, green: 0.49, blue: 0, alpha: 1)

        ], locations: [0, 0.5, 1], startPoint: CGPoint(x: 0.00, y: 0.5), endPoint: CGPoint(x: 0.75, y: 0.09))

        
//        func ccc (){
//                let view = UIView()
//
//        view.frame = self.frame
//
//                view.backgroundColor = .white
//
////                view
////         = view
//
//
//
//
//                let shadows = UIView()
//
//                shadows.frame = view.frame
//
//                shadows.clipsToBounds = false
//
//                view.addSubview(shadows)
//
//
//                let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 50)
//
//                let layer0 = CALayer()
//
//                layer0.shadowPath = shadowPath0.cgPath
//
//                layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
//
//                layer0.shadowOpacity = 1
//
//                layer0.shadowRadius = 20
//
//                layer0.shadowOffset = CGSize(width: 0, height: 10)
//
//                layer0.bounds = shadows.bounds
//
//                layer0.position = shadows.center
//
//                shadows.layer.addSublayer(layer0)
//
//
//                let shapes = UIView()
//
//                shapes.frame = view.frame
//
//                shapes.clipsToBounds = true
//
//                view.addSubview(shapes)
//
//
//                let layer1 = CAGradientLayer()
//
//                layer1.colors = [
//
//                  UIColor(red: 0.99, green: 0.17, blue: 0.03, alpha: 1).cgColor,
//
//                  UIColor(red: 1, green: 0.19, blue: 0, alpha: 1).cgColor,
//
//                  UIColor(red: 1, green: 0.49, blue: 0, alpha: 1).cgColor
//
//                ]
//
//                layer1.locations = [0, 0.5, 1]
//
//        layer1.startPoint = CGPoint(x: 0., y: 0.5)
//
//                layer1.endPoint = CGPoint(x: 0.75, y: 0.5)
//
//                layer1.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1, b: 0, c: 0, d: 8.76, tx: 0, ty: -3.87))
//
//                layer1.bounds = shapes.bounds.insetBy(dx: -0.5*shapes.bounds.size.width, dy: -0.5*shapes.bounds.size.height)
//
//                layer1.position = shapes.center
//
//                shapes.layer.addSublayer(layer1)
//
//
//                shapes.layer.cornerRadius = 50
//
//
//            let parent = self
//
//                parent.addSubview(view)
//
//                view.translatesAutoresizingMaskIntoConstraints = false


//            }
        
        
        self.titleLabel?.font = UIFont(name: "Eina03-Regular", size: 17.0)
        self.layer.cornerRadius =  self.frame.height / 2.041
    }
    
    func setFont(size : CGFloat)  {
         self.titleLabel?.font = UIFont(name: "Eina03-Regular", size: size)
    }
    
}


extension UIView {
    
    
    func blink() {
        self.alpha = 0.2
        UIView.animate(withDuration: 1, delay: 0.0, options: [.curveLinear, .repeat, .autoreverse], animations: {self.alpha = 1.0}, completion: nil)
    }
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 0, height: 1.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 4.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.masksToBounds = false
    }
    func giveShadow()  {
        
//        let shadows = UIView()
//        let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 0)
//
//        let layer0 = CALayer()
//
//        layer0.shadowPath = shadowPath0.cgPath
//
//        layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
//
//        layer0.shadowOpacity = 1
//
//        layer0.shadowRadius = 4
//
//        layer0.shadowOffset = CGSize(width: 0, height: 1)
//
//        layer0.bounds = shadows.bounds
//
//        layer0.position = shadows.center
//
//        shadows.layer.addSublayer(layer0)
        
        self.layer.shadowOpacity = 0.2
        
//        self.clipsToBounds = false
        
        self.layer.shadowRadius = 4.0
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false

    }
    func showToast(message : String) {
    //        label.intrinsicContentSize.width
    //        label.sizeToFit()
            let toastLabel = UILabel(frame: CGRect(x: 0, y: self.frame.size.height-100, width: self.frame.size.width, height: 35))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.textAlignment = .center;
            toastLabel.font = UIFont(name: "Montserrat-Light", size: 10.0)
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            self.addSubview(toastLabel)
            UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
    }
    
    
    func applyGradient(colours: [UIColor]) -> Void {

        self.applyGradient(colours: colours, locations: nil, startPoint: nil, endPoint: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]? , startPoint : CGPoint? , endPoint : CGPoint?) -> Void {
        
        
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = startPoint!
        gradient.endPoint = endPoint!
        gradient.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1, b: 0, c: 0, d: 8.76, tx: 0, ty: -3.87))

//        gradient.bounds = self.bounds.insetBy(dx: -0.5*self.bounds.size.width, dy: -0.5*self.bounds.size.height)
//
//        gradient.position = self.center

        
        self.layer.insertSublayer(gradient, at: 0)
        
    }
    
//    func ccc (){
//            let view = UILabel()
//
//            view.frame = CGRect(x: 0, y: 0, width: 190, height: 49)
//
//            view.backgroundColor = .white
//
//    //        self.view
//
//
//            let shadows = UIView()
//
//            shadows.frame = view.frame
//
//            shadows.clipsToBounds = false
//
//            view.addSubview(shadows)
//
//
//            let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 50)
//
//    //        let layer0 = CALayer()
//    //
//    //        layer0.shadowPath = shadowPath0.cgPath
//    //
//    //        layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
//    //
//    //        layer0.shadowOpacity = 1
//    //
//    //        layer0.shadowRadius = 20
//    //
//    //        layer0.shadowOffset = CGSize(width: 0, height: 10)
//    //
//    //        layer0.bounds = shadows.bounds
//    //
//    //        layer0.position = shadows.center
//    //
//    //        shadows.layer.addSublayer(layer0)
//
//
//            let shapes = UIView()
//
//            shapes.frame = view.frame
//
//            shapes.clipsToBounds = true
//
//            view.addSubview(shapes)
//
//
//            let layer1 = CAGradientLayer()
//
//            layer1.colors = [
//
//              UIColor(red: 0.99, green: 0.17, blue: 0.03, alpha: 1).cgColor,
//
//              UIColor(red: 1, green: 0.19, blue: 0, alpha: 1).cgColor,
//
//              UIColor(red: 1, green: 0.49, blue: 0, alpha: 1).cgColor
//
//            ]
//
//            layer1.locations = [0, 0.5, 1]
//
//            layer1.startPoint = CGPoint(x: 0.25, y: 0.5)
//
//            layer1.endPoint = CGPoint(x: 0.75, y: 0.5)
//
//            layer1.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1, b: 0, c: 0, d: 8.76, tx: 0, ty: -3.87))
//
//            layer1.bounds = shapes.bounds.insetBy(dx: -0.5*shapes.bounds.size.width, dy: -0.5*shapes.bounds.size.height)
//
//            layer1.position = shapes.center
//
//            shapes.layer.addSublayer(layer1)
//
//
//            shapes.layer.cornerRadius = 50
//
//
//        let parent = self.view
//
//            parent.addSubview(view)
//
//            view.translatesAutoresizingMaskIntoConstraints = false
//
//
//        }
    
    
    func addDashedBorder() {
       let color = UIColor.red.cgColor

       let shapeLayer:CAShapeLayer = CAShapeLayer()
       let frameSize = self.frame.size
       let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

       shapeLayer.bounds = shapeRect
       shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
       shapeLayer.fillColor = UIColor.clear.cgColor
       shapeLayer.strokeColor = color
       shapeLayer.lineWidth = 2
       shapeLayer.lineJoin = CAShapeLayerLineJoin.round
       shapeLayer.lineDashPattern = [6,3]
       shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath

       self.layer.addSublayer(shapeLayer)
    }
    
    
  
}

class Colors {
    var gl:CAGradientLayer!

    init() {
        let colorTop = UIColor(red: 192.0 / 255.0, green: 38.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 35.0 / 255.0, green: 2.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0).cgColor

        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 1.0]
    }
}


extension Double {
    var dollarString:String {
        return String(format: "$%.2f", self)
    }
}

extension UITableView {
    func scrollToBottom(animated: Bool = true) {
        let section = self.numberOfSections
        if section > 0 {
            let row = self.numberOfRows(inSection: section - 1)
            if row > 0 {
                self.scrollToRow(at: NSIndexPath(row: row - 1, section: section - 1) as IndexPath, at: .bottom, animated: animated)
            }
        }
    }
}
