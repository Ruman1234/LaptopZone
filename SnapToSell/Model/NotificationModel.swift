//
//  File.swift
//  LaptopZone
//
//  Created by Apple on 11/26/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import ObjectMapper


class notificationModel: Mappable {
    
    
    var id :String?
    var type :String?
    var notifiable_type :String?
    var notifiable_id :String?
    var read_at :String?
    var created_at :String?
    var updated_at :String?
    var data :notificationData?
    
    init() {
        
    }
    required init?(map: Map) {
           
    }
       
    func mapping(map: Map) {
        id <- map["id"]
        type <- map["type"]
        notifiable_type <- map["notifiable_type"]
        notifiable_id <- map["notifiable_id"]
        read_at <- map["read_at"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        data <- map["data"]
    }
    
}


class notificationData: Mappable {
   
    
    var category :String?
    var request_id :String?
    var request_title :String?
    
    var title :String?
    var body :String?
   
    init() {
       
    }
    required init?(map: Map) {
          
    }
      
    func mapping(map: Map) {
       category <- map["category"]
       request_id <- map["request_id"]
       request_title <- map["request_title"]
        title <- map["title"]
        body <- map["body"]
      
    }
}
