

//
//  ShipmentSetupViewController.swift
//  SnapToSell
//
//  Created by Apple on 8/30/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import StepView

class ShipmentSetupViewController: UIViewController {
    
    
    
    private var pageViewController: UIPageViewController!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var setupView: StepView!
//    @IBOutlet weak var continueBtn: UIButton!
    
    var requestId = String()
    
    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: String.init(describing: DefaultAddressViewController.self)),
            self.getViewController(withIdentifier: String.init(describing: PackageDetailsViewController.self)),
            self.getViewController(withIdentifier: String.init(describing: ShipmentRatesViewController.self)),
            //            self.getViewController(withIdentifier: String.init(describing: FirstViewController.self)),
            //            self.getViewController(withIdentifier: String.init(describing: SecondViewController.self))
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let firstVC = storyboard?.instantiateViewController(withIdentifier: "PackageDetailsViewController") as! PackageDetailsViewController
        let secondVC = storyboard?.instantiateViewController(withIdentifier: "ShipmentRatesViewController") as! ShipmentRatesViewController
        
        firstVC.delegate = secondVC
        secondVC.data?.delegate = secondVC
//        secondVC.data?.delegate = firstVC
        
        Constants.CheckAvailbility = false
        setupControllers()
        NotificationCenter.default.addObserver(self, selector: #selector(self.enableBtn(notification:)), name: Notification.Name("nextStepShipment"), object: nil)

        
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.enableBtn(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
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
            //            self.continueBtn.isEnabled = false
            //            self.continueBtn.layer.backgroundColor = UIColor.gray.cgColor
//            self.continueBtn.setTitle("Confirm", for: .normal)
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
        
//        if self.continueBtn.titleLabel?.text == "Confirm"{
//            NetworkManager.SharedInstance.requestDropOff(request_id: self.requestId, success: { (res) in
//                print(res)
//                self.navigationController?.popViewController(animated: true)
//            }) { (err) in
//                Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
//            }
//        }else{
            setupView.showNextStep()
            
            if let controllerToShow = getControllerToShow(from: setupView.selectedStep) {
                
                pageViewController.setViewControllers([controllerToShow], direction: .forward, animated: true, completion: nil)
                
            }
//        }
    }
    
    @objc func enableBtn(notification: Notification){
        setupView.showNextStep()
        
        if let controllerToShow = getControllerToShow(from: setupView.selectedStep) {
            
            pageViewController.setViewControllers([controllerToShow], direction: .forward, animated: true, completion: nil)
            
        }
        
    }
    
    
    
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
