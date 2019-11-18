//
//  SelectdeliveryMethodViewController.swift
//  SnapToSell
//
//  Created by Apple on 10/16/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON

import MapKit

class SelectdeliveryMethodViewController: UIViewController,SelectShipmentViewDelegate  , UITextFieldDelegate, MKLocalSearchCompleterDelegate,ShowImageViewDelegate{
   
    
        
    @IBOutlet weak var chequeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var virw: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var mainviewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var amazonDetailHeight: NSLayoutConstraint!
    
    @IBOutlet weak var paypalViewHeight: NSLayoutConstraint!
    @IBOutlet weak var amazonView: UIView!
    
//    @IBOutlet weak var pickupStreetAddress: UITextField!
    @IBOutlet weak var pickupSearchAddress: UITextField!
    
    @IBOutlet weak var pickupStreetAddress: UITextField!
    @IBOutlet weak var pickupCity: UITextField!
    @IBOutlet weak var pickupState: UITextField!
    
    @IBOutlet weak var pickUpzipcode: UITextField!
    
    
    @IBOutlet weak var dropOffBtn: UIButton!
    @IBOutlet weak var pickUpBtn: UIButton!
    
    
    @IBOutlet weak var chequeRadioImage: UIImageView!
    @IBOutlet weak var paypalRadioImage: UIImageView!
    @IBOutlet weak var amazonRadiouimage: UIImageView!
    
    
    @IBOutlet weak var dropoffopenBtn: UIButton!
    
    @IBOutlet weak var pickupopenBnt: UIButton!
    @IBOutlet weak var shipmentopenBtn: UIButton!
    
    @IBOutlet weak var shipmentAdsres: UITextField!
    
    @IBOutlet weak var shipmentLength: UITextField!
    
    @IBOutlet weak var shipmentWidth: UITextField!
    
    @IBOutlet weak var shipmentHeight: UITextField!
    
    @IBOutlet weak var shipmentWeight: UITextField!
    

    
    @IBOutlet weak var shipmentnextBtn: UIButton!
    
    var paypalEmail = String()
    var chequeEmail = String()
    
    var chequePayabito = String()

    var chequeAddress = String()
    var chequeAddress2 = String()
    var chequecity = String()
    var chequestate = String()
    var chequezipcode = String()
    var chequecountry = String()
    var area = String()
    
    
    var shipmentZip = String()
    var shipmentCity = String()
    var shipmentStreet = String()
    var shipmentState = String()
    var shipmentPhone = String()
    
    var paymentMode = String()
    var selectOption = String()
    var countryName = String()
    let tableView = UITableView()
//    let tableView2 = UITableView()
    
    var placeIDArray = [String]()
    var resultsArray = [String]()
    var primaryAddressArray = [String]()
    var searchResults = [String]()
    var searhPlacesName = [String]()
     
    var request_id = String()
    var rates = [Rates]()
    var selectShipment : SelectShipmentView!
    var imgView : ShowImageView!
    
    
    var type = String()
    var repRecId = String()
    lazy var searchCompleter: MKLocalSearchCompleter = {
           let sC = MKLocalSearchCompleter()
           sC.delegate = self
           return sC
       }()

       var searchSource: [String]?
    
    
    
    let imageView = UIImageView(image: UIImage(named: "no_net (1)"))
                                     let button = UIButton(type: UIButton.ButtonType.system) as UIButton

                               
                            @objc func buttonAction(_ sender:UIButton!)
                               {
                                   if Utilites.isInternetAvailable() {
                                       self.imageView.isHidden = true
                                       self.button.isHidden = true
                           //            self.viewWillAppear(true)
//                                       self.callApi(id: self.id)
                                   }else{
                                       self.showToast(message: "Internet is not availble")
                                   }
                               }
    
    override func loadView() {
      super.loadView()
//        setupTableView()
//        setupTableView2()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCompleter.delegate = self
        
        self.shipmentAdsres.delegate = self
        self.pickupSearchAddress.delegate = self
      
        self.tableView.isHidden = true
//        self.tableView2.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
          
              self.addBG()
              self.addPAger(totalPage: 7, currentPage: 6)
              self.cancleBtn()
              self.backBtn()
              
              
              self.dropOffBtn.setGradient()
              self.pickUpBtn.setGradient()
              self.shipmentnextBtn.setGradient()
        self.shipmentnextBtn.isHidden = true
    }
    
