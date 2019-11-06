//
//  AppDelegate.swift
//  SnapToSell
//
//  Created by Apple on 8/23/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import Firebase
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import GoogleMaps
import GooglePlaces

import Foundation

@available(iOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate, MessagingDelegate {
    
   

    var window: UIWindow?
    var ss :UIStatusBarManager!
    let notificationCenter = UNUserNotificationCenter.current()
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
//    let manager = SocketManager(socketURL: URL(string: "http://71.78.236.22:6001")!, config: [.log(true), .compress])
//    var socket : SocketIOClient!
        
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        socketdata()
        notificationCenter.delegate = self
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
//        GIDSignIn.sharedInstance().clientID = "477867186230-8k2j681ktpvav5hl4ehf4ajscbai8moi.apps.googleusercontent.com"
//        GIDSignIn.sharedInstance().delegate = self

        
//        UITabBar.appearance().tintColor.add
        
        GMSServices.provideAPIKey("AIzaSyDnKuPE0DGd4OFFzkJtsbh970OCXyRJ4wg")
        GMSPlacesClient.provideAPIKey("AIzaSyDnKuPE0DGd4OFFzkJtsbh970OCXyRJ4wg")


        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.toolbarTintColor = Constants.APP_THEAME_COLOR
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done"
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        GIDSignIn.sharedInstance().clientID = "477867186230-tumr6302i75gnmm6576e3rl7a5rcjuv1.apps.googleusercontent.com"
        
        
        GIDSignIn.sharedInstance()?.serverClientID = "477867186230-8k2j681ktpvav5hl4ehf4ajscbai8moi.apps.googleusercontent.com"
        
        
        FirebaseApp.configure()

    Messaging.messaging().delegate = self
    UIApplication.shared.applicationIconBadgeNumber = 0

      UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
      application.registerForRemoteNotifications()

//        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {_, _ in })
//            // For iOS 10 data message (sent via FCM
//            Messaging.messaging().delegate = self
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
        
//        application.registerForRemoteNotifications()
        
//        Messaging.messaging().isAutoInitEnabled = true
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        // Sets the translucent background color
        UINavigationBar.appearance().backgroundColor = .clear
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        
//        navigationController?.navigationItem.backBarButtonItem?.image = UIImage(named: "backImg")
        
        
        let backImage = UIImage(named: "back")!.withRenderingMode(.alwaysOriginal)
        
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -80.0), for: .default)
        
        
        
        UINavigationBar.appearance().isTranslucent = true
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(18)
        return true
    }
    
 
    
     func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//
//               let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//
//               profileViewController.socketdata()
//        completionHandler(.newData)
//         if let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
//             // Update JSON data
////             VC.soc()
////                VC.socketdata()profileViewController.socketdata()
//                profileViewController.socketdata()
//             completionHandler(.newData)
//         } else {
//             completionHandler(.noData)
//     }
    }
    
    
    func scheduleNotification(title: String ,body: String ) {
        
        let content = UNMutableNotificationContent() // Содержимое уведомления
        let categoryIdentifire = "Delete Notification Type"
        
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = categoryIdentifire
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "DeleteAction", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(identifier: categoryIdentifire,
                                              actions: [snoozeAction, deleteAction],
                                              intentIdentifiers: [],
                                              options: [])
        
        notificationCenter.setNotificationCategories([category])
    }


    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
    
    
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        NSLog("[RemoteNotification] didRefreshRegistrationToken: \(fcmToken)")
    }

    // iOS9, called when presenting notification in foreground
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
//        NSLog("[RemoteNotification] applicationState: \(applicationStateString) didReceiveRemoteNotification for iOS9: \(userInfo)")
//        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        
        guard
        let aps = userInfo[AnyHashable("aps")] as? NSDictionary,
        let alert = aps["alert"] as? NSDictionary,
        let body = alert["body"] as? String,
        let title = alert["title"] as? String
        else {
            // handle any error here
            return
        }
        
        if UIApplication.shared.applicationState == .active {
            //TODO: Handle foreground notification
//            print("sa")
            
            
            self.appDelegate?.scheduleNotification(title: title, body: body)
        } else {
            //TODO: Handle background notification
            print("sad")
        }
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                
//                if CustomUserDefaults.fcm_token.value == "" ||  CustomUserDefaults.fcm_token.value != result.token {
//
//                    NetworkManager.SharedInstance.UpdateToken(fcm_token: result.token, success: { (res) in
//                        print(res)
//                    }, failure: { (err) in
//                        print("FCM is not updated")
//                    })
//
//                }
                
                CustomUserDefaults.fcm_token.value = result.token
