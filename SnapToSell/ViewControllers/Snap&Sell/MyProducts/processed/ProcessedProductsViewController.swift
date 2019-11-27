//
//  ProcessedProductsViewController.swift
//  SnapToSell
//
//  Created by Apple on 8/29/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD

class ProcessedProductsViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource , UICollectionViewDelegate , UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var previewIamge: UIImageView!

    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var titleProduct: UILabel!

    @IBOutlet weak var titleModel: UILabel!
    @IBOutlet weak var lotPrice: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var remarks: UILabel!

    @IBOutlet var cameraButton: UIBarButtonItem!

    @IBOutlet weak var ShowCancelBtn: UIButton!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var activeLbl: UILabel!
    
    @IBOutlet weak var navigationTitile: UILabel!
    
    @IBOutlet weak var requestCancelBtn: UIButton!
    
    @IBOutlet weak var askingpriceLbl: UILabel!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var requestStatusLbl: UILabel!
    
    
    var id  = String()
    var conversation_id  = String()
    var detail = RequestStatusModel()
    var offersArray = [OffersModel]()
    var index = Int()
    var img = Int()
    var products = [String]()
    
    var type = String()
    var approves = Bool()
//    var images = [UIImage]()
//    let cancelBtn = UIButton()
               
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.offers(id: id)
//        cancelBtn.frame = CGRect(x: <#T##Int#>, y: <#T##Int#>, width: <#T##Int#>, height: <#T##Int#>)
        
        Constants.requestId = id
        self.addBG()
        self.backBtn()
        
         self.activeLbl.layer.cornerRadius = 13
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        hideLAble()
       
        if self.type == "rep"{
            self.messageBtn.isHidden = true
            titleModel.text = "Model"
            if self.approves {
                self.activeLbl.text = "APPROVED"
                self.requestStatusLbl.text = "APPROVED"
             self.descriptionLbl.text = "Awaiting for your Package, Please send as soon as for further Processing"
                self.acceptBtn.setTitle("Proceed by another way", for: .normal)
            }else{
                self.activeLbl.text = "PROCESSED"
            }
            fetchDetailOfRepRec() 
        }else{
            fetchSingalProduct()
        }
        
        self.messageBtn.layer.cornerRadius = self.messageBtn.frame.height / 2.041
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
         self.acceptBtn.setGradient()
    }
    
