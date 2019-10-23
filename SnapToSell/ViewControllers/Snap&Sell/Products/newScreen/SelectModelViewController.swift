//
//  SelectModelViewController.swift
//  SnapToSell
//
//  Created by Apple on 10/14/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD

class SelectModelViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
   

    @IBOutlet weak var collectionView: UICollectionView!
    private let spacing:CGFloat = 10.0
    
    var id = String()
    
    var brandArray = [Buy_SellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBG()
        self.addPAger(totalPage: 7, currentPage: 3)
        self.cancleBtn()
        self.backBtn()
        

        
        print(self.id)
        self.callApi(id: self.id)
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView?.collectionViewLayout = layout
        // Do any additional setup after loading the view.
    }
    
    
    func callApi(id : String)  {
        SVProgressHUD.show(withStatus: "Loading...")
        
        NetworkManager.SharedInstance.getModel(Id: id, success: { (res) in
            
            SVProgressHUD.dismiss()
            guard let arr = res.model else{
                return
            }
            
            self.brandArray = arr
            self.collectionView.reloadData()
        }) { (err) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.brandArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "brandCell", for: indexPath) as! RepairingBrandCollectionViewCell

        cell.brandName.text = self.brandArray[indexPath.row].DESCRIPTION
//        cell.imageView.sd_setImage(with: URL(string: self.brandArray[indexPath.row].BRAND_URL_FULL!), placeholderImage: UIImage(named: "placeholder.png"))
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          
      
         let main = self.storyboard?.instantiateViewController(withIdentifier: "CarierServisesViewController") as! CarierServisesViewController
       
        main.id = self.brandArray[indexPath.row].MODEL_DT_ID!
        main.name = self.brandArray[indexPath.row].DESCRIPTION!
        Constants.model_name = self.brandArray[indexPath.row].MODEL_DT_ID!
         self.navigationController?.pushViewController(main, animated: true)
          
      }
    
    
//   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//           let numberOfItemsPerRow:CGFloat = 3
//           let spacingBetweenCells:CGFloat = 10
//
//
//           let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
//
//           if let collection = self.collectionView{
//               let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
//   //            self.height.constant = width
//   //            self.width.constant = width
//
//               return CGSize(width: width, height: 180)
//
//           }else{
//               return CGSize(width: 0, height: 0)
//           }
//
//   }
       
           

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
             let numberOfItemsPerRow:CGFloat = 2
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
         
    
}