    func setupTableView(y : CGFloat) {
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
       virw.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
       tableView.translatesAutoresizingMaskIntoConstraints = false
        
//        tableView.frame = CGRect(x: 21, y: y, width: self.shipmentAdsres.frame.width, height: 300)
        
        tableView.frame = CGRect(x: 21, y: y, width: self.shipmentAdsres.frame.width, height: 300)
        
//        self.tableView.isHidden = true
     }
    
  
        
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if Utilites.isInternetAvailable(){
            if textField == self.shipmentAdsres {
                self.tableView.isHidden = false
                let point = CGPoint(x: 0, y: 410 )
                scrollView.contentOffset = point
            //            searchCompleter.queryFragment = self.shipmentAdsres.text!
                placeAutocomplete(text_input: self.shipmentAdsres.text!)
            }else if textField == self.pickupSearchAddress{
                
                self.tableView.isHidden = false
                
                let point = CGPoint(x: 0, y: 300 )
                scrollView.contentOffset = point
                
                placeAutocomplete(text_input: self.pickupSearchAddress.text!)
            }
        }
       
        
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        if Utilites.isInternetAvailable(){
             if textField == self.shipmentAdsres {
                        self.tableView.isHidden = false
                        
            //            searchCompleter.queryFragment = self.shipmentAdsres.text!
                        placeAutocomplete(text_input: self.shipmentAdsres.text!)

                    }else if textField == self.pickupSearchAddress{
                        self.tableView.isHidden = false
                        placeAutocomplete(text_input: self.shipmentAdsres.text!)
                    }
        }
       
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.shipmentAdsres && self.shipmentAdsres.text == ""{
            self.tableView.isHidden = true
        }else if textField == self.pickupSearchAddress && self.pickupSearchAddress.text == ""{
            self.tableView.isHidden = true
        }

    }
    
    @IBAction func amazonBtn(_ sender: AnyObject) {
        
        if sender.tag == 0 {
            self.dropoffopenBtn.tag = 1
            self.view.layoutIfNeeded()
                   

            if #available(iOS 13.0, *) {
               self.amazonRadiouimage.image = UIImage(systemName: "largecircle.fill.circle")
                self.paypalRadioImage.image = UIImage(systemName: "circle")
                self.chequeRadioImage.image = UIImage(systemName: "circle")
               
            } else {
               // Fallback on earlier versions
            }

            self.amazonDetailHeight.constant = 429
            self.mainviewHeight.constant = self.view.frame.height + 429
            self.paypalViewHeight.constant = 0
            self.chequeViewHeight.constant = 0
            self.shipmentnextBtn.isHidden = true
            UIView.animate(withDuration: 0.5, animations: {

                self.view.layoutIfNeeded()

            })
        }else{
            self.dropoffopenBtn.tag = 0
            self.view.layoutIfNeeded()
                   

            if #available(iOS 13.0, *) {
               self.amazonRadiouimage.image = UIImage(systemName: "circle")
                self.paypalRadioImage.image = UIImage(systemName: "circle")
                self.chequeRadioImage.image = UIImage(systemName: "circle")
               
            } else {
               // Fallback on earlier versions
            }

            self.amazonDetailHeight.constant = 0
            self.mainviewHeight.constant = self.view.frame.height + 0
            self.paypalViewHeight.constant = 0
            self.chequeViewHeight.constant = 0
            UIView.animate(withDuration: 0.5, animations: {

                self.view.layoutIfNeeded()

            })
        }
        
       
    }
    

    