//                print("Remote InstanceID token: \(result.token)")
            }
        }

        
    }
    
    
    
    
    private func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
         Messaging.messaging().apnsToken = deviceToken as Data
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("fail")
    }
    
    
    func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        print("error")
    }
    //Google signin
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("Asdf")
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        
    }
    // [END openurl]

    // [START openurl_new]
//    @available(iOS 9.0, *)
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
//        return GIDSignIn.sharedInstance().handle(url, sourceApplication: nil, annotation: nil)
//    }
    // [END openurl_new]

    // [START signin_handler]
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
        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        // [START_EXCLUDE]
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "Signed in user:\n\(fullName!)"])
        // [END_EXCLUDE]
    }
//     [END signin_handler]
    
//     [START disconnect_handler]
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
//              withError error: Error!) {
//        // Perform any operations when the user disconnects from app here.
//        // [START_EXCLUDE]
//        NotificationCenter.default.post(
//            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
//            object: nil,
//            userInfo: ["statusText": "User has disconnected."])
//        // [END_EXCLUDE]
//    }
//     [END disconnect_handler]
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("bjhbj")
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//
//               let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//
//               profileViewController.socketdata()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
//        var rootViewController = self.window!.rootViewController
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//
//        let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//
//        profileViewController.socketdata()
//        print(window?.rootViewController)
//         if let VC = window?.rootViewController as? ViewController {
//                     // Update JSON data
//        //             VC.soc()
////                        VC.socketdata()
//            print("asfd")
////                     completionHandler(.newData)
//         } else {
//            print("asfsad")
//        }
//                     completionHandler(.noData)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        NotificationCenter.default.addObserver(self, selector:
               #selector(tokenRefreshNotification), name:
               NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        
    }

    
    @objc func tokenRefreshNotification(notification: NSNotification) {

//        InstanceID.instanceID().toke
//        insta
//        if let refreshedToken = InstanceID.instanceID().token(withAuthorizedEntity: <#String#>, scope: <#String#>, handler: <#InstanceIDTokenHandler#>) {
//            print("InstanceID token: \(refreshedToken)")
//            UserDefaults.standard.set(refreshedToken, forKey: "deviceToken")
//
//            self.sendFCMTokenToServer(token: refreshedToken)
//        }
        /*
        Connect to FCM since connection may
        have failed when attempted before having a token.
        */
//        else {
//            connectToFcm()
//        }
    }

    func updatePushNotificationWebservice() {
        /*
         if you want to save that token on your server
         Do that here.
         else use the token any other way you want.
        */
    }

//    func connectToFcm() {
//
//        
////        InstanceID.token(Ins)
////        Messaging.messaging().conn
//
////        let token = InstanceID.instanceID().token(withAuthorizedEntity: <#String#>)!
////        self.sendFCMTokenToServer(token: token)
//
//        Messaging.messaging().connect { (error) in
//                if (error != nil) {
//                    print("Unable to connect with FCM. \(String(describing: error))")
//                }
//                else {
//                    print("Connected to FCM.")
//                    /*
//                    **this is the token that you have to use**
//                    print(FIRInstanceID.instanceID().token()!)
//                    if there was no connection established earlier,
//                    you can try sending the token again to server.
//                    */
//
//                    let token = FIRInstanceID.instanceID().token()!
//                    self.sendFCMTokenToServer(token: token)
//
//                }
//            }
//    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//        socketdata()
        
    }
    



}





class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func userRequest() {
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }
    
    func scheduleNotification(notificationType: String) {
        
        let content = UNMutableNotificationContent() // Содержимое уведомления
        let userActions = "User Actions"
        
        content.title = notificationType
        content.body = "This is example how to create " + notificationType
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = userActions
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(identifier: userActions,
                                              actions: [snoozeAction, deleteAction],
                                              intentIdentifiers: [],
                                              options: [])
        
        notificationCenter.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.identifier == "Local Notification" {
            print("Handling notifications with the Local Notification Identifier")
        }
        
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "Snooze":
            print("Snooze")
            scheduleNotification(notificationType: "sdfd")
        case "Delete":
            print("Delete")
        default:
            print("Unknown action")
        }
        completionHandler()
    }
}

