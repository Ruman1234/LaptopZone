//
//  SelectPaymentMethodViewController.swift
//  SnapToSell
//
//  Created by Apple on 10/15/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class SelectPaymentMethodViewController: UIViewController {
        
    @IBOutlet weak var chequeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var virw: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var mainviewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewheght: NSLayoutConstraint!
    
    @IBOutlet weak var amazonDetailHeight: NSLayoutConstraint!
    
    @IBOutlet weak var paypalViewHeight: NSLayoutConstraint!
    @IBOutlet weak var amazonView: UIView!
    
    @IBOutlet weak var paypalEmail: UITextField!
    
    @IBOutlet weak var chequePayableTo: UITextField!
    
    @IBOutlet weak var chequeEmail: UITextField!
    
    @IBOutlet weak var chequeLineAddress: UITextField!
    
    @IBOutlet weak var chequeLineAddress2: UITextField!
    
    @IBOutlet weak var cite: UITextField!
    
    
    @IBOutlet weak var paypalConfirmEmail: UITextField!
    
    @IBOutlet weak var Chequestate: UITextField!
    
    
    @IBOutlet weak var chequwZipcode: UITextField!
    
    @IBOutlet weak var chequeCountry: UITextField!
    
    @IBOutlet weak var chequeNextBtn: UIButton!
    @IBOutlet weak var paypalNextBtn: UIButton!
    
    @IBOutlet weak var chequeRadioImage: UIImageView!
    @IBOutlet weak var paypalRadioImage: UIImageView!
    @IBOutlet weak var amazonRadiouimage: UIImageView!
    
    @IBOutlet weak var chwqueNextBtn: UIButton!
    
    @IBOutlet weak var amazonBtn: UIButton!
    @IBOutlet weak var paypalBtn: UIButton!
    @IBOutlet weak var chequeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBG()
        self.addPAger(totalPage: 7, currentPage: 6)
        self.cancleBtn()
        self.backBtn()
        self.chwqueNextBtn.setGradient()
        self.paypalNextBtn.setGradient()
        self.chequeNextBtn.setGradient()
        // Do any additional setup after loading the view.
    }
    
    func textfieldRemoveSpaces(textfield:UITextField)  {
        textfield.text = textfield.text?.trimmingCharacters(in:.whitespaces)
    }
    
    
    @IBAction func amazonBtn(_ sender: AnyObject) {
        /*
        if sender.tag == 0 {
            self.amazonBtn.tag = 1
            self.view.layoutIfNeeded()
            
            
            if #available(iOS 13.0, *) {
                self.amazonRadiouimage.image = UIImage(systemName: "largecircle.fill.circle")
                 self.paypalRadioImage.image = UIImage(systemName: "circle")
                 self.chequeRadioImage.image = UIImage(systemName: "circle")
                
            } else {
                // Fallback on earlier versions
            }
            
            self.amazonDetailHeight.constant = 231
            self.mainviewHeight.constant = self.view.frame.height + 231
            self.paypalViewHeight.constant = 0
            self.chequeViewHeight.constant = 0
            UIView.animate(withDuration: 0.5, animations: {

                 self.view.layoutIfNeeded()

            })
            
            
            
        }else{
            self.amazonBtn.tag = 0
            
            self.view.layoutIfNeeded()
                       
                       
            if #available(iOS 13.0, *) {
                self.amazonRadiouimage.image = UIImage(systemName: "circle")
                self.paypalRadioImage.image = UIImage(systemName: "circle")
                self.chequeRadioImage.image = UIImage(systemName: "circle")
               
            } else {
               // Fallback on earlier versions
            }
            
            self.amazonDetailHeight.constant = 0
            self.mainviewHeight.constant = self.view.frame.height
            self.paypalViewHeight.constant = 0
            self.chequeViewHeight.constant = 0
            UIView.animate(withDuration: 0.5, animations: {

                self.view.layoutIfNeeded()

            })

        }
        
        */
    }
    
    
    @IBAction func paypalView(_ sender: AnyObject) {
        
        
        if sender.tag == 0 {
            self.paypalBtn.tag = 1
            self.view.layoutIfNeeded()
             
             if #available(iOS 13.0, *) {
                self.paypalRadioImage.image = UIImage(systemName: "largecircle.fill.circle")
                 
                 self.amazonRadiouimage.image = UIImage(systemName: "circle")
                 self.chequeRadioImage.image = UIImage(systemName: "circle")
                           
            } else {
                // Fallback on earlier versions
            }

             self.textFieldBorder(textField: self.paypalEmail)
             self.textFieldBorder(textField: self.paypalConfirmEmail)
            
             self.mainviewHeight.constant = self.view.frame.height + 381
             self.paypalViewHeight.constant = 381
             self.amazonDetailHeight.constant = 0
             self.chequeViewHeight.constant = 0

             UIView.animate(withDuration: 0.5, animations: {

                 self.view.layoutIfNeeded()

             })
            
        }else{
            self.paypalBtn.tag = 0
            self.view.layoutIfNeeded()

            if #available(iOS 13.0, *) {
               self.paypalRadioImage.image = UIImage(systemName: "circle")
                
                self.amazonRadiouimage.image = UIImage(systemName: "circle")
                self.chequeRadioImage.image = UIImage(systemName: "circle")
                          
            } else {
               // Fallback on earlier versions
            }

            self.textFieldBorder(textField: self.paypalEmail)
            self.textFieldBorder(textField: self.paypalConfirmEmail)

            self.mainviewHeight.constant = self.view.frame.height + 0
            self.paypalViewHeight.constant = 0
            self.amazonDetailHeight.constant = 0
            self.chequeViewHeight.constant = 0

            UIView.animate(withDuration: 0.5, animations: {

                self.view.layoutIfNeeded()

            })
        }
        
        
    }
    
    
    @IBAction func chequeViewBtn(_ sender: AnyObject) {
        
        
        if sender.tag == 0{
            self.chequeBtn.tag = 1
            self.view.layoutIfNeeded()
             
             if #available(iOS 13.0, *) {
                 
                self.chequeRadioImage.image = UIImage(systemName: "largecircle.fill.circle")
                 
                 self.paypalRadioImage.image = UIImage(systemName: "circle")
                 self.amazonRadiouimage.image = UIImage(systemName: "circle")
                           
             } else {
                   // Fallback on earlier versions
             }
             
             self.textFieldBorder(textField: self.chequeEmail)
             self.textFieldBorder(textField: self.chequePayableTo)
             self.textFieldBorder(textField: self.chequeLineAddress)
             self.textFieldBorder(textField: self.chequeLineAddress2)
             self.textFieldBorder(textField: self.cite)
             self.textFieldBorder(textField: self.Chequestate)
             self.textFieldBorder(textField: self.chequwZipcode)
             self.textFieldBorder(textField: self.chequeCountry)

            self.mainviewHeight.constant = self.view.frame.height + 948
            self.paypalViewHeight.constant = 0
            self.amazonDetailHeight.constant = 0
            self.chequeViewHeight.constant = 948
            UIView.animate(withDuration: 0.5, animations: {

                self.view.layoutIfNeeded()

            })
        }else{
            self.chequeBtn.tag = 0
            self.view.layoutIfNeeded()
             
             if #available(iOS 13.0, *) {
                 
                self.chequeRadioImage.image = UIImage(systemName: "circle")
                 
                 self.paypalRadioImage.image = UIImage(systemName: "circle")
                 self.amazonRadiouimage.image = UIImage(systemName: "circle")
                           
             } else {
                   // Fallback on earlier versions
             }
             
          

            self.mainviewHeight.constant = self.view.frame.height + 0
            self.paypalViewHeight.constant = 0
            self.amazonDetailHeight.constant = 0
            self.chequeViewHeight.constant = 0
            UIView.animate(withDuration: 0.5, animations: {

                self.view.layoutIfNeeded()

            })
        }
        
               
        
    }
    
    
    
    func textFieldBorder(textField: UITextField)  {
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
    }
    
    @IBAction func nextBtn(_ sender: AnyObject) {
        
        let main = self.storyboard?.instantiateViewController(withIdentifier: "SelectdeliveryMethodViewController") as! SelectdeliveryMethodViewController
              
        self.navigationController?.pushViewController(main, animated: true)
                       
        
    }
    
    @IBAction func chequeNextBtn(_ sender: Any) {
        
        if self.validCheque(){
            
            let main = self.storyboard?.instantiateViewController(withIdentifier: "SelectdeliveryMethodViewController") as! SelectdeliveryMethodViewController
            
            main.chequePayabito = self.chequePayableTo.text!
//            main.paypalEmail = self.chequeEmail.text!
            main.chequeEmail = self.chequeEmail.text!
            
            main.chequeAddress = self.chequeLineAddress.text!
            main.chequeAddress2 = self.chequeLineAddress2.text!
            main.chequecity = self.cite.text!
            main.chequestate = self.Chequestate.text!
            main.chequezipcode = self.chequwZipcode.text!
            main.chequecountry = self.chequeCountry.text!
            main.paymentMode = "check"
            
            self.navigationController?.pushViewController(main, animated: true)
                             
        }
       
        
    }
    
    @IBAction func amazonNextbtn(_ sender: Any) {
        
        
        let main = self.storyboard?.instantiateViewController(withIdentifier: "SelectdeliveryMethodViewController") as! SelectdeliveryMethodViewController
              main.paymentMode = "amazon"
        self.navigationController?.pushViewController(main, animated: true)
           
    }
    
    
    @IBAction func paypalNExtBtn(_ sender: Any) {
        if self.validPaypal(){
            
            let main = self.storyboard?.instantiateViewController(withIdentifier: "SelectdeliveryMethodViewController") as! SelectdeliveryMethodViewController
                         
            main.paypalEmail = self.paypalEmail.text!
            print(self.paypalEmail.text!)
            main.paymentMode = "paypal"
            
            self.navigationController?.pushViewController(main, animated: true)
                      
        }
       
        
    }
    
    func validPaypal() -> Bool {
        var flag = true
        self.textfieldRemoveSpaces(textfield: paypalEmail)
        self.textfieldRemoveSpaces(textfield: paypalConfirmEmail)
        
        if self.paypalEmail.text == "" {
            flag = false
            Utilites.ShowAlert(title: "Error!!!", message: "Please enter paypal email", view: self)
        }else if Utilites.isValid(email: self.paypalEmail.text! as NSString) == false{
            flag = false
            self.showToast(message: "Please enter a valid Email")
        } else if self.paypalEmail.text != self.paypalConfirmEmail.text {
            flag = false
             Utilites.ShowAlert(title: "Error!!!", message: "Please confirm paypal email", view: self)
        }
        return flag
        
    }
    
    
    func validCheque() -> Bool {
           var flag = true
           
        self.textfieldRemoveSpaces(textfield: chequePayableTo)
        self.textfieldRemoveSpaces(textfield: chequeEmail)
        self.textfieldRemoveSpaces(textfield: chequeLineAddress)
        self.textfieldRemoveSpaces(textfield: cite)
        self.textfieldRemoveSpaces(textfield: Chequestate)
        self.textfieldRemoveSpaces(textfield: chequwZipcode)
        self.textfieldRemoveSpaces(textfield: chequeCountry)
            
           if self.chequePayableTo.text == "" {
               flag = false
               Utilites.ShowAlert(title: "Error!!!", message: "Please enter Payable", view: self)
           }else if self.chequeEmail.text == "" {
               flag = false
               Utilites.ShowAlert(title: "Error!!!", message: "Please enter Email", view: self)
           }else if Utilites.isValid(email: self.chequeEmail.text! as NSString) == false{
               flag = false
               self.showToast(message: "Please enter a valid Email")
           }else if self.chequeLineAddress.text == "" {
               flag = false
               Utilites.ShowAlert(title: "Error!!!", message: "Please enter address", view: self)
           }else if self.cite.text == "" {
               flag = false
               Utilites.ShowAlert(title: "Error!!!", message: "Please enter city", view: self)
           }else if self.Chequestate.text == "" {
               flag = false
               Utilites.ShowAlert(title: "Error!!!", message: "Please enter state", view: self)
           }else if self.chequwZipcode.text == "" {
               flag = false
               Utilites.ShowAlert(title: "Error!!!", message: "Please enter zipcode", view: self)
           }else if self.chequeCountry.text == "" {
               flag = false
               Utilites.ShowAlert(title: "Error!!!", message: "Please enter country", view: self)
           }
        
           return flag
           
       }

}

