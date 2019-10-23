//
//  Buy&Sell.swift
//  SnapToSell
//
//  Created by Apple on 10/14/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import ObjectMapper


struct Buy_Sell : Mappable {
    
    var Products : [Buy_SellModel]?
    var series : [Buy_SellModel]?
    var model : [Buy_SellModel]?
    var carier : [Buy_SellModel]?
    
    var storage : [Buy_SellModel]?
   
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        Products <- map["ljw_getobject"]
        series <- map["ljw_Series"]
        model <- map["ljw_Model"]
        carier <- map["ljw_Carrier"]
        storage <- map["ljw_Storage"]
        
     
    }
    
}


struct Buy_SellModel : Mappable {
    
    var BRAND_DT_ID : String?
    var BRAND_URL : String?
    var BRAND_NAME : String?
    var PRODUCT : String?
    var BRAND_URL_FULL : String?
    
    var SERIES_DT_ID : String?
    var SERIES_NAME : String?
    
    var MODEL_DT_ID : String?
    var DESCRIPTION : String?
  
    var LZW_CARRIER_DT_ID : String?
    var CARRIER_NAME : String?
    
    var SALE_PRICE : String?
    var LZW_STORAGE_DT_ID : String?
    var STORAGE_DESC : String?
    
  
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        BRAND_DT_ID <- map["BRAND_DT_ID"]
        BRAND_URL <- map["BRAND_URL"]
        BRAND_NAME <- map["BRAND_NAME"]
        PRODUCT <- map["PRODUCT"]
        BRAND_URL_FULL <- map["BRAND_URL_FULL"]
        SERIES_DT_ID <- map["SERIES_DT_ID"]
        SERIES_NAME <- map["SERIES_NAME"]
        MODEL_DT_ID <- map["MODEL_DT_ID"]
        DESCRIPTION <- map["DESCRIPTION"]

        LZW_CARRIER_DT_ID <- map["LZW_CARRIER_DT_ID"]
        CARRIER_NAME <- map["CARRIER_NAME"]
        
        SALE_PRICE <- map["SALE_PRICE"]
        LZW_STORAGE_DT_ID <- map["LZW_STORAGE_DT_ID"]
        STORAGE_DESC <- map["STORAGE_DESC"]
        

        
        
    }
    
}





struct Buy_Sell_Questions : Mappable {
    
    var ID : String?
    var DESCRIPTION : String?
    var answers : [answers]?
   
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        ID <- map["ID"]
        answers <- map["answers"]
        DESCRIPTION <- map["DESCRIPTION"]
        
    }
    
}


struct answers : Mappable {
    
    var ID : String?
    var DESCRIPTION : String?
    var EFFECTIVE_VALUE : String?
    var IS_DEFAULT : String?
   
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        ID <- map["ID"]
        DESCRIPTION <- map["DESCRIPTION"]
        EFFECTIVE_VALUE <- map["EFFECTIVE_VALUE"]
        IS_DEFAULT <- map["IS_DEFAULT"]
        
    }
    
}


struct Buy_Sell_Questions1 : Mappable {
    
    var QuestionsArray : [QuestionsModel]?
    var AnswerArray : [QuestionsModel]?
   
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        QuestionsArray <- map["lzw_questions_mt"]
        AnswerArray <- map["lzw_questions_ans"]
        
    }
    
}


struct QuestionsModel : Mappable {
    
    var QUESTION_DESCRIPTION : String?
    var QUESTIONS_MT_ID : String?
    var OBJECT_ID : String?
    var TOT_ANS : String?
    
    
    var ANSWERS_ID : String?
    var VALUE_DESC : String?
    var EFFECTIVE_VALUE : String?
    var DEFAULT_VAL : String?
    
  
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        QUESTION_DESCRIPTION <- map["QUESTION_DESCRIPTION"]
        QUESTIONS_MT_ID <- map["QUESTIONS_MT_ID"]
        OBJECT_ID <- map["OBJECT_ID"]
        TOT_ANS <- map["TOT_ANS"]
        
        ANSWERS_ID <- map["ANSWERS_ID"]
        VALUE_DESC <- map["VALUE_DESC"]
        EFFECTIVE_VALUE <- map["EFFECTIVE_VALUE"]
        DEFAULT_VAL <- map["DEFAULT_VAL"]
    }
    
}
