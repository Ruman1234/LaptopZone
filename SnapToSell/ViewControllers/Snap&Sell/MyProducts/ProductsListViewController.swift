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
    @IBOutlet var menubtn: UIBarButtonItem!
    
    var AllProducts = [RequestStatusModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = menubtn
        self.menubtn.target = self.revealViewController()
        self.menubtn.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        getProductList()
        getAllProductList()
    }
    
    
    func getProductList() {
        SVProgressHUD.show(withStatus: "Loading..")
        NetworkManager.SharedInstance.RequestStatus(status: "NEW", success: { (response) in
           SVProgressHUD.dismiss()
            self.AllProducts = response
            self.tableView.reloadData()
        }) { (err) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!", message: "something went wrong", view: self)
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
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Pending")
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
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = self.AllProducts[indexPath.row]
        if product.status == "NEW" {
            
            
            let main = self.storyboard?.instantiateViewController(withIdentifier: "PendingProductDetailViewController") as! PendingProductDetailViewController
            main.detail = self.AllProducts[indexPath.row]
            self.navigationController?.pushViewController(main, animated: true)
            
            
        }else if product.status == "PROCESSED" {
            
            
            let main = self.storyboard?.instantiateViewController(withIdentifier: "ProcessedProductsViewController") as! ProcessedProductsViewController
            
            main.id = "\(String(describing: self.AllProducts[indexPath.row].id!))"
            self.navigationController?.pushViewController(main, animated: true)
            
            
        }else if product.status == "APPROVED" {
            
            
            let main = self.storyboard?.instantiateViewController(withIdentifier: "ApprovedProductDetailViewController") as! ApprovedProductDetailViewController
            main.detail = self.AllProducts[indexPath.row]
            self.navigationController?.pushViewController(main, animated: true)
            
            
        }
       
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
    
    
}



class PendingProductsListViewController: UIViewController , UITableViewDelegate , UITableViewDataSource ,IndicatorInfoProvider {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var AllProducts = [RequestStatusModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getProductList()
    }
    
    func getProductList() {
        SVProgressHUD.show(withStatus: "Loading..")
        NetworkManager.SharedInstance.RequestStatus(status: "PROCESSED", success: { (response) in
            SVProgressHUD.dismiss()
            self.AllProducts = response
            self.tableView.reloadData()
        }) { (err) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!", message: "something went wrong", view: self)
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PROCESSED")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.AllProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let product = self.AllProducts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell", for: indexPath) as! AddressTableViewCell
        cell.productName.text = product.title
        if product.images!.count > 0 {
            cell.productImage.sd_setImage(with: URL(string: product.images![0].url!), placeholderImage: UIImage(named: "placeholder.png"))
        }
        cell.delBTn.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let main = self.storyboard?.instantiateViewController(withIdentifier: "ProcessedProductsViewController") as! ProcessedProductsViewController
//        main.detail = self.AllProducts[indexPath.row]
        main.id = "\(String(describing: self.AllProducts[indexPath.row].id!))"
        self.navigationController?.pushViewController(main, animated: true)
    }
    
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
    
    
    
  
}



class ApprovedProductsListViewController: UIViewController , UITableViewDelegate , UITableViewDataSource ,IndicatorInfoProvider{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var AllProducts = [RequestStatusModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getProductList()
    }
    
    func getProductList() {
        SVProgressHUD.show(withStatus: "Loading..")
        NetworkManager.SharedInstance.RequestStatus(status: "APPROVED", success: { (response) in
            SVProgressHUD.dismiss()
            self.AllProducts = response
            self.tableView.reloadData()
        }) { (err) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!", message: "something went wrong", view: self)
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Approved")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.AllProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let product = self.AllProducts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell", for: indexPath) as! AddressTableViewCell
        cell.productName.text = product.title
        if product.images!.count > 0 {
            cell.productImage.sd_setImage(with: URL(string: product.images![0].url!), placeholderImage: UIImage(named: "placeholder.png"))
        }
        cell.delBTn.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let main = self.storyboard?.instantiateViewController(withIdentifier: "ApprovedProductDetailViewController") as! ApprovedProductDetailViewController
        main.detail = self.AllProducts[indexPath.row]
        self.navigationController?.pushViewController(main, animated: true)
    }
    
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
    

}
