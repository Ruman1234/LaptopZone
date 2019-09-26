
//
//  ForgotPasswordViewController.swift
//  SnapToSell
//
//  Created by Apple on 9/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var emailText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.addBG()
            self.emailText.setIcon(UIImage(named: "emalImg")!)
            self.continueBtn.setGradient()
        }
      
        
    }
    
    func SendEmail(email:String) {
        SVProgressHUD.show(withStatus: "Loading...")
        NetworkManager.SharedInstance.RequestOTP(Email: self.emailText.text!, success: { (res) in
            SVProgressHUD.dismiss()
            self.showToast(message: "kindly check your mail")
            
        }) { (err) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        
    }
    
    func validInput() -> Bool {
        var flag = true
        if self.emailText.text == "" {
            flag = false
            self.showToast(message: "Kindly enter email")
        }
        return flag
    }

    
    @IBAction func continueBtn(_ sender: Any) {
        
        if self.validInput(){
            self.SendEmail(email: self.emailText.text!)
        }
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
