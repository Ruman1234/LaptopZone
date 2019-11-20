//
//  CarierServisesViewController.swift
//  SnapToSell
//
//  Created by Apple on 10/8/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD

class CarierServisesViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
   

    @IBOutlet weak var collectionView: UICollectionView!
    private let spacing:CGFloat = 10.0
    var id = String()
    var name = String()
    

    let imageView = UIImageView(image: UIImage(named: "no_net (1)"))
                              let button = UIButton(type: UIButton.ButtonType.system) as UIButton

                        
                     @objc func buttonAction(_ sender:UIButton!)
                        {
                            if Utilites.isInternetAvailable() {
                                self.imageView.isHidden = true
                                self.button.isHidden = true
                    //            self.viewWillAppear(true)
                                self.callApi(id: self.id)
                            }else{
                                self.showToast(message: "Internet is not availble")
                            }
                        }
  
    
    
    var brandArray = [Buy_SellModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBG()
        self.addPAger(totalPage: 7, currentPage: 4)
        self.cancleBtn()
        self.backBtn()
        
        if Utilites.isInternetAvailable() {
            self.callApi(id: self.id)
          }else{
            self.netCheck(button: button, imageView: imageView)
              button.addTarget(self, action: #selector(self.buttonAction(_:)), for: .touchUpInside)
                  
          }
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView?.collectionViewLayout = layout
        // Do any additional setup after loading the view.
    }
 
    
    override func viewDidAppear(_ animated: Bool) {
            self.addBG()
//                  self.addPAger(totalPage: 7, currentPage: 0)
                  self.backBtn()
                  self.cancleBtn()
       }
    
    func callApi(id : String)  {
          SVProgressHUD.show(withStatus: "Loading...")
          NetworkManager.SharedInstance.getCarier(Id: id, success: { (res) in
            
              SVProgressHUD.dismiss()
              guard let arr = res.carier else{
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
        return brandArray.count
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "brandCell", for: indexPath) as! RepairingBrandCollectionViewCell
//        
        cell.brandName.text = self.brandArray[indexPath.row].CARRIER_NAME
        cell.imageView.sd_setImage(with: URL(string: self.brandArray[indexPath.row].IMAGE_URL_FULL!), placeholderImage: UIImage(named: "placeholder.png"))
//        cell.imageView.sd_setImage(with: URL(string: self.brandArray[indexPath.row].BRAND_URL_FULL!), placeholderImage: UIImage(named: "placeholder.png"))
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let main = self.storyboard?.instantiateViewController(withIdentifier: "SelectPhoneModelViewController") as! SelectPhoneModelViewController
        main.id = self.brandArray[indexPath.row].LZW_CARRIER_DT_ID!
 
        main.carierService = self.brandArray[indexPath.row].CARRIER_NAME!
        main.name = self.name
        Constants.carrier_name = self.brandArray[indexPath.row].LZW_CARRIER_DT_ID!
        
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
