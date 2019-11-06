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

class ApprovedProductDetailViewController: UIViewController,UITableViewDelegate , UITableViewDataSource , UICollectionViewDelegate , UICollectionViewDataSource ,AddDropOffViewDelegate{
   
    

    
//    @IBOutlet weak var titleProduct: UILabel!
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var img: UIImageView!
//    @IBOutlet weak var lotPrice: UILabel!
//    @IBOutlet weak var dateLbl: UILabel!
//    @IBOutlet weak var status: UILabel!
//    @IBOutlet weak var remarks: UILabel!
    
    
    
    
      
      @IBOutlet weak var tableView: UITableView!
      
      @IBOutlet weak var previewIamge: UIImageView!

      @IBOutlet weak var collectionView: UICollectionView!

      @IBOutlet weak var titleProduct: UILabel!

      @IBOutlet weak var lotPrice: UILabel!
      @IBOutlet weak var dateLbl: UILabel!
      @IBOutlet weak var status: UILabel!
      @IBOutlet weak var remarks: UILabel!

      @IBOutlet var cameraButton: UIBarButtonItem!

      @IBOutlet weak var sendBtn: UIButton!
      @IBOutlet weak var activeLbl: UILabel!
    @IBOutlet weak var navigationTitile: UILabel!
    
    
    @IBOutlet weak var deliveredAsLbl: UILabel!
    
    @IBOutlet weak var address_trackingNumber: UILabel!
    
    @IBOutlet weak var dropOffDetailHeight: NSLayoutConstraint!
    
    @IBOutlet weak var download_addTrackingBtn: UIImageView!
    
    @IBOutlet weak var download_addtracking: UIButton!
    
    @IBOutlet weak var carierForDropOff: UILabel!
    
    @IBOutlet weak var trackingNumberForDropOff: UILabel!
    
    var detail = RequestStatusModel()
    var offersArray = [OffersModel]()
    
    
    var img = Int()
    var products = [String]()
    var slipImage = UIImage()
//    var addDropOffView : AddDropOffView!
    var addotherView : AddDropOffView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBG()
//        getBarcode()
         self.activeLbl.layer.cornerRadius = 13
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        
        self.titleProduct.text = self.detail?.title
//        self.lotPrice.text = Double(self.detail!.asking_price ?? "0")?.dollarString
//        self.dateLbl.text = self.detail?.created_at
//        self.status.text = self.detail?.status
//        self.remarks.text = self.detail?.remarks
//        offers(id: "\(detail!.id!)")
        self.backBtn()
        fetchSingalProduct()
        // Do any additional setup after loading the view.
    }
    
    
    func getBarcode()  {
        
        SVProgressHUD.show(withStatus: "Loading...")
        Alamofire.request(URL(string: "http://talkerscode.com/webtricks/demo/js/barcode/barcode.php?codetype=Code39&size=40&text=\(self.detail!.id!)&print=true")!)        .responseData { (data) in
            SVProgressHUD.dismiss()
            self.showToast(message: "Slip Downloaded")
            
            
            if let data1 = data.data {
                let img = UIImage(data: data1)

                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (time) in
                    if img != nil {

                    UIImageWriteToSavedPhotosAlbum(img!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)

                    }
                }
            }
            
//            let data = data
            
//            let img = UIImage(data: data.data!)
//            self.slipImage = img!
//            self.img.image = img!
//            self.images.append(img!)
//            self.collectionView.reloadData()
        }
        
    }
    
    
