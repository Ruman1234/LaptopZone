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
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        rates <- map["rates"]
        message <- map["message"]
    }
    
}


struct Rates : Mappable {
    var carrier : String?
    var service : String?
    var rate : String?
    var id : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        carrier <- map["carrier"]
        service <- map["service"]
        rate <- map["rate"]
        id <- map["id"]
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


