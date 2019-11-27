//
//  NotificationViewController.swift
//  SnapToSell
//
//  Created by Apple on 10/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD

class NotificationViewController: UIViewController  ,UITableViewDelegate , UITableViewDataSource,UISearchBarDelegate{
    
    @IBOutlet var searchBtn: UIBarButtonItem!
    @IBOutlet var menuBTn: UIBarButtonItem!
    
    @IBOutlet weak var noNotificationView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var notificationArray = [notificationModel]()
    var fileterNotificationArray = [notificationModel]()
    var searchArray = false
       
     var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 10, height: 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBG()
        self.searchBar.tintColor = UIColor.white
        self.searchBar.delegate = self
        self.navigationItem.leftBarButtonItem = self.menuBTn
        self.navigationItem.rightBarButtonItem = self.searchBtn
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.apiCall()
    }

 
    override func viewDidAppear(_ animated: Bool) {

        self.navigationController?.navigationBar.isHidden = false
         self.navigationController?.navigationBar.isTranslucent = true
              self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
         let view = UIView()
                view.layer.masksToBounds = true
                view.frame = CGRect(x: 0, y: 15, width: (navigationController?.navigationBar.frame.width)!, height: 50)
                self.view.addSubview(view)
        //
                view.applyGradient(colours: [
                    UIColor(red: 0.99, green: 0.17, blue: 0.03, alpha: 1),
                  UIColor(red: 1, green: 0.49, blue: 0, alpha: 1)
                ], locations: [0.12, 1], startPoint: CGPoint(x:0.00, y: 0.1), endPoint: CGPoint(x: 1, y: 1))
//        let requestImg = UIImageView()
//        requestImg.image = UIImage(named: "Notification-1")
//        requestImg.frame = CGRect(x: 25, y: 42, width: 162, height: 22)
//        self.view.addSubview(requestImg)
//
//        let xside = self.view.frame.width / 1.123
//
//
//        let sideImg = UIImageView()
//        sideImg.image = UIImage(named: "sideimg1")
//        sideImg.frame = CGRect(x: xside, y: 45, width: 25, height: 15)
//        self.view.addSubview(sideImg)
    }
    
    
    
    func apiCall()  {
        SVProgressHUD.show(withStatus: "Loading...")
        NetworkManager.SharedInstance.getNotificaiton(success: { (res) in
            print(res)
            SVProgressHUD.dismiss()
            
            self.notificationArray = res
            
            if self.notificationArray.count == 0 {
                self.tableView.isHidden = true
            }else{
                self.noNotificationView.isHidden = true
            }
            self.tableView.reloadData()
            
        }) { (err) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.searchArray {
            return self.fileterNotificationArray.count
        }else{
            return notificationArray.count
        }
        
    }
       
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
        var notification = notificationModel()
    
        if self.searchArray {
            notification = self.notificationArray[indexPath.row]
        }else{
          notification = self.notificationArray[indexPath.row]
        }
    
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Message_NotificationTableViewCell", for: indexPath) as! Message_NotificationTableViewCell
    
        cell.nameLbl.text = notification.data!.title
        cell.descriptionLBl.text = notification.data!.body
        cell.selectionStyle = .none

        return cell
   }
       

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = self.notificationArray[indexPath.row]
//        product.data?.request_id
        
//              if product.status == "NEW" {
//
//
//                  let main = self.storyboard?.instantiateViewController(withIdentifier: "PendingProductDetailViewController") as! PendingProductDetailViewController
//
//                  main.detail = self.AllProducts[indexPath.row]
//                  self.navigationController?.pushViewController(main, animated: true)
//
//
//              }else if product.status == "PROCESSED" || product.status == "DELIVERED" || product.status == "CANCELLED" {
//
//
//                  let main = self.storyboard?.instantiateViewController(withIdentifier: "ProcessedProductsViewController") as! ProcessedProductsViewController
//
//                  main.id = "\(String(describing: self.AllProducts[indexPath.row].id!))"
//                  if self.AllProducts[indexPath.row].conversation_id != nil {
//                      main.conversation_id = "\(String(describing: self.AllProducts[indexPath.row].conversation_id!))"
//                  }else{
//                       main.conversation_id = ""
//                  }
//
//                  self.navigationController?.pushViewController(main, animated: true)
//
//
//              }else if product.status == "APPROVED" {
//
//
//                  let main = self.storyboard?.instantiateViewController(withIdentifier: "ApprovedProductDetailViewController") as! ApprovedProductDetailViewController
//                  main.detail = self.AllProducts[indexPath.row]
//                  self.navigationController?.pushViewController(main, animated: true)
//
//
//              }
    }
    
    
    

        @IBAction func searchBtn(_ sender: Any) {
            
            searchBar.placeholder = "Search"

            self.navigationItem.leftBarButtonItems?.removeAll()
            self.navigationItem.rightBarButtonItems?.removeAll()
            
            
            self.searchBar.becomeFirstResponder()
            let leftNavBarButton = UIBarButtonItem(customView:searchBar)
            searchBar.showsCancelButton = true
            self.navigationItem.leftBarButtonItem = leftNavBarButton
            
            
            UIView.animate(withDuration: 3) {
                self.view.layoutIfNeeded()
            }
            

        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

            self.navigationItem.leftBarButtonItem = menuBTn
            self.navigationItem.rightBarButtonItem = searchBtn
            self.searchArray = false
            self.tableView.reloadData()
            UIView.animate(withDuration: 0.7) {
              self.view.layoutIfNeeded()
            }
            
        }

        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            
            fileterNotificationArray = notificationArray.filter { (candy: notificationModel) -> Bool in
                return candy.data!.title!.lowercased().contains(searchText.lowercased())
            }

            self.searchArray = true
            self.tableView.reloadData()
        }
        
    


}
