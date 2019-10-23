//
//  ShipmentRatesModel.swift
//  SnapToSell
//
//  Created by Apple on 8/30/19.
//  Copyright © 2019 Apple. All rights reserved.
//


import Foundation
import ObjectMapper

struct ShipmentRates : Mappable {
    var id : String?
    var message : String?
    var rates : [Rates]?
    
    var label_remote_url : String?
    
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        rates <- map["rates"]
        message <- map["message"]
        label_remote_url <- map["label_remote_url"]
    }
    
}


struct Rates : Mappable {
    var id : String?
    var shipment_id : String?
    var carrier : String?
    var service : String?
    var rate : String?
    var currency : String?
    
    
    
   
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        shipment_id <- map["shipment_id"]
        carrier <- map["carrier"]
        service <- map["service"]
        rate <- map["rate"]
        currency <- map["currency"]
        
    }
    
}



struct NewRequest : Mappable {
    var title : String?
    var price : String?
    var user_id : Int?
    var id : Int?
    var message : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        title <- map["title"]
        price <- map["price"]
        user_id <- map["user_id"]
        id <- map["id"]
        message <- map["message"]
    }
    
}


