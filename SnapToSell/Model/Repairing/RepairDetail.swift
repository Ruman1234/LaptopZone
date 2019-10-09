//
//  RepairDetail.swift
//  SnapToSell
//
//  Created by Apple on 9/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//


import Foundation
import ObjectMapper

struct RepairModel : Mappable {
    var ljw_getobject : [Ljw_getobject]?
    var ljw_Series : [Ljw_Series]?
    var ljw_Model : [Ljw_Model]?
    var ljw_Issues : [Ljw_Issues]?
    var exist : Bool?
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        ljw_getobject <- map["ljw_getobject"]
        ljw_Series <- map["ljw_Series"]
        ljw_Model <- map["ljw_Model"]
        ljw_Issues <- map["ljw_Issues"]
        exist <- map["exist"]
    }
    
}


class Ljw_getobject : Mappable {
    var bRAND_DT_ID : String?
    var bRAND_URL : String?
    var bRAND_NAME : String?
    var pRODUCT : String?
    var image : String?
    
    init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        bRAND_DT_ID <- map["BRAND_DT_ID"]
        bRAND_URL <- map["BRAND_URL"]
        bRAND_NAME <- map["BRAND_NAME"]
        pRODUCT <- map["PRODUCT"]
        image <- map["BRAND_URL_FULL"]
        
    }
    
}




struct Ljw_Series : Mappable {
    var sERIES_DT_ID : String?
    var sERIES_NAME : String?
    var bRAND_DT_ID : String?
    var bRAND_NAME : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        sERIES_DT_ID <- map["SERIES_DT_ID"]
        sERIES_NAME <- map["SERIES_NAME"]
        bRAND_DT_ID <- map["BRAND_DT_ID"]
        bRAND_NAME <- map["BRAND_NAME"]
    }
    
}




struct Ljw_Model : Mappable {
    var mODEL_DT_ID : String?
    var dESCRIPTION : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        mODEL_DT_ID <- map["MODEL_DT_ID"]
        dESCRIPTION <- map["DESCRIPTION"]
    }
    
}




struct Ljw_Issues : Mappable {
    var iSSUE_DT_ID : String?
    var iSSU_NAME : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        iSSUE_DT_ID <- map["ISSUE_DT_ID"]
        iSSU_NAME <- map["ISSU_NAME"]
    }
    
}
