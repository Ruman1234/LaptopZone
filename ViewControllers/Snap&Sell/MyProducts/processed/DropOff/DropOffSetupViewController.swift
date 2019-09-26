//
//  DropOffSetupViewController.swift
//  SnapToSell
//
//  Created by Apple on 8/30/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import StepView
import  SVProgressHUD

class DropOffSetupViewController: UIViewController {
    
    
    
    private var pageViewController: UIPageViewController!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var setupView: StepView!
    @IBOutlet weak var continueBtn: UIButton!
    
    var requestId = String()
    
    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: String.init(describing: DropOffDescriptionViewController.self)),
            self.getViewController(withIdentifier: String.init(describing: MapViewController.self)),
            //            self.getViewController(withIdentifier: String.init(describing: FirstViewController.self)),
            //            self.getViewController(withIdentifier: String.init(describing: SecondViewController.self))
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupControllers()
        NotificationCenter.default.addObserver(self, selector: #selector(self.backButtonDidPress), name: Notification.Name("backStepdropoff"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("asd")
    }
    
    private func setupControllers() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.view.frame = containerView.bounds
        containerView.addSubview(pageViewController.view)
        
        if let firstController = pages.first {
            pageViewController.setViewControllers([firstController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    private func getControllerToShow(from index: Int) -> UIViewController? {
        if index == 2 {

            self.continueBtn.setTitle("Confirm", for: .normal)
        }
        if index - 1 < pages.count {
            
            return pages[index - 1]
        }
        else {
            print("Index is out of range")
            return nil
        }
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonDidPress(_ sender: Any) {
        
        if self.continueBtn.titleLabel?.text == "Confirm"{
            SVProgressHUD.setStatus("Loading...")
            NetworkManager.SharedInstance.requestDropOff(request_id: self.requestId, success: { (res) in
                SVProgressHUD.dismiss()
                print(res)
//                self.navigationController?.popViewController(animated: true)
                
               
                let a = self.navigationController?.viewControllers[0] as! NewProductsListViewController
                
                self.navigationController?.popToViewController(a, animated: true)

                
                Utilites.ShowAlert(title: "Success", message: "product is added to dropof", view: self)
                
            }) { (err) in
                SVProgressHUD.dismiss()
                Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
            }
        }else{
            setupView.showNextStep()
            
            if let controllerToShow = getControllerToShow(from: setupView.selectedStep) {
                
                pageViewController.setViewControllers([controllerToShow], direction: .forward, animated: true, completion: nil)
                
            }
        }
    }
    
    
    
    
//    @objc func enableBtn(notification: Notification){
//        self.continueBtn.isEnabled = true
//        self.continueBtn.layer.backgroundColor = UIColor.blue.cgColor
//        self.continueBtn.setTitle("Confirm", for: .normal)
//
//    }
    
    @objc private func backButtonDidPress() {
        if setupView.selectedStep == 1 {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            setupView.showPreviousStep()
            
            if let controllerToShow = getControllerToShow(from: setupView.selectedStep) {
                pageViewController.setViewControllers([controllerToShow], direction: .reverse, animated: true, completion: nil)
            }
        }
    }
}
