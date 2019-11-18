
//
//  CodeVerificationViewController.swift
//  SnapToSell
//
//  Created by Apple on 9/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD

class CodeVerificationViewController: UIViewController {

    @IBOutlet weak var number: UITextField!
    
    @IBOutlet weak var verifyBtn: UIButton!
    
    var email = String()
    let imageView = UIImageView(image: UIImage(named: "no_net (1)"))
    let button = UIButton(type: UIButton.ButtonType.system) as UIButton

       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.number.setIcon(UIImage(named: "StartImg")!)
            self.addBG()
            
            self.verifyBtn.setGradient()
        }
    }
    
    
    
    func validInput() -> Bool {
        var flag = true
        if self.number.text == "" {
            flag = false
            self.showToast(message: "Kindly enter Code")
        }
        return flag
    }

    func enterCode(number : String )  {
        SVProgressHUD.show(withStatus: "Loading...")
        NetworkManager.SharedInstance.OtpVerify(email: email, otp: self.number.text!, success: { (res) in
            SVProgressHUD.dismiss()
            
            let main = self.storyboard?.instantiateViewController(withIdentifier: "ResetYourPasswordViewController") as! ResetYourPasswordViewController
            main.otp = self.number.text!
            main.email = self.email
            self.navigationController?.pushViewController(main, animated: true)

            
            
            
        }) { (err) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!!", message: "Enter a vaild OTP", view: self)
        }
        
    }
    
    @IBAction func verifyBtn(_ sender: Any) {
        
        if self.validInput() {
            if Utilites.isInternetAvailable() {
                   self.enterCode(number: self.number.text!)
               }else{
                     self.netCheck(button: button, imageView: imageView)
                   button.addTarget(self, action: #selector(self.buttonAction(_:)), for: .touchUpInside)
                       
               }
            
        }
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func buttonAction(_ sender:UIButton!)
    {
        if Utilites.isInternetAvailable() {
            self.imageView.isHidden = true
            self.button.isHidden = true
    //            self.viewWillAppear(true)
        }else{
            self.showToast(message: "Internet is not availble")
        }
    }
}
