//
//  ChatViewController.swift
//  SnapToSell
//
//  Created by Apple on 10/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import OpalImagePicker
import SocketIO

class ChatViewController: UIViewController ,UITableViewDataSource ,UITableViewDelegate,OpalImagePickerControllerDelegate{


    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var messageText: UITextField!
    
//    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!

    var id  = String()
    var messages = [MessageModel]()
    let modl = MessageModel()
    var img : UIImage?
    
    let manager = SocketManager(socketURL: URL(string: "http://71.78.236.22:6001")!, config: [.log(true), .compress])
    var socket : SocketIOClient!
    
    let imageView = UIImageView(image: UIImage(named: "no_net (1)"))
    let button = UIButton(type: UIButton.ButtonType.system) as UIButton


    
    
    var type = String()
    var gottoCamera = String()
    var createConversationId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBG()
        self.backBtn()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        if Utilites.isInternetAvailable() {
//            apicall()
        }else{
           self.netCheck(button: button, imageView: imageView)
           button.addTarget(self, action: #selector(ViewController.buttonAction(_:)), for: .touchUpInside)
             
        }

        
        let pra = ["conversation_id" : "",
               "cover" : "asdfasdf",
               "created_at" : "",
               "delivered_as" : "",
               "id" : "212",
               "price" : "",
               "remarks" : "",
               "unread_messages" : "",
               "status" : "",
               "title" : "asdfasf",
               "user_id" : "",
               "user_role" : "",
               "type" : "",
               "timestamp" : "",
               "content" : "asdfasfdasdf"]

               let msg = MessageModel(JSON: pra)
        
        if self.type == "createConversation"{
            createConversation(id: createConversationId)
        }
        if self.id != "" {
            ApiCall(id: self.id)
        }
        
//        ApiCall(id: "21")
        tableView.register(UINib(nibName: "shipmentTableViewCell", bundle: nil), forCellReuseIdentifier: "shipmentCell")
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        if self.img != nil{
            self.sendImage(type: "IMAGE")
        }
        self.tabBarController?.tabBar.isHidden = false
        SocketData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.backBtn()
    }