//
    @IBAction func paypalView(_ sender: AnyObject) {
        if sender.tag == 0 {
            self.pickupopenBnt.tag = 1
            self.selectOption = "2"
             self.view.layoutIfNeeded()
             
             if #available(iOS 13.0, *) {
                self.paypalRadioImage.image = UIImage(systemName: "largecircle.fill.circle")
                 
                 self.amazonRadiouimage.image = UIImage(systemName: "circle")
                 self.chequeRadioImage.image = UIImage(systemName: "circle")
                           
            } else {
                // Fallback on earlier versions
            }
           
            self.setupTableView(y: 360)

             self.textFieldBorder(textField: self.pickupCity)
             self.textFieldBorder(textField: self.pickupStreetAddress)
             self.textFieldBorder(textField: self.pickUpzipcode)
             self.textFieldBorder(textField: self.pickupState)
            
             self.mainviewHeight.constant = self.view.frame.height + 797
             self.paypalViewHeight.constant = 797
             self.amazonDetailHeight.constant = 0
             self.chequeViewHeight.constant = 0
             self.shipmentnextBtn.isHidden = true
             UIView.animate(withDuration: 0.5, animations: {

                 self.view.layoutIfNeeded()

             })

        }else{
            self.pickupopenBnt.tag = 0
             self.view.layoutIfNeeded()
             
             if #available(iOS 13.0, *) {
                self.paypalRadioImage.image = UIImage(systemName: "circle")
                 
                 self.amazonRadiouimage.image = UIImage(systemName: "circle")
                 self.chequeRadioImage.image = UIImage(systemName: "circle")
                           
            } else {
                // Fallback on earlier versions
            }

             self.textFieldBorder(textField: self.pickupCity)
             self.textFieldBorder(textField: self.pickupStreetAddress)
             self.textFieldBorder(textField: self.pickUpzipcode)
             self.textFieldBorder(textField: self.pickupState)
            
             self.mainviewHeight.constant = self.view.frame.height + 0
             self.paypalViewHeight.constant = 0
             self.amazonDetailHeight.constant = 0
             self.chequeViewHeight.constant = 0
             
             UIView.animate(withDuration: 0.5, animations: {

                 self.view.layoutIfNeeded()

             })

        }
        
    }
    
    
    
    
    
    @IBAction func chequeViewBtn(_ sender: AnyObject) {
        
        if sender.tag == 0 {
             self.shipmentopenBtn.tag = 1
             self.view.layoutIfNeeded()
             self.setupTableView(y: 500)
             if #available(iOS 13.0, *) {
                 
                   self.chequeRadioImage.image = UIImage(systemName: "largecircle.fill.circle")
                 
                 self.paypalRadioImage.image = UIImage(systemName: "circle")
                 self.amazonRadiouimage.image = UIImage(systemName: "circle")
                           
             } else {
                   // Fallback on earlier versions
             }
            
            
             self.textFieldBorder(textField: self.shipmentAdsres)
             self.textFieldBorder(textField: self.shipmentLength)
             self.textFieldBorder(textField: self.shipmentWidth)
             self.textFieldBorder(textField: self.shipmentHeight)
             self.textFieldBorder(textField: self.shipmentWeight)

            self.mainviewHeight.constant = self.view.frame.height + 649
            self.paypalViewHeight.constant = 0
            self.amazonDetailHeight.constant = 0
            self.chequeViewHeight.constant = 649
            self.shipmentnextBtn.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {

                self.view.layoutIfNeeded()

            })

        }else{
             self.shipmentopenBtn.tag = 0
             self.view.layoutIfNeeded()
             
             if #available(iOS 13.0, *) {
                 
                   self.chequeRadioImage.image = UIImage(systemName: "circle")
                 
                 self.paypalRadioImage.image = UIImage(systemName: "circle")
                 self.amazonRadiouimage.image = UIImage(systemName: "circle")
                           
             } else {
                   // Fallback on earlier versions
             }
             

            self.mainviewHeight.constant = self.view.frame.height + 0
            self.paypalViewHeight.constant = 0
            self.amazonDetailHeight.constant = 0
            self.chequeViewHeight.constant = 0
            UIView.animate(withDuration: 0.5, animations: {

                self.view.layoutIfNeeded()

            })

        }
               
        
    }
    
    
    
    func textFieldBorder(textField: UITextField)  {
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
    }
    
    func pickpValidInput() -> Bool {
        var flag = true
        
        if self.pickupSearchAddress.text == "" {
            flag = false
            self.showToast(message: "Please enter Address")
        }else if self.pickupStreetAddress.text == "" {
            flag = false
            self.showToast(message: "Please enter Street Address")
        }else if self.pickupCity.text == "" {
            flag = false
            self.showToast(message: "Please enter City")
        }else if self.pickupState.text == "" {
            flag = false
            self.showToast(message: "Please enter State Address")
        }else if self.pickUpzipcode.text == "" {
            flag = false
            self.showToast(message: "Please enter Zipcode Address")
        }
        
        
        return flag
    }
    
    @IBAction func dropoffbtn(_ sender: Any) {
        
        if self.type == "rec"{
            sendRepRecRequest()
        }else{
            self.selectOption = "1"
            self.countryName = "United States"
            self.sendRequest()
        }
        
    }
    
    
    func sendRepRecRequest()  {
        SVProgressHUD.show(withStatus: "Loading...")
        let parameters = ["getRadioVale" : "1",
                            "requestId" : repRecId,
                            "user_id" : CustomUserDefaults.userId.value!]
        
        NetworkManager.SharedInstance.setRepRecProceed(pra: parameters, success: { (res) in
            SVProgressHUD.dismiss()
            
            print(res)
            Utilites.ShowAlert(title: "Success", message: "Your request has been received we will contact you ASAP", view: self) { (res) in
                let a = self.navigationController?.viewControllers[0] as! newTabBarViewController
                
                self.navigationController?.popToViewController(a, animated: true)

            }
        }) { (err) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
        }
    }
    
    func sendRequest()  {
            
        SVProgressHUD.show(withStatus: "Loading...")
            
       let parameters = ["product_name" : Constants.productName,
                         "brand_name" : Constants.brand_name,
                         "series_name" : Constants.series_name,
                         "model_name" : Constants.model_name,
                         "carrier_name" : Constants.carrier_name,
                         "storage_name" : Constants.storage_name,
                         "answer_ids" : Constants.answer_ids,
                         "gevin_offer" : Constants.gevin_offer,
                         "available_offer" : Constants.available_offer,
                         "select_option" : self.selectOption,
                         "payment_mode"  : self.paymentMode,
                         "paypalEmail" : self.paypalEmail,
                         "payable_to" : self.chequePayabito,
                         "email_address" : self.chequeEmail,
                         "address1" : self.chequeAddress,
                         "address2" : self.chequeAddress2,
                         "cityName" : self.chequecity,
                         "stateName" : self.chequestate,
                         "zipCode" : self.chequezipcode,
                         "countryName" : self.countryName,
                         "pick_address" : self.shipmentStreet,
                         "pick_area" : self.shipmentCity,
                         "pick_city" : self.shipmentCity,
                         "pick_state" : self.shipmentState,
                         "pick_zipcode" : self.shipmentZip,
                         "user_id" : CustomUserDefaults.userId.value!]
        

        print(parameters)
        NetworkManager.SharedInstance.dropOff(pra:parameters, success: { (res) in
            
            SVProgressHUD.dismiss()
           
            
            if self.selectOption != "3" {
                if #available(iOS 13.0, *) {
                    let a = self.navigationController?.viewControllers[0] as! HomeViewController
                    self.navigationController?.popToViewController(a, animated: true)
                } else {
                    // Fallback on earlier versions
                }
//                self.navigationController?.popToViewController(a, animated: true)
                       
                Utilites.ShowAlert(title: "Success!!", message: "Your request has been received we will contact you ASAP", view: self)
            }else{
                if (res.data != nil){
                   self.request_id = res.data!
                   self.addView(rate: self.rates)
                }
            }
          
            
        }) { (err) in
            
            SVProgressHUD.dismiss()
            
            Utilites.ShowAlert(title: "Error!!", message: "Something went wrong", view: self)
        }
    }
    
    func didClose() {
          self.selectShipment.removeFromSuperview()
                  
          UIView.animate(withDuration: 0.3) {

              self.selectShipment.alpha = 0
              self.selectShipment = nil
          }
      }
      
    
    func didCloseImgView() {
        self.imgView.removeFromSuperview()
                
        UIView.animate(withDuration: 0.3) {

            self.imgView.alpha = 0
            self.imgView = nil
            if #available(iOS 13.0, *) {
                Utilites.ShowAlert(title: "!!!", message: "Image downloaded", view: self) { (res) in
                    if self.type == "rec"{
                        let a = self.navigationController?.viewControllers[0] as! newTabBarViewController
                        self.navigationController?.popToViewController(a, animated: true)

                    }else{
                        let a = self.navigationController?.viewControllers[0] as! HomeViewController
                        self.navigationController?.popToViewController(a, animated: true)

                    }

                }
            } else {
                // Fallback on earlier versions
            }
            

        }
        
    }
    

    
 
    func didClose(text: String, id: String) {
        self.selectShipment.removeFromSuperview()
                
        UIView.animate(withDuration: 0.3) {

            self.selectShipment.alpha = 0
            self.selectShipment = nil
        }
        SVProgressHUD.show(withStatus: "Loading...")
        
        var request_type = String()
        
        if self.type == "rec" {
            request_type = "REPAIRING"
        }else{
            request_type = "BUY_SELL"
        }
        
        let parameters = ["shipment_id" : id,
                            "rate_id" : text,
                            "request_id" : self.request_id,
                            "request_type" : request_type]
        
        NetworkManager.SharedInstance.getShipmentImage(pra: parameters, success: { (res) in
            print(res)
            
            
            let remoteImageURL = URL(string: res.label_remote_url!)!
             
                      // Use Alamofire to download the image
            Alamofire.request(remoteImageURL).responseData { (response) in
                SVProgressHUD.dismiss()
              if response.error == nil {
                    print(response.result)

                
                    if let data = response.data {
                        let img = UIImage(data: data)
//                        UIImageWriteToSavedPhotosAlbum(img!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
//                         elf.downloadImage.image = UIImage(data: data)
                        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (time) in
                            if img != nil {
                                self.addImageView(img: img!)
                            }
                        }
                    }
                }
            }
            
            
        }) { (err) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
        }
        
    }
      
    func addImageView(img : UIImage)  {
          if self.imgView == nil {
              self.imgView = nil
              self.imgView = (Bundle.main.loadNibNamed("ShowImageView", owner: self, options: nil)![0] as! ShowImageView)
              
              self.imgView.delegate = self
            self.imgView.img = img
            self.imgView.image.image = img
//            self.imgView.rates = rate
            
              self.imgView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                         
             self.view.addSubview(imgView)
             UIView.animate(withDuration: 0.3) {

                 self.imgView.alpha = 1
             }
          }
      }
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            
            if #available(iOS 13.0, *) {
                let a = self.navigationController?.viewControllers[0] as! HomeViewController
                self.navigationController?.popToViewController(a, animated: true)

            } else {
                // Fallback on earlier versions
            }
                      
            
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            
            
            present(ac, animated: true)
            
          
            
        }
    }
    
    
    
    
    func addView(rate : [Rates])  {
          if self.selectShipment == nil {
              self.selectShipment = nil
              self.selectShipment = (Bundle.main.loadNibNamed("SelectShipmentViewController", owner: self, options: nil)![0] as!  SelectShipmentView)
              
              self.selectShipment.delegate = self
            self.selectShipment.rates = rate
            
              self.selectShipment.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                         
             self.view.addSubview(selectShipment)
             UIView.animate(withDuration: 0.3) {

                 self.selectShipment.alpha = 1
             }
          }
      }
    
    func shipmentValidInput() -> Bool {
        var flag = true
        
        if self.shipmentAdsres.text == "" {
            flag = false
            self.showToast(message: "Please add shipment address")
        }else if self.shipmentLength.text == "" {
            flag = false
            self.showToast(message: "Please add shipment length")
        }else if self.shipmentWidth.text == "" {
            flag = false
            self.showToast(message: "Please add shipment width")
        }else if self.shipmentHeight.text == "" {
            flag = false
            self.showToast(message: "Please add shipment height")
        }else if self.shipmentWeight.text == "" {
            flag = false
            self.showToast(message: "Please add shipment weight")
        }
        
        return flag
    }
    
    @IBAction func sipmentNextBtn(_ sender: Any) {
        
        if self.shipmentValidInput(){
            
            SVProgressHUD.show(withStatus: "Loading...")
            
            self.selectOption = "3"

            let parameters = ["weight" : self.shipmentWeight.text!,
            "length" : self.shipmentLength.text!,
            "width" : self.shipmentWidth.text!,
            "height" : self.shipmentHeight.text!,
            "city" : self.shipmentCity,
            "zip" : self.shipmentZip,
            "street" : self.shipmentStreet,
            "state" : self.shipmentState,
            "phone" : "+1539888550"]
//            "getradio" : "2",
            NetworkManager.SharedInstance.getShipmentRates(pra: parameters, success: { (res) in
                SVProgressHUD.dismiss()
                print(res)
                self.rates = res.rates!
                
                if self.type == "rec"{
                    print("Asdf")
                    
                    self.saveRepairShipment()
                }else{
                    self.sendRequest()
                }
                
            }) { (err) in
                SVProgressHUD.dismiss()
                Utilites.ShowAlert(title: "Error!!", message: "Something went wrong", view: self)
            }
           
        }
        
    }
    
    func saveRepairShipment()  {
        print(self.repRecId)
        print(self.request_id)
        
         let parameters = ["getRadioVale" : "3",
                           "requestId" : self.repRecId,
                   ]
        //            "getradio" : "2",
            NetworkManager.SharedInstance.saveRepairRequest(pra: parameters, success: { (res) in
                
                SVProgressHUD.dismiss()
                
                print(res)
                
                self.request_id = self.repRecId
                self.addView(rate: self.rates)
                
            }) { (err) in
                SVProgressHUD.dismiss()
                Utilites.ShowAlert(title: "Error!!", message: "Something went wrong", view: self)
            }
    }
    
