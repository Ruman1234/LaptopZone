

import Foundation
import ObjectMapper

struct Results : Mappable {
	var iD : String?
	var cOND_NAME : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		iD <- map["ID"]
		cOND_NAME <- map["COND_NAME"]
	}

}
