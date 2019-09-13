//
//  ProcessedProductsViewController.swift
//  SnapToSell
//
//  Created by Apple on 8/29/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD

class ProcessedProductsViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var id  = String()
    var offersArray = [OffersModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.offers(id: id)
        Constants.requestId = id
        // Do any additional setup after loading the view.
    }
    
    
    func offers(id :String) {
        SVProgressHUD.show(withStatus: "Loading..")
        NetworkManager.SharedInstance.Offers(id: id, success: { (res) in
            print(res)
            SVProgressHUD.dismiss()
            self.offersArray = res
            self.tableView.reloadData()
        }) { (err) in
            Utilites.ShowAlert(title: "Error!!", message: "Something went wrond", view: self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.offersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let offer = self.offersArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell", for: indexPath) as! AddressTableViewCell
        
        cell.priceLbl.text = "\(String(describing: offer.price!.dollarString))"
        cell.numberLbl.text = offer.title
        
        if offer.images![0].url!.first == "/" {
            print("http://71.78.236.22/laptop-zone-stage/public" + offer.images![0].url!)
            cell.productImage.sd_setImage(with: URL(string: "http://71.78.236.22/laptop-zone-stage/public" + offer.images![0].url!), placeholderImage: UIImage(named: "placeholder.png"))
        }else{
            cell.productImage.sd_setImage(with: URL(string: offer.images![0].url!), placeholderImage: UIImage(named: "placeholder.png"))
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
  
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let alert = UIAlertController(title: "Continue By", message: "", preferredStyle: .actionSheet)
//
//
//        let pickup = UIAlertAction(title: "Pickup", style: .default) { (ale) in
//
//            let main = self.storyboard?.instantiateViewController(withIdentifier: "processedSetupIndicatorViewController") as! processedSetupIndicatorViewController
//            main.requestId = self.id
//            self.navigationController?.pushViewController(main, animated: true)
//
//        }
//
//        let dropOff = UIAlertAction(title: "Drop Off", style: .default) { (ale) in
//            let main = self.storyboard?.instantiateViewController(withIdentifier: "DropOffSetupViewController") as! DropOffSetupViewController
//            main.requestId = self.id
//            self.navigationController?.pushViewController(main, animated: true)
//
//        }
//
//        let Shipment = UIAlertAction(title: "Shipment", style: .default) { (ale) in
//            let main = self.storyboard?.instantiateViewController(withIdentifier: "ShipmentSetupViewController") as! ShipmentSetupViewController
//
//            self.navigationController?.pushViewController(main, animated: true)
//
//        }
//
//        let cancle = UIAlertAction(title: "Cancle", style: .cancel) { (ale) in
//
//        }
//
//
//        alert.addAction(pickup)
//        alert.addAction(dropOff)
//        alert.addAction(Shipment)
//        alert.addAction(cancle)
//
//        self.present(alert, animated: true, completion: nil)
//
//    }
    
    
    @IBAction func continuebtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "Continue By", message: "", preferredStyle: .actionSheet)
        
       
        let pickup = UIAlertAction(title: "Pickup", style: .default) { (ale) in
            
            let main = self.storyboard?.instantiateViewController(withIdentifier: "processedSetupIndicatorViewController") as! processedSetupIndicatorViewController
            main.requestId = self.id
            self.navigationController?.pushViewController(main, animated: true)
            
        }
        
        let dropOff = UIAlertAction(title: "Drop Off", style: .default) { (ale) in
            let main = self.storyboard?.instantiateViewController(withIdentifier: "DropOffSetupViewController") as! DropOffSetupViewController
            main.requestId = self.id
            self.navigationController?.pushViewController(main, animated: true)
            
        }
        
        let Shipment = UIAlertAction(title: "Shipment", style: .default) { (ale) in
            let main = self.storyboard?.instantiateViewController(withIdentifier: "ShipmentSetupViewController") as! ShipmentSetupViewController
            
            self.navigationController?.pushViewController(main, animated: true)

        }
        
        let cancle = UIAlertAction(title: "Cancle", style: .cancel) { (ale) in
            
        }
        
        
        alert.addAction(pickup)
        alert.addAction(dropOff)
        alert.addAction(Shipment)
        alert.addAction(cancle)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func chatVC(_ sender: Any) {
    }
    
    @IBAction func chat(_ sender: Any) {
        let main = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        self.navigationController?.pushViewController(main, animated: true)

    }
    
    @IBAction func approve(_ sender: Any) {
        let alert = UIAlertController(title: "Continue By", message: "", preferredStyle: .actionSheet)
        
        
        let pickup = UIAlertAction(title: "Pickup", style: .default) { (ale) in
            
            let main = self.storyboard?.instantiateViewController(withIdentifier: "processedSetupIndicatorViewController") as! processedSetupIndicatorViewController
            main.requestId = self.id
            self.navigationController?.pushViewController(main, animated: true)
            
        }
        
        let dropOff = UIAlertAction(title: "Drop Off", style: .default) { (ale) in
            let main = self.storyboard?.instantiateViewController(withIdentifier: "DropOffSetupViewController") as! DropOffSetupViewController
            main.requestId = self.id
            self.navigationController?.pushViewController(main, animated: true)
            
        }
        
        let Shipment = UIAlertAction(title: "Shipment", style: .default) { (ale) in
            let main = self.storyboard?.instantiateViewController(withIdentifier: "ShipmentSetupViewController") as! ShipmentSetupViewController
            
            self.navigationController?.pushViewController(main, animated: true)
            
        }
        
        let cancle = UIAlertAction(title: "Cancle", style: .cancel) { (ale) in
            
        }
        
        
        alert.addAction(pickup)
        alert.addAction(dropOff)
        alert.addAction(Shipment)
        alert.addAction(cancle)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    

    @IBAction func reject(_ sender: Any) {
    }
}


extension Double {
    var dollarString:String {
        return String(format: "$%.2f", self)
    }
}
