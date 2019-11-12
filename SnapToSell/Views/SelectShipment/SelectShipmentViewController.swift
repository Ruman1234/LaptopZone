//
//  SelectShipmentViewController.swift
//  SnapToSell
//
//  Created by Apple on 10/21/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD


protocol SelectShipmentViewDelegate {
    func didClose(text : String , id : String)
    func didClose()
}




class SelectShipmentView: UIView , UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate : SelectShipmentViewDelegate?
    
    var rates = [Rates]()
    var check = [0,0,0,0,0,0]
    var rateId = String()
    var id = String()
    
    override func awakeFromNib() {
        doneBtn.setFont(size: 19)
        doneBtn.setGradient()
        self.apiCall()
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: "shipmentTableViewCell", bundle: nil), forCellReuseIdentifier: "shipmentCell")
        
        self.tableView.tableFooterView = UIView()
//        tableView.fott
    }
    
    func apiCall() {
//        SVProgressHUD.show(withStatus: "Loading...")
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rates.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shipmentCell", for: indexPath) as! shipmentTableViewCell
        let price = Double(rates[indexPath.row].rate!)?.dollarString
        cell.nameLbl.text = rates[indexPath.row].carrier! + "     " + price!  + "     " + rates[indexPath.row].service!
        if self.check[indexPath.row] == 0{

            if #available(iOS 13.0, *) {
                cell.cellImg?.tintColor = UIColor.gray
                cell.cellImg.image = UIImage(systemName: "circle")
            } else {
                // Fallback on earlier versions
            }
        }else{

            if #available(iOS 13.0, *) {
                cell.cellImg?.tintColor = UIColor.red
                cell.cellImg.image = UIImage(systemName: "largecircle.fill.circle")
            } else {
                // Fallback on earlier versions
            }
        }
        cell.selectionStyle = .none
        
        return cell
    }
       

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath1 = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example

        let currentCell = tableView.cellForRow(at: indexPath1!) as! shipmentTableViewCell

        self.rateId = self.rates[indexPath.row].id!
        self.id = self.rates[indexPath.row].shipment_id!
        if #available(iOS 13.0, *) {
            currentCell.imageView?.tintColor = UIColor.red
            currentCell.cellImg.image = UIImage(systemName: "largecircle.fill.circle")
        } else {
            // Fallback on earlier versions
        }
        
        for i in 0...5 {
            self.check[i] = 0
        }
        self.check[indexPath.row] = 1
        self.tableView.reloadData()
    }
       
       
    
    
    @IBAction func doneBtn(_ sender: Any) {
        if self.rateId != "" &&  self.id != ""{
            delegate?.didClose(text: self.rateId, id: self.id)
        }else{
            self.showToast(message: "Please select carrier")
        }
//        delegate?.didClose(text: self.rateId)
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        delegate?.didClose()
    }
    
}
