//
//  newTabBarViewController.swift
//  SnapToSell
//
//  Created by Apple on 10/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class newTabBarViewController: ButtonBarPagerTabStripViewController  {
  
    static let SharedInstance = newTabBarViewController()
    @IBOutlet weak var barView: ButtonBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBG()
//        if self.accountViewController == nil {
//            self.accountViewController = nil
//        self.accountViewController?.delegte = self
//        }
      
//        let inputHandler = accountViewController()
//        let inputReceiver = newTabBarViewController()
//        inputHandler.delegate = inputReceiver
        NotificationCenter.default.addObserver(self, selector: #selector(self.showSpinningWheel(_:)), name: NSNotification.Name(rawValue: "sendData"), object: nil)
        
          self.datasource = self
                containerView.isScrollEnabled = true
                  self.buttonBarView.frame = CGRect(x: 0, y: 89, width: self.view.frame.width, height: 40)
                changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
                    guard
                        changeCurrentIndex == true
                        else {
                            return
                    }
                    
                    oldCell?.label.textColor = UIColor.lightGray
                    newCell?.label.textColor = Constants.APP_THEME_COLOR
                }
                settings.style.buttonBarBackgroundColor = UIColor.white
                settings.style.buttonBarItemsShouldFillAvailableWidth = true
                
                // change selected bar color
                settings.style.buttonBarItemBackgroundColor = UIColor.clear
                settings.style.selectedBarBackgroundColor = UIColor.black
        //        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 16)
                settings.style.buttonBarItemTitleColor = UIColor.black
        //        settings.style.selectedBarHeight = 1.0
                settings.style.buttonBarMinimumLineSpacing = 0
                settings.style.selectedBarHeight = 3
                settings.style.buttonBarLeftContentInset = 0
                settings.style.buttonBarRightContentInset = 0
                settings.style.buttonBarHeight = 5
                buttonBarView.selectedBar.backgroundColor = Constants.APP_THEME_COLOR
        //        buttonBarView.selectedBar.heightAnchor = 1
                buttonBarView.selectedBar.frame.size.height = 1
                buttonBarView.selectedBar.viewWithTag(1)
                
                
                edgesForExtendedLayout = []
                buttonBarView.frame.origin.y = buttonBarView.frame.origin.y
                buttonBarView.layer.backgroundColor = UIColor.clear.cgColor
        //        let selectedBarHeight: CGFloat = 2
        //
        //        buttonBarView.selectedBar.frame.origin.y = buttonBarView.frame.size.height + selectedBarHeight
//                buttonBarView.layer.shadowColor = UIColor.black.cgColor
//                buttonBarView.layer.shadowOffset = CGSize(width: 0, height: 3)
//                buttonBarView.layer.shadowOpacity = 0.3
//                buttonBarView.layer.masksToBounds = false
            buttonBarView.layer.backgroundColor = UIColor.clear.cgColor
         buttonBarView.layer.backgroundColor = UIColor.clear.cgColor
                self.automaticallyAdjustsScrollViewInsets = false
                
                buttonBarView.selectedBar.frame.origin.x = buttonBarView.frame.size.width + 1
        
        // Do any additional setup after loading the view.
    }

        
        
    override func viewDidAppear(_ animated: Bool) {
        let requestImg = UIImageView()
        requestImg.image = UIImage(named: "Your Requests")
        requestImg.frame = CGRect(x: 25, y: 42, width: 166, height: 22)
        self.view.addSubview(requestImg)

        let xside = self.view.frame.width / 1.123


        let sideImg = UIImageView()
        sideImg.image = UIImage(named: "sideimg1")
        sideImg.frame = CGRect(x: xside, y: 45, width: 25, height: 15)
        self.view.addSubview(sideImg)
//        moveToViewController(at: 2)

    }
    
    
    
    @objc func showSpinningWheel(_ notification: NSNotification) {
         print(notification.userInfo ?? "")
         if let dict = notification.userInfo as NSDictionary? {
             if let id = dict["image"] as? Int{
                 // do something with your image
                self.tabBarController?.selectedIndex = 4
                print(id)
                moveToViewController(at: id)
             }
         }
    }

  
//    func moveto(index : Int)  {
////        self.tabBarController?.selectedIndex = 4
////        moveToViewController(at: index)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(self.showSpinningWheel(_:)), name: NSNotification.Name(rawValue: "sendData"), object: nil)
//
//
////        self.viewDidLoad()
//
//    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
           
           let child1 = self.storyboard?.instantiateViewController(withIdentifier: "NewProductsListViewController")
           
           let child2 = self.storyboard?.instantiateViewController(withIdentifier: "PendingProductsListViewController")

           let child3 = self.storyboard?.instantiateViewController(withIdentifier: "ApprovedProductsListViewController")
           let child4 = self.storyboard?.instantiateViewController(withIdentifier: "Snap_SellListViewController")
                 
           return [child1! , child2! , child3!, child4!]
           
       }


}
