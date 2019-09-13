//
//  PendingProductDetailViewController.swift
//  SnapToSell
//
//  Created by Apple on 8/29/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SDWebImage
class PendingProductDetailViewController: UIViewController ,UICollectionViewDelegate , UICollectionViewDataSource{
  

    @IBOutlet weak var previewIamge: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var titleProduct: UILabel!
    
    @IBOutlet weak var lotPrice: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var remarks: UILabel!
    
    var detail = RequestStatusModel()
    var img = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       fetchSingalProduct()
        // Do any additional setup after loading the view.
    }
    
    func fetchSingalProduct()  {
        print("\(String(describing: detail!.id!))")
        NetworkManager.SharedInstance.getSingalRequest(request_id: "\(String(describing: detail!.id!))", success: { (res) in
            self.detail = res
            if (self.detail?.images!.count)! > 0 {
                self.previewIamge.sd_setImage(with: URL(string: (self.detail?.images![0].url)!), placeholderImage: UIImage(named: "placeholder.png"))
                
            }
            
            self.titleProduct.text = self.detail?.title
            self.lotPrice.text = "\(String(describing: self.detail!.price!))"
            self.dateLbl.text = self.detail?.created_at
            self.status.text = self.detail?.status
            self.remarks.text = self.detail?.remarks
            self.img = (self.detail?.images!.count)!
            self.collectionView.reloadData()
            
        }) { (err) in
            Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return img
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCollectionViewCell", for: indexPath) as! ProductImageCollectionViewCell
        
        cell.productImage.sd_setImage(with: URL(string: (self.detail?.images![indexPath.row].url)!), placeholderImage: UIImage(named: "placeholder.png"))
//        cell.productImage.sd_setImage(with: URL(self.detail?.images![indexPath.row]), placeholderImage: UIImage(named: "placeholder.png"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.previewIamge.sd_setImage(with: URL(string: (self.detail?.images![indexPath.row].url)!), placeholderImage: UIImage(named: "placeholder.png"))
    }

}
