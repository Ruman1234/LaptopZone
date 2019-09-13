



import Foundation
import ObjectMapper

class AddressesModel : Mappable {
	var id : Int?
	var contact_name : String?
	var apartment : String?
	var street : String?
	var city : String?
	var state : String?
	var zip : String?
	var phone : String?
	var is_default : Bool?
	var pickup_service : Bool?
	var verification : String?
	var latitude : String?
	var longitude : String?
	var created_at : String?
	var updated_at : String?

    required init?(map: Map) {

	}

    init() {
        
    }
    
    func mapping(map: Map) {

		id <- map["id"]
		contact_name <- map["contact_name"]
		apartment <- map["apartment"]
		street <- map["street"]
		city <- map["city"]
		state <- map["state"]
		zip <- map["zip"]
		phone <- map["phone"]
		is_default <- map["is_default"]
		pickup_service <- map["pickup_service"]
		verification <- map["verification"]
		latitude <- map["latitude"]
		longitude <- map["longitude"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
	}

}
