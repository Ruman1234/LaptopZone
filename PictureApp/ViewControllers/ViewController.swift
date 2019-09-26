//
//  ViewController.swift
//  PictureApp
//
//  Created by Apple on 6/22/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase
import CoreData
import SVProgressHUD

class ViewController: UIViewController , UITextFieldDelegate  {
    
    var iconClick = true
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var usernameText: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordText: SkyFloatingLabelTextField!
    
    var refArtists: DatabaseReference!
    var loginDB: [NSManagedObject] = []
    var username = [String]()
    var password = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if (UserDefaults.standard.value(forKey: "isLogin") != nil) {
            let main = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            
            self.navigationController?.pushViewController(main, animated: true)
        }
        
//        if let uuid = UIDevice.current.identifierForVendor{
//            print(uuid)
//        }
        
        self.usernameText.delegate = self
        self.passwordText.delegate = self
        
        UIApplication.shared.statusBArView?.backgroundColor = Constants.APP_THEAME_COLOR
        
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = true
        self.hideKeyboardWhenTappedAround() 
        loginBtn.layer.cornerRadius = 5
        self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        
        
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureHandler(panGesture:)))
//        panGesture.minimumNumberOfTouches = 1
//        self.loginBtn.addGestureRecognizer(panGesture)
//        let word = UIButton(type: .system)
//
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getFormDB()
    }
    
    func saveToDB(name: String , id :String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Login",
                                       in: managedContext)!
        
        let condNAme = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
        
        condNAme.setValue(name, forKeyPath: "userName")
        condNAme.setValue(id, forKey: "password")
        do {
            try managedContext.save()
            loginDB.append(condNAme)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    func isEntityAttributeExist(userName: String , entityName: String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "userName == %@", userName)
        
        let res = try! managedContext.fetch(fetchRequest)
        return res.count > 0 ? true : false
    }
    
    func deleteAllData()
    {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Login")
        
        //3
        do {
            loginDB = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
        for cond in loginDB {
            
            managedContext.delete(cond)
            
        }
    }
    
    func getFormDB()  {
        
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Login")
        
        //3
        do {
            loginDB = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        print(loginDB)
        
        let i = 0
        
        for _ in loginDB {
            
            self.username.append(loginDB[i].value(forKey: "userName") as! String)
            
            self.password.append(loginDB[i].value(forKey: "password") as! String)
//            self.conditionArray.append(Results(JSON: [
//                "COND_NAME" : loginDB[i].value(forKey: "name") as? String?,
//                "ID" : loginDB[i].value(forKey: "id") as? String?])!)
//            i += 1
        }
        
//        for arr in self.conditionArray{
//
//
//            self.conditionName.append(arr.cOND_NAME!)
//            self.cond_id.append(arr.iD!)
//
//
//
//        }
        
        
        
    }
    
    
//    @objc func panGestureHandler(panGesture recognizer: UIPanGestureRecognizer) {
//
//        let buttonTag = (recognizer.view?.tag)!
//        if let button = view.viewWithTag(buttonTag) as? UIButton {
//
//            if recognizer.state == .began {
//                loginBtn.center = button.center // store old button center
//            } else if recognizer.state == .ended || recognizer.state == .failed || recognizer.state == .cancelled {
//                button.center = loginBtn.center // restore button center
//            } else {
//                let location = recognizer.location(in: view) // get pan location
//                button.center = location // set button to where finger is
//            }
//        }
//    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = true
        
    }
   
    @IBAction func iconAction(sender: AnyObject) {
        if(iconClick == true) {
            passwordText.isSecureTextEntry = false
        } else {
            passwordText.isSecureTextEntry = true
        }
        
        iconClick = !iconClick
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        return false
    }
    
    func validInut() -> Bool {
        var flag = true
        
        if self.usernameText.text == ""{
            flag = false
            self.showToast(message: "Please enter username")
        }else if self.passwordText.text == ""{
            self.showToast(message: "Please enter password")
            flag = false
        }
        
        return flag
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        
        if validInut(){
            SVProgressHUD.show(withStatus: "Loading...")
            if Utilites.isInternetAvailable(){
                
                Database.database().reference(withPath: "Users").queryOrdered(byChild: "u_pass").queryEqual(toValue: self.usernameText.text! +  "_" + self.passwordText.text!).observeSingleEvent(of: .value, with: { (DataSnapshot) in

                    SVProgressHUD.dismiss()
                    
                    let value = DataSnapshot.value as? NSDictionary

                    var mainObj = String()
                    if value?.allKeys != nil{
                        mainObj = value?.allKeys[0].self as! String
                        
                        
                        let val : NSDictionary = value?.value(forKey: mainObj) as! NSDictionary
                        print(val.object(forKey: "id") ?? "nil")
                        print(val.object(forKey: "username") ?? "nil")
                        
                        UserDefaults.standard.set(val.object(forKey: "username"), forKey: "username")
                        UserDefaults.standard.set(val.object(forKey: "id"), forKey: "id")
                        
                        Constants.Pic_Taker_Id = val.object(forKey: "id")! as! String
                        
                        self.saveToDB(name: self.usernameText.text!, id: self.passwordText.text!)
                        
                        UserDefaults.standard.set(true, forKey: "isLogin")
                        let main = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                        
                        self.navigationController?.pushViewController(main, animated: true)
                    }else{
                        Utilites.ShowAlert(title: "Error!", message: "these credentials are not matched", view: self)
                    }
                    
                    
                })
            }else{
                SVProgressHUD.dismiss()
                if self.username.contains(self.usernameText.text!) {
                    let main = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                    //        self.present(main, animated: true, completion: nil)
                    self.navigationController?.pushViewController(main, animated: true)
                }else{
                    Utilites.ShowAlert(title: "Error", message: "please login first via internet your credentuias are not save in DB", view: self)
                }
            }

        }
        

        
    }
}
