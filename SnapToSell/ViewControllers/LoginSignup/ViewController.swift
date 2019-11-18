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
import FBSDKLoginKit



class eee: UIViewController {
    override func viewDidLoad() {
        self.addBG()
    }
}

class ViewController: eee ,GIDSignInDelegate, GIDSignInUIDelegate ,BWWalkthroughViewControllerDelegate ,LoginButtonDelegate{
   
    
   
    
    
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var googleLogin: UIButton!
    
    
    @IBOutlet weak var signinBtn: UIButton!
    
    @IBOutlet weak var rememberMe: UIImageView!
    
    
    @IBOutlet weak var rememberMeBtn: UIButton!
    
    
    
    @IBOutlet weak var tickImg: UIImageView!
    
    
//    @IBOutlet weak var fblogin: UIButton!
    
    @IBOutlet weak var fbloginBtn: FBLoginButton! = {
        
        let butt = FBLoginButton()
//        butt.delegate = self
        butt.permissions = ["email","public_profile", "first_name", "last_name"]
//           butt.readPermissions = ["email"]
           return butt
       }()
    
    
    let loginManager = LoginManager()

    
//    FBSDKLoginButton! = {
//        let butt = FBSDKLoginButton()
//        butt.readPermissions = ["email"]
//        return butt
//    }()
    @IBOutlet weak var teitter: UIButton!
    
    let userdefaults = UserDefaults.standard
    let manager = SocketManager(socketURL: URL(string: "http://71.78.236.22:6001")!, config: [.log(true), .compress])
          
    
    var socket : SocketIOClient!
    
    let imageView = UIImageView(image: UIImage(named: "no_net (1)"))
    let button = UIButton(type: UIButton.ButtonType.system) as UIButton
      
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.red
//        self.signinBtn.setGradient()
//        self.setGragientBar()
        fbloginBtn.delegate = self
        print(AccessToken.current)
        print(AccessToken.self)
       
        
        if !userdefaults.bool(forKey: "walkthroughPresented") {
//
           showWalkthrough()
           
           userdefaults.set(true, forKey: "walkthroughPresented")
           userdefaults.synchronize()
        }
        
        
        self.rememberMe.image =  UIImage(named: "tickImg")
        tickImg.layer.cornerRadius = 2
        rememberMe.layer.borderWidth = 0.5
        rememberMe.layer.borderColor = UIColor.init(rgb: 0xFC2B08).cgColor
        
        
        self.googleLogin.layer.cornerRadius = self.googleLogin.frame.width / 2
        self.fbloginBtn.layer.cornerRadius = self.fbloginBtn.frame.width / 2
        self.teitter.layer.cornerRadius = self.teitter.frame.width / 2
        
        
        
        userName.setIcon(UIImage(named: "emalImg")!)
        password.setIcon(UIImage(named: "passwordimg")!)
        print(self.userdefaults.bool(forKey: "islogin"))
        print(CustomUserDefaults.Token.value)
        if self.userdefaults.bool(forKey: "islogin") &&  CustomUserDefaults.Token.value != nil {
            
            if CustomUserDefaults.Token.value != "" {
                let main = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                
                self.navigationController?.pushViewController(main, animated: true)

            }
        }
        
        DispatchQueue.main.async {
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().uiDelegate = self
            self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        }
//        if self.userdefaults.bool(forKey: "islogin") == false {
//
//        }else{
//            self.userdefaults.set(true, forKey: "islogin")
//        }
        
//
//        let button = UIButton(type: .custom)
//           button.setImage(UIImage(named: "asdf"), for: .normal)
////        button.setTitle("View", for: .normal)
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
//        button.frame = CGRect(x: CGFloat(self.password.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
//           button.addTarget(self, action: #selector(self.refresh), for: .touchUpInside)
//           self.password.rightView = button
//           self.password.rightViewMode = .always
//

        self.password.hideShowText()
        
        loginManager.logIn(permissions: [ "publicProfile", "email" ], from: self) { (result, error) in
            
            
            
//            print(result?.token?.tokenString)
            
//            switch result {
//
//
////             case .failed(let error):
////                 print(error)
////             case .cancelled:
////                 print("User cancelled login.")
////             case .success(let grantedPermissions, let declinedPermissions, let accessToken):
////
////                 print("accessToken: " +  accessToken.authenticationToken)
////                 break
//
//             }
        }
//
        
    }
    
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        print(result?.token?.tokenString)
        
