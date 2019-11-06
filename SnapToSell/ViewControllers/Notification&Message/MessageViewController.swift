//
//  MessageViewController.swift
//  SnapToSell
//
//  Created by Apple on 10/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD

class MessageViewController: UIViewController  ,UITableViewDelegate , UITableViewDataSource{
   
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noreuestView: UIView!
    var messages = [MessageModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBG()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        apicall()
    }

    override func viewDidAppear(_ animated: Bool) {
        let requestImg = UIImageView()
        requestImg.image = UIImage(named: "Messages")
        requestImg.frame = CGRect(x: 25, y: 42, width: 139, height: 22)
        self.view.addSubview(requestImg)

        let xside = self.view.frame.width / 1.123


        let sideImg = UIImageView()
        sideImg.image = UIImage(named: "sideimg1")
        sideImg.frame = CGRect(x: xside, y: 45, width: 25, height: 15)
        self.view.addSubview(sideImg)
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
        return self.messages.count
       }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let msg = self.messages[indexPath.row]

           let cell = tableView.dequeueReusableCell(withIdentifier: "Message_NotificationTableViewCell", for: indexPath) as! Message_NotificationTableViewCell
                

        cell.dateLbl.text = msg.created_at
        cell.nameLbl.text = msg.title
        cell.descriptionLbl.text = msg.remarks

        if msg.cover != nil {
            
            cell.img.sd_setImage(with: URL(string: msg.cover!), placeholderImage: UIImage(named: "placeholder.png"))
            cell.img.layer.cornerRadius =  cell.img.frame.width / 2
        }

        cell.selectionStyle = .none

        return cell
    }
       
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            let main = self.storyboard?.instantiateViewController(identifier: "ChatViewController") as! ChatViewController
            main.id = "\(self.messages[indexPath.row].id!)"
            self.navigationController?.pushViewController(main, animated: true)
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 133
    }

}
