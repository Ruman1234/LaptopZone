
//
//  DefaultAddressViewController.swift
//  SnapToSell
//
//  Created by Apple on 8/29/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD

class DefaultAddressViewController: UIViewController {

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var aptStreet: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var zip: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var checkAvailbility: UIButton!
    
    @IBOutlet weak var continueBtn: UIButton!
    
    var address = AddressesModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDefaultAddress()
        if Constants.CheckAvailbility  {
            self.continueBtn.isHidden = true
            self.continueBtn.isEnabled = false
        }else{
            self.checkAvailbility.isEnabled = false
            self.checkAvailbility.isHidden = true
        }
        
        self.addBG()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.address = Constants.address
        if Constants.CheckAvailbility  {
            self.checkAvailbility.isEnabled = true
            self.checkAvailbility.isHidden = false
            
        }else{
            self.continueBtn.isHidden = false
            self.continueBtn.isEnabled = true
        }
        if (self.address.contact_name != nil)  {
            
            
            Constants.addressId = "\(self.address.id!)"
            self.name.text = address.contact_name
            self.aptStreet.text = (address.apartment ?? "") + "," + (address.street ?? "")
            self.city.text = address.city
            self.state.text = address.state
            self.zip.text = address.zip
            self.number.text = address.phone
        }
    }
    
    func getDefaultAddress()  {
        SVProgressHUD.show(withStatus: "Loading..")
        NetworkManager.SharedInstance.getDefaultAddress(success: { (response) in
            print(response)
            SVProgressHUD.dismiss()
            if (response.contact_name != nil){
                Constants.address = response
                Constants.addressId = "\(response.id!)"
                self.address = response
                self.name.text = response.contact_name
                self.aptStreet.text = (response.apartment ?? "") + "," + (response.street ?? "")
                
                self.city.text = response.city
                self.state.text = response.state
                self.zip.text = response.zip
                self.number.text = response.phone
                
            }else{
                Utilites.ShowAlert(title: "Error!!!", message: response.message!, view: self)
                
                if Constants.CheckAvailbility  {
                    NotificationCenter.default.post(name: Notification.Name("changeBtn"), object: nil)
                    
                }else{
                    NotificationCenter.default.post(name: Notification.Name("changeBtnshipment"), object: nil)
                }
                
                
                self.continueBtn.isHidden = true
                self.continueBtn.isEnabled = false
            }
            
            
        }) { (error) in
            Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
        }
    }

    
    @IBAction func changeBtn(_ sender: Any) {
        
        
        if Constants.CheckAvailbility  {
            self.checkAvailbility.isEnabled = true
            self.checkAvailbility.isHidden = false
            self.continueBtn.isHidden = true
            self.continueBtn.isEnabled = false
            NotificationCenter.default.post(name: Notification.Name("changeBtn"), object: nil)
            
        }else{
             NotificationCenter.default.post(name: Notification.Name("changeBtnshipment"), object: nil)
        }
        
      
    }
    
    
    
    @IBAction func checkAvailbility(_ sender: Any) {
        if self.address.id == nil{
            Utilites.ShowAlert(title: "Error!!!", message: "kindly add a address", view: self)
            return
        }
        
        SVProgressHUD.show(withStatus: "Loading..")
        NetworkManager.SharedInstance.checkAvailbility(id: "\(String(describing: self.address.id!))", success: { (res) in
            print(res)
            SVProgressHUD.dismiss()
            if res == 1{

                self.continueBtn.isHidden = false
                self.continueBtn.isEnabled = true
                
                self.checkAvailbility.isEnabled = false
                self.checkAvailbility.isHidden = true
                
                Constants.addressId = "\(String(describing: self.address.id!))"
            }else{
                Utilites.ShowAlert(title: "Oppsss!!", message: "We are not availble in this area", view: self)
            }
            
        }) { (err) in
            Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
        }
    }
    
    @IBAction func continueBtn(_ sender: Any) {
        if Constants.CheckAvailbility  {
            NotificationCenter.default.post(name: Notification.Name("nextStepPickup"), object: nil)
            SVProgressHUD.show(withStatus: "Loading..")
            NetworkManager.SharedInstance.requestPickup(request_id: Constants.requestId, address_id: Constants.addressId, success: { (res) in
                SVProgressHUD.dismiss()
                print(res)
                
                 NotificationCenter.default.post(name: Notification.Name("backStepPickup"), object: nil)
                
                Utilites.ShowAlert(title: "Success", message: "product is added to pickup", view: self)

                
            }) { (err) in
                Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
            }
        }else{
            
            NotificationCenter.default.post(name: Notification.Name("nextStepShipment"), object: nil)
        }
        
        
    }
    
}