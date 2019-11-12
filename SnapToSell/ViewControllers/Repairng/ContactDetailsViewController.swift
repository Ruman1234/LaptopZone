
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
import OpalImagePicker

class ContactDetailsViewController: UIViewController,OpalImagePickerControllerDelegate {
    
    
    
    @IBOutlet weak var firstname: UITextField!
//    @IBOutlet weak var lastname: SkyFloatingLabelTextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    
    @IBOutlet var cameraBtn: UIBarButtonItem!
    
    @IBOutlet weak var message: UITextView!
    
    @IBOutlet var menuBtn: UIBarButtonItem!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var savebtn: UIButton!
    
    @IBOutlet weak var selectPhotos: UIButton!
    
    @IBOutlet weak var selectPhototsheight: NSLayoutConstraint!
    
    @IBOutlet weak var selectProductHeight: NSLayoutConstraint!
    @IBOutlet weak var productName: UILabel!
    
    var type = String()
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBG()
        
        
        self.email.text = CustomUserDefaults.email.value
        self.firstname.text = CustomUserDefaults.userName.value
       
        
        //message.layer.cornerRadius = 5
        message.layer.borderColor = UIColor.lightGray.cgColor
        message.layer.borderWidth = 1
        if type == "recycle"{
            self.selectProductHeight.constant = 0
//            self.navigationItem.rightBarButtonItem = cameraBtn
//            self.navigationItem.leftBarButtonItem = menuBtn
//            self.menuBtn.target = self.revealViewController()
//            self.menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
//            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }else{
            self.addPAger(totalPage: 7, currentPage: 6)
            self.cancleBtn()
            self.selectPhototsheight.constant = 0
            self.productName.text = Constants.seriesName
            self.selectPhotos.isHidden = true
            self.selectPhotos.isEnabled = false
            self.navigationItem.rightBarButtonItem = nil
        }
        self.backBtn()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.selectPhotos.setGradient()
        self.savebtn.setGradient()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.type == "recycle"{
            self.tabBarController?.tabBar.isHidden = false
        }
          if self.images.count != 0 {
            self.selectPhotos.setTitle("\(images.count) files selected", for: .normal)
            
          }
    }
  

    func SaveRepairInfo(brand_name: String,
                        product_name: String,
                        series_name: String,
                        model_name: String,
                        issues_name: String,
                        emailNumb: String,
                        phoneNumb: String,
                        LastName: String,
                        yourName: String,
                        enterComents: String,
                        images : [UIImage]
                        )  {
            SVProgressHUD.show(withStatus: "Loading...")
     //   http://localhost/laptopzone/reactcontroller/c_react/ljw_SaveRequest
        
        let parameter = ["product_name" : product_name,
            "brand_name":brand_name,
            "series_name":series_name,
            "model_name":model_name,
            "issues_name":issues_name,
            "emailNumb":emailNumb,
            "phoneNumb":phoneNumb,
            "LastName":LastName,
            "yourName":yourName,
            "enterComents":enterComents,
        ]

        Alamofire.upload(multipartFormData: { (MultipartFormData) in

            var i = 0
            
            for img in images{
                
                let data = img.jpegData(compressionQuality: 0.5)

                 MultipartFormData.append(data!, withName: "images[]", fileName: "images\(i).jpg", mimeType: "image/jpg")
                i += 1
            }

            // Here is your Post paramaters
            for (key, value) in parameter
            {
                MultipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }

        }, usingThreshold: UInt64.init(), to: "http://71.78.236.20/laptopzone/reactcontroller/c_react/ljw_SaveRequest", method: .post) { (result) in

            switch result {
            case .success(let upload, _, _):

                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })

                upload.responseString { (res) in
                    print(res)
                }
                
                
                
                upload.responseJSON { response in
                    print(response)
                    if response.response?.statusCode == 200
                    {
                        SVProgressHUD.dismiss()
                        let json = response.result.value as? NSDictionary
//                        print(json)
                        
//                        self.showToast(message: "Product Send successfully")
                       Utilites.ShowAlert(title: "Success!!!", message: "Your request has been received we will contact you ASAP", view: self){ (alert) in
//                           self.navigationController?.popViewController(animated: true)
                        
                        if #available(iOS 13.0, *) {
                            
                            
                            let a = self.navigationController?.viewControllers[0] as! HomeViewController
                            self.navigationController?.popToViewController(a, animated: true)

                        } else {
                            // Fallback on earlier versions
                        }
                       }
                        
                        

                    }
                    else
                    {
                        
                    }
                }

            case .failure(let encodingError):
                print(encodingError)

//                completion(false,[:]);
            }

        }
        
