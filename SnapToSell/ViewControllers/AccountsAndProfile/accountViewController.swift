//
//  accountViewController.swift
//  SnapToSell
//
//  Created by Apple on 10/17/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol accountViewControllerDelegate : AnyObject{
    
    func moveToNextTab(index : Int)
    
}

class accountViewController: UIViewController,ChangePasswordViewDelegate {
    
    

    @IBOutlet weak var repairTotalCount: UILabel!
    
    @IBOutlet weak var myTitleView: UIView!
    @IBOutlet weak var sellAnythingTotalCount: UILabel!
    
    @IBOutlet weak var recycleTotalCount: UILabel!
    @IBOutlet weak var SellDeviceTotalCount: UILabel!
    
    @IBOutlet weak var profileNAme: UITextField!
    
    @IBOutlet weak var profileEmail: UITextField!
    
    @IBOutlet weak var profilePhoneNumber: UITextField!
    
    @IBOutlet weak var editBtn: UIButton!
    
    
    var addotherView : ChangePasswordView!
    var delegte : accountViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.setGragientBar()
        self.tabBarController?.selectedIndex = 2
        
        self.myTitleView.applyGradient(colours: [
                   UIColor(red: 0.99, green: 0.17, blue: 0.03, alpha: 1),
                 UIColor(red: 1, green: 0.49, blue: 0, alpha: 1)
               ], locations: [0.12, 1], startPoint: CGPoint(x:0.00, y: 0.1), endPoint: CGPoint(x: 1, y: 1))
        
