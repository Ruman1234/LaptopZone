//
//  ViewController.swift
//  SnapToSell
//
//  Created by Apple on 8/23/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SVProgressHUD
import GoogleSignIn
import SocketIO



class eee: UIViewController {
    override func viewDidLoad() {
        self.addBG()
    }
}

class ViewController: eee ,GIDSignInDelegate, GIDSignInUIDelegate ,BWWalkthroughViewControllerDelegate{
    
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var googleLogin: UIButton!
    
    
    @IBOutlet weak var signinBtn: UIButton!
    
    @IBOutlet weak var rememberMe: UIImageView!
    
    
    @IBOutlet weak var rememberMeBtn: UIButton!
    
    
    
    @IBOutlet weak var tickImg: UIImageView!
    
    
    @IBOutlet weak var fblogin: UIButton!
    
    
    @IBOutlet weak var teitter: UIButton!
    
    let userdefaults = UserDefaults.standard
    let manager = SocketManager(socketURL: URL(string: "http://71.78.236.22:6001")!, config: [.log(true), .compress])
          
    
    var socket : SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.red
        

        if !userdefaults.bool(forKey: "walkthroughPresented") {
           
           showWalkthrough()
           
           userdefaults.set(true, forKey: "walkthroughPresented")
           userdefaults.synchronize()
        }
        
        tickImg.layer.cornerRadius = 2
        rememberMe.layer.borderWidth = 0.5
        rememberMe.layer.borderColor = UIColor.init(rgb: 0xFC2B08).cgColor
        
        
        self.googleLogin.layer.cornerRadius = self.googleLogin.frame.width / 2
        self.fblogin.layer.cornerRadius = self.fblogin.frame.width / 2
        self.teitter.layer.cornerRadius = self.teitter.frame.width / 2
        
        
        
        userName.setIcon(UIImage(named: "emalImg")!)
        password.setIcon(UIImage(named: "passwordimg")!)
        
        if self.userdefaults.bool(forKey: "islogin") &&  CustomUserDefaults.Token.value! != "" {
            let main = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            
            self.navigationController?.pushViewController(main, animated: true)
        }
        
        DispatchQueue.main.async {
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().uiDelegate = self
            self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        }
       

        
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = true
        self.hideKeyboardWhenTappedAround()
        
        
    }
//
//    override var preferredStatusBarStyle: UIStatusBarStyle{
//           .lightContent
//    }
//
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.signinBtn.setGradient()
    }
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
           return UIStatusBarStyle.lightContent
    }
    
    func showWalkthrough(){
        
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        let walkthrough = stb.instantiateViewController(withIdentifier: "walk") as! BWWalkthroughViewController
        
        let page_one = stb.instantiateViewController(withIdentifier: "walk1")
        let page_two = stb.instantiateViewController(withIdentifier: "walk2")
//        let page_zero = stb.instantiateViewController(withIdentifier: "walk0")
        let page_three = stb.instantiateViewController(withIdentifier: "walk3")
        
        // Attach the pages to the master
        walkthrough.delegate = self
//        walkthrough.add(viewController:page_zero)
        walkthrough.add(viewController:page_one)
        walkthrough.add(viewController:page_two)
        walkthrough.add(viewController:page_three)
        
        
//        self.present(walkthrough, animated: true, completion: nil)
        self.navigationController?.pushViewController(walkthrough, animated: true)
    }
    
    
    // MARK: - Walkthrough delegate -
    
    func walkthroughPageDidChange(_ pageNumber: Int) {
        print("Current Page \(pageNumber)")
    }
    
    func walkthroughCloseButtonPressed() {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        
        
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            // [START_EXCLUDE silent]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
            // [END_EXCLUDE]
            return
        }
        
//        let userId = user.userID
        let idToken = user.authentication.idToken
        let fullName = user.profile.name
//        let givenName = user.profile.givenName
//        let familyName = user.profile.familyName
//        let email = user.profile.email
//        let accesstoken = user.authentication.accessToken
//        let refreshToken = user.authentication.refreshToken
        
