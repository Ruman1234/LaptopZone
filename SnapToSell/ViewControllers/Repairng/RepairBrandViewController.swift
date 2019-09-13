//
//  RepairDetailViewController.swift
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

class RepairBrandViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    

    
    
    @IBOutlet weak var tableView: UITableView!
    var id = String()
    var itemsArray = [Ljw_getobject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        fetchDetails(id: id)
        
        self.tableView.tableFooterView = UIView()
    }
    
    func fetchDetails(id :String) {
        SVProgressHUD.show(withStatus: "Loading...")
        Alamofire.request(URL(string: "http://71.78.236.20/laptopzone/reactcontroller/c_react/ljw_Brands")!, method: HTTPMethod.post, parameters: ["get_product_name" : id], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print(response)
            SVProgressHUD.dismiss()
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                   let res1 = Mapper<RepairModel>().map(JSON: value as! [String : Any])!
                    print(res1.ljw_getobject)
                    guard let arr = res1.ljw_getobject else{
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrandCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = self.itemsArray[indexPath.row].bRAND_NAME
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let main = self.storyboard?.instantiateViewController(withIdentifier: "SeriesViewController") as! SeriesViewController
        main.id = self.itemsArray[indexPath.row].bRAND_DT_ID!
        Constants.brandId = self.itemsArray[indexPath.row].bRAND_DT_ID!
        self.navigationController?.pushViewController(main, animated: true)
    }

}