//    func sendRepRecshipmentRequest()  {
//        SVProgressHUD.show(withStatus: "Loading...")
//
//      shipment_id: shp_02a47ff54c9749e2984bd49520933870
//      rate_id: rate_38308f6ce7b6470f85c577896b843fef
//      request_id: REP-000142
//      request_type: REPAIRING
//
//        let parameters = [
//            "shipment_id" : self.shipmentStreet,
//            "rate_id" : self.shipmentStreet,
//            "request_id" : self.shipmentStreet,
//            "request_type" : self.shipmentStreet]
//        print(parameters)
//        NetworkManager.SharedInstance.setRepRecPickup(pra: parameters, success: { (res) in
//            SVProgressHUD.dismiss()
//
//            print(res)
//            Utilites.ShowAlert(title: "Success", message: "Your request has been received we will contact you ASAP", view: self) { (res) in
//                let a = self.navigationController?.viewControllers[0] as! newTabBarViewController
//
//                self.navigationController?.popToViewController(a, animated: true)
//
//            }
//        }) { (err) in
//            SVProgressHUD.dismiss()
//            Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
//        }
//    }
    
    
    func placeAutocomplete(text_input: String) {
            let placesClient = GMSPlacesClient()
           let filter = GMSAutocompleteFilter()
           
           filter.type = .establishment
           
           
           //geo bounds set for karntaka region
           let bounds = GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: 32.7767, longitude: 96.7970), coordinate: CLLocationCoordinate2D(latitude: 33.7490, longitude: 84.3880))
        
           placesClient.autocompleteQuery(text_input, bounds: bounds, filter: nil) { (results, error) -> Void in
               self.placeIDArray.removeAll()
               self.resultsArray.removeAll()
               self.primaryAddressArray.removeAll()
               if let error = error {
                   print("Autocomplete error \(error)")
                   return
               }
            
               if let results = results {
                   for result in results {
                    
                    print(result.types)
                    
                     self.primaryAddressArray.append(result.attributedPrimaryText.string)

                    self.resultsArray.append(result.attributedFullText.string)
                       self.primaryAddressArray.append(result.attributedPrimaryText.string)
                    self.placeIDArray.append(result.placeID)
                    
                   }
               }
            
            
               self.searchResults = self.resultsArray
               self.searhPlacesName = self.primaryAddressArray
               self.tableView.reloadData()
           }
       }
    
    
    @IBAction func pickUpNextBtn(_ sender: Any) {
        if self.type == "rec"{
            sendRepRecPickupRequest()
        }else{
            if pickpValidInput(){
                self.countryName = "United States"
                self.sendRequest()

            }

        }
    }
    
    
    func sendRepRecPickupRequest()  {
        SVProgressHUD.show(withStatus: "Loading...")
        
//        "pick_address" : self.shipmentStreet,
//        "pick_area" : self.shipmentCity,
//        "pick_city" : self.shipmentCity,
//        "pick_state" : self.shipmentState,
//        "pick_zipcode" : self.shipmentZip
//
        
        //        address: 2720 Royal Ln
           //        city: Dallas County
           //        area: Dallas
           //        state: Texas
           //        zipcode: 75229
           //        getRepareId: REP-000142
           //        getradio: 2


        let parameters = [  "address" : self.shipmentStreet,
                            "city" : self.shipmentCity,
                            "area" : self.shipmentCity,
                            "state" : self.shipmentState,
                            "zipcode" : self.shipmentZip,
                            "getRepareId" : self.repRecId,
                            "getradio" : "2",
         "user_id" : CustomUserDefaults.userId.value!]
        print(parameters)
        NetworkManager.SharedInstance.setRepRecPickup(pra: parameters, success: { (res) in
            SVProgressHUD.dismiss()
            
            print(res)
            Utilites.ShowAlert(title: "Success", message: "Your request has been received we will contact you ASAP", view: self) { (res) in
                let a = self.navigationController?.viewControllers[0] as! newTabBarViewController
                
                self.navigationController?.popToViewController(a, animated: true)

            }
        }) { (err) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
        }
    }
    
}

