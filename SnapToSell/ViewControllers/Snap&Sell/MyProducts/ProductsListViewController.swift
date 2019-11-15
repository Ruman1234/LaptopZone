//
//  ProductsListViewController.swift
//  SnapToSell
//
//  Created by Apple on 8/28/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SDWebImage
import XLPagerTabStrip
import SVProgressHUD


class NewProductsListViewController: UIViewController , UITableViewDelegate , UITableViewDataSource,IndicatorInfoProvider {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var norequestView: UIView!
    
    @IBOutlet weak var createRequestBtn: UIButton!
    var AllProducts = [RequestStatusModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.addBG()
//        self.createRequestBtn.setGradient()
//        self.tableView.delegate
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        getProductList()
        getProductList()
        self.createRequestBtn.setGradient()
    }
    
    
    func getProductList() {
        SVProgressHUD.show(withStatus: "Loading..")
        NetworkManager.SharedInstance.RequestStatus(searcInput: "rep", success: { (response) in
           SVProgressHUD.dismiss()
            self.AllProducts = response
            if  self.AllProducts.count != 0 {
                self.tableView.isHidden = false
                self.norequestView.isHidden = true
            }else{
                self.tableView.isHidden = true
                self.norequestView.isHidden = false
            }
            
            self.tableView.reloadData()
        }) { (err) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!", message: "something went wrong", view: self)
        }
    }
    
//    func getAllProductList() {
//        SVProgressHUD.show(withStatus: "Loading..")
//        NetworkManager.SharedInstance.AllProductsRequest( success: { (response) in
//            SVProgressHUD.dismiss()
//            self.AllProducts = response
//            self.tableView.reloadData()
//        }) { (err) in
//            SVProgressHUD.dismiss()
//            Utilites.ShowAlert(title: "Error!!", message: "something went wrong", view: self)
//        }
//    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Repairing")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.AllProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let product = self.AllProducts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell", for: indexPath) as! AddressTableViewCell
        cell.productName.text = product.MODEL_NAME
        cell.priceLbl.text = Double(product.OFFER!)?.dollarString
        
        if (product.IMAGE_URL_FULL != nil) {
            cell.productImage.sd_setImage(with: URL(string: product.IMAGE_URL_FULL!), placeholderImage: UIImage(named: "placeholder.png"))
        }else{
            cell.productImage.image = UIImage(named: "placeholder.png")
        }
        
        cell.statusLbl.text = product.STATUS
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = self.AllProducts[indexPath.row]
        if product.STATUS == "NEW" {
            
            
            let main = self.storyboard?.instantiateViewController(withIdentifier: "PendingProductDetailViewController") as! PendingProductDetailViewController
            main.type = "rep"
            main.detail = self.AllProducts[indexPath.row]
            self.navigationController?.pushViewController(main, animated: true)
            
            
        }else if product.STATUS == "PROCESSED" || product.STATUS == "DELIVERED" || product.STATUS == "CANCELLED" {
            let main = self.storyboard?.instantiateViewController(withIdentifier: "ProcessedProductsViewController") as! ProcessedProductsViewController
            main.detail = self.AllProducts[indexPath.row]
            main.type = "rep"
            self.navigationController?.pushViewController(main, animated: true)
                      
            
//            let main = self.storyboard?.instantiateViewController(withIdentifier: "ProcessedProductsViewController") as! ProcessedProductsViewController
//
//            main.id = "\(String(describing: self.AllProducts[indexPath.row].id!))"
//            if self.AllProducts[indexPath.row].conversation_id != nil {
//                main.conversation_id = "\(String(describing: self.AllProducts[indexPath.row].conversation_id!))"
//            }else{
//                 main.conversation_id = ""
//            }
//
//            self.navigationController?.pushViewController(main, animated: true)
//
            
        }else if product.STATUS == "APPROVED" {
            let main = self.storyboard?.instantiateViewController(withIdentifier: "PendingProductDetailViewController") as! PendingProductDetailViewController
            main.type = "rep"
            main.approves = true
            main.detail = self.AllProducts[indexPath.row]
            self.navigationController?.pushViewController(main, animated: true)
                      
//
//            let main = self.storyboard?.instantiateViewController(withIdentifier: "ApprovedProductDetailViewController") as! ApprovedProductDetailViewController
//            main.detail = self.AllProducts[indexPath.row]
//            main.type = "rep"
//            self.navigationController?.pushViewController(main, animated: true)
            
            
            
        }
       
    }
     
    
    @IBAction func deleteBtn(_ sender: AnyObject) {
        let alert = UIAlertController(title: "!!!!", message: "Are you sure", preferredStyle: .alert)
        
        var reason = ""
       
        alert.addTextField {  (textField : UITextField!) -> Void  in
//             searchTextField?.delegate = self
            reason = textField.text!
            
        }
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            NetworkManager.SharedInstance.CancleRequest(request_id: "\(self.AllProducts[sender.tag].id!)", reason: reason, success: { (res) in
                print(res)
                self.AllProducts.remove(at:sender.tag)
                self.tableView.reloadData()
            }, failure: { (err) in
                Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong ", view: self)
            })
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
           
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func createRequestBtn(_ sender: Any) {
        
        
    }
    
    
    
}



