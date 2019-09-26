

//
//  SideMenuViewController.swift
//  SnapToSell
//
//  Created by Apple on 8/28/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var tabelVeiw: UITableView!
    @IBOutlet weak var countNumber: UIButton!
    @IBOutlet weak var countId: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var email: UILabel!
    
    var arr = ["Home" ,"My Products" , "Addresses" , "Repair" , "Recycle" ,"Logout" , "Verify Paypal"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userName.text = CustomUserDefaults.userName.value
        self.email.text = CustomUserDefaults.email.value
//        if CustomUserDefaults.VerifyPaypal.value != nil {
//            self.arr.removeLast()
//        }
//        userName.text = Constants.USERNAME
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
        
        cell.nameLbl.text = self.arr[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let main = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
            
            let front = UINavigationController.init(rootViewController: main)
            revealViewController()?.pushFrontViewController(front, animated: true)
//            self.navigationController?.pushViewController(main, animated: true)

//            self.revealViewController()?.pushFrontViewController(main, animated: true)
        }else if indexPath.row == 1{
            let main = self.storyboard?.instantiateViewController(withIdentifier: "NewProductsListViewController") as! NewProductsListViewController
            //            main.type = "selectaddress"
            let front = UINavigationController.init(rootViewController: main)
            revealViewController()?.pushFrontViewController(front, animated: true)
            
        }else if indexPath.row == 2{
            let main = self.storyboard?.instantiateViewController(withIdentifier: "AllAddresViewController") as! AllAddresViewController
            let front = UINavigationController.init(rootViewController: main)
            revealViewController()?.pushFrontViewController(front, animated: true)
//            main.type = "selectaddress"
//            self.navigationController?.pushViewController(main, animated: true)
//            self.revealViewController()?.pushFrontViewController(main, animated: true)

        }else if indexPath.row == 3{
            let main = self.storyboard?.instantiateViewController(withIdentifier: "SelectYourProductViewController") as! SelectYourProductViewController
          
            let front = UINavigationController.init(rootViewController: main)
            //            revealViewController()?.pushFrontViewController(front, animated: true)
            //            main.type = "selectaddress"
//            self.navigationController?.pushViewController(front, animated: true)
            self.revealViewController()?.pushFrontViewController(front, animated: true)
            
        }else if indexPath.row == 4{
            let main = self.storyboard?.instantiateViewController(withIdentifier: "ContactDetailsViewController") as! ContactDetailsViewController
             let front = UINavigationController.init(rootViewController: main)
          main.type = "recycle"
            self.revealViewController()?.pushFrontViewController(front, animated: true)
            
        
            
        }else if indexPath.row == 5{
            let main = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let userdefaults = UserDefaults.standard
            userdefaults.set(false, forKey: "islogin")
            userdefaults.removeObject(forKey: "Token")
            let add = AddressesModel()
            Constants.address = add
//            let front = UINavigationController.init(rootViewController: main)
//            revealViewController()?.pushFrontViewController(front, animated: true)
            //            main.type = "selectaddress"
            self.navigationController?.pushViewController(main, animated: true)
//            self.revealViewController()?.pushFrontViewController(main, animated: true)
            
        }else if indexPath.row == 6{
            
            let alert = UIAlertController(title: "!!!!", message: "Please enter your email", preferredStyle: .alert)
            
         
            
            alert.addTextField {  (textField : UITextField!) -> Void  in
                //             searchTextField?.delegate = self
                
                
            }
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                
                let firstTextField = alert.textFields![0] as UITextField
                
                if Utilites.isValid(email: firstTextField.text! as NSString) {
                    NetworkManager.SharedInstance.PaypalRequest(Email: (firstTextField.text! as NSString) as String, success: { (res) in
                        print(res)
                        Utilites.ShowAlert(title: "Success!!!", message: "email Registered successfully", view: self)
                    }, failure: { (err) in
                        Utilites.ShowAlert(title: "Error!!!", message: "Please enter a valid email", view: self)
                    })
                }else{
                    self.showToast(message: "Please enter a valid email")
                }
               
                
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
                
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
}
