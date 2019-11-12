//
//  HomeViewController.swift
//  SnapToSell
//
//  Created by Apple on 10/3/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD
import SocketIO
import AVFoundation


@available(iOS 13.0, *)
class HomeViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource{

    
    @IBOutlet var menuBtn: UIBarButtonItem!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var upperView: UIView!
    
    @IBOutlet weak var requestView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var AllProducts = [RequestStatusModel]()
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    let manager = SocketManager(socketURL: URL(string: "http://71.78.236.22:6001")!, config: [.log(true), .compress])
    var socket : SocketIOClient!
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.addButton.setGradient()
        
        socketdata()
        
        self.tableView.tableFooterView = UIView()
        
        self.getAllProductList()
        
        requestView.layer.cornerRadius = 8
        self.menuBtn.target = self.revealViewController()
        self.menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
//        self.upperView.applyGradient(colours: [
//            UIColor(red: 0.99, green: 0.17, blue: 0.03, alpha: 1),
//          UIColor(red: 1, green: 0.49, blue: 0, alpha: 1)
//        ], locations: [0.12, 1], startPoint: CGPoint(x:0.00, y: 0.1), endPoint: CGPoint(x: 1, y: 1))
        
    }
    
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        self.tabBarController?.tabBar.isHidden = false
//        self.hidesBottomBarWhenPushed = false
        self.setGragientBar()
        self.upperView.applyGradient(colours: [
                   UIColor(red: 0.99, green: 0.17, blue: 0.03, alpha: 1),
                 UIColor(red: 1, green: 0.49, blue: 0, alpha: 1)
               ], locations: [0.12, 1], startPoint: CGPoint(x:0.00, y: 0.1), endPoint: CGPoint(x: 1, y: 1))
    }
    
    override func viewWillAppear(_ animated: Bool) {
                 
         super.viewWillAppear(true)
         self.getAllProductList()
//         self.tabBarController?.tabBar.isHidden = false
//         self.hidesBottomBarWhenPushed = false
    }
    
    func socketdata(){
        socket = manager.defaultSocket

//        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

        socket.connect()

        print(socket.status)
        print("ASfda")


        let json = [
          "channel" : "private-App.User.\(CustomUserDefaults.userId.value!)",
          "name"    : "subscribe",
          "auth"    : [
              "headers" : [
                  "Authorization"  : "Bearer " + CustomUserDefaults.Token.value! ,
                  "Accept"         : "application/json",
                  "client_id"      : "21",
                  "client_secret"  : "4KPwfKtXjuaQlFuU69B4dHvFHGblYQ5GsurdbHqM",
              ]
          ]

        ] as [String : Any]

        print(json)


        socket.on(clientEvent: .connect) {data, ack in
          print("socket connected")
          self.socket.emit("subscribe", json)

        }
        
        
        socket.on("MessagePushed") { (dataArray, socketAck) -> Void in
            
            let dd =  dataArray[1] as! [String: AnyObject]
                     print(dd)
                     
                    let msg = dd["message"] as! [String: AnyObject]
                     print(msg)
                     print(msg.count)
                     let type = msg["type"] as! String
                     print(type)
                     let content = msg["content"] as! String
                     print(content)
            
            
              if #available(iOS 13.0, *) {
                  let appDelegate = UIApplication.shared.delegate as? AppDelegate
                  appDelegate?.scheduleNotification(title: "New message from Admin", body: content)
              } else {
                  // Fallback on earlier versions
              }
            
            
        }
        
    }
    
    func getAllProductList() {
       SVProgressHUD.show(withStatus: "Loading..")
       NetworkManager.SharedInstance.AllProductsRequest( success: { (response) in
           SVProgressHUD.dismiss()
           self.AllProducts = response
           self.tableView.reloadData()
       }) { (err) in
           SVProgressHUD.dismiss()
           Utilites.ShowAlert(title: "Error!!", message: "something went wrong", view: self)
       }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return self.AllProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let product = self.AllProducts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell", for: indexPath) as! AddressTableViewCell
        cell.productName.text = product.title
        if (product.cover != nil) {
          cell.productImage.sd_setImage(with: URL(string: product.cover!), placeholderImage: UIImage(named: "placeholder.png"))
        }else{
          cell.productImage.image = UIImage(named: "placeholder.png")
        }
        cell.statusLbl.text = product.status

        cell.selectionStyle = .none
        
        return cell
    }
      
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let product = self.AllProducts[indexPath.row]
//        if product.status == "NEW" {
//
//
//            let main = self.storyboard?.instantiateViewController(withIdentifier: "PendingProductDetailViewController") as! PendingProductDetailViewController
//            main.detail = self.AllProducts[indexPath.row]
//            self.navigationController?.pushViewController(main, animated: true)
//
//
//        }else if product.status == "PROCESSED" {
//
//
//            let main = self.storyboard?.instantiateViewController(withIdentifier: "ProcessedProductsViewController") as! ProcessedProductsViewController
//
//            main.id = "\(String(describing: self.AllProducts[indexPath.row].id!))"
//            self.navigationController?.pushViewController(main, animated: true)
//
//
//        }else if product.status == "APPROVED" {
//
//
//            let main = self.storyboard?.instantiateViewController(withIdentifier: "ApprovedProductDetailViewController") as! ApprovedProductDetailViewController
//            main.detail = self.AllProducts[indexPath.row]
//            self.navigationController?.pushViewController(main, animated: true)
//
//
//        }
//
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 85
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       return true
    }
       
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
     
       let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
           let alert = UIAlertController(title: "!!!!", message: "Are you sure", preferredStyle: .alert)
           
           var reason = ""
           
           alert.addTextField {  (textField : UITextField!) -> Void  in
               //             searchTextField?.delegate = self
               reason = textField.text!
               
           }
           alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
               NetworkManager.SharedInstance.CancleRequest(request_id: "\(self.AllProducts[indexPath.row].id!)", reason: reason, success: { (res) in
                   print(res)
                   self.AllProducts.remove(at:indexPath.row)
                   self.tableView.reloadData()
               }, failure: { (err) in
                   Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong ", view: self)
               })
           }))
           
           alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
               
           }))
           self.present(alert, animated: true, completion: nil)
           
       })
       
       return [deleteAction]
    }
    
    @IBAction func addBtn(_ sender: Any) {
        
        
//        let main = self.storyboard?.instantiateViewController(withIdentifier: "mainViewController") as! mainViewController
//        self.tabBarController?.navigationController?.pushViewController(main, animated: true)
        
        
//        let main = self.storyboard?.instantiateViewController(identifier: "ProductDetailViewController") as! ProductDetailViewController
//        self.tabBarController?.navigationController?.pushViewController(main, animated: true)
    }
    
    
    @IBAction func sellMobile(_ sender: Any) {
        let main = self.storyboard?.instantiateViewController(withIdentifier: "Snap_sellSelectBrandViewController") as! Snap_sellSelectBrandViewController

        self.navigationController?.pushViewController(main, animated: true)
                     
    }
    
    @IBAction func repairBtn(_ sender: Any) {
        
        let main = self.storyboard?.instantiateViewController(withIdentifier: "UploadViewController") as! UploadViewController

        //        self.tabBarController?.navigationController?.pushViewController(main, animated: true)
        self.navigationController?.pushViewController(main, animated: true)
                            
        
    }
    
    @IBAction func recycleBtn(_ sender: Any) {
        let main = self.storyboard?.instantiateViewController(withIdentifier: "ContactDetailsViewController") as! ContactDetailsViewController
                   
        main.type = "recycle"
        //        self.tabBarController?.navigationController?.pushViewController(main, animated: true)
        self.navigationController?.pushViewController(main, animated: true)
                            
    }
    
    
    @IBAction func profileBtn(_ sender: Any) {
        let main = self.storyboard?.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(main, animated: true)
    }
    
    
    @IBAction func notificationBtn(_ sender: Any) {
        
        self.tabBarController?.selectedIndex = 3
    }
    
    
    @IBAction func settingBtn(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    
    
    
}
