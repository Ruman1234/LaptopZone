//
//  MessageViewController.swift
//  SnapToSell
//
//  Created by Apple on 10/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD

class MessageViewController: UIViewController  ,UITableViewDelegate , UITableViewDataSource, UISearchBarDelegate{
   
    @IBOutlet weak var menuBTn: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBtn: UIBarButtonItem!
    @IBOutlet weak var noreuestView: UIView!
    var messages = [MessageModel]()
    var messagesFilterArray = [MessageModel]()
    var searchArray = false
    
    let imageView = UIImageView(image: UIImage(named: "no_net (1)"))
    let button = UIButton(type: UIButton.ButtonType.system) as UIButton
    
    var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 10, height: 20))
//    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = self.menuBTn
        self.navigationItem.rightBarButtonItem = self.searchBtn
        self.addBG()
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)

       
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Utilites.isInternetAvailable() {
          apicall()
        }else{
            self.netCheck(button: button, imageView: imageView)
            button.addTarget(self, action: #selector(ViewController.buttonAction(_:)), for: .touchUpInside)
              
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
       self.navigationController?.navigationBar.isTranslucent = true
       self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
 
        let view = UIView()
        view.layer.masksToBounds = true
        view.frame = CGRect(x: 0, y: 15, width: (navigationController?.navigationBar.frame.width)!, height: 50)
        self.view.addSubview(view)
//
        view.applyGradient(colours: [
            UIColor(red: 0.99, green: 0.17, blue: 0.03, alpha: 1),
          UIColor(red: 1, green: 0.49, blue: 0, alpha: 1)
        ], locations: [0.12, 1], startPoint: CGPoint(x:0.00, y: 0.1), endPoint: CGPoint(x: 1, y: 1))
        
        
//        view.applyGradient(colours: [
//                   UIColor(red: 0.99, green: 0.17, blue: 0.03, alpha: 1),
//                 UIColor(red: 1, green: 0.49, blue: 0, alpha: 1)
//               ], locations: [0, 1], startPoint: CGPoint(x: 0.25, y: 0.5), endPoint: CGPoint(x: 0.75, y: 0.5))
        
        
//        let requestImg = UIImageView()
//        requestImg.image = UIImage(named: "Messages")
//        requestImg.frame = CGRect(x: 25, y: 42, width: 139, height: 22)
//        self.view.addSubview(requestImg)
//
//        let xside = self.view.frame.width / 1.123
//
//
//        let sideImg = UIImageView()
//        sideImg.image = UIImage(named: "sideimg1")
//        sideImg.frame = CGRect(x: xside, y: 45, width: 25, height: 15)
//        self.view.addSubview(sideImg)
    }
       
       
    
    func apicall()  {
        SVProgressHUD.show(withStatus: "Loading...")
        NetworkManager.SharedInstance.getMessages(success: { (res) in
            SVProgressHUD.dismiss()
            print(res)
            
            if res.count == 0 {
                self.tableView.isHidden = true
            }else{
                self.noreuestView.isHidden = true
            }
            
            if res != nil{
                self.messages = res
                self.tableView.reloadData()
            }else{
                return
            }
            
          
            
        }) { (err) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
        }
    }
 
      
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.searchArray {
            return self.messagesFilterArray.count
        }else{
            return self.messages.count
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var msg = MessageModel()
        
        if self.searchArray {
             msg = self.messagesFilterArray[indexPath.row]
        }else{
             msg = self.messages[indexPath.row]
        }
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "Message_NotificationTableViewCell", for: indexPath) as! Message_NotificationTableViewCell
                

        if msg.unread_messages == 0 {
             cell.dateLbl.text = ""
        }else{
            cell.dateLbl.text = "\(msg.unread_messages!)"
        }
        
        cell.nameLbl.text = msg.title
        cell.descriptionLbl.text = msg.last_message?.content
        
        
//        if msg.last_message.u

        
        if msg.cover != nil {
            
            cell.img.sd_setImage(with: URL(string: msg.cover!), placeholderImage: UIImage(named: "placeholder.png"))
            cell.img.layer.cornerRadius =  cell.img.frame.width / 2
        }

        cell.selectionStyle = .none

        return cell
    }
       
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            
            var msg = MessageModel()
                  
            if self.searchArray {
               msg = self.messagesFilterArray[indexPath.row]
            }else{
               msg = self.messages[indexPath.row]
            }
                  
            
            let main = self.storyboard?.instantiateViewController(identifier: "ChatViewController") as! ChatViewController
            main.id = "\(msg.id!)"
            self.navigationController?.pushViewController(main, animated: true)
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 133
    }

    
    @objc func buttonAction(_ sender:UIButton!)
          {
              if Utilites.isInternetAvailable() {
                  self.imageView.isHidden = true
                  self.button.isHidden = true
                  apicall()
          //            self.viewWillAppear(true)
              }else{
                  self.showToast(message: "Internet is not availble")
              }
          }
    
    
    @IBAction func searchBtn(_ sender: Any) {
        
        searchBar.placeholder = "Search"

        self.navigationItem.leftBarButtonItems?.removeAll()
        self.navigationItem.rightBarButtonItems?.removeAll()
        
        
        self.searchBar.becomeFirstResponder()
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        searchBar.showsCancelButton = true
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        
        UIView.animate(withDuration: 3) {
            self.view.layoutIfNeeded()
        }
        

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        self.navigationItem.leftBarButtonItem = menuBTn
        self.navigationItem.rightBarButtonItem = searchBtn
        self.searchArray = false
        self.tableView.reloadData()
        UIView.animate(withDuration: 0.7) {
          self.view.layoutIfNeeded()
        }
        
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        messagesFilterArray = messages.filter { (candy: MessageModel) -> Bool in
            return candy.title!.lowercased().contains(searchText.lowercased())
        }

        self.searchArray = true
        self.tableView.reloadData()
    }
    
}
