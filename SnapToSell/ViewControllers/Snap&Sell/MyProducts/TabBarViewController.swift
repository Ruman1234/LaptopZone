
//
//  TabBarViewController.swift
//  SnapToSell
//
//  Created by Apple on 8/28/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class TabBarViewController:  ButtonBarPagerTabStripViewController{
    
    @IBOutlet weak var barView: ButtonBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBG()
//        self.setGragientBar()
        
        
      
              
        
        self.buttonBarView.frame = CGRect(x: 0, y: 89, width: self.view.frame.width, height: 40)
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard
                changeCurrentIndex == true
                else {
                    return
            }
            
            oldCell?.label.textColor = UIColor.lightGray
            newCell?.label.textColor = UIColor.black
        }
        settings.style.buttonBarBackgroundColor = UIColor.clear
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
    
        settings.style.buttonBarItemBackgroundColor = UIColor.white
        settings.style.selectedBarBackgroundColor = UIColor.black
        
        settings.style.buttonBarItemTitleColor = UIColor.black
        
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.selectedBarHeight = 1
        
//        settings.style.buttonBarLeftContentInset = 0
//        settings.style.buttonBarRightContentInset = 0
        settings.style.buttonBarHeight = 1
        
        
        buttonBarView.selectedBar.frame.size.height = 1
//        buttonBarView.selectedBar.frame = CGRect(x: <#T##Int#>, y: <#T##Int#>, width: <#T##Int#>, height: <#T##Int#>)
        buttonBarView.selectedBar.viewWithTag(1)
        buttonBarView.selectedBar.backgroundColor = UIColor.red
        
        buttonBarView.layer.backgroundColor = UIColor.clear.cgColor
        
        edgesForExtendedLayout = []
        buttonBarView.frame.origin.y = buttonBarView.frame.origin.y
        buttonBarView.layer.backgroundColor = UIColor.clear.cgColor

        
//        buttonBarView.layer.shadowColor = UIColor.black.cgColor
//        buttonBarView.layer.shadowOffset = CGSize(width: 0, height: 3)
//        buttonBarView.layer.shadowOpacity = 0.3
//        buttonBarView.layer.masksToBounds = false
        self.automaticallyAdjustsScrollViewInsets = false

//        buttonBarView.selectedBar.frame.origin.x = buttonBarView.frame.size.width + 1
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let requestImg = UIImageView()
              requestImg.image = UIImage(named: "Your Requests")
              requestImg.frame = CGRect(x: 25, y: 42, width: 166, height: 22)
              self.view.addSubview(requestImg)
              
              let xside = self.view.frame.width / 1.123
              
              
              let sideImg = UIImageView()
              requestImg.image = UIImage(named: "sideimg1")
              requestImg.frame = CGRect(x: xside, y: 45, width: 25, height: 15)
              self.view.addSubview(sideImg)
//        buttonBarView.selectedBar.frame.origin.x = (buttonBarView.selectedBar.frame.size.width / 2) - 22.5
//        buttonBarView.selectedBar.frame.size.width = 45
//        buttonBarView.selectedBar.frame = CGRect(x:  buttonBarView.selectedBar.frame.size.width / 2, y: <#T##Int#>, width: <#T##Int#>, height: <#T##Int#>)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child1 = self.storyboard?.instantiateViewController(withIdentifier: "NewProductsListViewController")
        
        let child2 = self.storyboard?.instantiateViewController(withIdentifier: "PendingProductsListViewController")

        let child3 = self.storyboard?.instantiateViewController(withIdentifier: "ApprovedProductsListViewController")
        let child4 = self.storyboard?.instantiateViewController(withIdentifier: "Snap_SellListViewController")
              
        return [ child2! , child3!, child4!]
        
    }

   

}



