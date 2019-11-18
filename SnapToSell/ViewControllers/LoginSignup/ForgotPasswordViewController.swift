
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
    
    let imageView = UIImageView(image: UIImage(named: "no_net (1)"))
    let button = UIButton(type: UIButton.ButtonType.system) as UIButton

    
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
            let main = self.storyboard?.instantiateViewController(withIdentifier: "CodeVerificationViewController") as! CodeVerificationViewController
            main.email = self.emailText.text!
            self.navigationController?.pushViewController(main, animated: true)
               
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
        }else if Utilites.isValid(email: self.emailText!.text! as NSString) == false {
            flag = false
            self.showToast(message: "Please enter a valid Email")
        }
        return flag
    }

    
    @IBAction func continueBtn(_ sender: Any) {
        
        if self.validInput(){
            if Utilites.isInternetAvailable() {
                self.SendEmail(email: self.emailText.text!)
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
