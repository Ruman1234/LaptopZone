//
//  ApprovedProductDetailViewController.swift
//  SnapToSell
//
//  Created by Apple on 8/29/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class ApprovedProductDetailViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    
    @IBOutlet weak var titleProduct: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lotPrice: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var remarks: UILabel!
    
    
    var detail = RequestStatusModel()
    var offersArray = [OffersModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getBarcode()
        self.titleProduct.text = self.detail?.title
        self.lotPrice.text = "\(String(describing: self.detail!.price!))"
        self.dateLbl.text = self.detail?.created_at
        self.status.text = self.detail?.status
        self.remarks.text = self.detail?.remarks
        offers(id: "\(detail!.id!)")
        // Do any additional setup after loading the view.
    }
    
    
    func getBarcode()  {
        
        
        Alamofire.request(URL(string: "http://talkerscode.com/webtricks/demo/js/barcode/barcode.php?codetype=Code39&size=40&text=5555&print=true")!)        .responseData { (data) in
            let data = data
            
            let img = UIImage(data: data.data!)
            self.img.image = img!
//            self.images.append(img!)
//            self.collectionView.reloadData()
        }
        
    }
    
    
    func offers(id :String) {
        SVProgressHUD.show(withStatus: "Loading...")
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
        
        cell.priceLbl.text = "\(String(describing: offer.price!)) $"
        cell.numberLbl.text = offer.upc
        cell.productImage.sd_setImage(with: URL(string: offer.images![0].url!), placeholderImage: UIImage(named: "placeholder.png"))
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

}
