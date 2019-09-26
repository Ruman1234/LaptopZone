//
//  PictureAppManager.swift
//  PictureApp
//
//  Created by Apple on 6/29/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class NetworkManager {
    
    static let SharedInstance = NetworkManager()
    
    func request(url:String ,
                 method : Alamofire.HTTPMethod ,
                 parameters : Parameters? = nil ,
                 encoding : ParameterEncoding = URLEncoding.default,
                 header : [String : String]? = nil,
                 completionHandler :@escaping (DataResponse<Any>) -> Void
                 )  {
        let url = "http://71.78.236.20/laptopzone_webservice/C_android_record_upload/get_cond_result"
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: header).responseJSON { (response) in
            if let value = response.result.value {
                let json = JSON(value)
                if json["success"].intValue == -1 {
                    
                }else{
                    completionHandler(response)
                }
            }else{
                completionHandler(response)
            }
        }
    }
}
