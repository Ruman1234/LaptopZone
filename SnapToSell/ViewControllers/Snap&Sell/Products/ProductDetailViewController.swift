//
//  ProductDetailViewController.swift
//  SnapToSell
//
//  Created by Apple on 8/24/19.
//  Copyright © 2019 Apple. All rights reserved.
//


import UIKit
import SkyFloatingLabelTextField
import OpalImagePicker
import Photos
import FirebaseStorage
import SVProgressHUD


class ProductDetailViewController: UIViewController ,UICollectionViewDelegate , UICollectionViewDataSource, UINavigationControllerDelegate , UIImagePickerControllerDelegate,OpalImagePickerControllerDelegate,PreviewViewControllerDelegate {
    
   
    
    @IBOutlet weak var titleProduct: SkyFloatingLabelTextField!
    @IBOutlet weak var lotPrice: SkyFloatingLabelTextField!
    @IBOutlet weak var remarks: SkyFloatingLabelTextField!
    @IBOutlet weak var senfProduct: UIButton!
    @IBOutlet var camera: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var menubtn: UIBarButtonItem!
    
    
    
    var imagePicker: UIImagePickerController!
    
    var images = [UIImage]()
    var address = AddressesModel()
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _ = UserDefaults.standard.value(forKey: "Token")
        
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

         
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if self.images.count != 0 {
            self.collectionView.reloadData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        self.navigationItem.rightBarButtonItem = camera
        self.navigationItem.leftBarButtonItem = menubtn

        self.menubtn.target = self.revealViewController()
        self.menubtn.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCollectionViewCell", for: indexPath) as! ProductImageCollectionViewCell
        
        cell.productImage.image = self.images[indexPath.row]
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        
        cell.productImage.addGestureRecognizer(tap)
        
        cell.cancleBtn.tag = indexPath.row
        return cell
    }
    
    
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        secondVC.img = self.images
        secondVC.delegate = self
        self.present(secondVC, animated: true, completion: nil)
        
    }
    
    func remove(_ i: Int) {
        
        self.images.remove(at: i)
        let indexPath = IndexPath(row: i, section: 0)
        
        self.collectionView.performBatchUpdates({
            self.collectionView.deleteItems(at: [indexPath])
        }) { (finished) in
            self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
        }
        
    }


    
    @IBAction func cancleBtn(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "!!!", message: "Are you sure you want to delete", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            self.remove(sender.tag)
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func validInput() -> Bool {
        var flag = true
        
        self.titleProduct.text = self.titleProduct.text?.trimmingCharacters(in: .whitespaces)
        
        self.lotPrice.text = self.lotPrice.text?.trimmingCharacters(in: .whitespaces)
        
        self.remarks.text = self.remarks.text?.trimmingCharacters(in: .whitespaces)
        
        if self.titleProduct.text == ""{
            flag = false
            self.showToast(message: "please enter title")
            
        }else if self.images.count == 0{
            flag = false
            self.showToast(message: "please add images")
        }
        
        return flag
    }
    
    var imageUrl = [[String: String]]()
    
    @IBAction func sendProduct(_ sender: Any) {

        if validInput(){
            DispatchQueue.main.async {
                SVProgressHUD.show(withStatus: "Loading...")
//                let storageRef = self.storage.reference()
                self.view.isUserInteractionEnabled = false
                var i = 0
                
                
                    NetworkManager.SharedInstance.AddNewOrder(title: self.titleProduct.text!, price: self.lotPrice.text ?? "", remarks: self.remarks.text ?? "", success: { (res) in
                        print(res)
                        
                        for img in self.images{
                            
                            let date :Date = Date()
                            
                            let dateFormatter = DateFormatter()
                            //dateFormatter.dateFormat = "yyyy-MM-dd'_'HH:mm:ss"
                            dateFormatter.dateFormat = "yyyyMMddHHmmssSSSS"
                            
                            dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone?
                            
                            let imageName = "\(dateFormatter.string(from: date))\(i).jpg"
                            print("images/\(imageName)")
                            
                            
                            let par = ["request_id" : "\(res.id!)",
                                       "name" : imageName] as [String : Any]
                            NetworkManager.SharedInstance.UploadImages(params: par, images: img, success: { (res) in
                                print(res)
                                if i == self.images.count{
                                    SVProgressHUD.dismiss()
                                    Utilites.ShowAlert(title: "Success!!!", message: "Product added successfully", view: self)
                                    self.view.isUserInteractionEnabled = true
                                    self.reset()
                                }
                                i = i + 1
                            }, failure: { (err) in
                                SVProgressHUD.dismiss()
                                self.view.isUserInteractionEnabled = true
                                Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
                                
                            })
                            
                        }
                        
                    }, failure: { (err) in
                        SVProgressHUD.dismiss()
                        self.view.isUserInteractionEnabled = true
                        Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
                    })
                    
                    
//                    let date :Date = Date()
//
//                    let dateFormatter = DateFormatter()
//                    //dateFormatter.dateFormat = "yyyy-MM-dd'_'HH:mm:ss"
//                    dateFormatter.dateFormat = "yyyyMMddHHmmssSSSS"
//
//                    dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone?
//
//                    let imageName = "\(dateFormatter.string(from: date))\(i).jpg"
//                    print("images/\(imageName)")
                
                    
//                    let riversRef = storageRef.child("products/\(imageName)")
//                    riversRef.putData(data, metadata: nil) { (metadata, error) in
//                        guard let metadata = metadata else {
//                            // Uh-oh, an error occurred!
//                            Utilites.ShowAlert(title: "Error", message: "\(imageName) not upload", view: self)
//                            return
//                        }
//
//                        let size = metadata.size
//                        print(size)
//                        riversRef.downloadURL { (url, error) in
//                            guard url != nil else {
//                                // Uh-oh, an error occurred!
//                                Utilites.ShowAlert(title: "Error", message: "\(imageName) not upload", view: self)
//                                return
//                            }
//                            print(url!)
//
//
//                            let dataToAppend: [String: String] = ["url": "\(url!)"]
//                            self.imageUrl.append(dataToAppend)
//
//                            let encoder = JSONEncoder()
//                            encoder.outputFormatting = .prettyPrinted
//                            if self.imageUrl.count == self.images.count {
//                                do{
//                                    let json = try encoder.encode(self.imageUrl)    // Generic parameter 'T' could not be inferred
//                                    let str = String(data: json, encoding: .utf8)!
//
//                                    print(str)
//
//
//
//                                    NetworkManager.SharedInstance.AddNewOrder(title: self.titleProduct.text!, price: self.lotPrice.text!, images: str, remarks: self.remarks.text ?? "", success: { (response) in
//                                        SVProgressHUD.dismiss()
//                                        print(response)
//                                        self.reset()
//                                        Utilites.ShowAlert(title: "Success!!!", message: "product added successfully", view: self)
//                                    }, failure: { (err) in
//                                        SVProgressHUD.dismiss()
//                                        Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
//                                    })
//
//                                }catch{
//
//                                }
//                            }
//                        }
//                    }
//                    i += 1
//                }
            }
        }
    }
    
    
    func reset()  {
        self.titleProduct.text = ""
        self.lotPrice.text = ""
        self.remarks.text = ""
        self.images.removeAll()
        self.collectionView.reloadData()
    }
    
    func dataBack(img: [UIImage]) {
        self.images = img
        self.collectionView.reloadData()
        
    }
    
    
    @IBAction func cameraBtn(_ sender: Any) {
        
        let imagesource = UIAlertController(title: "Image source", message: "", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Take Picture", style: .default) { (ale) in
            
            let main = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
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
            let max = 20 - self.images.count
            imagePicker.maximumSelectionsAllowed = max
            
            if self.images.count <= 20 {
                self.present(imagePicker, animated: true, completion: nil)
            }else{
                Utilites.ShowAlert(title: "Alert!!!", message: "MAx num of photos in 20", view: self)
            }
            
            
            
         
        }
        let cancle = UIAlertAction(title: "Cancle", style: .cancel ) { (ale) in
            
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
    
}
