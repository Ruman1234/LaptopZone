//
//  AllAddresViewController.swift
//  SnapToSell
//
//  Created by Apple on 8/23/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD

class AllAddresViewController: UIViewController ,UITableViewDataSource , UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var addBtn: UIBarButtonItem!
    @IBOutlet var menuBtn: UIBarButtonItem!
    
    var addresses = [AddressesModel]()
    var type = String()
    var defaultAddressViewController = DefaultAddressViewController()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        if self.type == "selectaddress"{
//            print(self.revealViewController()?.navigationController?.viewControllers.count)
//            print(self.navigationController?.viewControllers.count as Any)
//            print(self.navigationController?.viewControllers as Any)
//            print(self.navigationController?.viewControllers[2] as Any)
//            let a = self.navigationController?.viewControllers[2] as! DefaultAddressViewController
//            defaultAddressViewController = a
//
//
//        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getaddress()
    }
    override func viewDidAppear(_ animated: Bool) {

        self.navigationController?.navigationItem.hidesBackButton = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true

        self.navigationItem.leftBarButtonItem = menuBtn
        
        
        if self.type != "selectaddress"{
            
            self.menuBtn.target = self.revealViewController()
            self.menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        }
        
    }
    
    func getaddress()  {
        SVProgressHUD.show(withStatus: "Loading...")
        NetworkManager.SharedInstance.getAddress(success: { (response) in
            
            print(response)
            SVProgressHUD.dismiss()
            self.addresses = response
            print(self.addresses.count)
            self.tableView.reloadData()
            if self.addresses.count < 5 {
                self.navigationItem.rightBarButtonItem = self.addBtn
            }
        }) { (error) in
            
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!", message: "something went wrong", view: self)
            print("error")
            
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let addres = self.addresses[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell", for: indexPath) as! AddressTableViewCell
        cell.name.text = addres.contact_name
        cell.aptStreet.text = addres.apartment! + "," + addres.street!
        cell.city.text = addres.city
        cell.state.text = addres.state
        cell.zip.text = addres.zip
        cell.number.text = addres.phone
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if self.type == "selectaddress"{
            
            Constants.address = self.addresses[indexPath.row]
            self.dismiss(animated: true, completion: nil)
            
        }else{
            
            let bottomSheet = UIAlertController(title: "Address", message: "", preferredStyle: .actionSheet)
            
            
            let edit = UIAlertAction(title: "Edit", style: .default) { (alert) in
                let main = self.storyboard?.instantiateViewController(withIdentifier: "AddNewAddressViewController") as! AddNewAddressViewController
                main.type = "update"
                main.address = self.addresses[indexPath.row]
                self.navigationController?.pushViewController(main, animated: true)
            }
            
            let delete = UIAlertAction(title: "delete", style: .destructive) { (alert) in
                
                
                self.deleteAddress(id: "\(self.addresses[indexPath.row].id!)", indexpath: indexPath)
            }
            
            let cancle = UIAlertAction(title: "Cancle", style: .cancel) { (res) in
                
            }
            
            bottomSheet.addAction(edit)
            bottomSheet.addAction(delete)
            bottomSheet.addAction(cancle)
            self.present(bottomSheet, animated: true, completion: nil)
            
        }
        
       
    }
    
    func deleteAddress(id :String , indexpath : IndexPath)  {
        print(id)
        print(indexpath)
        SVProgressHUD.show(withStatus: "Loading...")
        NetworkManager.SharedInstance.deleteAddress(id: id, success: { (success) in
            SVProgressHUD.dismiss()
            self.addresses.remove(at: indexpath.row)
            self.tableView.deleteRows(at: [indexpath], with: .automatic)
            if self.addresses.count < 5 {
                self.navigationItem.rightBarButtonItem = self.addBtn
            }
        }) { (error) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!", message: "something went wrong", view: self)
        }
    }
    
    
    
    @IBAction func addbtn(_ sender: Any) {
        let main = self.storyboard?.instantiateViewController(withIdentifier: "AddNewAddressViewController") as! AddNewAddressViewController
        main.type = "add"
        self.navigationController?.pushViewController(main, animated: true)
    }
    
    
    
}