//    func offers(id :String) {
//        SVProgressHUD.show(withStatus: "Loading...")
//        NetworkManager.SharedInstance.Offers(id: id, success: { (res) in
//            print(res)
//            SVProgressHUD.dismiss()
//            self.offersArray = res
//            self.tableView.reloadData()
//        }) { (err) in
//            Utilites.ShowAlert(title: "Error!!", message: "Something went wrond", view: self)
//        }
//    }
    
    func fetchSingalProduct()  {
    //            print("\(String(describing: detail!.id!))")
        print("\(detail!.id!)")
        SVProgressHUD.show(withStatus: "Loading...")
        NetworkManager.SharedInstance.getSingalRequest(request_id: "\(detail!.id!)", success: { (res) in
            SVProgressHUD.dismiss()
            
            self.detail = res
            if (self.detail?.images!.count)! > 0 {
                self.previewIamge.sd_setImage(with: URL(string: (self.detail?.images![0].url)!), placeholderImage: UIImage(named: "placeholder.png"))
                
            }
            
            self.navigationTitile.text = self.detail!.title

            self.titleProduct.text = self.detail?.title
            
            print(self.detail!.offered_price )
            print(self.detail!.asking_price )
            self.lotPrice.text = Double(self.detail!.offered_price ?? "0")?.dollarString
            
            
            
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
            
            
            if self.detail!.delivered_as == "PICKUP"{
                
                self.deliveredAsLbl.text = "Pickup - Your Address"
//                self.address_trackingNumber.text = self.detail!.pickup?.street + self.detail!.pickup?.city + self.detail!.pickup?.state + self.detail!.pickup?.zip + "United State"
                self.address_trackingNumber.text = "\(String(describing: self.detail!.pickup!.street!)), \(String(describing: self.detail!.pickup!.city!)), \(String(describing: self.detail!.pickup!.state!)), \(String(describing: self.detail!.pickup!.zip!)), United State."
                
                self.download_addTrackingBtn.isHidden = true
                self.download_addtracking.isEnabled = false
                
            }else if self.detail!.delivered_as == "DROP_OFF"{
                
                
                self.deliveredAsLbl.text = "DropOff - LaptopZone Address"
                self.address_trackingNumber.text = "2720 Royal Lane Ste #180 Dallas, TX 75229 Phone: (214) 427-4496"
//                print(self.detail!.drop_off?.carrier_name!)
                if self.detail!.drop_off?.carrier_name != nil {
                    self.trackingNumberForDropOff.isHidden = false
                    self.carierForDropOff.isHidden = false
                    
//                    self.trackingNumberForDropOff.text
                    self.trackingNumberForDropOff.text = self.detail!.drop_off!.tracking_code!
                    self.carierForDropOff.text = "Carrier: " + self.detail!.drop_off!.carrier_name!

                    self.download_addTrackingBtn.image = nil
                    self.download_addtracking.isHidden = true
                    
                }else{
                    self.dropOffDetailHeight.constant = 61.5
                     self.download_addTrackingBtn.image = UIImage(named: "Add Tracking Info")
                }
                
            }else if self.detail!.delivered_as == "SHIPMENT"{
                self.download_addTrackingBtn.image = UIImage(named: "Download Shipment Label")
                self.deliveredAsLbl.text = "Shipment - Tracking Info"
                self.address_trackingNumber.text = self.detail!.shipment!.tracking_code
                
            }
            
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
            cell.productImage.sd_setImage(with: URL(string: (self.detail?.images![indexPath.row].url)!), placeholderImage: UIImage(named: "placeholder.png"))

    //            }
    //        cell.productImage.image = self.images[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.previewIamge.sd_setImage(with: URL(string: (self.detail?.images![indexPath.row].url)!), placeholderImage: UIImage(named: "placeholder.png"))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.products.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
    //        let offer = self.offersArray[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "OffertableViewCell", for: indexPath) as! OffertableViewCell
            
            cell.productName.text = self.products[indexPath.row]
        cell.selectionStyle = .none
            return cell
    }
    
    
    @IBAction func addTracking_downloadSlip(_ sender: Any) {
        
        if self.detail!.delivered_as == "SHIPMENT"{
            SVProgressHUD.show(withStatus: "Loading...")
            Alamofire.request(self.detail!.shipment!.label_remote_url!).responseData { (response) in
                SVProgressHUD.dismiss()
              if response.error == nil {
                    print(response.result)

                
                    if let data = response.data {
                        let img = UIImage(data: data)

                        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (time) in
                            if img != nil {

                            UIImageWriteToSavedPhotosAlbum(img!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)

                            }
                        }
                    }
                }
            }

            
        }else if self.detail!.delivered_as == "DROP_OFF"{
         
            addView()
               
        }
        
    }

       
        @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if error != nil {
                   // we got back an error!
    //               let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
    //               ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.showToast(message: "Save error")
    //            delegate?.didCloseImgView()
    //               present(ac, animated: true)
               } else {
    //               let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
    //               ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.showToast(message: "Save Successfully")
//                delegate?.didCloseImgView()
    //            self.showToast(message: "Saved!")
                
    //               present(ac, animated: true)
               }
           }
    
  
    func didClose(trackingNumber: String, carierName: String)  {
     
     if trackingNumber != "" || carierName != "" {
//           self.otherBtn.setTitle(text, for: .normal)
           self.addotherView.removeFromSuperview()
                   
           UIView.animate(withDuration: 0.3) {

               self.addotherView.alpha = 0
               self.addotherView = nil
           }

        self.trackingNumberForDropOff.isHidden = false
        self.carierForDropOff.isHidden = false
//        self.address_trackingNumber.isHidden = false
        
        self.download_addTrackingBtn.isHidden = true
        self.download_addtracking.isEnabled = false
        
        self.dropOffDetailHeight.constant = 0
        self.download_addTrackingBtn.image = nil
        
        
//        self.trackingNumberForDropOff.text = text
        self.trackingNumberForDropOff.text = trackingNumber
        self.carierForDropOff.text = "Carrier: " + carierName
        
        SVProgressHUD.show(withStatus: "Loading...")
        NetworkManager.SharedInstance.UpdateDropOff(request_id:"\(self.detail!.id!)" , tracking_id: trackingNumber, carrier_name: carierName, success: { (res) in
            SVProgressHUD.dismiss()
            print(res)
        }) { (err) in
            SVProgressHUD.dismiss()
            Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
        }
        
//           Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (time) in
//
//     //        print("asdfadf")
//             let main = self.storyboard?.instantiateViewController(withIdentifier: "ModelViewController") as! ModelViewController
//             Constants.seriesId = self.otherBtn.titleLabel!.text!
//     //        main.id = self.itemsArray[indexPath.row].sERIES_DT_ID!
//     //        Constants.seriesId = self.itemsArray[indexPath.row].sERIES_DT_ID!
//             self.navigationController?.pushViewController(main, animated: true)
//
//           }
     }else{
        self.showToast(message: "All fields are required")
        }
        
    }
        
     
     func didClose() {
            self.addotherView.removeFromSuperview()
                    
            UIView.animate(withDuration: 0.3) {

                self.addotherView.alpha = 0
                self.addotherView = nil
            }
        }
        
        
    func addView()  {
        if self.addotherView == nil {
            self.addotherView = nil
            self.addotherView = (Bundle.main.loadNibNamed("AddDropOffView", owner: self, options: nil)![0] as!  AddDropOffView)

            self.addotherView.delegate = self
//            self.addotherView.titleName = "Enter Series Name"
//            self.addotherView.nameLbl.text = "Enter Tracking number"
            self.addotherView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                   
            self.view.addSubview(addotherView)
            UIView.animate(withDuration: 0.3) {

               self.addotherView.alpha = 1
            }
        }
    }
        
    
    
    @IBAction func downloadSlip(_ sender: Any) {
        getBarcode()
    }
    
    

}
