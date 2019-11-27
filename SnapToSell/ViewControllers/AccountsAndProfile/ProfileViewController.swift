//
//  ProfileViewController.swift
//  SnapToSell
//
//  Created by Apple on 11/1/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var cityCountryname: UILabel!
    
    @IBOutlet weak var numberLbl: UILabel!
    
    @IBOutlet weak var circleImg: UIImageView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var changeBtn: UIButton!
    
    let imageView = UIImageView(image: UIImage(named: "no_net (1)"))
    let button = UIButton(type: UIButton.ButtonType.system) as UIButton

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if validInput(){
            if Utilites.isInternetAvailable() {
               APiCall()
            }else{
                 self.netCheck(button: button, imageView: imageView)
                 button.addTarget(self, action: #selector(ViewController.buttonAction(_:)), for: .touchUpInside)
                   
            }
//        }

               
            
        self.circleImg.layer.cornerRadius = self.circleImg.frame.width / 2
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        // Do any additional setup after loading the view.
    }
    

    func APiCall()  {
        SVProgressHUD.show(withStatus: "Loading..")
          NetworkManager.SharedInstance.Profile(success: { (res) in
              print(res)
            SVProgressHUD.show(withStatus: "Loading..")
            self.emailLbl.text = res.email
            self.nameLbl.text = res.name
              CustomUserDefaults.email.value = res.email
              CustomUserDefaults.userName.value = res.name
              CustomUserDefaults.VerifyPaypal.value = res.paypal
              CustomUserDefaults.userId.value = "\(res.id!)"
            self.getDefaultAddress()
          }, failure: { (err) in
            SVProgressHUD.show(withStatus: "Loading..")
              print("Error!!!")
            Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)

          })
    }
    
    @IBAction func changeBtn(_ sender: Any) {
        
        
    }
    
    func getDefaultAddress()  {
        SVProgressHUD.show(withStatus: "Loading..")
        NetworkManager.SharedInstance.getDefaultAddress(success: { (response) in
            print(response)
            SVProgressHUD.dismiss()
            if (response.contact_name != nil){
//                Constants.address = response
//                Constants.addressId = "\(response.id!)"
                
                self.cityCountryname.text = "\(String(describing: response.city!)), United State."
                 self.addressLbl.text = "\(String(describing: response.street!)), \(String(describing: response.city!)), \(String(describing: response.state!)), \(String(describing: response.zip!)), United State."
                
                self.numberLbl.text = response.phone ?? ""
//                self.address = response
//                self.name.text = response.contact_name
//                self.aptStreet.text = (response.apartment ?? "") + "," + (response.street ?? "")
//
//                self.city.text = response.city
//                self.state.text = response.state
//                self.zip.text = response.zip
//                self.number.text = response.phone
                
            }else{
                Utilites.ShowAlert(title: "Error!!!", message: response.message!, view: self)
                
              
            }
            
            
        }) { (error) in
            Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
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
            APiCall()
    //            self.viewWillAppear(true)
        }else{
            self.showToast(message: "Internet is not availble")
        }
    }
    
}
