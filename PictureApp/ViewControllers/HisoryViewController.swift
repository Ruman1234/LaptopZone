//
//  HisoryViewController.swift
//  PictureApp
//
//  Created by Apple on 6/22/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import CoreData

struct historyDb {
    
    var bacode:String
    var condition:String
    var status:String
    var pictures:String
    var timeStamp:String
}

class HisoryViewController: UIViewController ,UITableViewDataSource ,UITableViewDelegate{

    @IBOutlet var sideMenu: UIBarButtonItem!
    @IBOutlet weak var tableVeiw: UITableView!
    
    
    var history: [NSManagedObject] = []
    var historyFormDB = [historyDb]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getHistoryFormDB()
        
        self.navigationController?.navigationItem.leftBarButtonItem = sideMenu
        
        self.sideMenu.target = self.revealViewController()
        self.sideMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.tableVeiw.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    
    func getHistoryFormDB()  {
        
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "History")
        
        //3
        do {
            history = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        var i = 0
        for _ in history {
        
            self.historyFormDB.append(historyDb(bacode: history[i].value(forKey: "barcode") as! String, condition: history[i].value(forKey: "condition") as! String, status: history[i].value(forKey: "status") as! String, pictures: history[i].value(forKey: "pictures") as! String, timeStamp: history[i].value(forKey: "timeStamp") as! String))
            
            i += 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyFormDB.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let history = self.historyFormDB[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        
        cell.barcodelbl.text = history.bacode
        cell.conditionLbl.text = history.condition
        cell.statusLbl.text = history.status
        cell.pictureLbl.text = history.pictures
        cell.timeLbl.text = history.timeStamp
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            self.historyFormDB.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }

    
}
