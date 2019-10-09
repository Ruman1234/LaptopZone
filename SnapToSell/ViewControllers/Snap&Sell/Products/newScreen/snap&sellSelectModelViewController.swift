//
//  snap&sellSelectModelViewController.swift
//  SnapToSell
//
//  Created by Apple on 10/8/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class snap_sellSelectModelViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
   

    @IBOutlet weak var collectionView: UICollectionView!
    private let spacing:CGFloat = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBG()
        self.addPAger(totalPage: 7, currentPage: 1)
        self.cancleBtn()
        self.backBtn()
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: 0, bottom: spacing, right: 0)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView?.collectionViewLayout = layout
        // Do any additional setup after loading the view.
    }
 
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return 10
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "brandCell", for: indexPath) as! RepairingBrandCollectionViewCell

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          
      
         let main = self.storyboard?.instantiateViewController(withIdentifier: "CarierServisesViewController") as! CarierServisesViewController
       
         self.navigationController?.pushViewController(main, animated: true)
          
      }
    
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let numberOfItemsPerRow:CGFloat = 3
           let spacingBetweenCells:CGFloat = 10
           
           
           let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
           
           if let collection = self.collectionView{
               let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
   //            self.height.constant = width
   //            self.width.constant = width
               
               return CGSize(width: width, height: 180)
               
           }else{
               return CGSize(width: 0, height: 0)
           }
    
   }
       
           

}
