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
import SocketIO


class ProductDetailViewController: UIViewController ,UICollectionViewDelegate , UICollectionViewDataSource, UINavigationControllerDelegate , UIImagePickerControllerDelegate,UICollectionViewDelegateFlowLayout,OpalImagePickerControllerDelegate,PreviewViewControllerDelegate {
    
    
    
    @IBOutlet weak var titleProduct: UITextField!
    @IBOutlet weak var lotPrice: UITextField!
    @IBOutlet weak var remarks: UITextField!
    @IBOutlet weak var senfProduct: UIButton!
//    @IBOutlet var camera: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var menubtn: UIBarButtonItem!
    
    @IBOutlet weak var sellAnythingView: UIView!
    
    
    var imagePicker: UIImagePickerController!
    var images = [UIImage]()
    
    var address = AddressesModel()
    let storage = Storage.storage()
    
    let manager = SocketManager(socketURL: URL(string: "http://71.78.236.22:6001")!, config: [.log(true), .compress])
    var socket : SocketIOClient!

    private let spacing:CGFloat = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.backBtn()
        self.sellAnythingView.applyGradient(colours: [
            UIColor(red: 0.99, green: 0.17, blue: 0.03, alpha: 1),
          UIColor(red: 1, green: 0.49, blue: 0, alpha: 1)
        ], locations: [0.12, 1], startPoint: CGPoint(x:0.00, y: 0.1), endPoint: CGPoint(x: 1, y: 1))
        
//        self.images.append(UIImage(named: "addimage")!)
        
        _ = UserDefaults.standard.value(forKey: "Token")
        
