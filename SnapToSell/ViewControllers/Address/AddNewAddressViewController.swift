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




class AddNewAddressViewController: UIViewController , CLLocationManagerDelegate ,UITextFieldDelegate{

    
    @IBOutlet weak var contactName: UITextField!
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var apt: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var zip: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var phones: UITextField!
//    @IBOutlet weak var latitude: SkyFloatingLabelTextField!
//    @IBOutlet weak var longitude: SkyFloatingLabelTextField!
    
    @IBOutlet weak var defaultAddress: UISwitch!
    
    @IBOutlet weak var save: UIButton!
    
    var type = String()
    var isdefault = String()
    var orderId = String()
    var locationManager = CLLocationManager()
    
    var address : AddressesModel = AddressesModel()
    var phone = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBG()
//        self.backBtn()
        self.hideKeyboardWhenTappedAround()
        if self.isdefault == "yes"{
            self.defaultAddress.isOn = true
        }
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            
        }
        
        if type == "update"{
            self.save.setTitle("Update", for: .normal)
            
            self.phone = true
            self.contactName.text = self.address.contact_name
            self.street.text = self.address.street
            self.apt.text = self.address.apartment
            self.city.text = self.address.city
            self.zip.text = self.address.zip
            self.state.text = self.address.state
            self.phones.text = self.address.phone
//            self.latitude.text = self.address.latitude
//            self.longitude.text = self.address.longitude
            if self.address.is_default! {
                self.defaultAddress.isOn = true
            }
            
        }
        
        
        self.designTextField(textField: self.contactName)
        self.designTextField(textField: self.street)
        self.designTextField(textField: self.apt)
        self.designTextField(textField: self.city)
        self.designTextField(textField: self.zip)
        self.designTextField(textField: self.state)
        self.designTextField(textField: self.phones)
        
        phones.delegate = self
        
//        PlaygroundPage.current.needsIndefiniteExecution = true
        // Do any additional setup after loading the view.
    }
    
    
    func designTextField(textField : UITextField)  {
        
        textField.layer.masksToBounds = false
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.addShadow()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == phones {
            
            
            let txt = testFormat(sourcePhoneNumber: phones.text!)
            phones.text = txt
        }
    }
 
    func testFormat(sourcePhoneNumber: String) -> String {
        if let formattedPhoneNumber = format(phoneNumber: sourcePhoneNumber) {
            phone = true
            return "\(formattedPhoneNumber)"
            
        }
        else {
            phone = false
            return "\(sourcePhoneNumber)"
        }
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
        
        self.zip.text = self.zip.text?.trimmingCharacters(in: .whitespaces)
        self.contactName.text = self.contactName.text?.trimmingCharacters(in: .whitespaces)
        self.street.text = self.street.text?.trimmingCharacters(in: .whitespaces)
        self.city.text = self.city.text?.trimmingCharacters(in: .whitespaces)
        self.state.text = self.state.text?.trimmingCharacters(in: .whitespaces)
        self.phones.text = self.phones.text?.trimmingCharacters(in: .whitespaces)
       
        
        
        if self.contactName.text == ""{
            flag = false
            self.showToast(message: "Please enter contactName")
        }else if self.street.text == ""{
            flag = false
            self.showToast(message: "Please enter street")
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
        }else if self.phone == false{
            self.showToast(message: "Please enter a valid phone number")
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
            phone: self.phones.text!,
            is_default: defaultAddrss , success: { (response) in
            
            SVProgressHUD.dismiss()
            self.navigationController?.popViewController(animated: true)
            print(response)
                Utilites.ShowAlert(title: "!!!", message: "Address added successfully", view: self)
            
            
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
            phone: self.phones.text!,
            is_default: defaultAddrss , success: { (response) in
                
                SVProgressHUD.dismiss()
                
                print(response)
                if (response.message != nil){
                     Utilites.ShowAlert(title: "!!!", message: response.message!, view: self)
                }else{
                    self.navigationController?.popViewController(animated: true)
                     Utilites.ShowAlert(title: "Success", message: "Address updated Successfully", view: self)
                    
                }
//                self.navigationController?.popViewController(animated: true)
                
                
                
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
        
//        self.latitude.text = "\(String(describing: locationManager.location!.coordinate.latitude))"
//        self.longitude.text = "\(String(describing: locationManager.location!.coordinate.longitude))"
        
        fetchCityAndCountry(from: locationManager.location!) { (city, cuntry,plac,  err) in
            self.zip.text = plac?.postalCode ?? ""
            self.city.text = city ?? ""
        }
    }
    
    
    
    func format(phoneNumber sourcePhoneNumber: String) -> String? {
        // Remove any character that is not a number
        let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let length = numbersOnly.count
        let hasLeadingOne = numbersOnly.hasPrefix("1")
        
        // Check for supported phone number length
        guard length == 7 || length == 10 || (length == 11 && hasLeadingOne) else {
            return nil
        }
        
        let hasAreaCode = (length >= 10)
        var sourceIndex = 0
        
        // Leading 1
        var leadingOne = ""
        if hasLeadingOne {
            leadingOne = "1 "
            sourceIndex += 1
        }
        
        // Area code
        var areaCode = ""
        if hasAreaCode {
            let areaCodeLength = 3
            guard let areaCodeSubstring = numbersOnly.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
                return nil
            }
            areaCode = String(format: "(%@) ", areaCodeSubstring)
            sourceIndex += areaCodeLength
        }
        
        // Prefix, 3 characters
        let prefixLength = 3
        guard let prefix = numbersOnly.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return nil
        }
        sourceIndex += prefixLength
        
        // Suffix, 4 characters
        let suffixLength = 4
        guard let suffix = numbersOnly.substring(start: sourceIndex, offsetBy: suffixLength) else {
            return nil
        }
        
        return leadingOne + areaCode + prefix + "-" + suffix
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}




extension String {
    /// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster).
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        
        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[substringStartIndex ..< substringEndIndex])
    }
    
    
    
    
}
