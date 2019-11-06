//
//  ProfileModel.swift
//  SnapToSell
//
//  Created by Apple on 9/16/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

import ObjectMapper



struct ProfileModel : Mappable {
    var id : Int?
    var name : String?
    var avatar : String?
    var email : String?
    var paypal : String?
    var email_verified : String?
    var email_verified_at : String?
    var role : String?
    var created_at : Int?
    var updated_at : String?
    var requests_count : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        avatar <- map["avatar"]
        email <- map["email"]
        paypal <- map["paypal"]
        email_verified <- map["email_verified"]
        email_verified_at <- map["email_verified_at"]
        role <- map["role"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        requests_count <- map["requests_count"]
    }
    
}
