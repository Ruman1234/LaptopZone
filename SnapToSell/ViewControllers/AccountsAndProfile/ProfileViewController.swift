//
//  ProfileViewController.swift
//  SnapToSell
//
//  Created by Apple on 11/1/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD
import OpalImagePicker
import Alamofire
class ProfileViewController: UIViewController,OpalImagePickerControllerDelegate {

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

    var img = UIImage()
    var setimage = Bool()
    
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
    

    override func viewWillAppear(_ animated: Bool) {
        
        
        if self.setimage {
            self.profileImage.image = img
            self.tabBarController?.tabBar.isHidden = false
            UpdateProfileCall()
            
        }
        
        
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
            if res.avatar != nil {
                self.profileImage.sd_setImage(with: URL(string: res.avatar!), placeholderImage: UIImage(named: "placeholder.png"))

            }
            
            self.getDefaultAddress()
          }, failure: { (err) in
            SVProgressHUD.show(withStatus: "Loading..")
              print("Error!!!")
            Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)

          })
    }
    
    
    func UpdateProfileCall()  {
        
//        let pra = ["name" : CustomUserDefaults.userName.value!,"email":CustomUserDefaults.email.value]
        SVProgressHUD.show(withStatus: "Loading...")
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
    
        if  let data = self.profileImage.image!.jpegData(compressionQuality: 0.5)
        {
            MultipartFormData.append(data, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
                       
        }

//        for (key, value) in pra
//        {
//            MultipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
//        }

            
        }, usingThreshold: UInt64.init(), to: "http://71.78.236.22/laptop-zone-stage/public/api/customer/profile/avatar", method: .post,headers: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (result) in

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
                    SVProgressHUD.dismiss()
                    self.view.showToast(message: "Image uploaded")
                    if response.response?.statusCode == 200
                    {
                       
                        

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
    
    
    
    @IBAction func profileBtn(_ sender: Any) {
        self.openCamer()
    }
    

    func openCamer() {
        
        let imagesource = UIAlertController(title: "Image source", message: "", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Take Picture", style: .default) { (ale) in
            self.setimage = true
                let main = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
                main.type = "profile"
                self.navigationController?.pushViewController(main, animated: true)
                
                      
            
        }
        let media = UIAlertAction(title: "Media", style: .default) { (ale) in
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                //Show error to user?
                return
            }
//            self.images.removeLast()
            //Example Instantiating OpalImagePickerController with Closures
            let imagePicker = OpalImagePickerController()
            imagePicker.imagePickerDelegate = self
            imagePicker.allowedMediaTypes = Set([.image ])
            
            imagePicker.maximumSelectionsAllowed = 1
            
            self.present(imagePicker, animated: true, completion: nil)
            
            
         
        }
        let cancle = UIAlertAction(title: "Cancel", style: .cancel ) { (ale) in
            
        }
        imagesource.addAction(camera)
        imagesource.addAction(media)
        imagesource.addAction(cancle)
        
        
        if let popoverController = imagesource.popoverPresentationController {
                 popoverController.sourceView = self.view
                 popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                 popoverController.permittedArrowDirections = []
               }
        
        self.present(imagesource, animated: true, completion: nil)
        
    }
        
        
        
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        //Cancel action?
        print("adsasd")
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
    
//            self.images.removeLast()
//            print(images.count)
//            for img in images{
//                self.images.append(img)
//            }
//            self.images.append(UIImage(named: "addimage")!)
//            self.collectionview.reloadData()
        self.profileImage.image = images[0]
        self.UpdateProfileCall()
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
