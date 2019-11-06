
//
//  ShipmentRatesViewController.swift
//  SnapToSell
//
//  Created by Apple on 8/30/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD

class ShipmentRatesViewController: UIViewController, PackageDetailsViewControllerDelegate , UITableViewDelegate , UITableViewDataSource {
   
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var continueBtn: UIButton!
    
    var height = String()
    var weight = String()
    var width = String()
    var length = String()
    
    var data : PackageDetailsViewController?
    
    var rates = [Rates]()
    var sihp_id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data?.delegate = self
        
        self.height = Constants.height
        self.weight = Constants.weight
        self.width = Constants.width
        self.length = Constants.length
        SVProgressHUD.show(withStatus: "Loading..")
        NetworkManager.SharedInstance.requestShipmentRates(address_id: Constants.addressId, weight: self.weight, length: self.length, width: self.width, height: self.height, success: { (res) in
            print(res)
            SVProgressHUD.dismiss()
            self.rates = res.rates!
            self.sihp_id = res.id!
            self.tableView.reloadData()
        }) { (err) in
            Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
        }
        
//        self.addBG()
//        self.backBtn()
        // Do any additional setup after loading the view.
    }
    
    func data(height: String, weight: String, width: String, length: String) {
        self.height = height
        self.weight = weight
        self.width = width
        self.length = length
    }
    

    @IBAction func continueBtn(_ sender: Any) {
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShipmentRatesTableViewCell", for: indexPath ) as! ShipmentRatesTableViewCell
        cell.carier.text = self.rates[indexPath.row].carrier
        cell.servidce.text = self.rates[indexPath.row].service
        cell.rate.text = self.rates[indexPath.row].rate! + "$"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alrt = UIAlertController(title: "!!!!", message: "Are you sure you want to ship", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .default) { (res) in
            SVProgressHUD.show(withStatus: "Loading...")
            NetworkManager.SharedInstance.requestShipment(request_id: Constants.requestId, shipment_id: self.sihp_id, rate_id: self.rates[indexPath.row].id!, success: { (res) in
                
                
                if res == "Error" {
                    SVProgressHUD.dismiss()
                    Utilites.ShowAlert(title: "Error!!!", message: "Please enter a USA address", view: self)
                    return
                }
                SVProgressHUD.dismiss()
                print(res)
                
                NotificationCenter.default.post(name: Notification.Name("backStepShippment"), object: nil)
                
                Utilites.ShowAlert(title: "Success", message: "product is added to shipment", view: self)
                
                
            }) { (err) in
                SVProgressHUD.dismiss()
                Utilites.ShowAlert(title: "Error!!!", message: "something went wrong", view: self)
            }
        }
        let no = UIAlertAction(title: "No", style: .destructive) { (res) in
            
        }
        alrt.addAction(yes)
        alrt.addAction(no)
        self.present(alrt, animated: true, completion: nil)
       
    }
    
    
}
