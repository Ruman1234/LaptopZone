
//
//  SelectYourProductViewController.swift
//  SnapToSell
//
//  Created by Apple on 9/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class SelectYourProductViewController: UIViewController {

    
    @IBOutlet weak var destopPc: UIButton!
    
    @IBOutlet weak var LAptop: UIButton!
    
    @IBOutlet var menubtn: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addPAger(totalPage: 7, currentPage: 1)
        
        self.addBG()
//        self.navigationItem.leftBarButtonItem = menubtn
//        self.menubtn.target = self.revealViewController()
//        self.menubtn.action = #selector(SWRevealViewController.revealToggle(_:))
//        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.btn(btn: destopPc)
        self.btn(btn: LAptop)
        self.cancleBtn()
        self.backBtn()
        // Do any additional setup after loading the view.
    }
    
    func btn(btn : UIButton)  {
        btn.layer.shadowOffset = CGSize(width: 0, height: 3)
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowRadius = 4
        btn.layer.shadowOpacity = 0.5
        btn.layer.masksToBounds = false
    }
    
    @IBAction func desktop(_ sender: Any) {
        
        let main = self.storyboard?.instantiateViewController(withIdentifier: "RepairBrandViewController") as! RepairBrandViewController
        main.id = "1"
        Constants.productId = "1"
        self.navigationController?.pushViewController(main, animated: true)
        
    }
    
    @IBAction func pc(_ sender: Any) {
        
        let main = self.storyboard?.instantiateViewController(withIdentifier: "RepairBrandViewController") as! RepairBrandViewController
        main.id = "2"
        Constants.productId = "2"
        self.navigationController?.pushViewController(main, animated: true)
        
        
    }
    
}
