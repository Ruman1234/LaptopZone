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
    @IBOutlet weak var noAddressView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var addBtn: UIBarButtonItem!
    @IBOutlet var menuBtn: UIBarButtonItem!
    
    @IBOutlet weak var addNewAddressBtn: UIButton!
    var addresses = [AddressesModel]()
    var type = String()
    var defaultAddressViewController = DefaultAddressViewController()
   let imageView = UIImageView(image: UIImage(named: "no_net (1)"))
            let button = UIButton(type: UIButton.ButtonType.system) as UIButton

    
      
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBG()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if Utilites.isInternetAvailable() {
           getaddress()
        }else{
              self.netCheck(button: button, imageView: imageView)
              button.addTarget(self, action: #selector(ViewController.buttonAction(_:)), for: .touchUpInside)
                
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {

      
        
        
        if self.type != "selectaddress"{
            self.navigationController?.navigationItem.hidesBackButton = false
            self.navigationController?.navigationBar.isHidden = false
            self.navigationItem.hidesBackButton = true
            
            
            self.navigationItem.leftBarButtonItem = menuBtn
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
            if self.addresses.count == 0 {
//                Utilites.ShowAlert(title: "Oops", message: "You don't have any address kindly add a new address", view: self) { (res) in
//                      let main = self.storyboard?.instantiateViewController(withIdentifier: "AddNewAddressViewController") as! AddNewAddressViewController
//
//                        main.type = "add"
//                        main.isdefault = "yes"
////                    main.defaultAddress.isOn = true
//                        self.navigationController?.pushViewController(main, animated: true)

//                }
                self.addNewAddressBtn.isHidden = true
                
                self.noAddressView.isHidden = false
              
            }
            
            if self.addresses.count >= 5 {
//                self.navigationItem.rightBarButtonItem = self.addBtn
                self.addNewAddressBtn.isHidden = true
            }else{
//                self.navigationItem.rightBarButtonItem = nil
                self.addNewAddressBtn.isHidden = false
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
        
        if addres.is_default! {
            cell.defaultLbl.text = "Default"
            cell.defaultLbl.textColor = UIColor.red
        }else{
            cell.defaultLbl.text = "Make Default"
            cell.defaultLbl.textColor = UIColor.darkGray
        }
        
        
        cell.name.text = addres.contact_name
        cell.aptStreet.text = (addres.apartment ?? "") + "," + (addres.street ?? "")
        cell.city.text = addres.city! + "," + addres.state!
//        cell.state.text = addres.state
        cell.zip.text = addres.zip
        cell.number.text = addres.phone
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 181
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if self.type == "selectaddress"{
            
            Constants.address = self.addresses[indexPath.row]
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }else{
            
            let bottomSheet = UIAlertController(title: "Address", message: "", preferredStyle: .actionSheet)
            
            
            let edit = UIAlertAction(title: "Edit", style: .default) { (alert) in
                let main = self.storyboard?.instantiateViewController(withIdentifier: "AddNewAddressViewController") as! AddNewAddressViewController
                main.type = "update"
                
                main.address = self.addresses[indexPath.row]
                self.navigationController?.pushViewController(main, animated: true)
            }
            
            let delete = UIAlertAction(title: "Delete", style: .destructive) { (alert) in
                
                
                self.deleteAddress(id: "\(self.addresses[indexPath.row].id!)", indexpath: indexPath)
            }
            
            let cancle = UIAlertAction(title: "Cancel", style: .cancel) { (res) in
                
            }
            
            
            if let popoverController = bottomSheet.popoverPresentationController {
                     popoverController.sourceView = self.view
                     popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                     popoverController.permittedArrowDirections = []
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
           if self.addresses.count >= 5 {
            //                self.navigationItem.rightBarButtonItem = self.addBtn
                self.addNewAddressBtn.isHidden = true
            }else{
//                self.navigationItem.rightBarButtonItem = nil
                self.addNewAddressBtn.isHidden = false
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
    
    
    
    @IBAction func addNewAddress(_ sender: Any) {
        let main = self.storyboard?.instantiateViewController(withIdentifier: "AddNewAddressViewController") as! AddNewAddressViewController
              main.type = "add"
              self.navigationController?.pushViewController(main, animated: true)
    }
    
    
    @IBAction func backbtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func buttonAction(_ sender:UIButton!)
           {
               if Utilites.isInternetAvailable() {
                   self.imageView.isHidden = true
                   self.button.isHidden = true
                getaddress()
           //            self.viewWillAppear(true)
               }else{
                   self.showToast(message: "Internet is not availble")
               }
           }
    
}