//
extension SelectdeliveryMethodViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.searchResults.count)
        return self.searchResults.count
//        print(self.searchSource?.count)
//        return searchSource?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = self.searchSource![indexPath.row]
        
        cell.textLabel?.text = self.searchResults[indexPath.row]
        
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.shipmentAdsres.text = self.searchSource![indexPath.row]
        self.tableView.isHidden = true
//        let address = self.searchSource![indexPath.row]
        if self.paypalViewHeight.constant == 0{
            self.shipmentAdsres.text = self.searchResults[indexPath.row]
        }else{
            self.pickupSearchAddress.text = self.searchResults[indexPath.row]
        }
        
        
        let address = self.searchResults[indexPath.row]
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
           guard
               let placemarks = placemarks,
               let location = placemarks.first?.location
            
           else {
               // handle no location found
               return
           }
//             print(placemarks.first?.country)
//            print(placemarks.first?.locality)
//            print(placemarks.first?.subLocality)
//            print(placemarks.first)
//            print(placemarks.first?.name)
////            print(placemarks.first?.region)
//
//            print(placemarks.first?.postalCode)
//        print(location.coordinate.longitude)
            
            
//            print(placemarks.first?.country)
//           print(placemarks.first?.locality)
//           print(placemarks.first?.subLocality)
//           print(placemarks.first?.thoroughfare)
//           print(placemarks.first?.postalCode)
//           print(placemarks.first?.subThoroughfare)
//
//            self.shipmentCity = (placemarks.first?.name)!
//            self.shipmentZip = (placemarks.first?.postalCode) ?? ""
//            self.shipmentState = self.shipmentAdsres.text!
//            self.shipmentStreet = self.shipmentAdsres.text!
            
           // Use your location
            
