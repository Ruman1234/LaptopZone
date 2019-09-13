
import Foundation
import ObjectMapper

struct LoginModel : Mappable {
	var access_token : String?
	var token_type : String?
	var expires_at : String?
	var user_id : Int?
    var message : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		access_token <- map["access_token"]
		token_type <- map["token_type"]
		expires_at <- map["expires_at"]
		user_id <- map["user_id"]
        message <- map["message"]
	}

}