    func createConversation(id : String)  {
        NetworkManager.SharedInstance.createConversations(id: id, success: { (res) in
            print(res)
            self.id = "\(res.id!)"
            self.ApiCall(id: self.id)
            
//            self.
        }) { (err) in
            Utilites.ShowAlert(title: "Error!!!", message: "something went wrong", view: self)
        }
    }
    
    
    func SocketData()   {
        
        socket = manager.defaultSocket

        socket.connect()

        print(socket.status)
        print("ASfda")


        let json = [
            "channel" : "private-App.User.\(CustomUserDefaults.userId.value!)",
            "name"    : "subscribe",
            "auth"    : [
                "headers" : [
                    "Authorization"  : "Bearer " + CustomUserDefaults.Token.value! ,
                    "Accept"         : "application/json",
                    "client_id"      : "21",
                    "client_secret"  : "4KPwfKtXjuaQlFuU69B4dHvFHGblYQ5GsurdbHqM",
                ]
            ]

        ] as [String : Any]

        print(json)


        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            self.socket.emit("subscribe", json)

        }
        
        
        socket.on("MessagePushed") { (dataArray, socketAck) -> Void in
//            if #available(iOS 13.0, *) {
//                let appDelegate = UIApplication.shared.delegate as? AppDelegate
//                appDelegate?.scheduleNotification(title: "title", body: "body")
//            } else {
//                // Fallback on earlier versions
//            }
            
            
            
            print(dataArray[1])
           
            
            
            let dd =  dataArray[1] as! [String: AnyObject]
            print(dd)
            
            let msg0 = dd["message"] as! String
                       print(msg0)
            let str = "[\(msg0)]"
//            print(msg0["id"] as! AnyObject)
             let msg1 = dd["message"] as! String
            print(msg1)
            print(msg1.count)
           
            let data = str.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                {
                   print(jsonArray) // use the json here
                    print(jsonArray[0])
                    let msg = jsonArray[0]
                    let arr = msg["type"] as! String
                    let type = msg["type"] as! String
                             print(type)
                             let content = msg["content"] as! String
                             print(content)
                            let conversation_id = msg["conversation_id"] as! Int
                             print(conversation_id)
                            let id = msg["id"] as! Int
                             print(id)
                            let timestamp = msg["timestamp"] as! String
                             print(timestamp)
                            let user_id = msg["user_id"] as! Int
                             print(user_id)
                            let user_role = msg["user_role"] as! String
                             print(user_role)
                            let status = msg["status"] as! String
                             
                             print(status)
                             
                             
                             
                             let pra = ["conversation_id" : conversation_id,
                                           "cover" : "asdfasdf",
                                           "created_at" : "",
                                           "delivered_as" : "",
                                           "id" : id,
                                           "price" : "",
                                           "remarks" : "",
                                           "unread_messages" : "",
                                           "status" : status,
                                           "title" : "asdfasf",
                                           "user_id" : user_id,
                                           "user_role" : user_role,
                                           "type" : type,
                                           "timestamp" : timestamp,
                                           "content" : content] as [String : Any]

                                           let msgsocket = MessageModel(JSON: pra)
                             self.messages.append(msgsocket!)
                             self.tableView.reloadData()
                             self.tableView.scrollToBottom(animated: true)
                             
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
            
//           let msg = dd["message"] as! [String: Any]
//            print(msg)
//            print(msg.count)
//            let type = msg["type"] as! String
//            print(type)
//            let content = msg["content"] as! String
//            print(content)
//           let conversation_id = msg["conversation_id"] as! Int
//            print(conversation_id)
//           let id = msg["id"] as! Int
//            print(id)
//           let timestamp = msg["timestamp"] as! String
//            print(timestamp)
//           let user_id = msg["user_id"] as! Int
//            print(user_id)
//           let user_role = msg["user_role"] as! String
//            print(user_role)
//           let status = msg["status"] as! String
//
//            print(status)
//
//
//
//            let pra = ["conversation_id" : conversation_id,
//                          "cover" : "asdfasdf",
//                          "created_at" : "",
//                          "delivered_as" : "",
//                          "id" : id,
//                          "price" : "",
//                          "remarks" : "",
//                          "unread_messages" : "",
//                          "status" : status,
//                          "title" : "asdfasf",
//                          "user_id" : user_id,
//                          "user_role" : user_role,
//                          "type" : type,
//                          "timestamp" : timestamp,
//                          "content" : content] as [String : Any]
//
//                          let msgsocket = MessageModel(JSON: pra)
//            self.messages.append(msgsocket!)
//            self.tableView.reloadData()
//            self.tableView.scrollToBottom(animated: true)
            
            
        }
    }
    
