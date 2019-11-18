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
    
    let imageView = UIImageView(image: UIImage(named: "no_net (1)"))
    let button = UIButton(type: UIButton.ButtonType.system) as UIButton

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.newPassword.setIcon(UIImage(named: "passwordimg")!)
            self.confimPassword.setIcon(UIImage(named: "passwordimg")!)
            self.addBG()
            self.doneBtn.setGradient()
        }
        self.newPassword.hideShowText()
        self.confimPassword.hideShowText()
       
        
    }
    
    func validInput() -> Bool {
           var flag = true
           if self.newPassword.text == "" {
               flag = false
//               self.showToast(message: "Kindly enter Password")
            Utilites.ShowAlert(title: "Error!!!", message: "Kindly enter Password", view: self)
           }else if self.confimPassword.text == "" {
               flag = false
//               self.showToast(message: "Kindly enter confirm Password")
             Utilites.ShowAlert(title: "Error!!!", message: "Kindly enter confirm Password", view: self)
           }else if self.newPassword.text!.count < 6{
//                self.showToast(message: "Password should be six digit")
             Utilites.ShowAlert(title: "Error!!!", message: "Password should be six digit", view: self)
               flag = false

           }else if self.confimPassword.text != self.newPassword.text {
               flag = false
//               self.showToast(message: "Password and confirm password should be same")
                Utilites.ShowAlert(title: "Error!!!", message: "Password and confirm password should be same", view: self)
           }
           return flag
    }
    
    func reset()  {
        SVProgressHUD.show(withStatus: "Loading...")
        NetworkManager.SharedInstance.ResetPasswordWithOTP(Email: self.email, password: self.newPassword.text!, otp: otp, success: { (res) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Success", message: "Your password updated", view: self) { (res) in
                let main = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(main, animated: true)
            }
           

            
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
            if Utilites.isInternetAvailable() {
                  self.reset()
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
