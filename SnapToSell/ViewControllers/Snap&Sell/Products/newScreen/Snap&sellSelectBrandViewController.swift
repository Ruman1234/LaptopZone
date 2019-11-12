//
//  Snap&sellSelectBrandViewController.swift
//  SnapToSell
//
//  Created by Apple on 10/8/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

struct selectProduct {
    var name : String!
    var id : String!
    var image : UIImage?
}

class Snap_sellSelectBrandViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let spacing:CGFloat = 10.0
//    let arr = ["Phones" , "Ipad/Tablet" , "Laptop"]
    let arr = [selectProduct(name: "Phones", id: "6", image: UIImage(named: "iphones")),
               selectProduct(name: "Ipad/Tablet", id: "5", image: UIImage(named: "ipad")),
               selectProduct(name: "Laptop", id: "2", image: UIImage(named: "prod-3"))]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView?.collectionViewLayout = layout
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
         self.addBG()
               self.addPAger(totalPage: 7, currentPage: 0)
               self.backBtn()
               self.cancleBtn()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "brandCell", for: indexPath) as! RepairingBrandCollectionViewCell
        
        cell.brandName.text = arr[indexPath.row].name
        cell.imageView.image = arr[indexPath.row].image
//        print(arr[indexPath.row].image)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    
       let main = self.storyboard?.instantiateViewController(withIdentifier: "snap_sellSelectModelViewController") as! snap_sellSelectModelViewController
        
        main.id = arr[indexPath.row].id
        Constants.productName = arr[indexPath.row].id
       self.navigationController?.pushViewController(main, animated: true)
        
    }
    
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
