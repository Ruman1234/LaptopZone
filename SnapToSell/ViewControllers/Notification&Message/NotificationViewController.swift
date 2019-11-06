//
//  NotificationViewController.swift
//  SnapToSell
//
//  Created by Apple on 10/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController  ,UITableViewDelegate , UITableViewDataSource{
   
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBG()
        // Do any additional setup after loading the view.
    }
    

 
       override func viewDidAppear(_ animated: Bool) {
           let requestImg = UIImageView()
                 requestImg.image = UIImage(named: "Notification-1")
                 requestImg.frame = CGRect(x: 25, y: 42, width: 162, height: 22)
                 self.view.addSubview(requestImg)

                 let xside = self.view.frame.width / 1.123


                 let sideImg = UIImageView()
                 sideImg.image = UIImage(named: "sideimg1")
                 sideImg.frame = CGRect(x: xside, y: 45, width: 25, height: 15)
                 self.view.addSubview(sideImg)
       }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 6
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "Message_NotificationTableViewCell", for: indexPath) as! Message_NotificationTableViewCell
                
                  cell.selectionStyle = .none
                  
                  return cell
       }
       

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98
    }

}
