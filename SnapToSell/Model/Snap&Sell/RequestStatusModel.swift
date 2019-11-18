
import Foundation
import ObjectMapper

class RequestStatusModel : Mappable {
	var id : Int?
    var conversation_id : Int?
	var user_id : Int?
	var title : String?
	var asking_price : String?
	var remarks : String?
	var status : String?
	var delivered_as : String?
	var created_at : String?
	var updated_at : String?
    var cover : String?
    var offered_price : String?
	var images : [Images]?

    
//    var delivered_as : String?
    var products : [String]?
    var shipment : Shipment?
    var pickup : Pickup?
    var drop_off : DropOff?
    
    
    var REQ_ID : String?
    var DATA_SOURCE : String?
    var MODEL_NAME : String?
    var OFFER : String?
    var STATUS : String?
    var IMAGE_URL_FULL : String?
    var SELECT_OPTION : String?
    
    
    
    var details : [details]?
    var images_rep : [String]?

    
	init?() {

	}
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {

		SELECT_OPTION <- map["SELECT_OPTION"]
        id <- map["id"]
        conversation_id <- map["conversation_id"]
		user_id <- map["user_id"]
		title <- map["title"]
		asking_price <- map["asking_price"]
		remarks <- map["remarks"]
		status <- map["status"]
		delivered_as <- map["delivered_as"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
		images <- map["images"]
        cover <- map["cover"]
        offered_price <- map["offered_price"]
        
        products <- map["products"]
        shipment <- map["shipment"]
        pickup <- map["pickup"]
        drop_off <- map["drop_off"]

        REQ_ID <- map["REQ_ID"]
        DATA_SOURCE <- map["DATA_SOURCE"]
        MODEL_NAME <- map["MODEL_NAME"]
        OFFER <- map["OFFER"]
        STATUS <- map["STATUS"]
        IMAGE_URL_FULL <- map["IMAGE_URL_FULL"]
        
        
        details <- map["details"]
        images_rep <- map["images"]
	}

}



class Shipment: Mappable {
    
    var shipment_id : String?
    var tracking_code : String?
    var label_name : String?
    var label_remote_url : String?
    
  
    
    init?() {

    }
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        shipment_id <- map["shipment_id"]
        tracking_code <- map["tracking_code"]
        label_name <- map["label_name"]
        label_remote_url <- map["label_remote_url"]
    }
}

class Pickup: Mappable {
   
    
    var contact_name : String?
    var apartment : String?
    var street : String?
    var city : String?
    var state : String?
    var zip : String?
    var phone : String?
  
    
    init?() {

    }
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        contact_name <- map["contact_name"]
        apartment <- map["apartment"]
        street <- map["street"]
        city <- map["city"]
        state <- map["state"]
        zip <- map["zip"]
        phone <- map["phone"]
    }
}



class DropOff: Mappable {
   
    var carrier_name : String?
    var tracking_code : String?
    
  
    
    init?() {

    }
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        carrier_name <- map["carrier_name"]
        tracking_code <- map["tracking_code"]
        
    }
}
