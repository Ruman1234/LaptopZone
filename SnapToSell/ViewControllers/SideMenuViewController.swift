

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
    
    let arr = ["Home" ,"My Products" , "Addresses" , "Repair" ,"Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            let main = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let userdefaults = UserDefaults.standard
            userdefaults.set(false, forKey: "islogin")
            userdefaults.removeObject(forKey: "Token")
//            let front = UINavigationController.init(rootViewController: main)
//            revealViewController()?.pushFrontViewController(front, animated: true)
            //            main.type = "selectaddress"
            self.navigationController?.pushViewController(main, animated: true)
//            self.revealViewController()?.pushFrontViewController(main, animated: true)
            
        }
    }
    
}
