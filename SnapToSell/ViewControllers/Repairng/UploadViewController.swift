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
        
        self.addPAger(totalPage: 7, currentPage: 0)
        self.addBG()
        
        nextBtn.setGradient()
        nextBtn.setFont(size: 19.5)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionview?.collectionViewLayout = layout
        self.backBtn()
        self.cancleBtn()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionview.reloadData()
        self.tabBarController?.tabBar.isHidden = false
        self.images.append(UIImage(named: "addimage")!)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "uploadCell", for: indexPath) as! RepairingBrandCollectionViewCell
        cell.imageView.image = images[indexPath.row]
        
        return cell
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
        
        if indexPath.row == self.images.count - 1{
            openCamer()
        }
    }
    
    
    
    func openCamer() {
        
        let imagesource = UIAlertController(title: "Image source", message: "", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Take Picture", style: .default) { (ale) in
            self.images.removeLast()
            let main = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
            main.type = "repair"
            self.navigationController?.pushViewController(main, animated: true)
            
        }
        let media = UIAlertAction(title: "Media", style: .default) { (ale) in
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                //Show error to user?
                return
            }
            self.images.removeLast()
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
