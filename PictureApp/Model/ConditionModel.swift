




import Foundation
import ObjectMapper

struct ConditionModel : Mappable {
	var results : [Results]?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		results <- map["Results"]
	}

}