//            let locations = CLLocation(latitude: CLLocationDegrees(location.coordinate.latitude), longitude: CLLocationDegrees(location.coordinate.longitude))

            self.latLong(lat: location.coordinate.latitude, long: location.coordinate.longitude)
            
//            self.fetchCityAndCountry(from: locations) { (city, cuntry,plac,  err) in
////                       self.zip.text = plac?.postalCode ?? ""
////                       self.city.text = city ?? ""
//
//                print(city)
//                print(cuntry)
//                print(plac?.locality)
//                print(plac?.subLocality)
//
//
//                print(plac?.country)
//                         print(plac?.locality)
//                         print(plac?.subLocality)
//                         print(plac?.thoroughfare)
//                         print(plac?.postalCode)
//                         print(plac?.subThoroughfare)
//
//                self.shipmentStreet = "\(String(describing: plac!.subThoroughfare!)),\(String(describing: plac!.thoroughfare!)),\(String(describing: plac!.locality!)),\(String(describing: plac!.postalCode!)) , \(String(describing: plac!.country!))"
//                print(self.shipmentStreet)
//                 self.shipmentZip = (plac?.postalCode)!
//
//            }
    }
  
        
        
        
        
   
       
//
//        let placeID = self.placeIDArray[indexPath.row]
////        self.getAddress(address: placeID)
//
//        let placesClient = GMSPlacesClient()
//        // Specify the place data types to return.
//        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
//          UInt(GMSPlaceField.placeID.rawValue))!
//
//
//        placesClient.fetchPlace(fromPlaceID:placeID  , placeFields: fields, sessionToken: nil, callback: {
//          (place: GMSPlace?, error: Error?) in
//          if let error = error {
//            print("An error occurred: \(error.localizedDescription)")
//            return
//          }
//          if let place = place {
//            print(place.formattedAddress)
//            print(place.coordinate)
//            print(place.coordinate.self.latitude)
//            print(place.coordinate.longitude)
//            print(place.addressComponents)
//
//            print(place)
//            print(place.attributions?.string)
//
////            self.lblName?.text = place.name
//            print("The selected place is: \(place.name)")
//          }
//        })
    }

    
    
     func latLong(lat: Double,long: Double)  {

        SVProgressHUD.show(withStatus: "Loading...")
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat , longitude: long)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in

            print("Response GeoLocation : \(placemarks)")
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]

            // Country
            SVProgressHUD.dismiss()
            if self.selectOption == "2"{
                
                let coordinate0 = CLLocation(latitude: 32.894661, longitude: -96.886848)
                let coordinate1 = CLLocation(latitude: lat, longitude: long)
                let distanceInMeters = coordinate0.distance(from: coordinate1)
                
                let mileDistance = distanceInMeters / 1609.344
                print(mileDistance)
                if mileDistance > 10.0{
                    Utilites.ShowAlert(title: "Alert!!!", message: "We are providing pickup service with in 10 miles your selected area is not in 10 miles", view: self)
                    self.pickUpBtn.isEnabled = false
                    self.pickUpBtn.layer.opacity = 0.6
                }else{
                    self.pickUpBtn.isEnabled = true
                    self.pickUpBtn.layer.opacity = 1
                }

                
            }
            
            
            
             print(placeMark?.country)
             print(placeMark.administrativeArea)
             print(placeMark?.locality)
             print(placeMark?.subLocality)
             print(placeMark?.thoroughfare)
             print(placeMark?.postalCode)
             print(placeMark?.subThoroughfare)
            
            self.shipmentCity = placeMark!.locality ?? ""
            self.shipmentZip = placeMark!.postalCode ?? ""
            self.shipmentState = placeMark!.administrativeArea ?? ""
            print(self.shipmentZip)
            self.shipmentStreet = "\(String(describing: placeMark!.subThoroughfare ?? "")) \(String(describing: placeMark!.thoroughfare ?? "")), \(String(describing: placeMark!.locality ?? "")), \(String(describing: placeMark!.administrativeArea ?? "")), \(String(describing: placeMark!.postalCode ?? "")), \(String(describing: placeMark!.country ?? ""))"
            
            print(self.shipmentStreet)
            
            self.pickupStreetAddress.text = "\(String(describing: placeMark!.subThoroughfare ?? "")) \(String(describing: placeMark!.thoroughfare ?? ""))"
            print(self.pickupStreetAddress.text!)
            self.pickupCity.text = self.shipmentCity
            self.pickupState.text = self.shipmentState
            self.pickUpzipcode.text = self.shipmentZip
