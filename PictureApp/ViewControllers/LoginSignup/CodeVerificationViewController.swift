
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
        }) { (err) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!!", message: "Enter a vail OTP", view: self)
        }
        
    }
    
    @IBAction func verifyBtn(_ sender: Any) {
        
        if self.validInput() {
            self.enterCode(number: self.number.text!)
        }
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