        self.senfProduct.setGradient()
//        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//
//        self.navigationController?.navigationItem.rightBarButtonItem = camera
        
//        self.navigationController?.navigationItem.rightBarButtonItem = menubtn
        
        
             let layout = UICollectionViewFlowLayout()
             layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
             layout.minimumLineSpacing = spacing
             layout.minimumInteritemSpacing = spacing
             self.collectionView?.collectionViewLayout = layout
        self.addBG()
        self.textFieldDesign(textField: self.titleProduct)
        self.textFieldDesign(textField: self.lotPrice)
        self.textFieldDesign(textField: self.remarks)
        
    }
    
    
    func textFieldDesign(textField :UITextField)  {
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.giveShadow()
        
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if self.images.count != 0 {
            self.collectionView.reloadData()
            
        }
        self.tabBarController?.tabBar.isHidden = false
       if self.images.last != UIImage(named: "addimage"){
            self.images.append(UIImage(named: "addimage")!)
        }
//        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
//        self.navigationItem.rightBarButtonItem = camera
//        self.navigationItem.leftBarButtonItem = menubtn

//        self.menubtn.target = self.revealViewController()
//        self.menubtn.action = #selector(SWRevealViewController.revealToggle(_:))
//        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCollectionViewCell", for: indexPath) as! ProductImageCollectionViewCell
        
        cell.productImage.image = self.images[indexPath.row]
        if indexPath.row == self.images.count - 1 {
            cell.cancleBtn.isHidden = true
        }else{
            cell.cancleBtn.isHidden = false
            cell.cancleBtn.setGradient()
        }
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//
//
//        cell.productImage.addGestureRecognizer(tap)
        
        cell.cancleBtn.tag = indexPath.row
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let numberOfItemsPerRow:CGFloat = 3
            let spacingBetweenCells:CGFloat = 10
            
            
            let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
            
            if let collection = self.collectionView{
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
    //            self.height.constant = width
    //            self.width.constant = width
                
                return CGSize(width: width, height: width)
                
            }else{
                return CGSize(width: 0, height: 0)
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCollectionViewCell", for: indexPath) as! ProductImageCollectionViewCell
        
         if indexPath.row == self.images.count - 1{
                   openCamer()
         }else{
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                   
                   
                   cell.productImage.addGestureRecognizer(tap)
        }
    }
    
    
    func openCamer() {
        
        let imagesource = UIAlertController(title: "Image source", message: "", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Take Picture", style: .default) { (ale) in
//            self.images.removeLast()
            
            if self.images.count < 21 {
                let main = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
                //            main.type = "repair"
                self.images.removeLast()
                self.navigationController?.pushViewController(main, animated: true)
                            
            }else{
              Utilites.ShowAlert(title: "Alert!!!", message: "Max num of photos in 20", view: self)
            }
            
        }
        let media = UIAlertAction(title: "Media", style: .default) { (ale) in
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                //Show error to user?
                return
            }
//            self.images.removeLast()
            //Example Instantiating OpalImagePickerController with Closures
               //Example Instantiating OpalImagePickerController with Closures
            let imagePicker = OpalImagePickerController()
            imagePicker.imagePickerDelegate = self
            imagePicker.allowedMediaTypes = Set([.image ])
            let max = 21 - self.images.count
            imagePicker.maximumSelectionsAllowed = max

            if self.images.count < 21 {
                self.present(imagePicker, animated: true, completion: nil)
            }else{
                Utilites.ShowAlert(title: "Alert!!!", message: "Max num of photos in 20", view: self)
            }
            
            
            
         
        }
        let cancle = UIAlertAction(title: "Cancel", style: .cancel ) { (ale) in
            
        }
        imagesource.addAction(camera)
        imagesource.addAction(media)
        imagesource.addAction(cancle)
        
        self.present(imagesource, animated: true, completion: nil)
        
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
            
        }else if self.images.count == 1{
            flag = false
            self.showToast(message: "please add atleast 1 image")
        }
        
        return flag
    }
    
    var imageUrl = [[String: String]]()
    
    @IBAction func sendProduct(_ sender: Any) {

        if validInput(){
            
            

        
//        let date :Date = Date()
//
//        let dateFormatter = DateFormatter()
//        //dateFormatter.dateFormat = "yyyy-MM-dd'_'HH:mm:ss"
//        dateFormatter.dateFormat = "yyyyMMddHHmmssSSSS"
//
//        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone?
        
//        let imageName = "\(dateFormatter.string(from: date))\(i).jpg"
//        print("images/\(imageName)")
        self.images.removeLast()
          DispatchQueue.main.async {
            SVProgressHUD.show(withStatus: "Loading...")
            self.view.isUserInteractionEnabled = false
            let par = [
        //                   "name" : imageName,
                       "title":self.titleProduct.text! ,
                       "asking_price":self.lotPrice.text ?? "" ,
                       "remarks" : self.remarks.text ?? "",
                       "offered_price" : ""] as [String : Any]
            
            
            
            NetworkManager.SharedInstance.UploadImages(params: par, images: self.images, success: { (res) in
                self.view.isUserInteractionEnabled = true
                print(res)
        //            if i == self.images.count{
                    SVProgressHUD.dismiss()
        //
                    
                    Utilites.ShowAlert(title: "Success!!!", message: "Your request has been received we will contact you ASAP", view: self) { (alert) in
                        self.navigationController?.popViewController(animated: true)
                    }
                    
//                    self.view.isUserInteractionEnabled = true
                    self.reset()
                    
            }, failure: { (err) in
                SVProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
                Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
                
            })
        }
    
            
            
//            DispatchQueue.main.async {
//                SVProgressHUD.show(withStatus: "Loading...")
////                let storageRef = self.storage.reference()
//                self.view.isUserInteractionEnabled = false
//                var i = 0
//
//
//                NetworkManager.SharedInstance.AddNewOrder(title: self.titleProduct.text!, price: self.lotPrice.text ?? "", offered_price: "", remarks: self.remarks.text ?? "", success: { (res) in
//                        print(res)
//                        self.images.removeLast()
//                        for img in self.images{
//
//                            let date :Date = Date()
//
//                            let dateFormatter = DateFormatter()
//                            //dateFormatter.dateFormat = "yyyy-MM-dd'_'HH:mm:ss"
//                            dateFormatter.dateFormat = "yyyyMMddHHmmssSSSS"
//
//                            dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone?
//
//                            let imageName = "\(dateFormatter.string(from: date))\(i).jpg"
//                            print("images/\(imageName)")
//
//
//                            let par = ["request_id" : "\(res.id!)",
//                                       "name" : imageName,
//                                       "title":self.titleProduct.text! ,
//                                       "asking-price":self.lotPrice.text ?? "" ,
//                                       "remarks" : self.remarks.text ?? "",
//                                       "offered_price" : ""] as [String : Any]
//                            NetworkManager.SharedInstance.UploadImages(params: par, images: [img], success: { (res) in
//                                print(res)
//                                if i == self.images.count{
//                                    SVProgressHUD.dismiss()
////
//
//                                    Utilites.ShowAlert(title: "Success!!!", message: "Your request has been received we will contact you ASAP", view: self) { (alert) in
//                                        self.navigationController?.popViewController(animated: true)
//                                    }
//
//                                    self.view.isUserInteractionEnabled = true
//                                    self.reset()
//
//                                }
//                                i = i + 1
//                            }, failure: { (err) in
//                                SVProgressHUD.dismiss()
//                                self.view.isUserInteractionEnabled = true
//                                Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
//
//                            })
//
//                        }
//
//                    }, failure: { (err) in
//                        SVProgressHUD.dismiss()
//                        self.view.isUserInteractionEnabled = true
//                        Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
//                    })
//
//            }
        }
    }
    
    
    func reset()  {
        self.titleProduct.text = ""
        self.lotPrice.text = ""
        self.remarks.text = ""
        self.images.removeAll()
        if self.images.last != UIImage(named: "addimage"){
           self.images.append(UIImage(named: "addimage")!)
        }
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
                Utilites.ShowAlert(title: "Alert!!!", message: "MAx num of photos are 20", view: self)
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
        self.images.removeLast()
        for img in images{
            self.images.append(img)
        }
        self.images.append(UIImage(named: "addimage")!)
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
    
    
    @IBAction func backBTn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}
