
//
//  ContactDetailsViewController.swift
//  SnapToSell
//
//  Created by Apple on 9/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper
import SVProgressHUD
import SkyFloatingLabelTextField

class ContactDetailsViewController: UIViewController {

    
    
    @IBOutlet weak var firstname: SkyFloatingLabelTextField!
    @IBOutlet weak var lastname: SkyFloatingLabelTextField!
    @IBOutlet weak var email: SkyFloatingLabelTextField!
    @IBOutlet weak var phone: SkyFloatingLabelTextField!
    
    @IBOutlet weak var message: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        message.layer.cornerRadius = 5
        message.layer.borderColor = UIColor.gray.cgColor
        message.layer.borderWidth = 1
        // Do any additional setup after loading the view.
    }
    

    func SaveRepairInfo(brand_name: String,
                        series_name: String,
                        model_name: String,
                        issues_name: String,
                        emailNumb: String,
                        phoneNumb: String,
                        LastName: String,
                        yourName: String,
                            enterComents: String)  {
            SVProgressHUD.show(withStatus: "Loading...")
            Alamofire.request(URL(string: "http://71.78.236.20/laptopzone/reactcontroller/c_react/ljw_SaveRequest")!, method: .post, parameters: ["brand_name":brand_name,
                "series_name":series_name,
                "model_name":model_name,
                "issues_name":issues_name,
                "emailNumb":emailNumb,
                "phoneNumb":phoneNumb,
                "LastName":LastName,
                "yourName":yourName,
                "enterComents":enterComents,
                ], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                        SVProgressHUD.dismiss()
                        if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                            print(response)
//                            self.dismiss(animated: true, completion: nil)
//                            Utilites.ShowAlert(title: "Success", message: "Mail sent successfully", view: self)
                            self.showToast(message: "Mail sent successfully")
//                            self.navigationController?.popViewController(animated: true)
//                           let main = self.storyboard?.instantiateViewController(withIdentifier: "SelectYourProductViewController") as! SelectYourProductViewController
                            
                             let a = self.navigationController?.viewControllers[0] as! SelectYourProductViewController
                            
                            self.navigationController?.popToViewController(a, animated: true)
                            
                            }
                        else{
                            SVProgressHUD.dismiss()
                            Utilites.ShowAlert(title: "Error!!", message: "Something went wrong", view: self)
                        }
        
                }
    
    }
    
    
    
    func validInput() -> Bool {
        var flag = true
        let firstname = self.firstname.text?.trimmingCharacters(in: .whitespaces)
        let lastname = self.lastname.text?.trimmingCharacters(in: .whitespaces)
        let email = self.email.text?.trimmingCharacters(in: .whitespaces)
        let phone = self.phone.text?.trimmingCharacters(in: .whitespaces)
        
        print(firstname)
        print(lastname)
        print(email)
        print(phone)
        
        
        if self.email.text == "" {
            flag = false
            self.showToast(message: "Please enter email")
        }else if self.firstname.text == "" {
            flag = false
            self.showToast(message: "Please enter first name")
        }else if self.lastname.text == "" {
            flag = false
            self.showToast(message: "Please enter last name")
        }else if self.phone.text == "" {
            flag = false
            self.showToast(message: "Please enter phone")
        }else if Utilites.isValid(email: self.email!.text! as NSString) == false{
            flag = false
            self.showToast(message: "Please enter a valid email")
        }
        
        return flag
    }
    
    
    
    @IBAction func saveBtn(_ sender: Any) {
        if validInput(){
            self.SaveRepairInfo(brand_name: Constants.brandId, series_name: Constants.seriesId, model_name: Constants.modelId, issues_name: Constants.issuesId, emailNumb: self.email.text!, phoneNumb: self.phone.text!, LastName: self.lastname.text!, yourName: self.firstname.text!, enterComents: self.message.text ?? "")
        }
    }
    
}