//    func offers(id :String) {
//        SVProgressHUD.show(withStatus: "Loading..")
//        NetworkManager.SharedInstance.Offers(id: id, success: { (res) in
//            print(res)
//            SVProgressHUD.dismiss()
//            for arr in res{
//                if arr.status == "CANCELLED"{
//
//                }else{
//                    self.offersArray.append(arr)
//                }
//            }
//
//            self.tableView.reloadData()
//        }) { (err) in
//            SVProgressHUD.dismiss()
//            Utilites.ShowAlert(title: "Error!!", message: "Something went wrond", view: self)
//        }
//    }
//
    
    func fetchDetailOfRepRec()  {
            
        SVProgressHUD.show(withStatus: "Loading...")
        
        
    NetworkManager.SharedInstance.getRepRecData(searcInput: "\(String(describing: detail!.REQ_ID!))", success: { (res) in
            
            SVProgressHUD.dismiss()
            self.detail = res
            if (self.detail?.images_rep!.count)! > 0 {
                self.previewIamge.sd_setImage(with: URL(string: (self.detail?.images_rep![0])!), placeholderImage: UIImage(named: "placeholder.png"))
                
            }
        
            self.navigationTitile.text = self.detail!.details![0].MODEL_NAME
        self.titleProduct.text = self.detail!.details![0].MODEL_NAME
        self.lotPrice.text = Double(self.detail!.details![0].OFFER ?? "0")?.dollarString
            
        
        self.askingpriceLbl.isHidden = true
        self.products.append(self.detail!.details![0].MODEL_NAME!)
//            let inputFormatter = DateFormatter()
//            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//            let showDate = inputFormatter.date(from: self.detail!.created_at!)
//            inputFormatter.dateFormat = "yyyy-MM-dd"
//            let resultString = inputFormatter.string(from: showDate!)
//            print(resultString)
            
           
//            self.dateLbl.text = self.detail?.created_at
//            self.status.text = self.detail?.status
        self.remarks.text = self.detail!.details![0].REMARKS
            self.img = (self.detail?.images_rep!.count)!
            
//            for image in self.detail!.images! {
//                let img = UIImageView ()
//                img.sd_setImage(with: URL(string: image.url!), placeholderImage: nil)
//
//                self.images.append(img.image!)
//            }
        self.tableView.reloadData()
            self.collectionView.reloadData()
            
        }) { (err) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
        }
    }
    
    func fetchSingalProduct()  {
//            print("\(String(describing: detail!.id!))")
            print(id)
            SVProgressHUD.show(withStatus: "Loading...")
            NetworkManager.SharedInstance.getSingalRequest(request_id: id, success: { (res) in
                SVProgressHUD.dismiss()
                
                self.detail = res
                
                if self.detail?.status != "PROCESSED"{
                    self.acceptBtn.isHidden = true
                    self.messageBtn.isHidden = true
                    self.ShowCancelBtn.isHidden = true
                    self.ShowCancelBtn.isEnabled = false
                }
                
                if self.detail?.status == "APPROVED"{
                    self.descriptionLbl.text = "Congratualation , Item has been recieved at our store. Thank you"
                }
                
                if self.detail?.status == "CANCELLED"{
                    self.descriptionLbl.text = "You Canceled your item"
                }
                
                self.activeLbl.text = self.detail!.status
                self.requestStatusLbl.text = self.detail!.status
                if (self.detail?.images!.count)! > 0 {
                    self.previewIamge.sd_setImage(with: URL(string: (self.detail?.images![0].url)!), placeholderImage: UIImage(named: "placeholder.png"))
                    
                }
                self.navigationTitile.text = self.detail!.title
                self.titleProduct.text = self.detail?.title
                
                print(self.detail!.offered_price )
                print(self.detail!.asking_price )
                
                self.lotPrice.text = Double(self.detail!.offered_price ?? "0")?.dollarString
                self.askingpriceLbl.text = "Your asking Price was " + Double(self.detail!.asking_price ?? "0")!.dollarString
                
                
    //            let inputFormatter = DateFormatter()
    //            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    //            let showDate = inputFormatter.date(from: self.detail!.created_at!)
    //            inputFormatter.dateFormat = "yyyy-MM-dd"
    //            let resultString = inputFormatter.string(from: showDate!)
    //            print(resultString)
                
               
    //            self.dateLbl.text = self.detail?.created_at
    //            self.status.text = self.detail?.status
                self.remarks.text = self.detail?.remarks
                self.img = (self.detail?.images!.count)!
                self.products = self.detail!.products!
                
    //            for image in self.detail!.images! {
    //                let img = UIImageView ()
    //                img.sd_setImage(with: URL(string: image.url!), placeholderImage: nil)
    //
    //                self.images.append(img.image!)
    //            }
                self.tableView.reloadData()
                self.collectionView.reloadData()
                
            }) { (err) in
                SVProgressHUD.dismiss()
                Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
            }
        }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return img
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCollectionViewCell", for: indexPath) as! ProductImageCollectionViewCell
        
        

    //            if self.images.count > 0 {
    //               cell.productImage.image = self.images[indexPath.row]
    //            }else{
