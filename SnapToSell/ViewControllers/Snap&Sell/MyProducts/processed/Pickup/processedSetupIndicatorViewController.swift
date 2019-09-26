//
//  processedSetupIndicatorViewController.swift
//  SnapToSell
//
//  Created by Apple on 8/29/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import StepView

class processedSetupIndicatorViewController: UIViewController {

    
    
    private var pageViewController: UIPageViewController!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var setupView: StepView!
    @IBOutlet weak var continueBtn: UIButton!
    
    var requestId = String()
    
    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: String.init(describing: processedDescriptionViewController.self)),
            self.getViewController(withIdentifier: String.init(describing: DefaultAddressViewController.self)),
//            self.getViewController(withIdentifier: String.init(describing: FirstViewController.self)),
//            self.getViewController(withIdentifier: String.init(describing: SecondViewController.self))
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupControllers()
        NotificationCenter.default.addObserver(self, selector: #selector(self.enableBtn(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.nextBtn(notification:)), name: Notification.Name("nextStepPickup"), object: nil)
        
       
         NotificationCenter.default.addObserver(self, selector: #selector(self.backButtonDidPress), name: Notification.Name("backStepPickup"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeBtn), name: Notification.Name("changeBtn"), object: nil)
        
        Constants.CheckAvailbility = true
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
//        if index == 2 {
//            self.continueBtn.isEnabled = false
//            self.continueBtn.layer.backgroundColor = UIColor.gray.cgColor
//        }
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
            NetworkManager.SharedInstance.requestPickup(request_id: self.requestId, address_id: Constants.addressId, success: { (res) in
                print(res)
                self.navigationController?.popViewController(animated: true)
            }) { (err) in
                Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
            }
        }else{
            setupView.showNextStep()
            
            if let controllerToShow = getControllerToShow(from: setupView.selectedStep) {
                
                pageViewController.setViewControllers([controllerToShow], direction: .forward, animated: true, completion: nil)
                
            }
        }
    }
    
    @objc func nextBtn(notification: Notification){
        
        setupView.showNextStep()
        
        if let controllerToShow = getControllerToShow(from: setupView.selectedStep) {
            
            pageViewController.setViewControllers([controllerToShow], direction: .forward, animated: true, completion: nil)
            
        }
        
    }
    
    @objc func enableBtn(notification: Notification){
        self.continueBtn.isEnabled = true
        self.continueBtn.layer.backgroundColor = UIColor.blue.cgColor
        self.continueBtn.setTitle("Confirm", for: .normal)
        
    }
    
    @objc private func backButtonDidPress() {
//        self.navigationController?.popViewController(animated: true)
        let a = self.navigationController?.viewControllers[0] as! NewProductsListViewController
        
        self.navigationController?.popToViewController(a, animated: true)

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
    
    
    @objc private func changeBtn() {
        //        self.navigationController?.popViewController(animated: true)
        
        let main = self.storyboard?.instantiateViewController(withIdentifier: "AllAddresViewController") as! AllAddresViewController
        
        main.type = "selectaddress"
        
//        self.present(main, animated: true, completion: nil)
        self.navigationController?.pushViewController(main, animated: true)
        
    }
    
}


