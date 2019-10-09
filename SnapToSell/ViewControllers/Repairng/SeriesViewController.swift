//
//  SeriesViewController.swift
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

class SeriesViewController: UIViewController,UITableViewDataSource, UITableViewDelegate , AddotherViewDelegate{
    

    
    @IBOutlet weak var tableVew: UITableView!
    var itemsArray = [Ljw_Series]()
    var id = String()
    var addotherView : AddotherView!
    
    @IBOutlet weak var otherBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addPAger(totalPage: 7, currentPage: 3)
        self.addBG()
        self.fetchDetails(id: id)
        
        self.otherBtn.setGradient()
        
        self.tableVew.tableFooterView = UIView()
        self.cancleBtn()
        self.backBtn()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableVew.reloadData()
    }
    

    func fetchDetails(id :String) {
        SVProgressHUD.show(withStatus: "Loading...")
        Alamofire.request(URL(string: "http://71.78.236.20/laptopzone/reactcontroller/c_react/ljw_Series")!, method: HTTPMethod.post, parameters: ["get_brand_name" : id], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print(response)
            guard (response.response?.statusCode) != nil else{
                return
            }
            SVProgressHUD.dismiss()
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    let res1 = Mapper<RepairModel>().map(JSON: value as! [String : Any])!
                    print(res1.ljw_getobject)
                    guard let arr = res1.ljw_Series else{
                        return
                    }
                    self.itemsArray = arr
                    self.tableVew.reloadData()
//                    self.collectionView.reloadData()
                }
            }else{
                SVProgressHUD.dismiss()
                Utilites.ShowAlert(title: "Error!!", message: "Something went wrong", view: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
  
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
        

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "seriesCell", for: indexPath) as! SideMenuTableViewCell

        cell.nameLbl.text = self.itemsArray[indexPath.row].sERIES_NAME
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        if #available(iOS 13.0, *) {
            cell.imageView?.tintColor = UIColor.red
            cell.imgView.image = UIImage(systemName: "circle")
        } else {
            // Fallback on earlier versions
        }
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        
        let indexPath1 = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example

        let currentCell = tableView.cellForRow(at: indexPath1!) as! SideMenuTableViewCell

        if #available(iOS 13.0, *) {
            currentCell.imageView?.tintColor = UIColor.red
            currentCell.imgView.image = UIImage(systemName: "largecircle.fill.circle")
        } else {
            // Fallback on earlier versions
        }
        
        
        let main = self.storyboard?.instantiateViewController(withIdentifier: "ModelViewController") as! ModelViewController
        main.id = self.itemsArray[indexPath.row].sERIES_DT_ID!
        Constants.seriesId = self.itemsArray[indexPath.row].sERIES_DT_ID!
        self.navigationController?.pushViewController(main, animated: true)
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

      Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (time) in
        
//        print("asdfadf")
        let main = self.storyboard?.instantiateViewController(withIdentifier: "ModelViewController") as! ModelViewController
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
       
      

}