//            cell.productImage.sd_setImage(with: URL(string: (self.detail?.images![indexPath.row].url)!), placeholderImage: UIImage(named: "placeholder.png"))
        
        if self.type == "rep"{
            cell.productImage.sd_setImage(with: URL(string: (self.detail?.images_rep![indexPath.row])!), placeholderImage: UIImage(named: "placeholder.png"))
        }else{
            cell.productImage.sd_setImage(with: URL(string: (self.detail?.images![indexPath.row].url)!), placeholderImage: UIImage(named: "placeholder.png"))

        }
        

    //            }
    //        cell.productImage.image = self.images[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.type == "rep"{
            self.previewIamge.sd_setImage(with:  URL(string: (self.detail?.images_rep![indexPath.row])!), placeholderImage: UIImage(named: "placeholder.png"))
        }else{
            self.previewIamge.sd_setImage(with: URL(string: (self.detail?.images![indexPath.row].url)!), placeholderImage: UIImage(named: "placeholder.png"))
        }
    }

    func cancleRequest(requestid : String , offerid : String)  {
        NetworkManager.SharedInstance.CancleOffer(requestId: requestid, offerid: offerid, success: { (res) in
            print(res)

//            self.offersArray.remove(at:  self.index)
//            if self.offersArray.count == 0 {
                self.navigationController?.popViewController(animated: true)
//            }
//            self.tableView.reloadData()
        }) { (err) in
            Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let offer = self.offersArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OffertableViewCell", for: indexPath) as! OffertableViewCell
        //cell.textLabel?.text = self.products[indexPath.row]
        
        cell.productName.text = self.products[indexPath.row]
        cell.selectionStyle = .none
        return cell
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell", for: indexPath) as! AddressTableViewCell
//
//        cell.priceLbl.text = Double(offer.price!)?.dollarString
//        cell.numberLbl.text = offer.title
//
//        if offer.images![0].url!.first == "/" {
//            print("http://71.78.236.22/laptop-zone-stage/public/storage" + offer.images![0].url!)
//            cell.productImage.sd_setImage(with: URL(string: "http://71.78.236.22/laptop-zone-stage/public/storage" + offer.images![0].url!), placeholderImage: UIImage(named: "placeholder.png"))
//        }else{
//            cell.productImage.sd_setImage(with: URL(string: offer.images![0].url!), placeholderImage: UIImage(named: "placeholder.png"))
//        }
//
//        cell.rejectBtn.tag = indexPath.row
//        cell.chatBtn.tag = indexPath.row
        
//        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
//            let alert = UIAlertController(title: "!!!!", message: "Are you sure", preferredStyle: .alert)
//
//            var reason = ""
//
//            alert.addTextField {  (textField : UITextField!) -> Void  in
//                //             searchTextField?.delegate = self
//                reason = textField.text!
//
//            }
//            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
//                self.cancleRequest(requestid: self.id, offerid: "\(String(describing: self.offersArray[indexPath.row].id))")
//            }))
//
//            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
//
//            }))
//            self.present(alert, animated: true, completion: nil)
//
//        })
//
//        return [deleteAction]
//    }
    
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
    
    
//    @IBAction func continuebtn(_ sender: Any) {
//
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
    
    
    func hideLAble() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideLAbleAction))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func hideLAbleAction() {
//        view.endEditing(true)
        self.requestCancelBtn.isHidden = true
    }
    
    @IBAction func chat(_ sender: AnyObject) {
        
        if #available(iOS 13.0, *) {
            let main = self.storyboard?.instantiateViewController(identifier: "ChatViewController") as! ChatViewController
            if self.conversation_id == ""{
                main.type = "createConversation"
//                print("\(String(describing: self.offersArray[sender.tag].request_id!))")
                
//                self.detail?.id
//                print("\(String(describing: self.detail?.id!))")
                main.createConversationId = "\(String(describing: self.detail!.id!))"
            }else{
                
                
                main.id = self.conversation_id
            }
            main.gottoCamera = "go"
//            print(self.offersArray[sender.tag].conversation_id)
            
            
            self.navigationController?.pushViewController(main, animated: true)
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    @IBAction func approve(_ sender: Any) {
        
        if self.type == "rep"{
            
            
            let main = self.storyboard?.instantiateViewController(withIdentifier: "SelectdeliveryMethodViewController") as! SelectdeliveryMethodViewController
            main.repRecId = "\(String(describing: self.detail!.details![0].REQ_ID!))"
            main.type = "rec"
            self.navigationController?.pushViewController(main, animated: true)

            
        }else{
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
            
            let cancle = UIAlertAction(title: "Cancel", style: .cancel) { (ale) in
                
            }
            
            if let popoverController = alert.popoverPresentationController {
                                      popoverController.sourceView = self.view
                                      popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                                      popoverController.permittedArrowDirections = []
                                    }
            
            alert.addAction(pickup)
            alert.addAction(dropOff)
            alert.addAction(Shipment)
            alert.addAction(cancle)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    

    
    
    @IBAction func reject(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "!!!!", message: "Are you sure", preferredStyle: .alert)
        
        var reason = ""
        
        alert.addTextField {  (textField : UITextField!) -> Void  in
            //             searchTextField?.delegate = self
            reason = textField.text!
            
        }
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.cancleRequest(requestid: self.id, offerid: "\(String(describing: self.offersArray[sender.tag].id!))")
            self.index = sender.tag
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func requestCancelBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "!!!!", message: "Are you sure", preferredStyle: .alert)
        
        var reason = ""
        
        alert.addTextField {  (textField : UITextField!) -> Void  in
            //             searchTextField?.delegate = self
            reason = textField.text!
            
        }
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.cancleRequest(requestid: self.id, offerid: "")
            
//            self.index = sender.tag
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func showCancelBtn(_ sender: Any) {
        
        self.requestCancelBtn.isHidden = false
       
    }
    
}
