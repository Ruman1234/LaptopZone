//
//  ResetYourPasswordViewController.swift
//  SnapToSell
//
//  Created by Apple on 9/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD

class ResetYourPasswordViewController: UIViewController {
    
    
    
    @IBOutlet weak var newPassword: UITextField!
    
    @IBOutlet weak var confimPassword: UITextField!
    
    @IBOutlet weak var doneBtn: UIButton!
    
    var email = String()
    var otp = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.newPassword.setIcon(UIImage(named: "passwordimg")!)
            self.confimPassword.setIcon(UIImage(named: "passwordimg")!)
            self.addBG()
            self.doneBtn.setGradient()
        }
        
       
        
    }
    
    func validInput() -> Bool {
           var flag = true
           if self.newPassword.text == "" {
               flag = false
               self.showToast(message: "Kindly enter Password")
           }else if self.confimPassword.text == "" {
               flag = false
               self.showToast(message: "Kindly enter confirm Password")
           }else if self.confimPassword.text == self.confimPassword.text {
               flag = false
               self.showToast(message: "Kindly confirm Password")
           }
           return flag
    }

    func reset()  {
        SVProgressHUD.show(withStatus: "Loading...")
        NetworkManager.SharedInstance.ResetPasswordWithOTP(Email: self.email, password: self.newPassword.text!, otp: otp, success: { (res) in
            SVProgressHUD.dismiss()
        }) { (err) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            
        }
        
    }
    
    
    
    @IBAction func doneBtn(_ sender: Any) {
        if self.validInput(){
            self.reset()
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
