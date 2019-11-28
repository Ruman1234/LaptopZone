
//
//  HotItem.swift
//  LaptopZone
//
//  Created by Apple on 11/28/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import ObjectMapper


class HotItemModel: Mappable {
    
    
    var HOT_PRO_ID :String?
    var PRODUCT_ID :String?
    var BRAND_ID :String?
    var SERIES_ID :String?
    var MODEL_ID :String?
    var MODEL_LOGO :String?
    var CARRIER_ID :String?
    var OFFER_PRICE :String?
    var INSERTED_DATE :String?
    var INSERTED_BY :String?
    var ACTIVE_YN :String?
    var STORAGE_ID :String?
    
    init() {
        
    }
    required init?(map: Map) {
           
    }
       
    func mapping(map: Map) {
        
        HOT_PRO_ID <- map["HOT_PRO_ID"]
        PRODUCT_ID <- map["PRODUCT_ID"]
        BRAND_ID <- map["BRAND_ID"]
        SERIES_ID <- map["SERIES_ID"]
        MODEL_ID <- map["MODEL_ID"]
        MODEL_LOGO <- map["MODEL_LOGO"]
        CARRIER_ID <- map["CARRIER_ID"]
        OFFER_PRICE <- map["OFFER_PRICE"]
        INSERTED_DATE <- map["INSERTED_DATE"]
        INSERTED_BY <- map["INSERTED_BY"]
        ACTIVE_YN <- map["ACTIVE_YN"]
        STORAGE_ID <- map["STORAGE_ID"]
        
    }
}
