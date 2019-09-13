
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

    
    @IBOutlet weak var name: SkyFloatingLabelTextField!
    
    @IBOutlet weak var password: SkyFloatingLabelTextField!
    @IBOutlet weak var email: SkyFloatingLabelTextField!
    
    @IBOutlet weak var confirmPassword: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
  
    
    
    func validInput() -> Bool {
        var flag = true
         let nn = self.name.text?.trimmingCharacters(in: .whitespaces)
        print(nn)
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
        }else if self.confirmPassword.text == ""{
            self.showToast(message: "Please enter confirmPassword")
            flag = false
        }else if self.confirmPassword.text != self.password.text{
            self.showToast(message: "Please enter a valid password")
            flag = false
        }
        
        return flag
    }
    
    

    func register()  {
        SVProgressHUD.show(withStatus: "Loading...")
        
        NetworkManager.SharedInstance.Register(name: self.name.text!, email: self.email.text!, password: self.password.text!, Confirmpassword: self.confirmPassword.text!, success: { (response) in
            SVProgressHUD.dismiss()
            print(response)
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!!", message: "something Went wrong", view: self)
        }
    }
    
    
    @IBAction func register(_ sender: Any) {
        if self.validInput(){
            self.register()
        }
    }
    
    
}
