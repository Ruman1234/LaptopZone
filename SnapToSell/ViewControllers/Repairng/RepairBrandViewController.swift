//
//  RepairDetailViewController.swift
//  SnapToSell
//
//  Created by Apple on 9/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper
import SVProgressHUD

class RepairBrandViewController: UIViewController ,UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , AddotherViewDelegate{
    

    
    
//    @IBOutlet weak var tableView: UITableView!
    var id = String()
    var itemsArray = [Ljw_getobject]()
    private let spacing:CGFloat = 10.0
    
    @IBOutlet weak var otherBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var width: NSLayoutConstraint!
    
    var addotherView : AddotherView!
    
    var otherText = "Other"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addPAger(totalPage: 7, currentPage: 2)
        // Do any additional setup after loading the view.
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: 0, bottom: spacing, right: 0)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView?.collectionViewLayout = layout
        self.addBG()
        self.otherBtn.addDashedBorder()
        fetchDetails(id: id)
        self.cancleBtn()
        self.backBtn()
//        self.tableView.tableFooterView = UIView()
    }
    
    func fetchDetails(id :String) {
        SVProgressHUD.show(withStatus: "Loading...")
        Alamofire.request(URL(string: "http://71.78.236.20/laptopzone/reactcontroller/c_react/ljw_Brands")!, method: HTTPMethod.post, parameters: ["get_product_name" : id], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print(response)
            SVProgressHUD.dismiss()
            
            guard (response.response?.statusCode) != nil else{
                return
            }
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                   let res1 = Mapper<RepairModel>().map(JSON: value as! [String : Any])!
                    print(res1.ljw_getobject)
                    guard let arr = res1.ljw_getobject else{
                        return
                    }
                    self.itemsArray = arr
                    if self.itemsArray.count != 0 {
                        let last = Ljw_getobject()
                        self.itemsArray.append(last)

                    }
                    self.collectionView.reloadData()
                }
            }else{
                SVProgressHUD.dismiss()
                Utilites.ShowAlert(title: "Error!!", message: "Something went wrong", view: self)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        if self.itemsArray.count > 12 && self.itemsArray.count % 3 == 0 {
//            return self.itemsArray.count + 1
//        }else{
            return self.itemsArray.count
//        }
        
    }
    
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "brandCell", for: indexPath) as! RepairingBrandCollectionViewCell
    
        
    
        if indexPath.row == self.itemsArray.count - 1{


            cell.imageView.image = UIImage(named: "Rectangle 3.25")
            cell.bdView.layer.backgroundColor = UIColor.clear.cgColor
            cell.imageView.contentMode = .scaleToFill
            cell.brandName.text = self.otherText
        }else{
            cell.imageView.sd_setImage(with: URL(string: self.itemsArray[indexPath.row].image!), placeholderImage: UIImage(named: "placeholder.png"))
            
            cell.imageView.contentMode = .scaleAspectFit
            cell.brandName.isHidden = true
        }
    
        return cell
    
   }
       
       
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == self.itemsArray.count - 1{
            addView()
        }else{
            let main = self.storyboard?.instantiateViewController(withIdentifier: "SeriesViewController") as! SeriesViewController
            main.id = self.itemsArray[indexPath.row].bRAND_DT_ID!
            Constants.brandId = self.itemsArray[indexPath.row].bRAND_DT_ID!
            self.navigationController?.pushViewController(main, animated: true)
             
        }
       
    }
    
    
 //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
  //      return CGSize(width: CGFloat(collectionView.frame.size.width / 2.84), height: CGFloat(100))
 //   }
    
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
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
//    }
    
    /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrandCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = self.itemsArray[indexPath.row].bRAND_NAME
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let main = self.storyboard?.instantiateViewController(withIdentifier: "SeriesViewController") as! SeriesViewController
        main.id = self.itemsArray[indexPath.row].bRAND_DT_ID!
        Constants.brandId = self.itemsArray[indexPath.row].bRAND_DT_ID!
        self.navigationController?.pushViewController(main, animated: true)
    }
*/
    
    
    func didClose(text: String) {
        
        self.otherText = text
        self.collectionView.reloadData()
        self.otherBtn.setTitle(text, for: .normal)
        self.addotherView.removeFromSuperview()
               
       UIView.animate(withDuration: 0.3) {
           
           self.addotherView.alpha = 0
           self.addotherView = nil
        }
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (time) in
                
        //        print("asdfadf")
            let main = self.storyboard?.instantiateViewController(withIdentifier: "SeriesViewController") as! SeriesViewController
        //        main.id = self.itemsArray[indexPath.row].sERIES_DT_ID!
        //        Constants.seriesId = self.itemsArray[indexPath.row].sERIES_DT_ID!
            self.navigationController?.pushViewController(main, animated: true)
            
        }
        
    }
    
    
    func addView()  {
        if self.addotherView == nil {
            self.addotherView = nil
            self.addotherView = (Bundle.main.loadNibNamed("AddotherView", owner: self, options: nil)![0] as!  AddotherView)
            
            self.addotherView.delegate = self
            self.addotherView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                       
           self.view.addSubview(addotherView)
           UIView.animate(withDuration: 0.3) {

               self.addotherView.alpha = 1
           }
        }
    }
    
    @IBAction func otherBtn(_ sender: Any) {
        addView()
        
    }
    
}
