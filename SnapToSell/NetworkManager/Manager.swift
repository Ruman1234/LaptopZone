//
//  Manager.swift
//  SnapToSell
//
//  Created by Apple on 8/23/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class NetworkManager {
    
    static let SharedInstance = NetworkManager()
    var alamofireManager = Alamofire.SessionManager.default
//    let token = UserDefaults.standard.value(forKey: "Token")
//    let token = AppManager.shared().accessToken
    let token = CustomUserDefaults.Token.value
    
    func request(url:String ,
                 method : Alamofire.HTTPMethod ,
                 parameters : Parameters? = nil ,
                 encoding : ParameterEncoding = URLEncoding.default,
                 header : [String : String]? = nil,
                 completionHandler :@escaping (DataResponse<Any>) -> Void
        )  {

        let url = Constants.BASE_URL + url
        
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
    
    
    
    
      func request2(url:String ,
                   method : Alamofire.HTTPMethod ,
                   parameters : Parameters? = nil ,
                   encoding : ParameterEncoding = URLEncoding.default,
                   header : [String : String]? = nil,
                   completionHandler :@escaping (DataResponse<Any>) -> Void
          )  {

          let url = Constants.BASE_URL2 + url
          
        print(url)
        print(method)
        print(parameters)
        
        
          Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: header).responseJSON { (response) in
            
            print(response)
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



var sharedAppManager:AppManager? = nil

class AppManager {
    
    var accessToken:String = ""
    
    static func shared() -> AppManager {
        
        if (sharedAppManager == nil) {
            sharedAppManager = AppManager()
        }
        return sharedAppManager!
    }
    
    init() {
        
    }
    
    
}
