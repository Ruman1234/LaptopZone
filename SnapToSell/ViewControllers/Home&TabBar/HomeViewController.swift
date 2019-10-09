//
//  HomeViewController.swift
//  SnapToSell
//
//  Created by Apple on 10/3/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    
    @IBOutlet var menuBtn: UIBarButtonItem!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var upperView: UIView!
    
    @IBOutlet weak var requestView: UIView!
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setGragientBar()
        
        
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
    
    

   
    
    
    @IBAction func addBtn(_ sender: Any) {
        
        
//        let main = self.storyboard?.instantiateViewController(withIdentifier: "mainViewController") as! mainViewController
//        self.tabBarController?.navigationController?.pushViewController(main, animated: true)
        
        
//        let main = self.storyboard?.instantiateViewController(identifier: "ProductDetailViewController") as! ProductDetailViewController
//        self.tabBarController?.navigationController?.pushViewController(main, animated: true)
    }
    
    
}
