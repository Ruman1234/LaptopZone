//
//  AddNewAddressViewController.swift
//  SnapToSell
//
//  Created by Apple on 8/23/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SVProgressHUD
import CoreLocation
import MapKit




class AddNewAddressViewController: UIViewController , CLLocationManagerDelegate {

    
    @IBOutlet weak var contactName: SkyFloatingLabelTextField!
    @IBOutlet weak var street: SkyFloatingLabelTextField!
    @IBOutlet weak var apt: SkyFloatingLabelTextField!
    @IBOutlet weak var city: SkyFloatingLabelTextField!
    @IBOutlet weak var zip: SkyFloatingLabelTextField!
    @IBOutlet weak var state: SkyFloatingLabelTextField!
    @IBOutlet weak var phones: SkyFloatingLabelTextField!
    @IBOutlet weak var latitude: SkyFloatingLabelTextField!
    @IBOutlet weak var longitude: SkyFloatingLabelTextField!
    
    @IBOutlet weak var defaultAddress: UISwitch!
    
    @IBOutlet weak var save: UIButton!
    
    var type = String()
    var orderId = String()
    var locationManager = CLLocationManager()
    
    var address : AddressesModel = AddressesModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            
        }
        
        if type == "update"{
            self.save.setTitle("Update", for: .normal)
            
            
            self.contactName.text = self.address.contact_name
            self.street.text = self.address.street
            self.apt.text = self.address.apartment
            self.city.text = self.address.city
            self.zip.text = self.address.zip
            self.state.text = self.address.state
            self.phones.text = self.address.phone
            self.latitude.text = self.address.latitude
            self.longitude.text = self.address.longitude
            if self.address.is_default! {
                self.defaultAddress.isOn = true
            }
            
        }
        
//        PlaygroundPage.current.needsIndefiniteExecution = true
        // Do any additional setup after loading the view.
    }
    
    
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ placemarks: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       placemarks?.first,
                       error)
            print(placemarks?.first)
           
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    
    func validInput() -> Bool {
        var flag = true
        
        if self.contactName.text == ""{
            flag = false
            self.showToast(message: "Please enter contactName")
        }else if self.street.text == ""{
            flag = false
            self.showToast(message: "Please enter street")
        }else if self.apt.text == ""{
            self.showToast(message: "Please enter apt")
            flag = false
        }else if self.city.text == ""{
            self.showToast(message: "Please enter city")
            flag = false
        }else if self.zip.text == ""{
            self.showToast(message: "Please enter zip")
            flag = false
        }else if self.state.text == ""{
            self.showToast(message: "Please enter state")
            flag = false
        }else if self.phones.text == ""{
            self.showToast(message: "Please enter phones")
            flag = false
        }
        
        return flag
    }

    func addnewAddress()  {
        
        var defaultAddrss = Int()
        
        if self.defaultAddress.isOn {
            defaultAddrss = 1
        }else{
            defaultAddrss = 0
        }
        
        SVProgressHUD.show(withStatus: "Loading..")
        NetworkManager.SharedInstance.AddNewAddress(
            contact_name: self.contactName.text!,
            street: self.street.text!,
            apartment: self.apt.text!,
            city: self.city.text!,
            state: self.state.text!,
            zip: self.zip.text!,
            phone: self.contactName.text!,
            is_default: defaultAddrss ,
            latitude: self.latitude.text!,
            longitude: self.latitude.text!, success: { (response) in
            
            SVProgressHUD.dismiss()
            self.navigationController?.popViewController(animated: true)
            print(response)
                Utilites.ShowAlert(title: "!!!", message: response.message!, view: self)
            
            
        }) { (error) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!", message: "something went wrong", view: self)
        }
        
    }
    
    
    func UpdateAddress(id : String)  {
        
        var defaultAddrss = Int()
        
        if self.defaultAddress.isOn {
            defaultAddrss = 1
        }else{
            defaultAddrss = 0
        }
        
        SVProgressHUD.show(withStatus: "Loading..")
        NetworkManager.SharedInstance.UpdateAddress(
            id: id,
            contact_name: self.contactName.text!,
            street: self.street.text!,
            apartment: self.apt.text!,
            city: self.city.text!,
            state: self.state.text!,
            zip: self.zip.text!,
            phone: self.contactName.text!,
            is_default: defaultAddrss ,
            latitude: self.latitude.text!,
            longitude: self.latitude.text!, success: { (response) in
                
                SVProgressHUD.dismiss()
                
                print(response)
                if (response.message != nil){
                     Utilites.ShowAlert(title: "!!!", message: response.message!, view: self)
                }else{
                    self.navigationController?.popViewController(animated: true)
                     Utilites.ShowAlert(title: "Success", message: "Address updated Successfully", view: self)
                    
                }
                self.navigationController?.popViewController(animated: true)
               
                
                
        }) { (error) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!", message: "something went wrong", view: self)
        }
        
    }
    
    @IBAction func saveBtn(_ sender: Any) {
     
        if self.validInput(){
            if self.type == "update"{
                self.UpdateAddress(id: "\(self.address.id!)")
            }else{
                self.addnewAddress()
            }
            
        }
        
    }
    
    
    @IBAction func locationBtn(_ sender: Any) {
        
        print(locationManager.location!.coordinate.latitude)
        print(locationManager.location!.coordinate.longitude)
        
        self.latitude.text = "\(String(describing: locationManager.location!.coordinate.latitude))"
        self.longitude.text = "\(String(describing: locationManager.location!.coordinate.longitude))"
        
        fetchCityAndCountry(from: locationManager.location!) { (city, cuntry,plac,  err) in
            self.zip.text = plac?.postalCode ?? ""
            self.city.text = city ?? ""
        }
    }
    
    
}
