//
//  File.swift
//  PictureApp
//
//  Created by Apple on 6/29/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import ObjectMapper

import UIKit
extension NetworkManager {
    
    func Conditions(success : @escaping (ConditionModel) -> Void,
                    failure : @escaping (NSError) -> Void)  {
        self.request(url: "", method: .get) { (response) in
            if response.response?.statusCode == 200 {
                if let value = response.result.value{
                    success(Mapper<ConditionModel>().map(JSON: value as! [String : Any])!)
                }
            }else{
                failure(NSError())
            }
        }
    }
    
}
