
//
//  SelectPhoneModelViewController.swift
//  SnapToSell
//
//  Created by Apple on 10/8/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD

class SelectPhoneModelViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource{
  
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deviceName: UILabel!
    var id = String()
    var brandArray = [Buy_SellModel]()
    var carierService = String()
    var name = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBG()
        self.addPAger(totalPage: 7, currentPage: 5)
        self.cancleBtn()
        self.backBtn()
        callApi(id: self.id)
        
        self.deviceName.text = name
        // Do any additional setup after loading the view.
    }
    
    
    func callApi(id : String)  {
             SVProgressHUD.show(withStatus: "Loading...")
             NetworkManager.SharedInstance.getStorage(Id: id, success: { (res) in
               
                 SVProgressHUD.dismiss()
                 guard let arr = res.storage else{
                     return
                 }
               print(arr)
                 self.brandArray = arr
//                 self.collectionView.reloadData()
                self.tableView.reloadData()
             }) { (err) in
                 SVProgressHUD.dismiss()
                 Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
             }
         }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brandArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "modelCell", for: indexPath) as! SelectModelTableViewCell

        cell.modelName.text = self.name + "(\(self.brandArray[indexPath.row].STORAGE_DESC!))"
        cell.getofferBtn.setGradient()
        cell.servicename.text = "Carrier: " + self.carierService
//        cell.getofferBtn.setFont(size: 17)
        cell.getofferBtn.tag = indexPath.row
        
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 195
    }
    
    
    
    @IBAction func getofferBtbn(_ sender: AnyObject) {
        
        let main = self.storyboard?.instantiateViewController(withIdentifier: "GiveOfferScreenViewController") as! GiveOfferScreenViewController
        main.id = self.brandArray[sender.tag].LZW_STORAGE_DT_ID!
        main.price = self.brandArray[sender.tag].SALE_PRICE!
        print(self.brandArray[sender.tag].SALE_PRICE!)
        Constants.storage_name = self.brandArray[sender.tag].LZW_STORAGE_DT_ID!
        self.navigationController?.pushViewController(main, animated: true)
        
    }
    
    


    func addDashedBottomBorder(to cell: UITableViewCell) {
        let color = UIColor.black.cgColor

        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = cell.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: 0)

        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2.0
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [9,6]
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: shapeRect.height, width: shapeRect.width, height: 0), cornerRadius: 0).cgPath
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: shapeRect.height, width: shapeRect.width, height: 0), cornerRadius: 0).cgPath
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: shapeRect.height, width: shapeRect.width, height: 1), cornerRadius: 0).cgPath
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPhase = 3.0 // Add "lineDashPhase" property to CAShapeLayer
        shapeLayer.lineDashPattern = [9,6]
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: shapeRect.height, width: shapeRect.width, height: 0), cornerRadius: 0).cgPath

        cell.layer.addSublayer(shapeLayer)
    }

}
