//
//  HomeViewController.swift
//  SnapToSell
//
//  Created by Apple on 10/3/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource{

    
    @IBOutlet var menuBtn: UIBarButtonItem!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var upperView: UIView!
    
    @IBOutlet weak var requestView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var AllProducts = [RequestStatusModel]()
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setGragientBar()
        self.getAllProductList()
        
        requestView.layer.cornerRadius = 8
        self.addButton.layer.cornerRadius = self.addButton.frame.width / 2
        self.menuBtn.target = self.revealViewController()
        self.menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.upperView.applyGradient(colours: [UIColor(red: 0.99, green: 0.17, blue: 0.03, alpha: 1) , UIColor(red: 1, green: 0.49, blue: 0, alpha: 1)], locations: nil, startPoint: CGPoint(x: 0.25, y: 0.5), endPoint: CGPoint(x: 0.75, y: 0.5))
        
        self.addButton.applyGradient(colours: [UIColor.init(rgb: 0xFC2B08) , UIColor.init(rgb: 0xFF3000) , UIColor.init(rgb: 0xFF7C00)], locations: nil, startPoint: CGPoint(x: 0.25, y: 0.5), endPoint: CGPoint(x: 0.75, y: 0.5))
        
        self.addButton.layer.cornerRadius = self.addButton.frame.width / 2
        
        if #available(iOS 13.0, *) {
            self.addButton.setImage(.add, for: .normal)
        } else {
            // Fallback on earlier versions
        }
        
        
         func viewWillAppear(_ animated: Bool) {
               
               super.viewWillAppear(true)
               self.tabBarController?.tabBar.isHidden = false
               self.hidesBottomBarWhenPushed = false
           }
           
            func viewDidAppear(_ animated: Bool) {
               super.viewDidAppear(true)
               self.tabBarController?.tabBar.isHidden = false
               self.hidesBottomBarWhenPushed = false
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
}
