//
//  AddDropOffView.swift
//  SnapToSell
//
//  Created by Apple on 10/31/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField


protocol AddDropOffViewDelegate {
//    func didAdd()
//    func didClose(barcode:String, weight: String, condition:String , remarks:String , conditin_Id:String)
    func didClose(trackingNumber : String,carierName : String)
    func didClose()
}


class AddDropOffView: UIView {
      
    @IBOutlet weak var secondLbl: UILabel!
    @IBOutlet weak var firstLbl: UILabel!
    @IBOutlet weak var carierNAme: SkyFloatingLabelTextField!
    
    @IBOutlet weak var trackingNumber: SkyFloatingLabelTextField!
    
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var doneBtn: UIButton!
    
    var delegate : AddDropOffViewDelegate?
    
    var titleName = String()
    var type = String()
      override func awakeFromNib() {
          doneBtn.setFont(size: 19)
          doneBtn.setGradient()
          print(titleName)
    //          self.nameLbl.text = titleName
          
      }
      
    func validInput() -> Bool {
        var flag = true
        if self.carierNAme.text == "" {
            flag = false
            self.showToast(message: "Please enter old password")
        }else if self.trackingNumber.text == "" {
            flag = false
            self.showToast(message: "Please enter new password")
        }else if self.carierNAme.text != CustomUserDefaults.password.value {
            flag = false
            self.showToast(message: "Please enter your valid old password")
        }else if self.trackingNumber.text == self.carierNAme.text {
            flag = false
            self.showToast(message: "Old password and new passwor are same")
        }
        return flag
    }
    
      
    @IBAction func doneBtn(_ sender: Any) {
        if type == "password"{
            
            if validInput(){
                NetworkManager.SharedInstance.ResetPasswordUsingOld(new_password: trackingNumber.text!, old_password: carierNAme.text!, success: { (res) in
                    //                self.delegate?.didClose()
                    self.delegate?.didClose(trackingNumber: "", carierName: "")
                }) { (err) in
                    self.showToast(message: "Can't change password right now")
                }

            }
            
        }else{
            self.delegate?.didClose(trackingNumber: trackingNumber.text!, carierName: carierNAme.text!)

        }
    }
    
    
      @IBAction func closeBtn(_ sender: Any) {
          
          delegate?.didClose()
      }

}