//        Alamofire.request(URL(string: "http://71.78.236.20/laptopzone/reactcontroller/c_react/ljw_SaveRequest")!, method: .post, parameters: ["get_product_name" : product_name,
//                "brand_name":brand_name,
//                "series_name":series_name,
//                "model_name":model_name,
//                "issues_name":issues_name,
//                "emailNumb":emailNumb,
//                "phoneNumb":phoneNumb,
//                "LastName":LastName,
//                "yourName":yourName,
//                "enterComents":enterComents,
//                ], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
//                        SVProgressHUD.dismiss()
//                        if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
//                            print(response)
//                            guard (response.response?.statusCode) != nil else{
//                                return
//                            }
//
//                            self.showToast(message: "Mail sent successfully")
//
//
//                             let a = self.navigationController?.viewControllers[0] as! SelectYourProductViewController
//
//                            self.navigationController?.popToViewController(a, animated: true)
//
//                            }
//                        else{
//                            SVProgressHUD.dismiss()
//                            Utilites.ShowAlert(title: "Error!!", message: "Something went wrong", view: self)
//                        }
//
//                }
    
    }
    
    
    func Recycle(
                 email: String,
                 phone: String,
                 remarks: String,
                 full_name: String,
                 images: [UIImage])  {

        let par = ["email" : email,
                   "phone" : phone,
                    "remarks" : remarks,
                    "full_name" : full_name
         ]
        
        SVProgressHUD.show(withStatus: "Loading...")
        NetworkManager.SharedInstance.UploadReycleImages(params: par, images: images, success: { (res) in
            SVProgressHUD.dismiss()
            print(res)
            self.Reset()
            self.navigationController?.popViewController(animated: true)
            Utilites.ShowAlert(title: "Success!!!", message: "Your request has been received we will contact you ASAP", view: self){ (alert) in
                self.navigationController?.popViewController(animated: true)
            }
        }) { (err) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
        }
    }
    
    
    func validInput() -> Bool {
        var flag = true
        let firstname = self.firstname.text?.trimmingCharacters(in: .whitespaces)
//        let lastname = self.lastname.text?.trimmingCharacters(in: .whitespaces)
        let email = self.email.text?.trimmingCharacters(in: .whitespaces)
        let phone = self.phone.text?.trimmingCharacters(in: .whitespaces)
       self.message.text = self.message.text?.trimmingCharacters(in: .whitespaces)
        
//        print(firstname)
//        print(lastname)
//        print(email)
//        print(phone)
        
        self.firstname.text = firstname
        self.email.text = email
        self.phone.text = phone
        
        if self.type == "recycle" {
            if self.images.count == 0 {
                flag = false
                self.showToast(message: "Please select images")
            }else if self.message.text == "" {
                flag = false
                self.showToast(message: "Please add message")
            }else if self.phone.text == "" {
                flag = false
                self.showToast(message: "Please enter phone")
            }else if self.email.text == "" {
                flag = false
                self.showToast(message: "Please enter email")
            }else if Utilites.isValid(email: self.email!.text! as NSString) == false{
                flag = false
                self.showToast(message: "Please enter a valid email")
            }
        }else{
            if self.email.text == "" {
                flag = false
                self.showToast(message: "Please enter email")
            }else if self.firstname.text == "" {
                flag = false
                self.showToast(message: "Please enter first name")
            }else if self.phone.text == "" {
                flag = false
                self.showToast(message: "Please enter phone")
            }else if Utilites.isValid(email: self.email!.text! as NSString) == false{
                flag = false
                self.showToast(message: "Please enter a valid email")
            }
        }
        
        
        return flag
    }
    
    
    
    @IBAction func saveBtn(_ sender: Any) {
        if validInput(){
            if self.type == "recycle" {
                self.Recycle(email: self.email.text!, phone: self.phone.text!, remarks: self.message.text!, full_name: self.firstname.text! , images: self.images)
            }else{
                self.SaveRepairInfo(brand_name: Constants.brandId, product_name: Constants.productId, series_name: Constants.seriesId, model_name: Constants.modelId, issues_name: Constants.issuesId, emailNumb: self.email.text!, phoneNumb: self.phone.text!, LastName:"", yourName: self.firstname.text!, enterComents: self.message.text ?? "", images: Constants.UploadImage)
            }
            
        }
    }
    
    func Reset()  {
        self.firstname.text = ""
//        self.lastname.text = ""
        self.phone.text = ""
        self.email.text = ""
        self.message.text = ""
        self.images.removeAll()
    }
    
    
    @IBAction func cameraBtn(_ sender: Any) {
        
        let imagesource = UIAlertController(title: "Image source", message: "", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Take Picture", style: .default) { (ale) in
            if self.images.count >= 10{
                Utilites.ShowAlert(title: "Alert!!!", message: "You can't select more then 10 images", view: self)
            }else{
                let main = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
                main.type = "recycle"
                self.navigationController?.pushViewController(main, animated: true)
            }
            
            
        }
        let media = UIAlertAction(title: "Media", style: .default) { (ale) in
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                //Show error to user?
                return
            }
            
            //Example Instantiating OpalImagePickerController with Closures
            
            

            
            let imagePicker = OpalImagePickerController()
            imagePicker.imagePickerDelegate = self
//            let max = 10 - self.images.count
            imagePicker.maximumSelectionsAllowed = 10

            
            if self.images.count < 10 {
                self.present(imagePicker, animated: true, completion: nil)
            }else{
                Utilites.ShowAlert(title: "Alert!!!", message: "Max num of photos are 10", view: self)
            }
            
            
            
            
        }
        let cancle = UIAlertAction(title: "Cancel", style: .cancel ) { (ale) in
            
        }
        imagesource.addAction(camera)
        imagesource.addAction(media)
        imagesource.addAction(cancle)
        
        self.present(imagesource, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        //Cancel action?
        print("adsasd")
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        
        
        print(images.count)
        for img in images{
            self.images.append(img)
        }
        self.selectPhotos.setTitle("\(self.images.count) files selected", for: .normal)

//        self.collectionView.reloadData()
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerNumberOfExternalItems(_ picker: OpalImagePickerController) -> Int {
        return 1
    }
    
    func imagePickerTitleForExternalItems(_ picker: OpalImagePickerController) -> String {
        return NSLocalizedString("External", comment: "External (title for UISegmentedControl)")
    }
    
    func imagePicker(_ picker: OpalImagePickerController, imageURLforExternalItemAtIndex index: Int) -> URL? {
        return URL(string: "https://placeimg.com/500/500/nature")
    }
    
    
}
