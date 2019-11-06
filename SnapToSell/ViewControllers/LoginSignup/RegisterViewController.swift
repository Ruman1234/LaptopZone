
//
//  RegisterViewController.swift
//  SnapToSell
//
//  Created by Apple on 8/23/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SVProgressHUD

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var signupBtn: UIButton!
    
    
    @IBOutlet weak var fb: UIButton!
    @IBOutlet weak var google: UIButton!
    
    @IBOutlet weak var twitter: UIButton!
    let userdefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBG()
        self.hideKeyboardWhenTappedAround()
        
        
        self.google.layer.cornerRadius = self.google.frame.width / 2
        self.fb.layer.cornerRadius = self.fb.frame.width / 2
        self.twitter.layer.cornerRadius = self.twitter.frame.width / 2
        
        DispatchQueue.main.async {
            
            self.signupBtn.setGradient()
            
            self.name.setIcon(UIImage(named: "nameImg")!)
            
            self.email.setIcon(UIImage(named: "emalImg")!)
            self.confirmPassword.setIcon(UIImage(named: "passwordimg")!)
            self.password.setIcon(UIImage(named: "passwordimg")!)
        }
 
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
      
    }
    
    func validInput() -> Bool {
        var flag = true
         self.name.text = self.name.text?.trimmingCharacters(in: .whitespaces)
        
         self.email.text = self.email.text?.trimmingCharacters(in: .whitespaces)
         self.password.text = self.password.text?.trimmingCharacters(in: .whitespaces)
        
        if self.name.text == ""{
            flag = false
            self.showToast(message: "Please enter username")
        }else if self.email.text == ""{
            flag = false
            self.showToast(message: "Please enter emil")
        }else if Utilites.isValid(email: self.email!.text! as NSString) == false{
            flag = false
            self.showToast(message: "Please enter a valid Email")
        }else if self.password.text == ""{
            self.showToast(message: "Please enter password")
            flag = false
        }else if self.password.text!.count < 6{
            self.showToast(message: "Password should be six digit")
            flag = false
        }else if self.confirmPassword.text == ""{
            self.showToast(message: "Please enter confirmPassword")
            flag = false
        }else if self.confirmPassword.text != self.password.text{
//            self.showToast(message: "password and confirm oasswrd")
            Utilites.ShowAlert(title: "Error!!", message: "Password and confirm password are not same", view: self)
            flag = false
        }
        
        return flag
    }
    
    
    
    func register()  {
        SVProgressHUD.show(withStatus: "Loading...")
        
        NetworkManager.SharedInstance.Register(name: self.name.text!, email: self.email.text!, password: self.password.text!, Confirmpassword: self.confirmPassword.text!, success: { (response) in
            SVProgressHUD.dismiss()
            if response == "error"{
                
                Utilites.ShowAlert(title: "Error!!!", message: "Email Already exist", view: self)
                return
            }
            
            print(response)
            self.Login()
        }) { (error) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!!", message: "something Went wrong", view: self)
        }
    }
    
    
    func Login() {
        
        SVProgressHUD.show(withStatus: "Loading...")
        
        NetworkManager.SharedInstance.login(userNAme: self.email.text!, password:self.password.text!, fcm_token: CustomUserDefaults.fcm_token.value ?? "", success: { (response) in
            SVProgressHUD.dismiss()
            if (response.message != nil) {
                Utilites.ShowAlert(title: "Error!!", message: "Email or password is invalid", view: self)
                return
            }else{
                print("Adasd")
                
                
                self.userdefaults.setValue(response.access_token, forKey: "Token")
                
//                self.userdefaults.set(true, forKey: "islogin")
                
                AppManager.shared().accessToken = UserDefaults.standard.value(forKey: "Token") as! String
                
                print(AppManager.shared().accessToken)
                
                CustomUserDefaults.Token.value = response.access_token
                
                NetworkManager.SharedInstance.Profile(success: { (res) in
                   print(res)
                   SVProgressHUD.dismiss()
                   CustomUserDefaults.email.value = res.email
                   CustomUserDefaults.userName.value = res.name
                   CustomUserDefaults.VerifyPaypal.value = res.paypal
                   CustomUserDefaults.userId.value = "\(res.id!)"
                   CustomUserDefaults.password.value = self.password.text!
                   print(CustomUserDefaults.userId.value!)

                   let main = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                   
                   self.navigationController?.pushViewController(main, animated: true)

                   
               }, failure: { (err) in
                   print("Error!!!")
               })
                               
                
            }
            
        }) { (error) in
            SVProgressHUD.dismiss()
            
            Utilites.ShowAlert(title: "Error!!", message: "Something went wrong", view: self)
        }
    }
    
    
    @IBAction func register(_ sender: Any) {
        if self.validInput(){
            self.register()
        }
    }
    
    
    
    @IBAction func back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
