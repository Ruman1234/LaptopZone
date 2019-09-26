//
//  OffersModel.swift
//  SnapToSell
//
//  Created by Apple on 8/29/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

import ObjectMapper

class OffersModel : Mappable {
    var id : Int?
    var request_id : Int?
    var title : String?
    var price : String?
    var remarks : String?
    var upc : String?
    var mpn : String?
    var brand : String?
    var cond : String?
    var created_at : String?
    var updated_at : String?
    var images : [Images]?
    
    init?() {
        
    }
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        
        id <- map["id"]
        request_id <- map["request_id"]
        title <- map["title"]
        price <- map["price"]
        remarks <- map["remarks"]
        upc <- map["upc"]
        mpn <- map["mpn"]
        brand <- map["brand"]
        cond <- map["cond"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        images <- map["images"]
    }
    
}