class PendingProductsListViewController: UIViewController , UITableViewDelegate , UITableViewDataSource ,IndicatorInfoProvider {
    
    
    @IBOutlet weak var norequestView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createRequestBtn: UIButton!
      
    var AllProducts = [RequestStatusModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createRequestBtn.setGradient()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getProductList()
    }
    
    func getProductList() {
        SVProgressHUD.show(withStatus: "Loading..")
        NetworkManager.SharedInstance.RequestStatus(searcInput: "rec", success: { (response) in
            SVProgressHUD.dismiss()
            self.AllProducts = response
            if  self.AllProducts.count != 0 {
               self.tableView.isHidden = false
               self.norequestView.isHidden = true
           }else{
               self.tableView.isHidden = true
               self.norequestView.isHidden = false
           }
            self.tableView.reloadData()
        }) { (err) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!", message: "something went wrong", view: self)
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Recycling")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.AllProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let product = self.AllProducts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell", for: indexPath) as! AddressTableViewCell
        cell.productName.text = product.MODEL_NAME
        cell.priceLbl.text = Double(product.OFFER!)?.dollarString
//        if (product.cover != nil) {
//            cell.productImage.sd_setImage(with: URL(string: product.cover!), placeholderImage: UIImage(named: "placeholder.png"))
//        }else{
//            cell.productImage.image = UIImage(named: "placeholder.png")
//        }
        if (product.IMAGE_URL_FULL != nil) {
           cell.productImage.sd_setImage(with: URL(string: product.IMAGE_URL_FULL!), placeholderImage: UIImage(named: "placeholder.png"))
        }else{
           cell.productImage.image = UIImage(named: "placeholder.png")
        }
        cell.statusLbl.text = product.STATUS
        cell.selectionStyle = .none
//        cell.delBTn.tag = indexPath.row
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let product = self.AllProducts[indexPath.row]
            if product.STATUS == "NEW" {
                
                
                let main = self.storyboard?.instantiateViewController(withIdentifier: "PendingProductDetailViewController") as! PendingProductDetailViewController
                main.type = "rep"
                main.detail = self.AllProducts[indexPath.row]
                self.navigationController?.pushViewController(main, animated: true)
                
                
            }else if product.STATUS == "PROCESSED" || product.STATUS == "DELIVERED" || product.STATUS == "CANCELLED" {
                
                
//                let main = self.storyboard?.instantiateViewController(withIdentifier: "ProcessedProductsViewController") as! ProcessedProductsViewController
//
//                main.id = "\(String(describing: self.AllProducts[indexPath.row].id!))"
//                if self.AllProducts[indexPath.row].conversation_id != nil {
//                    main.conversation_id = "\(String(describing: self.AllProducts[indexPath.row].conversation_id!))"
//                }else{
//                     main.conversation_id = ""
//                }
//
//                self.navigationController?.pushViewController(main, animated: true)
                
                
            }else if product.STATUS == "APPROVED" {
                
    //
    //            let main = self.storyboard?.instantiateViewController(withIdentifier: "ApprovedProductDetailViewController") as! ApprovedProductDetailViewController
    //            main.detail = self.AllProducts[indexPath.row]
    //            self.navigationController?.pushViewController(main, animated: true)
                
                
            }
           
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let main = self.storyboard?.instantiateViewController(withIdentifier: "ProcessedProductsViewController") as! ProcessedProductsViewController
////        main.detail = self.AllProducts[indexPath.row]
//        main.id = "\(String(describing: self.AllProducts[indexPath.row].id!))"
//        self.navigationController?.pushViewController(main, animated: true)
//    }
    
    @IBAction func deleteBtn(_ sender: AnyObject) {
        let alert = UIAlertController(title: "!!!!", message: "Are you sure", preferredStyle: .alert)
        
        
        var reason = ""
        alert.addTextField { (text) in
            reason = text.text ?? ""
        }
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            NetworkManager.SharedInstance.CancleRequest(request_id: "\(self.AllProducts[sender.tag].id!)", reason: reason, success: { (res) in
                print(res)
                self.AllProducts.remove(at:sender.tag)
                self.tableView.reloadData()
            }, failure: { (err) in
                Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong ", view: self)
            })
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func createRequestBtn(_ sender: Any) {
              
              
    }
    
  
}



class ApprovedProductsListViewController: UIViewController , UITableViewDelegate , UITableViewDataSource ,IndicatorInfoProvider{
    
    
    @IBOutlet weak var norequestView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createRequestBtn: UIButton!
     
      
    
    
    var AllProducts = [RequestStatusModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createRequestBtn.setGradient()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getProductList()
    }
    
    func getProductList() {
        SVProgressHUD.show(withStatus: "Loading..")
        NetworkManager.SharedInstance.RequestStatus(searcInput: "sell", success: { (response) in
            SVProgressHUD.dismiss()
            self.AllProducts = response
            
            if  self.AllProducts.count != 0 {
               self.tableView.isHidden = false
               self.norequestView.isHidden = true
           }else{
               self.tableView.isHidden = true
               self.norequestView.isHidden = false
           }
            self.tableView.reloadData()
        }) { (err) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!", message: "something went wrong", view: self)
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Sell Device")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.AllProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let product = self.AllProducts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell", for: indexPath) as! AddressTableViewCell
        cell.productName.text = product.MODEL_NAME
        cell.priceLbl.text = Double(product.OFFER!)?.dollarString
//        if (product.cover != nil) {
//            cell.productImage.sd_setImage(with: URL(string: product.cover!), placeholderImage: UIImage(named: "placeholder.png"))
//        }else{
//            cell.productImage.image = UIImage(named: "placeholder.png")
//        }
        
        if (product.IMAGE_URL_FULL != nil) {
           cell.productImage.sd_setImage(with: URL(string: product.IMAGE_URL_FULL!), placeholderImage: UIImage(named: "placeholder.png"))
        }else{
           cell.productImage.image = UIImage(named: "placeholder.png")
        }
        
        cell.statusLbl.text = product.STATUS
        cell.selectionStyle = .none
//        cell.delBTn.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let product = self.AllProducts[indexPath.row]
            if product.STATUS == "PENDING" {
                
//                let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example

                let currentCell = tableView.cellForRow(at: tableView.indexPathForSelectedRow!) as! AddressTableViewCell

                let main = self.storyboard?.instantiateViewController(withIdentifier: "PendingProductDetailViewController") as! PendingProductDetailViewController
                main.type = "rep"
//                main.previewIamge.image = UIImage(named: "addimage")
                main.detail = self.AllProducts[indexPath.row]
                self.navigationController?.pushViewController(main, animated: true)
                
                
            }else if product.STATUS == "PROCESSED" || product.STATUS == "DELIVERED" || product.STATUS == "CANCELLED" {
                
                
//                let main = self.storyboard?.instantiateViewController(withIdentifier: "ProcessedProductsViewController") as! ProcessedProductsViewController
//
//                main.id = "\(String(describing: self.AllProducts[indexPath.row].id!))"
//                if self.AllProducts[indexPath.row].conversation_id != nil {
//                    main.conversation_id = "\(String(describing: self.AllProducts[indexPath.row].conversation_id!))"
//                }else{
//                     main.conversation_id = ""
//                }
//
//                self.navigationController?.pushViewController(main, animated: true)
                
                
            }else if product.STATUS == "APPROVED" {
                
    //
                
                
              let main = self.storyboard?.instantiateViewController(withIdentifier: "PendingProductDetailViewController") as! PendingProductDetailViewController
              main.type = "rep"
              main.approves = true
              main.detail = self.AllProducts[indexPath.row]
              self.navigationController?.pushViewController(main, animated: true)
                              
                
    //            let main = self.storyboard?.instantiateViewController(withIdentifier: "ApprovedProductDetailViewController") as! ApprovedProductDetailViewController
    //            main.detail = self.AllProducts[indexPath.row]
    //            self.navigationController?.pushViewController(main, animated: true)
                
                
            }
           
        }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let main = self.storyboard?.instantiateViewController(withIdentifier: "ApprovedProductDetailViewController") as! ApprovedProductDetailViewController
//        main.detail = self.AllProducts[indexPath.row]
//        self.navigationController?.pushViewController(main, animated: true)
//    }
    
    @IBAction func deleteBtn(_ sender: AnyObject) {
        let alert = UIAlertController(title: "!!!!", message: "Are you sure", preferredStyle: .alert)
        
        var reason = ""
        alert.addTextField { (text) in
            reason = text.text ?? ""
        }
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            
            
            NetworkManager.SharedInstance.CancleRequest(request_id: "\(self.AllProducts[sender.tag].id!)", reason: reason, success: { (res) in
                print(res)
                self.AllProducts.remove(at:sender.tag)
                self.tableView.reloadData()
            }, failure: { (err) in
                Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong ", view: self)
            })
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
      @IBAction func createRequestBtn(_ sender: Any) {
                
                
      }
      

}




class Snap_SellListViewController: UIViewController , UITableViewDelegate , UITableViewDataSource ,IndicatorInfoProvider{
    
    @IBOutlet weak var norequestView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createRequestBtn: UIButton!
  
    
    var AllProducts = [RequestStatusModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createRequestBtn.setGradient()
//        self.addBG()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        getProductList()
        getAllProductList()
    }
    
    
    
    
    func getAllProductList() {
        SVProgressHUD.show(withStatus: "Loading..")
        NetworkManager.SharedInstance.AllProductsRequest( success: { (response) in
            SVProgressHUD.dismiss()
            self.AllProducts = response
            
            if  self.AllProducts.count != 0 {
               self.tableView.isHidden = false
               self.norequestView.isHidden = true
            }else{
               self.tableView.isHidden = true
               self.norequestView.isHidden = false
            }
               
                
            self.tableView.reloadData()
        }) { (err) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!", message: "something went wrong", view: self)
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Snap2Sell")
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
        
        if product.status == "NEW" {
            cell.priceLbl.text = Double(product.asking_price ?? "0")?.dollarString
        }else if product.status == "PROCESSED" {
            cell.priceLbl.text = Double(product.offered_price ?? "0")?.dollarString
        }else if product.status == "APPROVED" {
            cell.priceLbl.text = Double(product.offered_price ?? "0")?.dollarString
        }
        
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = self.AllProducts[indexPath.row]
        if product.status == "NEW" {
            
            
            let main = self.storyboard?.instantiateViewController(withIdentifier: "PendingProductDetailViewController") as! PendingProductDetailViewController
            
            main.detail = self.AllProducts[indexPath.row]
            self.navigationController?.pushViewController(main, animated: true)
            
            
        }else if product.status == "PROCESSED" || product.status == "DELIVERED" || product.status == "CANCELLED" {
            
            
            let main = self.storyboard?.instantiateViewController(withIdentifier: "ProcessedProductsViewController") as! ProcessedProductsViewController
            
            main.id = "\(String(describing: self.AllProducts[indexPath.row].id!))"
            if self.AllProducts[indexPath.row].conversation_id != nil {
                main.conversation_id = "\(String(describing: self.AllProducts[indexPath.row].conversation_id!))"
            }else{
                 main.conversation_id = "" 
            }
            
            self.navigationController?.pushViewController(main, animated: true)
            
            
        }else if product.status == "APPROVED" {
            
            
            let main = self.storyboard?.instantiateViewController(withIdentifier: "ApprovedProductDetailViewController") as! ApprovedProductDetailViewController
            main.detail = self.AllProducts[indexPath.row]
            self.navigationController?.pushViewController(main, animated: true)
            
            
        }
       
    }
    
    @IBAction func deleteBtn(_ sender: AnyObject) {
        let alert = UIAlertController(title: "!!!!", message: "Are you sure", preferredStyle: .alert)
        
        var reason = ""
       
        alert.addTextField {  (textField : UITextField!) -> Void  in
//             searchTextField?.delegate = self
            reason = textField.text!
            
        }
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            NetworkManager.SharedInstance.CancleRequest(request_id: "\(self.AllProducts[sender.tag].id!)", reason: reason, success: { (res) in
                print(res)
                self.AllProducts.remove(at:sender.tag)
                self.tableView.reloadData()
            }, failure: { (err) in
                Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong ", view: self)
            })
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
           
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
      @IBAction func createRequestBtn(_ sender: Any) {
                
                
      }
      
    
}
