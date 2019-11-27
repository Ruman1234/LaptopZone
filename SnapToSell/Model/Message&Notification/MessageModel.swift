
//
//  File.swift
//  SnapToSell
//
//  Created by Apple on 10/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//



import Foundation
import ObjectMapper

class MessageModel : NSObject,Mappable {
    
    var conversation_id : String?
    var cover : String?
    var created_at : String?
    var delivered_as : String?
    var unread_messages : Int?
    
    var id : Int?
    var price : Int?
    var remarks : String?
    
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
    var last_message : last_message?
 
    
    
    required init?(map: Map) {

    }
   
    override init() {
        
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
        last_message <- map["last_message"]

     
         
    }
    

}


class last_message :NSObject, Mappable {
   
    
    var content : String?
    var conversation_id : Int?
    var created_at : String?
    
    var id : Int?
    var status : Int?
    var type : String?
    var updated_at : String?
    var user_id : Int?
    
   required init?(map: Map) {

   }
   override init() {
       
   }

   func mapping(map: Map) {

        content <- map["content"]
        conversation_id <- map["conversation_id"]

        created_at <- map["created_at"]
        id <- map["id"]
        status <- map["status"]
        type <- map["type"]
        updated_at <- map["updated_at"]
        user_id <- map["user_id"]
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
    
    var SELECT_OPTION : String?
    var TRACK_NUMB : String?
    var TYPE : String?
    var url : String?
    var ADDRESS : String?
    var CARIER_NAME : String?

    required init?(map: Map) {

    }
    init() {
      
    }

    func mapping(map: Map) {

        ADDRESS <- map["ADDRESS"]
        CARIER_NAME <- map["CARIER_NAME"]
        SELECT_OPTION <- map["SELECT_OPTION"]
        TRACK_NUMB <- map["TRACK_NUMB"]
        TYPE <- map["TYPE"]
        url <- map["URL"]
        
        REQ_ID <- map["REQ_ID"]
        DATA_SOURCE <- map["DATA_SOURCE"]
        MODEL_NAME <- map["MODEL_NAME"]
        OFFER <- map["OFFER"]
        STATUS <- map["STATUS"]
        REMARKS <- map["REMARKS"]
    }
}

