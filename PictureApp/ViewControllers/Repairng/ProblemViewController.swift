
//
//  ProblemViewController.swift
//  SnapToSell
//
//  Created by Apple on 9/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper
import SVProgressHUD

class ProblemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var itemsArray = [Ljw_Issues]()
    var id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchDetails(id: id)
        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    

    func fetchDetails(id :String) {
        SVProgressHUD.show(withStatus: "Loading...")
        Alamofire.request(URL(string: "http://71.78.236.20/laptopzone/reactcontroller/c_react/ljw_Issues")!, method: HTTPMethod.post, parameters: ["get_product_name" : id], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print(response)
            SVProgressHUD.dismiss()
            guard (response.response?.statusCode) != nil else{
                return
            }
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    let res1 = Mapper<RepairModel>().map(JSON: value as! [String : Any])!
                    print(res1.ljw_Issues)
                    guard let arr = res1.ljw_Issues else{
                        return
                    }
                    self.itemsArray = arr
                    self.tableView.reloadData()
                }
            }else{
                SVProgressHUD.dismiss()
                Utilites.ShowAlert(title: "Error!!", message: "Something went wrong", view: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "issueCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = self.itemsArray[indexPath.row].iSSU_NAME
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let main = self.storyboard?.instantiateViewController(withIdentifier: "ContactDetailsViewController") as! ContactDetailsViewController
        Constants.issuesId = self.itemsArray[indexPath.row].iSSUE_DT_ID!
        self.navigationController?.pushViewController(main, animated: true)
    }

    
}