    func ApiCall(id:String)  {
        SVProgressHUD.show(withStatus: "Loading...")
        NetworkManager.SharedInstance.getMessagesDetails(id: id, success: { (res) in
            SVProgressHUD.dismiss()
            
            
            self.messages = res
            
            let arr = self.messages.sorted { $0.convertedStartDate < $1.convertedStartDate }
           
            self.messages = arr
            self.tableView.reloadData()
            self.tableView.scrollToBottom(animated: true)
        }) { (err) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!!", message: "something went wrong", view: self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        let message = self.messages[indexPath.row]

        if message.type == "TEXT"{

            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatViewCell", for: indexPath) as! Message_NotificationTableViewCell

            cell.messageLbl.text = message.content

            cell.messageLbl.isHidden = false
            
            cell.chatview.giveShadow()
            cell.chatview.layer.cornerRadius = 15
            if message.user_role == "CUSTOMER"{
                cell.traillingSpace.constant = 28
            }else{
                cell.traillingSpace.constant = 77
            }
            
            
            return cell

        }else {
            
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatImgViewCell", for: indexPath) as! Message_NotificationTableViewCell
            if message.content != nil {
                cell.messageImg.sd_setImage(with: URL(string: message.content!), placeholderImage: UIImage(named: "placeholder.png"))

            }
            
            cell.chatview.giveShadow()
          cell.chatview.layer.cornerRadius = 15
          if message.user_role == "CUSTOMER"{
              cell.traillingSpace.constant = 28
          }else{
              cell.traillingSpace.constant = 77
          }
            
            return cell
        }

        
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
          let message = self.messages[indexPath.row]
        if message.type == "IMAGE" {
            return 100
        }else{
            return 600
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = self.messages[indexPath.row]
        if message.type == "IMAGE" {
            return 207
        }else{
            return UITableView.automaticDimension
        }
    }

    
    func sendContent(type : String ,message : String)  {
        let pra = ["type": type,"content":message]
        NetworkManager.SharedInstance.sendMessages(id: self.id, params: pra, content: nil, success: { (res) in
            print(res)
            self.messageText.text = ""
            self.messages.append(res)
            self.tableView.reloadData()
            self.tableView.scrollToBottom(animated: true)
        }) { (err) in
            print("error")
            
//            Utilites.ShowAlert(title: "E", message: <#T##String#>, view: <#T##UIViewController#>)
        }
    }
    
    
     func sendImage(type : String )  {
            let pra = ["type": type]
        NetworkManager.SharedInstance.sendMessages(id: self.id, params: pra, content: self.img, success: { (res) in
                print(res)
            self.img = nil
                self.messages.append(res)
                self.tableView.reloadData()
            self.tableView.scrollToBottom(animated: true)
            }) { (err) in
                print("error")
                
    //            Utilites.ShowAlert(title: "E", message: <#T##String#>, view: <#T##UIViewController#>)
            }
        }
    
   

    @IBAction func sendBtn(_ sender: Any) {
//        if self.messageText.text == "" {
//            self.sendImage(type: "IMAGE")
//        }else if self.img != nil{
        if self.messageText.text != "" {
            
            sendContent(type: "TEXT", message: self.messageText.text!)
            self.messageText.text = ""
        
        }else{
            self.showToast(message: "Kindly enter a text")
        }
            
//        }
        
    }
    
    
    @IBAction func cameraBtn(_ sender: Any) {
        
        openCamer()
    }
    
    
    func openCamer() {
            
            let imagesource = UIAlertController(title: "Image source", message: "", preferredStyle: .actionSheet)
            
            let camera = UIAlertAction(title: "Take Picture", style: .default) { (ale) in
    //            self.images.removeLast()
                let main = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
                main.type = "message"
    //            main.type = "repair"
//                self.image = nil
                if self.gottoCamera == "go" {
                    main.count = 2
                }else{
                    main.count = 1
                }
                
                self.messageText.text = ""
                self.navigationController?.pushViewController(main, animated: true)
                
            }
            let media = UIAlertAction(title: "Media", style: .default) { (ale) in
                guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                    //Show error to user?
                    return
                }
//                self.image = nil
                //Example Instantiating OpalImagePickerController with Closures
                let imagePicker = OpalImagePickerController()
                imagePicker.imagePickerDelegate = self
//                let max = 20 - self.images.count
                imagePicker.maximumSelectionsAllowed = 1
                self.messageText.text = ""
                self.present(imagePicker, animated: true, completion: nil)
//                if self.images.count <= 20 {
//                    self.present(imagePicker, animated: true, completion: nil)
//                }else{
//                    Utilites.ShowAlert(title: "Alert!!!", message: "MAx num of photos in 20", view: self)
//                }
                
                
                
             
            }
            let cancle = UIAlertAction(title: "Cancel", style: .cancel ) { (ale) in
                
            }
        
        if let popoverController = imagesource.popoverPresentationController {
                           popoverController.sourceView = self.view
                           popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                           popoverController.permittedArrowDirections = []
                         }
            imagesource.addAction(camera)
            imagesource.addAction(media)
            imagesource.addAction(cancle)
            
            self.present(imagesource, animated: true, completion: nil)
            
        }

    
    
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        //Cancel action?
        print("adsasd")
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
    
        
        print(images.count)
        for img in images{
            self.img = img
        }
        self.sendImage(type: "IMAGE")
//        self.images.append(UIImage(named: "addimage")!)
//        self.collectionView.reloadData()
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerNumberOfExternalItems(_ picker: OpalImagePickerController) -> Int {
        return 1
    }
    
    func imagePickerTitleForExternalItems(_ picker: OpalImagePickerController) -> String {
        return NSLocalizedString("External", comment: "External (title for UISegmentedControl)")
    }
    
    func imagePicker(_ picker: OpalImagePickerController, imageURLforExternalItemAtIndex index: Int) -> URL? {
        return URL(string: "https://placeimg.com/500/500/nature")
    }
    
    
    @objc func buttonAction(_ sender:UIButton!)
      {
          if Utilites.isInternetAvailable() {
              self.imageView.isHidden = true
              self.button.isHidden = true
    //                  apicall()()
      //            self.viewWillAppear(true)
          }else{
              self.showToast(message: "Internet is not availble")
          }
      }
    
}
