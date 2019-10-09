//
//  Snap&sellSelectBrandViewController.swift
//  SnapToSell
//
//  Created by Apple on 10/8/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class Snap_sellSelectBrandViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
   

    @IBOutlet weak var collectionView: UICollectionView!
    private let spacing:CGFloat = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBG()
        self.addPAger(totalPage: 7, currentPage: 0)
        self.cancleBtn()
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
