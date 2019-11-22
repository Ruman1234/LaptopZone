//
//  ChangePasswordView.swift
//  LaptopZone
//
//  Created by Apple on 11/7/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField



protocol ChangePasswordViewDelegate {
//    func didAdd()
//    func didClose(barcode:String, weight: String, condition:String , remarks:String , conditin_Id:String)
    func didClose(trackingNumber : String,carierName : String)
    func didClose()
}


class ChangePasswordView: UIView {

    @IBOutlet weak var oldpasswordView: SkyFloatingLabelTextField!
    
   
    @IBOutlet weak var confirmPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var newPasswordView: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var doneBtn: UIButton!
    
    var delegate : ChangePasswordViewDelegate?
    
    override func awakeFromNib() {
        doneBtn.setFont(size: 19)
        doneBtn.setGradient()
        
        self.oldpasswordView.hideShowText()
        self.confirmPassword.hideShowText()
        self.newPasswordView.hideShowText()
       //          self.nameLbl.text = titleName
             
    }
    
    
    func validInput() -> Bool {
        var flag = true
        if self.oldpasswordView.text == "" {
            flag = false
            self.showToast(message: "Please enter old password")
        }else if self.newPasswordView.text == "" {
            flag = false
            self.showToast(message: "Please enter new password")
        }else if self.oldpasswordView.text != CustomUserDefaults.password.value {
            flag = false
            self.showToast(message: "Current password is invalid")
        }else if self.oldpasswordView.text == self.newPasswordView.text {
            flag = false
            self.showToast(message: "Old password and new passwor are same")
        }else if self.confirmPassword.text != self.newPasswordView.text {
            flag = false
            self.showToast(message: "Password and confirm password are not same")
        }
        return flag
    }
    
    
    @IBAction func doneBtn(_ sender: Any) {
        
        if self.validInput(){
            NetworkManager.SharedInstance.ResetPasswordUsingOld(new_password: newPasswordView.text!, old_password: oldpasswordView.text!, success: { (res) in
                          //                self.delegate?.didClose()
                          self.delegate?.didClose(trackingNumber: "", carierName: "")
                      }) { (err) in
                          self.showToast(message: "Can't change password right now")
                      }
        }
          

        
    }
    
    
    
       @IBAction func closeBtn(_ sender: Any) {
              
              delegate?.didClose()
          }

    
    
}