//        print(result?.value(forKey: "name"))
        
        
        if(AccessToken.current != nil){

            GraphRequest(graphPath: "me", parameters: ["fields": "id,name , first_name, last_name , email"]).start(completionHandler: { (connection, result, error) in

                   guard let Info = result as? [String: Any] else { return }

                    if let userName = Info["name"] as? String
                    {
                        print(userName)
                        //                        CustomUserDefaults.email.value = res.email
                        CustomUserDefaults.userName.value = userName
                    }
                    if let email = Info["email"] as? String
                    {
                        print(email)
                        CustomUserDefaults.email.value = email
//                        CustomUserDefaults.userName.value = userName
                    }

               })
           }
        
     
        let token = result?.token?.tokenString
        if token == nil {
            return
        }
        SVProgressHUD.show(withStatus: "Loading")
        NetworkManager.SharedInstance.socalFBLogin(Token: token!, success: { (response) in
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
    }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
       print("logout")
    }
    
    
//    func loginManagerDidComplete(_ result: LoginResult) {
//        let alertController: UIAlertController
//        switch result {
//        case .cancelled:
//            alertController = UIAlertController(
//                nibName: "Login Cancelled",
//                bundle: : "User cancelled login."
//            )
//
//        case .failed(let error):
//            alertController = UIAlertController(
//                nibName: "Login Fail",
//                bundle: "Login failed with error \(error)"
//            )
//
//        case .success(let grantedPermissions, _, _):
//            alertController = UIAlertController(
//                nibName: "Login Success",
//                bundle: "Login succeeded with granted permissions: \(grantedPermissions)"
//            )
//        }
//        self.present(alertController, animated: true, completion: nil)
//    }
    
//    @IBAction func refresh(_ sender: Any) {
//
//        if self.password.isSecureTextEntry{
//            self.password.isSecureTextEntry = false
//        }else{
//            self.password.isSecureTextEntry = true
//        }
//    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = true
        self.hideKeyboardWhenTappedAround()
        self.signinBtn.setGradient()
        self.tabBarController?.tabBar.isHidden = true
        
    }
//
//    override var preferredStatusBarStyle: UIStatusBarStyle{
//           .lightContent
//    }
//
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.signinBtn.setGradient()
        self.setGragientBar()
        self.fbloginBtn.setImage(UIImage(named: "Fb"), for: .normal)
        let buttonText = NSAttributedString(string: " ")
        self.fbloginBtn.setAttributedTitle(buttonText, for: .normal)

//        self.fbloginBtn.setTitle(" ", for: .normal)
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
        self.userName.text = self.userName.text?.lowercased()
        NetworkManager.SharedInstance.login(userNAme: self.userName.text!, password: self.password.text!, fcm_token: CustomUserDefaults.fcm_token.value ?? "", success: { (response) in
            SVProgressHUD.dismiss()
            if (response.message != nil) {
                 Utilites.ShowAlert(title: "Error!!", message: "Email or password is invalid", view: self)
                return
            }else{
                print("Adasd")
                
                if self.rememberMe.image == UIImage(named: "tickImg"){
                    self.userdefaults.set(true, forKey: "islogin")
                }else{
                    self.userdefaults.set(false, forKey: "islogin")
                }
                           
                
                self.userdefaults.setValue(response.access_token, forKey: "Token")
                
               
                
                AppManager.shared().accessToken = UserDefaults.standard.value(forKey: "Token") as! String
                
                print(AppManager.shared().accessToken)
                
                CustomUserDefaults.Token.value = response.access_token
                
                NetworkManager.SharedInstance.Profile(success: { (res) in
                    print(res)
                    SVProgressHUD.dismiss()
                    CustomUserDefaults.email.value = res.email
                    CustomUserDefaults.userName.value = res.name
                    CustomUserDefaults.VerifyPaypal.value = res.paypal
                    CustomUserDefaults.userId.value = "\(res.id!)"
                    CustomUserDefaults.password.value = self.password.text!
                    print(CustomUserDefaults.userId.value!)

                    let main = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                    
                    self.navigationController?.pushViewController(main, animated: true)

                    
                }, failure: { (err) in
                    print("Error!!!")
                })
                
               
            
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
    
    
    @available(iOS 13.0, *)
    @IBAction func login(_ sender: Any) {
//        print(socket.status)
        if validInput(){
            if Utilites.isInternetAvailable() {
                self.Login()
            }else{
                  self.netCheck(button: button, imageView: imageView)
                  button.addTarget(self, action: #selector(ViewController.buttonAction(_:)), for: .touchUpInside)
                    
            }
            
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
    
    
    @objc func buttonAction(_ sender:UIButton!)
    {
        if Utilites.isInternetAvailable() {
            self.imageView.isHidden = true
            self.button.isHidden = true
    //            self.viewWillAppear(true)
        }else{
            self.showToast(message: "Internet is not availble")
        }
    }
    
}

