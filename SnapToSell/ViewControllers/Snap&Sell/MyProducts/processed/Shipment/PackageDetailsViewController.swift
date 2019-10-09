//
//  PackageDetailsViewController.swift
//  SnapToSell
//
//  Created by Apple on 8/30/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField



protocol PackageDetailsViewControllerDelegate {
    func data(height: String,weight: String,width: String,length: String)
    
    
}
class PackageDetailsViewController: UIViewController {

    
    @IBOutlet weak var height: SkyFloatingLabelTextField!
    @IBOutlet weak var weight: SkyFloatingLabelTextField!
    @IBOutlet weak var width: SkyFloatingLabelTextField!
    @IBOutlet weak var length: SkyFloatingLabelTextField!
    
    var delegate : PackageDetailsViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBG()
        // Do any additional setup after loading the view.
    }
    
    
    func validInput() -> Bool {
        var flag = true
        
        
        self.height.text = self.height.text?.trimmingCharacters(in: .whitespaces)
        self.weight.text = self.weight.text?.trimmingCharacters(in: .whitespaces)
        self.width.text = self.width.text?.trimmingCharacters(in: .whitespaces)
        self.length.text = self.length.text?.trimmingCharacters(in: .whitespaces)
        
        
        if self.height.text == ""{
            flag = false
            self.showToast(message: "Please enter height")
        }else if self.weight.text == ""{
                flag = false
            self.showToast(message: "Please enter weight")
        }else if self.width.text == ""{
            self.showToast(message: "Please enter width")
            flag = false
        }else if self.length.text == ""{
            self.showToast(message: "Please enter length")
            flag = false
        }
        
        return flag
    }
    
    @IBAction func continueBtn(_ sender: Any) {
        
        if validInput(){
            Constants.height = self.height.text!
            Constants.weight = self.weight.text!
            Constants.width = self.width.text!
            Constants.length = self.length.text!
            
            NotificationCenter.default.post(name: Notification.Name("nextStepShipment"), object: nil)
            
            delegate?.data(height: self.height.text!, weight: self.weight.text!, width: self.width.text!, length: self.length.text!)
            
            
        }
        
    }
    
}
