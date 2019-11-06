//
//  PendingProductDetailViewController.swift
//  SnapToSell
//
//  Created by Apple on 8/29/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SDWebImage
import OpalImagePicker
import SVProgressHUD

class PendingProductDetailViewController: UIViewController ,UICollectionViewDelegate , UICollectionViewDataSource,OpalImagePickerControllerDelegate{
  
    
    @IBOutlet weak var previewIamge: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var navigationTitile: UILabel!
    @IBOutlet weak var titleProduct: UILabel!
    
    @IBOutlet weak var lotPrice: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var remarks: UILabel!
    
    @IBOutlet var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var activeLbl: UILabel!
    
    var detail = RequestStatusModel()
    var img = Int()
    var images = [UIImage]()
    var type = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if type == "rep" {
            fetchRepProduct()
        }else{
            fetchSingalProduct()
        }
       
        sendBtn.isHidden = true
        sendBtn.isEnabled = false
//        self.navigationItem.rightBarButtonItem = cameraButton
        self.addBG()
        self.backBtn()
        
//        self.activeLbl.applyGradient(colours: [
//            UIColor(red: 0.99, green: 0.17, blue: 0.03, alpha: 1),
//          UIColor(red: 1, green: 0.49, blue: 0, alpha: 1)
//        ], locations: [0.12, 1], startPoint: CGPoint(x:0.00, y: 0.1), endPoint: CGPoint(x: 1, y: 1))
        self.activeLbl.textColor = .white
        self.activeLbl.text = "NEW"
        self.activeLbl.layer.cornerRadius = 13
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if self.images.count > 0 {
            sendBtn.isHidden = false
            sendBtn.isEnabled = true
            self.img = self.images.count
            self.previewIamge.image = self.images[0]
            self.collectionView.reloadData()
        }
    }
    
    func fetchSingalProduct()  {
        
        SVProgressHUD.show(withStatus: "Loading...")
        print("\(String(describing: detail!.id!))")
        
        NetworkManager.SharedInstance.getSingalRequest(request_id: "\(String(describing: detail!.id!))", success: { (res) in
            
            SVProgressHUD.dismiss()
            self.detail = res
            if (self.detail?.images!.count)! > 0 {
                self.previewIamge.sd_setImage(with: URL(string: (self.detail?.images![0].url)!), placeholderImage: UIImage(named: "placeholder.png"))
                
            }
            self.navigationTitile.text = self.detail!.title
            self.titleProduct.text = self.detail?.title
            self.lotPrice.text = Double(self.detail!.asking_price ?? "0")?.dollarString
            
            
            
//            let inputFormatter = DateFormatter()
//            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//            let showDate = inputFormatter.date(from: self.detail!.created_at!)
//            inputFormatter.dateFormat = "yyyy-MM-dd"
//            let resultString = inputFormatter.string(from: showDate!)
//            print(resultString)
            
           
//            self.dateLbl.text = self.detail?.created_at
//            self.status.text = self.detail?.status
            self.remarks.text = self.detail?.remarks
            self.img = (self.detail?.images!.count)!
            
//            for image in self.detail!.images! {
//                let img = UIImageView ()
//                img.sd_setImage(with: URL(string: image.url!), placeholderImage: nil)
//
//                self.images.append(img.image!)
//            }
            self.collectionView.reloadData()
            
        }) { (err) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
        }
    }
    
    
    func fetchRepProduct()  {
            
            SVProgressHUD.show(withStatus: "Loading...")
            
            
        NetworkManager.SharedInstance.getRepRecData(searcInput: "\(String(describing: detail!.REQ_ID!))", success: { (res) in
                
                SVProgressHUD.dismiss()
                self.detail = res
                if (self.detail?.images_rep!.count)! > 0 {
                    self.previewIamge.sd_setImage(with: URL(string: (self.detail?.images_rep![0])!), placeholderImage: UIImage(named: "placeholder.png"))
                    
                }
                self.navigationTitile.text = self.detail!.details![0].MODEL_NAME
            self.titleProduct.text = self.detail!.details![0].MODEL_NAME
            self.lotPrice.text = Double(self.detail!.details![0].OFFER ?? "0")?.dollarString
                
                
                
    //            let inputFormatter = DateFormatter()
    //            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    //            let showDate = inputFormatter.date(from: self.detail!.created_at!)
    //            inputFormatter.dateFormat = "yyyy-MM-dd"
    //            let resultString = inputFormatter.string(from: showDate!)
    //            print(resultString)
                
               
    //            self.dateLbl.text = self.detail?.created_at
    //            self.status.text = self.detail?.status
            self.remarks.text = self.detail!.details![0].REMARKS
                self.img = (self.detail?.images_rep!.count)!
                
    //            for image in self.detail!.images! {
    //                let img = UIImageView ()
    //                img.sd_setImage(with: URL(string: image.url!), placeholderImage: nil)
    //
    //                self.images.append(img.image!)
    //            }
                self.collectionView.reloadData()
                
            }) { (err) in
                SVProgressHUD.dismiss()
                Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return img
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCollectionViewCell", for: indexPath) as! ProductImageCollectionViewCell
        
        

        if self.images.count > 0 {
           cell.productImage.image = self.images[indexPath.row]
        }else{
            if self.type == "rep"{
                cell.productImage.sd_setImage(with: URL(string: (self.detail?.images_rep![indexPath.row])!), placeholderImage: UIImage(named: "placeholder.png"))
            }else{
                cell.productImage.sd_setImage(with: URL(string: (self.detail?.images![indexPath.row].url)!), placeholderImage: UIImage(named: "placeholder.png"))

            }
            

        }
//        cell.productImage.image = self.images[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.previewIamge.sd_setImage(with: URL(string: (self.detail?.images![indexPath.row].url)!), placeholderImage: UIImage(named: "placeholder.png"))
    }
    
    
    @IBAction func cameraButton(_ sender: Any) {
        
        
        let imagesource = UIAlertController(title: "Image source", message: "", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Take Picture", style: .default) { (ale) in
            
            let main = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
            main.type = "pending"
            self.navigationController?.pushViewController(main, animated: true)
            
        }
        let media = UIAlertAction(title: "Media", style: .default) { (ale) in
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                //Show error to user?
                return
            }
            
            //Example Instantiating OpalImagePickerController with Closures
            let imagePicker = OpalImagePickerController()
            imagePicker.imagePickerDelegate = self
            imagePicker.maximumSelectionsAllowed = 10
            
            
            
            self.present(imagePicker, animated: true, completion: nil)
            
            
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
        
        if images.count > 0 {
            sendBtn.isHidden = false
            sendBtn.isEnabled = true
        }
        
        self.img = images.count
        self.collectionView.reloadData()
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
    
    
    func sendMoreImages()  {
        
        SVProgressHUD.show(withStatus: "Loading...")
        var i = 0
        for img in self.images{
//            SVProgressHUD.dismiss()
            let date :Date = Date()
            
            let dateFormatter = DateFormatter()
            //dateFormatter.dateFormat = "yyyy-MM-dd'_'HH:mm:ss"
            dateFormatter.dateFormat = "yyyyMMddHHmmssSSSS"
            
            dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone?
            
            let imageName = "\(dateFormatter.string(from: date))\(i).jpg"
            print("images/\(imageName)")
            print("\(String(describing: self.detail!.id!))")
            
            let par = ["request_id" : "\(String(describing: self.detail!.id!))",
                "name" : imageName] as [String : Any]
            NetworkManager.SharedInstance.UploadImages(params: par, images: [img], success: { (res) in
                print(res)
                if i == self.images.count{
                    SVProgressHUD.dismiss()
                    
                }
                i = i + 1
            }, failure: { (err) in
                SVProgressHUD.dismiss()
                Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
            })
        }
        
        
    }
    
    
    
    @IBAction func send(_ sender: Any) {
        sendMoreImages()
        
    }
    
    
}
