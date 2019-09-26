//
//  SideMenuViewController.swift
//  PictureApp
//
//  Created by Apple on 6/22/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource{

    @IBOutlet weak var tabelVeiw: UITableView!
    @IBOutlet weak var countNumber: UIButton!
    @IBOutlet weak var countId: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    let arr = ["Main" , "Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userName.text = Constants.USERNAME
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
        
        cell.nameLbl.text = self.arr[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let main = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            let front = UINavigationController.init(rootViewController: main)
            revealViewController()?.pushFrontViewController(front, animated: true)
            
        }
    }
    
    @IBAction func countBtn(_ sender: Any) {
        
        let main = self.storyboard?.instantiateViewController(withIdentifier: "HisoryViewController") as! HisoryViewController
        let front = UINavigationController.init(rootViewController: main)
        revealViewController()?.pushFrontViewController(front, animated: true)
    }
}
