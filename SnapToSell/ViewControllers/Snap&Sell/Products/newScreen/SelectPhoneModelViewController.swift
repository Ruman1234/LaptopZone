
//
//  SelectPhoneModelViewController.swift
//  SnapToSell
//
//  Created by Apple on 10/8/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class SelectPhoneModelViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource{
  
    

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBG()
          self.addPAger(totalPage: 7, currentPage: 3)
          self.cancleBtn()
          self.backBtn()
        // Do any additional setup after loading the view.
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 10
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "modelCell", for: indexPath) as! SelectModelTableViewCell

        cell.getofferBtn.setGradient()
//        cell.getofferBtn.setFont(size: 17)
        
        cell.selectionStyle = .none
            return cell
        
      }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 195
    }
    
    
    
    @IBAction func getofferBtbn(_ sender: Any) {
        
        
    }
    

}
