//
//  UploadViewController.swift
//  SnapToSell
//
//  Created by Apple on 10/5/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import OpalImagePicker

class UploadViewController: UIViewController , UICollectionViewDelegateFlowLayout , UICollectionViewDelegate , UICollectionViewDataSource, OpalImagePickerControllerDelegate{
    
    
    
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var collectionview: UICollectionView!
    
    private let spacing:CGFloat = 10.0
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let a = self.navigationController?.viewControllers[1] as! mainViewController
        
     
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionview?.collectionViewLayout = layout
      
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
          self.backBtn()
              self.cancleBtn()
        self.addPAger(totalPage: 7, currentPage: 0)
             self.addBG()
             
             nextBtn.setGradient()
             nextBtn.setFont(size: 19.5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionview.reloadData()
        self.tabBarController?.tabBar.isHidden = false
        if self.images.last != UIImage(named: "addimage"){
            self.images.append(UIImage(named: "addimage")!)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "uploadCell", for: indexPath) as! RepairingBrandCollectionViewCell
        cell.imageView.image = images[indexPath.row]
        
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
    
    
    
    func remove(_ i: Int) {
       
       self.images.remove(at: i)
       let indexPath = IndexPath(row: i, section: 0)
//        self.collectionview
       self.collectionview.performBatchUpdates({
           self.collectionview.deleteItems(at: [indexPath])
       }) { (finished) in
           self.collectionview.reloadItems(at: self.collectionview.indexPathsForVisibleItems)
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

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = 3
        let spacingBetweenCells:CGFloat = 10
        
        
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        if let collection = self.collectionview{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
//            self.height.constant = width
//            self.width.constant = width
            
            return CGSize(width: width, height: width)
            
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
        
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (indexPath.row == self.images.count - 1) && indexPath.row <= 20{
            openCamer()
        }
    }
    
    
    
    func openCamer() {
        
        let imagesource = UIAlertController(title: "Image source", message: "", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Take Picture", style: .default) { (ale) in
            
            if self.images.count < 21 {
                self.images.removeLast()
                let main = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
                main.type = "repair"
                self.navigationController?.pushViewController(main, animated: true)
                
            }else{
              Utilites.ShowAlert(title: "Alert!!!", message: "Max num of photos are 20", view: self)
            }
                      
            
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
    
    
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        //Cancel action?
        print("adsasd")
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
    
        self.images.removeLast()
        print(images.count)
        for img in images{
            self.images.append(img)
        }
        self.images.append(UIImage(named: "addimage")!)
        self.collectionview.reloadData()
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
    
    @IBAction func nextBtn(_ sender: Any) {
        if self.images.count < 4 {
            self.showToast(message: "Please select atleast 3 images")
        }else{
            self.images.removeLast()
            Constants.UploadImage = self.images
            
            let main = self.storyboard?.instantiateViewController(withIdentifier: "SelectYourProductViewController") as! SelectYourProductViewController

            self.navigationController?.pushViewController(main, animated: true)
                                
        }
        
    }
    
    
    
}
