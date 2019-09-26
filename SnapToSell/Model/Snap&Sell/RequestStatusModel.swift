
import Foundation
import ObjectMapper

class RequestStatusModel : Mappable {
	var id : Int?
	var user_id : Int?
	var title : String?
	var price : String?
	var remarks : String?
	var status : String?
	var delivered_as : String?
	var created_at : String?
	var updated_at : String?
    var cover : String?
	var images : [Images]?

	init?() {

	}
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {

		id <- map["id"]
		user_id <- map["user_id"]
		title <- map["title"]
		price <- map["price"]
		remarks <- map["remarks"]
		status <- map["status"]
		delivered_as <- map["delivered_as"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
		images <- map["images"]
        cover <- map["cover"]
	}

}