        self.profileNAme.isUserInteractionEnabled = false
        self.profileEmail.isUserInteractionEnabled = false
        self.profilePhoneNumber.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        APiCall()
    }
    
    override func viewDidAppear(_ animated: Bool) {
          self.myTitleView.applyGradient(colours: [
                         UIColor(red: 0.99, green: 0.17, blue: 0.03, alpha: 1),
                       UIColor(red: 1, green: 0.49, blue: 0, alpha: 1)
                     ], locations: [0.12, 1], startPoint: CGPoint(x:0.00, y: 0.1), endPoint: CGPoint(x: 1, y: 1))
              
    }
    
    func APiCall()  {
        SVProgressHUD.show(withStatus: "Loading..")
          NetworkManager.SharedInstance.Profile(success: { (res) in
              print(res)
//            SVProgressHUD.show(withStatus: "Loading..")
            SVProgressHUD.dismiss()
            self.profileEmail.text = res.email
            self.profileNAme.text = res.name
              CustomUserDefaults.email.value = res.email
              CustomUserDefaults.userName.value = res.name
              CustomUserDefaults.VerifyPaypal.value = res.paypal
              CustomUserDefaults.userId.value = "\(res.id!)"
             
            self.sellAnythingTotalCount.text = "\(res.requests_count!)"
//            self.getDefaultAddress()
            self.getCount()
          }, failure: { (err) in
//            SVProgressHUD.show(withStatus: "Loading..")
            SVProgressHUD.dismiss()
              print("Error!!!")
            Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)

          })
    }
    
    func getCount()  {
        SVProgressHUD.show(withStatus: "Loading..")
        NetworkManager.SharedInstance.GetCount(success: { (res) in
            SVProgressHUD.dismiss()
            
        
            self.repairTotalCount.text = res.repairCount
            self.SellDeviceTotalCount.text = res.sellCount
            
        }) { (err) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
        }
    }
     func UpdateProfileCall()  {
            SVProgressHUD.show(withStatus: "Loading..")
        NetworkManager.SharedInstance.UpdateProfile(name: self.profileNAme.text!, email: self.profileEmail.text!, success: { (res) in
                  print(res)
    //            SVProgressHUD.show(withStatus: "Loading..")
                SVProgressHUD.dismiss()
                self.profileEmail.text = res.email
                self.profileNAme.text = res.name
                  CustomUserDefaults.email.value = res.email
                  CustomUserDefaults.userName.value = res.name
                  CustomUserDefaults.VerifyPaypal.value = res.paypal
                  CustomUserDefaults.userId.value = "\(res.id!)"
            self.showToast(message: "Profile Updated")
    //            self.getDefaultAddress()
              }, failure: { (err) in
    //            SVProgressHUD.show(withStatus: "Loading..")
                SVProgressHUD.dismiss()
                  print("Error!!!")
                Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)

              })
        }
    
    
    func validInput() -> Bool {
        var flag = true
        if self.profileNAme.text == "" {
            flag = false
            self.showToast(message: "Please enter Name")
        }else if self.profileEmail.text == "" {
            flag = false
            self.showToast(message: "Please enter Email")
        }
        
        return flag
    }
    
    
    @IBAction func editBTn(_ sender: AnyObject) {
        if self.editBtn.tag == 0 {
            self.editBtn.tag = 1
            self.profileNAme.isUserInteractionEnabled = true
            self.profileEmail.isUserInteractionEnabled = true
            self.profilePhoneNumber.isUserInteractionEnabled = true
            
            self.profileNAme.layer.borderColor = UIColor.lightGray.cgColor
            self.profileNAme.layer.borderWidth = 0.5
            
            self.profileEmail.layer.borderColor = UIColor.lightGray.cgColor
            self.profileEmail.layer.borderWidth = 0.5
            
            self.profilePhoneNumber.layer.borderColor = UIColor.lightGray.cgColor
            self.profilePhoneNumber.layer.borderWidth = 0.5
//            self.profileEmail.isUserInteractionEnabled = true
//            self.profilePhoneNumber.isUserInteractionEnabled = true
            
            self.profileNAme.resignFirstResponder()
            self.editBtn.setTitle("Done", for: .normal)
        }else if self.editBtn.tag == 1{
            if validInput(){
                 self.editBtn.tag = 0
                self.profileNAme.isUserInteractionEnabled = false
                self.profileEmail.isUserInteractionEnabled = false
                self.profilePhoneNumber.isUserInteractionEnabled = false
                
                self.profileNAme.layer.borderWidth = 0
                self.profileEmail.layer.borderWidth = 0
                self.profilePhoneNumber.layer.borderWidth = 0
                
                self.editBtn.setTitle("Edit", for: .normal)

                self.UpdateProfileCall()
            }
        }
        
    }
    
    @IBAction func shipingAddressBtn(_ sender: Any) {
        
        if #available(iOS 13.0, *) {
            let main = self.storyboard?.instantiateViewController(identifier: "AllAddresViewController") as! AllAddresViewController
            self.navigationController?.pushViewController(main, animated: true)
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    
    @IBAction func signoutBtn(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "!!!", message: "Are you sure you want to signout", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in

            let main = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let userdefaults = UserDefaults.standard
            userdefaults.set(false, forKey: "islogin")
            userdefaults.removeObject(forKey: "Token")
             CustomUserDefaults.Token.value = ""
            let add = AddressesModel()
            Constants.address = add
    //            let front = UINavigationController.init(rootViewController: main)
    //            revealViewController()?.pushFrontViewController(front, animated: true)
            //            main.type = "selectaddress"
            self.navigationController?.pushViewController(main, animated: true)
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        
    //            self.revealViewController()?.pushFrontViewController(main, animated: true)
                
    }
    
    
    @IBAction func changePassword(_ sender: Any) {
//
//        NetworkManager.SharedInstance.ResetPasswordUsingOld(new_password: <#T##String#>, old_password: <#T##String#>, success: { (res) in
//            <#code#>
//        }) { (err) in
//
//        }
        
        addView()
    }
    
    func didClose(trackingNumber: String, carierName: String) {
        
        self.view.showToast(message: "Password Changed")
        self.addotherView.removeFromSuperview()
                      
              UIView.animate(withDuration: 0.3) {

                  self.addotherView.alpha = 0
                  self.addotherView = nil
              }
                let main = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                let userdefaults = UserDefaults.standard
                userdefaults.set(false, forKey: "islogin")
                userdefaults.removeObject(forKey: "Token")
                 CustomUserDefaults.Token.value = ""
                let add = AddressesModel()
                Constants.address = add
        //            let front = UINavigationController.init(rootViewController: main)
        //            revealViewController()?.pushFrontViewController(front, animated: true)
                //            main.type = "selectaddress"
                self.navigationController?.pushViewController(main, animated: true)
    }
    
     func didClose() {
        self.addotherView.removeFromSuperview()
                
        UIView.animate(withDuration: 0.3) {

            self.addotherView.alpha = 0
            self.addotherView = nil
        }
     }
    
    
    func addView()  {
        if self.addotherView == nil {
            self.addotherView = nil
            self.addotherView = (Bundle.main.loadNibNamed("ChangePasswordView", owner: self, options: nil)![0] as!  ChangePasswordView)

            self.addotherView.delegate = self
//            self.addotherView.type = "password"
//            self.addotherView.firstLbl.text = "Old Password"
//            self.addotherView.secondLbl.text = "New Password"
//            self.addotherView.titleName = "Enter Series Name"
//            self.addotherView.nameLbl.text = "Enter Tracking number"
            self.addotherView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                   
            self.view.addSubview(addotherView)
            UIView.animate(withDuration: 0.3) {

               self.addotherView.alpha = 1
            }
        }
    }
    
    
    
    @IBAction func redirectBtn(_ sender: AnyObject) {
//        self.delegte?.moveToNextTab(index: sender.tag)
        let imageDataDict:[String: Any] = ["image": sender.tag!]
//        self.tabBarController?.selectedIndex = 4
//        UIView.animate(withDuration: 2) {
//        newTabBarViewController.SharedInstance.moveto(index: sender.tag )
            
//        print("asdf")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sendData"), object: nil, userInfo: imageDataDict)

//        }
        
        
         // `default` is now a property, not a method call

        // Register to receive notification in your class
       
        // handle notification
       
//        self.tabBarController?.selectedIndex = 4
        
    }
   
}
