
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
    
    @IBOutlet var menubtn: UIBarButtonItem!
    @IBOutlet weak var barView: ButtonBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationItem.hidesBackButton = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        
        self.navigationItem.leftBarButtonItem = menubtn
        
        self.menubtn.target = self.revealViewController()
        self.menubtn.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard
                changeCurrentIndex == true
                else {
                    return
            }
            
            oldCell?.label.textColor = UIColor.lightGray
            newCell?.label.textColor = UIColor.black
        }
        settings.style.buttonBarBackgroundColor = UIColor.white
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
    
        settings.style.buttonBarItemBackgroundColor = UIColor.white
        settings.style.selectedBarBackgroundColor = UIColor.black
        
        settings.style.buttonBarItemTitleColor = UIColor.black
        
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.selectedBarHeight = 1
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.buttonBarHeight = 1
        buttonBarView.selectedBar.frame.size.height = 1
        buttonBarView.selectedBar.viewWithTag(1)
        
        
        edgesForExtendedLayout = []
        buttonBarView.frame.origin.y = buttonBarView.frame.origin.y
        buttonBarView.layer.backgroundColor = UIColor.white.cgColor

        buttonBarView.layer.shadowColor = UIColor.black.cgColor
        buttonBarView.layer.shadowOffset = CGSize(width: 0, height: 3)
        buttonBarView.layer.shadowOpacity = 0.3
        buttonBarView.layer.masksToBounds = false
//        self.automaticallyAdjustsScrollViewInsets = false

//        buttonBarView.selectedBar.frame.origin.x = buttonBarView.frame.size.width + 1
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
//        buttonBarView.selectedBar.frame.origin.x = buttonBarView.frame.size.width + 1
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child1 = self.storyboard?.instantiateViewController(withIdentifier: "NewProductsListViewController")
        
        let child2 = self.storyboard?.instantiateViewController(withIdentifier: "PendingProductsListViewController")

        let child3 = self.storyboard?.instantiateViewController(withIdentifier: "ApprovedProductsListViewController")
        
        return [child1!, child2! , child3!]

    }

   

}