//
//        print(idToken)
//        print(accesstoken)
//        print(refreshToken)
        SVProgressHUD.show(withStatus: "Loading....")
        
        NetworkManager.SharedInstance.socalLogin(Token: idToken!, success: { (response) in
            print(response)
            
            SVProgressHUD.dismiss()
            if (response.message != nil) {
                Utilites.ShowAlert(title: "Error!!", message: response.message!, view: self)
                return
            }else{
                print("Adasd")
                
                self.userdefaults.setValue(response.access_token, forKey: "Token")
                
                self.userdefaults.set(true, forKey: "islogin")
                
                AppManager.shared().accessToken = UserDefaults.standard.value(forKey: "Token") as! String
                
                print(AppManager.shared().accessToken)
                
                CustomUserDefaults.Token.value = response.access_token
                
                let main = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                
                self.navigationController?.pushViewController(main, animated: true)
                
                
            }
            
        }) { (err) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
        }
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "Signed in user:\n\(fullName!)"])
        
    }
    
    func Login() {
        
        SVProgressHUD.show(withStatus: "Loading...")
        
        NetworkManager.SharedInstance.login(userNAme: self.userName.text!, password: self.password.text!, fcm_token: CustomUserDefaults.fcm_token.value ?? "", success: { (response) in
            SVProgressHUD.dismiss()
            if (response.message != nil) {
                 Utilites.ShowAlert(title: "Error!!", message: "Email or password is invalid", view: self)
                return
            }else{
                print("Adasd")
                
                
                self.userdefaults.setValue(response.access_token, forKey: "Token")
                
               
                
                AppManager.shared().accessToken = UserDefaults.standard.value(forKey: "Token") as! String
                
                print(AppManager.shared().accessToken)
                
                CustomUserDefaults.Token.value = response.access_token
                
                NetworkManager.SharedInstance.Profile(success: { (res) in
                    print(res)
                    CustomUserDefaults.email.value = res.email
                    CustomUserDefaults.userName.value = res.name
                    CustomUserDefaults.VerifyPaypal.value = res.paypal
                    CustomUserDefaults.userId.value = "\(res.id!)"
                }, failure: { (err) in
                    print("Error!!!")
                })
                
               
            
                let main = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                
                self.navigationController?.pushViewController(main, animated: true)

                
            }
            
        }) { (error) in
            SVProgressHUD.dismiss()
            
            Utilites.ShowAlert(title: "Error!!", message: "Something went wrong", view: self)
        }
    }
    
    
    func validInput() -> Bool {
        var flag = true
        
        if self.userName.text == ""{
            flag = false
            self.showToast(message: "Please enter username")
        }else if self.password.text == ""{
            self.showToast(message: "Please enter password")
            flag = false
        }
        
        return flag
    }
    
    
    @IBAction func login(_ sender: Any) {
//        print(socket.status)
        if validInput(){
            Login()
        }
        
    }
    
    
    @IBAction func registerBtn(_ sender: Any) {
        let main = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(main, animated: true)
        
    }
    
    
    @IBAction func googleLogin(_ sender: Any) {
        
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    
    @IBAction func rememberMeBtn(_ sender: Any) {
        
        if self.rememberMe.image ==  UIImage(named: "tickImg"){
            self.rememberMe.image = UIImage(named: "Box")
        }else{
            self.rememberMe.image =  UIImage(named: "tickImg")
        }
        
        if self.rememberMe.image == UIImage(named: "tickImg"){
            self.userdefaults.set(true, forKey: "islogin")
        }else{
            self.userdefaults.set(false, forKey: "islogin")
        }
            
    }
    
    @IBAction func forgotBtn(_ sender: Any) {
        
//        if #available(iOS 13.0, *) {
//            let main = self.storyboard?.instantiateViewController(identifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
//            self.navigationController?.pushViewController(main, animated: true)
//        } else {
//            // Fallback on earlier versions
//        }
        
        let main = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
//        self.tabBarController?.navigationController?.pushViewController(main, animated: true)
        self.navigationController?.pushViewController(main, animated: true)
            
        
        
        
    }
    
}

