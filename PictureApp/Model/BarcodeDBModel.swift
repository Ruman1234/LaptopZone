//
//  BarcodeDBModel.swift
//  PictureApp
//
//  Created by Apple on 7/4/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation


public class BarcodeDBModel : NSObject ,NSCoding {
    
    var barcode:[String]
    var bin_name:String
    var cond_id:String
    var cond_remarks:String
    var condition:String
    var folderBarcode:String
    var folderName:String
    var lot_id:String
    var mpn:String
    var pic_DateTime:String
    var pic_taker_id:String
    var remarks:String
    var sync_status:String
    var upc:String
    var imageData: [Data]
    
    required public init?(coder aDecoder: NSCoder) {
        barcode = aDecoder.decodeObject(forKey: "barcode") as! [String]
        bin_name = aDecoder.decodeObject(forKey: "bin_name") as! String
        cond_id = aDecoder.decodeObject(forKey: "cond_id") as! String
        cond_remarks = aDecoder.decodeObject(forKey: "cond_remarks") as! String
        condition = aDecoder.decodeObject(forKey: "condition") as! String
        folderBarcode = aDecoder.decodeObject(forKey: "folderBarcode") as! String
        folderName = aDecoder.decodeObject(forKey: "folderName") as! String
        lot_id = aDecoder.decodeObject(forKey: "lot_id") as! String
        mpn = aDecoder.decodeObject(forKey: "mpn") as! String
        pic_DateTime = aDecoder.decodeObject(forKey: "pic_DateTime") as! String
        pic_taker_id = aDecoder.decodeObject(forKey: "pic_taker_id") as! String
        remarks = aDecoder.decodeObject(forKey: "remarks") as! String
        sync_status = aDecoder.decodeObject(forKey: "sync_status") as! String
        upc = aDecoder.decodeObject(forKey: "upc") as! String
        imageData = aDecoder.decodeObject(forKey: "imageData") as! [Data]
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(barcode, forKey: "barcode")
        aCoder.encode(bin_name, forKey: "bin_name")
        aCoder.encode(cond_id, forKey: "cond_id")
        aCoder.encode(cond_remarks, forKey: "cond_remarks")
        aCoder.encode(condition, forKey: "condition")
        aCoder.encode(folderBarcode, forKey: "folderBarcode")
        aCoder.encode(folderName, forKey: "folderName")
        aCoder.encode(lot_id, forKey: "lot_id")
        aCoder.encode(mpn, forKey: "mpn")
        aCoder.encode(pic_DateTime, forKey: "pic_DateTime")
        aCoder.encode(pic_taker_id, forKey: "pic_taker_id")
        aCoder.encode(remarks, forKey: "remarks")
        aCoder.encode(sync_status, forKey: "sync_status")
        aCoder.encode(upc, forKey: "upc")
        aCoder.encode(imageData, forKey: "imageData")

    }
    
    
    init(barcode:[String],
         bin_name:String,
         cond_id:String,
         cond_remarks:String,
         condition:String,
         folderBarcode:String,
         folderName:String,
         lot_id:String,
         mpn:String,
         pic_DateTime:String,
         pic_taker_id:String,
         remarks:String,
         sync_status:String,
         upc:String,
         imageData: [Data]) {
        
        
        self.barcode = barcode
        self.bin_name = bin_name
        self.cond_id = cond_id
        self.cond_remarks = cond_remarks
        self.condition = condition
        self.folderBarcode = folderBarcode
        self.folderName = folderName
        self.lot_id = lot_id
        self.mpn = mpn
        self.pic_DateTime = pic_DateTime
        self.pic_taker_id = pic_taker_id
        self.remarks = remarks
        self.sync_status = sync_status
        self.upc = upc
        self.imageData = imageData
        
        
    }
    
    
}
