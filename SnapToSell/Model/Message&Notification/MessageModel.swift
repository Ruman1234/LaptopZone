
//
//  File.swift
//  SnapToSell
//
//  Created by Apple on 10/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//



import Foundation
import ObjectMapper

class MessageModel : Mappable {
    
    
    
    var conversation_id : String?
    var cover : String?
    var created_at : String?
    var delivered_as : String?
    var unread_messages : Int?
    
    var id : Int?
    var price : Int?
    var remarks : String?
// shipment
    var status : String?
    var title : String?
    
   
    var user_id : String?
    var user_role : String?
    var type : String?
    
    var timestamp : String?
    var content : String?
    
    var repairCount : String?
    var rec_count : String?
    var sellCount : String?
    
 
    
    
    required init?(map: Map) {

    }
    init() {
        
    }

    func mapping(map: Map) {

        repairCount <- map["rep_count"]
        rec_count <- map["rec_count"]
        sellCount <- map["sell_count"]
        
        conversation_id <- map["conversation_id"]
        cover <- map["cover"]
        created_at <- map["created_at"]
        delivered_as <- map["delivered_as"]
        id <- map["id"]
        price <- map["price"]
        remarks <- map["remarks"]
        unread_messages <- map["unread_messages"]
        
        status <- map["status"]
        title <- map["title"]
        
        user_id <- map["user_id"]
        user_role <- map["user_role"]
        type <- map["type"]
        timestamp <- map["timestamp"]
        content <- map["content"]

     
         
    }
    

}

extension MessageModel {
    /// converts the startDate to an actual date type which will be used for comparison
    var convertedStartDate: Date {
        return dateFormatter.date(from: timestamp!) ?? Date() // if server data has something in start_date that can't be converted to any date, assume that refers to current date. Or you can have your own logic here
    }
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }
}


class details : Mappable {
    
    
    var REQ_ID : String?
    var DATA_SOURCE : String?
    var MODEL_NAME : String?

    var OFFER : String?
    var STATUS : String?
    var REMARKS : String?

    required init?(map: Map) {

    }
    init() {
      
    }

    func mapping(map: Map) {

        REQ_ID <- map["REQ_ID"]
        DATA_SOURCE <- map["DATA_SOURCE"]
        MODEL_NAME <- map["MODEL_NAME"]
        OFFER <- map["OFFER"]
        STATUS <- map["STATUS"]
        REMARKS <- map["REMARKS"]
    }
}

