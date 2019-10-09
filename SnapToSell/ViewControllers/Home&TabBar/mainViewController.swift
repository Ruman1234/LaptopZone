//
//  mainViewController.swift
//  SnapToSell
//
//  Created by Apple on 10/3/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class mainViewController: UIViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBG()
        self.setRedStatusBar()
        self.tabBarController?.tabBar.isHidden = false
        self.hidesBottomBarWhenPushed = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        self.hidesBottomBarWhenPushed = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        self.hidesBottomBarWhenPushed = false
    }
    
    @IBAction func repair(_ sender: Any) {
        let main = self.storyboard?.instantiateViewController(withIdentifier: "UploadViewController") as! UploadViewController

//        self.tabBarController?.navigationController?.pushViewController(main, animated: true)
        self.navigationController?.pushViewController(main, animated: true)
                    
    }
    
    @IBAction func recycle(_ sender: Any) {
        let main = self.storyboard?.instantiateViewController(withIdentifier: "ContactDetailsViewController") as! ContactDetailsViewController
           
        main.type = "recycle"
//        self.tabBarController?.navigationController?.pushViewController(main, animated: true)
        self.navigationController?.pushViewController(main, animated: true)
                    
    }
    
    @IBAction func sellDevice(_ sender: Any) {
        let main = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
//        self.tabBarController?.navigationController?.pushViewController(main, animated: true)
        self.navigationController?.pushViewController(main, animated: true)
              
    }

    

}