//            self.shipmentStreet = self.shipmentAdsres.text!
            
            
//
            
//            if let country = placeMark.addressDictionary!["Country"] as? String {
//                print("Country :- \(country)")
//                // City
//                if let city = placeMark.addressDictionary!["City"] as? String {
//                    print("City :- \(city)")
//                    // State
//                    if let state = placeMark.addressDictionary!["State"] as? String{
//                        print("State :- \(state)")
//                        // Street
//                        if let street = placeMark.addressDictionary!["Street"] as? String{
//                            print("Street :- \(street)")
//                            let str = street
//                            let streetNumber = str.components(
//                                separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
//                            print("streetNumber :- \(streetNumber)" as Any)
//
//                            // ZIP
//                            if let zip = placeMark.addressDictionary!["ZIP"] as? String{
//                                print("ZIP :- \(zip)")
//                                // Location name
//                                if let locationName = placeMark?.addressDictionary?["Name"] as? String {
//                                    print("Location Name :- \(locationName)")
//                                    // Street address
//                                    if let thoroughfare = placeMark?.addressDictionary!["Thoroughfare"] as? NSString {
//                                    print("Thoroughfare :- \(thoroughfare)")
//
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
        })
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
    
    
//    func getAddressFromLatLong(latitude: Double, longitude : Double) {
//        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=AIzaSyDnKuPE0DGd4OFFzkJtsbh970OCXyRJ4wg"
//
//        Alamofire.request(url).validate().responseJSON { response in
//            switch response.result {
//            case .success:
//
//                print(response)
//                let responseJson = response.result.value! as! NSDictionary
//
//                if let results = responseJson.object(forKey: "results")! as? [NSDictionary] {
//                    if results.count > 0 {
//                        if let addressComponents = results[0]["address_components"]! as? [NSDictionary] {
////                            self.address = results[0]["formatted_address"] as? String
//                            for component in addressComponents {
//                                if let temp = component.object(forKey: "types") as? [String] {
//                                    if (temp[0] == "postal_code") {
////                                        self.pincode = component["long_name"] as? String
//                                    }
//                                    if (temp[0] == "locality") {
////                                        self.city = component["long_name"] as? String
//                                    }
//                                    if (temp[0] == "administrative_area_level_1") {
////                                        self.state = component["long_name"] as? String
//                                    }
//                                    if (temp[0] == "country") {
////                                        self.country = component["long_name"] as? String
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
}


//extension SelectdeliveryMethodViewController {
//    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
//        //get result, transform it to our needs and fill our dataSource
//        self.searchSource = completer.results.map { $0.title }
//
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//    }
//
//    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
//        //handle the error
//        print(error.localizedDescription)
//    }
//}
