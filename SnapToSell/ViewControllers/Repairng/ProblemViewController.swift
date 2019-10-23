
//
//  ProblemViewController.swift
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

class ProblemViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout , AddotherViewDelegate{

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var otherBtn: UIButton!
    var itemsArray = [Ljw_Issues]()
    var id = String()
    
    private let spacing:CGFloat = 10.0
    var addotherView : AddotherView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBG()
        self.otherBtn.setGradient()
        self.addPAger(totalPage: 7, currentPage: 5)
        fetchDetails(id: id)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView?.collectionViewLayout = layout
                    
        self.cancleBtn()
        self.backBtn()
//        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    

    func fetchDetails(id :String) {
        SVProgressHUD.show(withStatus: "Loading...")
        Alamofire.request(URL(string: "http://71.78.236.20/laptopzone/reactcontroller/c_react/ljw_Issues")!, method: HTTPMethod.post, parameters: ["get_product_name" : id], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print(response)
            SVProgressHUD.dismiss()
            guard (response.response?.statusCode) != nil else{
                return
            }
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    let res1 = Mapper<RepairModel>().map(JSON: value as! [String : Any])!
                    print(res1.ljw_Issues)
                    guard let arr = res1.ljw_Issues else{
                        return
                    }
                    self.itemsArray = arr
//                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                }
            }else{
                SVProgressHUD.dismiss()
                Utilites.ShowAlert(title: "Error!!", message: "Something went wrong", view: self)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsArray.count

    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "modelCell", for: indexPath) as! RepairingBrandCollectionViewCell
//            cell.textLabel?.text = self.itemsArray[indexPath.row].dESCRIPTION
//                cell.textLabel?.text = self.itemsArray[indexPath.row].iSSU_NAME
        cell.brandName.text = self.itemsArray[indexPath.row].iSSU_NAME
        return cell

     }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let main = self.storyboard?.instantiateViewController(withIdentifier: "ContactDetailsViewController") as! ContactDetailsViewController
        Constants.issuesId = self.itemsArray[indexPath.row].iSSUE_DT_ID!
        self.navigationController?.pushViewController(main, animated: true)
    }
            
            
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
           let numberOfItemsPerRow:CGFloat = 2
           let spacingBetweenCells:CGFloat = 10


           let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row

           if let collection = self.collectionView{
               let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
               return CGSize(width: width + 10, height: 110)
           }else{
               return CGSize(width: 0, height: 0)
           }

    }
    
    
    @IBAction func otherBtn(_ sender: Any) {
        
        addView()
    }
    
    
    
    
    func didClose(text: String) {
           self.otherBtn.setTitle(text, for: .normal)
           self.addotherView.removeFromSuperview()
                  
          UIView.animate(withDuration: 0.3) {

              self.addotherView.alpha = 0
              self.addotherView = nil
          }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (time) in
                             
                     
            let main = self.storyboard?.instantiateViewController(withIdentifier: "ContactDetailsViewController") as! ContactDetailsViewController
            self.navigationController?.pushViewController(main, animated: true)
                             
        }
               
        
    }
       
    
    func didClose() {
        self.addotherView.removeFromSuperview()
                
        UIView.animate(withDuration: 0.3) {

            self.addotherView.alpha = 0
            self.addotherView = nil
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
       
    
}
