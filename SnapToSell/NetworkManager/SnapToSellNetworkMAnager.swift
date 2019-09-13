//
//  SnapToSellNetworkMAnager.swift
//  SnapToSell
//
//  Created by Apple on 8/23/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import UIKit
import SwiftyJSON

extension NetworkManager{
    
    func login(userNAme: String ,
               password: String ,
               success : @escaping(LoginModel) -> Void ,
               failure : @escaping(NSError) -> Void)  {
        
        self.request(url: Constants.LOGIN, method: .post, parameters: ["email":userNAme , "password" : password], encoding: JSONEncoding.default, header: ["Accept": "application/json"]) { (response) in
            print(response)
//            let value = response.result.value
//            success(Mapper<LoginModel>().map(JSON: value as! [String : Any])!)
            
            if response.response?.statusCode == 200{
                print(response)
                if let value = response.result.value{
                    success(Mapper<LoginModel>().map(JSON: value as! [String : Any])!)
                }
            }else if response.response?.statusCode == 401{
                print(response)
                if let value = response.result.value{
                    success(Mapper<LoginModel>().map(JSON: value as! [String : Any])!)
                }
            }else{
                failure(NSError())
            }
        }
        
        
    }
    
    
    func socalLogin(Token: String ,
               
               success : @escaping(LoginModel) -> Void ,
               failure : @escaping(NSError) -> Void)  {
        
        self.request(url: Constants.SOCIAL_LOGIN, method: .post, parameters: ["access_token":Token], encoding: JSONEncoding.default, header: ["Accept": "application/json"]) { (response) in
            print(response)
            //            let value = response.result.value
            //            success(Mapper<LoginModel>().map(JSON: value as! [String : Any])!)
            
            
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    success(Mapper<LoginModel>().map(JSON: value as! [String : Any])!)
                }
            }else if response.response!.statusCode >= 400 && response.response!.statusCode < 500{
                print(response)
                if let value = response.result.value{
                    success(Mapper<LoginModel>().map(JSON: value as! [String : Any])!)
                }
            }else{
                failure(NSError())
            }
        }
        
        
    }
    
    
    func Register(name: String ,
                  email: String ,
                  password: String ,
               Confirmpassword: String ,
               success : @escaping(LoginModel) -> Void ,
               failure : @escaping(NSError) -> Void)  {
        
        self.request(url: Constants.REGISTER, method: .post, parameters: ["name":name ,"email":email , "password" : password, "password_confirmation" : Confirmpassword], encoding: JSONEncoding.default, header: ["Accept": "application/json"]) { (response) in
            print(response)
            //            let value = response.result.value
            //            success(Mapper<LoginModel>().map(JSON: value as! [String : Any])!)
          
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    success(Mapper<LoginModel>().map(JSON: value as! [String : Any])!)
                }
            }else if response.response?.statusCode == 401{
                print(response)
                if let value = response.result.value{
                    success(Mapper<LoginModel>().map(JSON: value as! [String : Any])!)
                }
            }else{
                failure(NSError())
            }
        }
        
        
    }
    
    
    
    func AddNewAddress(contact_name: String ,
                       street: String ,
                       apartment: String ,
                       city: String ,
                       state: String ,
                       zip: String ,
                       phone: String ,
                       is_default: Int ,
                       latitude: String ,
                       longitude: String ,
                       success : @escaping(LoginModel) -> Void ,
                       failure : @escaping(NSError) -> Void)    {
    
    
        self.request(url: Constants.ADD_NEW_ADDRESS, method: .post, parameters: ["contact_name" :contact_name,"street": street ,"apartment": apartment ,"city": city ,"state": state ,"zip": zip ,"phone": phone ,"is_default": is_default ,"latitude": latitude ,"longitude": longitude ], encoding: JSONEncoding.default , header: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
            
            print(response)
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    success(Mapper<LoginModel>().map(JSON: value as! [String : Any])!)
                }
            }else if response.response?.statusCode == 403{
                print(response)
                if let value = response.result.value{
                    success(Mapper<LoginModel>().map(JSON: value as! [String : Any])!)
                }
            }else{
                failure(NSError())
            }
            
        }
    
        
    }
    
    
    
    func UpdateAddress(id: String ,
                       contact_name: String ,
                       street: String ,
                       apartment: String ,
                       city: String ,
                       state: String ,
                       zip: String ,
                       phone: String ,
                       is_default: Int ,
                       latitude: String ,
                       longitude: String ,
                       success : @escaping(LoginModel) -> Void ,
                       failure : @escaping(NSError) -> Void)    {
        
        print(Constants.UPDATE_ADDRESS + "\(id)")
        self.request(url: Constants.UPDATE_ADDRESS + "\(id)", method: .put, parameters: ["contact_name" :contact_name,"street": street ,"apartment": apartment ,"city": city ,"state": state ,"zip": zip ,"phone": phone ,"is_default": is_default ,"latitude": latitude ,"longitude": longitude ], encoding: JSONEncoding.default , header: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
            
            print(response)
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    success(Mapper<LoginModel>().map(JSON: value as! [String : Any])!)
                }
            }else if response.response?.statusCode == 403{
                print(response)
                if let value = response.result.value{
                    success(Mapper<LoginModel>().map(JSON: value as! [String : Any])!)
                }
            }else{
                failure(NSError())
            }
            
        }
        
        
    }
    
    
    
    func getAddress(success : @escaping([AddressesModel]) -> Void ,
                    failure : @escaping(NSError) -> Void)  {
        
        self.request(url: Constants.GET_ADDRESS, method: .get, parameters: nil, encoding: JSONEncoding.default, header: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
            
            print(response)
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    
                    success(Mapper<AddressesModel>().mapArray(JSONObject: value)!)

                }
            }else if response.response?.statusCode == 403{
                print(response)
                if let value = response.result.value{

                    success(Mapper<AddressesModel>().mapArray(JSONObject: value)!)

                }
            }else{
                failure(NSError())
            }
        }
    }
    
    
    func deleteAddress(
        id : String ,
        success : @escaping(String) -> Void ,
                    failure : @escaping(NSError) -> Void)  {
        
        
        self.request(url: Constants.DELETE_ADDRESS + id, method: .delete, parameters: nil, encoding: JSONEncoding.default, header: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
            print(response)
            
            if response.response?.statusCode == 204{
                print(response)
                if response.result.value != nil{
//                    success(Mapper<LoginModel>().map(JSON: value as? [String : Any])!)
                    success("success")
                }
            }else{
                failure(NSError())
            }
        }
        
    }
    
    
    func getDefaultAddress(success : @escaping(AddressesModel) -> Void ,
                    failure : @escaping(NSError) -> Void)  {
        
        self.request(url: Constants.DEFAULT_ADDRESS, method: .get, parameters: nil, encoding: JSONEncoding.default, header: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
            
            print(response)
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    
//                    success(Mapper<AddressesModel>().mapArray(JSONObject: value)!)
                    success(Mapper<AddressesModel>().map(JSON: value as! [String : Any])!)
                }
            }else if response.response?.statusCode == 403{
                print(response)
                if let value = response.result.value{
                    
//                    success(Mapper<AddressesModel>().mapArray(JSONObject: value)!)
                    success(Mapper<AddressesModel>().map(JSON: value as! [String : Any])!)
                }
            }else{
                failure(NSError())
            }
        }
    }
    
    
    
    func AddNewOrder(title: String ,
                  price: String ,
                  
                  remarks: String ,
                  success : @escaping(NewRequest) -> Void ,
                  failure : @escaping(NSError) -> Void)  {
        
        self.request(url: Constants.ADD_NEW_ORDER, method: .post, parameters: ["title":title ,"price":price , "remarks" : remarks], encoding: JSONEncoding.default, header: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
            print(response)
            //            let value = response.result.value
            //            success(Mapper<LoginModel>().map(JSON: value as! [String : Any])!)
            
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    success(Mapper<NewRequest>().map(JSON: value as! [String : Any])!)
                }
            }else if response.response?.statusCode == 401{
                print(response)
                if let value = response.result.value{
                    success(Mapper<NewRequest>().map(JSON: value as! [String : Any])!)
                }
            }else{
                failure(NSError())
            }
        }
        
        
    }
    
    
    
    
    func RequestStatus(
        status : String ,
        success : @escaping([RequestStatusModel]) -> Void ,
        failure : @escaping(NSError) -> Void)  {
        
        
        self.request(url: Constants.PRODUCT_STATUS , method: .post, parameters: ["status":status], encoding: JSONEncoding.default, header: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
             if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    success(Mapper<RequestStatusModel>().mapArray(JSONObject: value)!)
                    
                }
            }else{
                failure(NSError())
            }
        }
        
    }
    
    
    func Offers(
        id : String ,
        success : @escaping([OffersModel]) -> Void ,
        failure : @escaping(NSError) -> Void)  {
        
        
        self.request(url: Constants.OFFERS + id + "/offers" , method: .get, parameters: nil, encoding: JSONEncoding.default, header: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
            print(response)
            
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    success(Mapper<OffersModel>().mapArray(JSONObject: value)!)
                    
                }
            }else{
                failure(NSError())
            }
        }
        
    }
    
    func checkAvailbility(
        id : String ,
        success : @escaping(Int) -> Void ,
        failure : @escaping(NSError) -> Void)  {
        
        
        self.request(url: Constants.CHECK_AVAILBILITY + id + "/pickup-eligibility" , method: .get, parameters: nil, encoding: JSONEncoding.default, header: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
            print(response)
            
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
//                    success(Mapper<OffersModel>().mapArray(JSONObject: value)!)
                    
                    success(value as! Int)
                }
            }else if response.response!.statusCode > 300{
                print(response)
//                if let value = response.result.value{
                    //                    success(Mapper<OffersModel>().mapArray(JSONObject: value)!)
                success(0)
                    
//                }
            }else{
                failure(NSError())
            }
        }
        
    }
    
    
    
    func requestPickup(
        request_id : String ,
        address_id : String ,
        success : @escaping(LoginModel) -> Void ,
        failure : @escaping(NSError) -> Void)  {
        
        
        self.request(url: Constants.PICKUP  , method: .post, parameters: ["request_id":request_id , "address_id" :address_id], encoding: JSONEncoding.default, header: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
            print(response)
            
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                     success(Mapper<LoginModel>().map(JSON: value as! [String : Any])!)
                    
                }
            }else{
                failure(NSError())
            }
        }
        
    }
    
    
    
    func requestDropOff(
        request_id : String ,
        success : @escaping(LoginModel) -> Void ,
        failure : @escaping(NSError) -> Void)  {
        
        
        self.request(url: Constants.DROPOFF  , method: .post, parameters: ["request_id":request_id ], encoding: JSONEncoding.default, header: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
            print(response)
            
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    success(Mapper<LoginModel>().map(JSON: value as! [String : Any])!)
                    
                }
            }else{
                failure(NSError())
            }
        }
        
    }
    
    
    func requestShipmentRates(
        address_id : String ,
        weight : String ,
        length : String ,
        width : String ,
        height : String ,
        success : @escaping(ShipmentRates) -> Void ,
        failure : @escaping(NSError) -> Void)  {
        
        
        self.request(url: Constants.REQUEST_SHIPMENT_Rates  , method: .post, parameters: ["address_id":address_id ,"weight":weight ,"length":length ,"width":width ,"height":height ], encoding: JSONEncoding.default, header: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
            print(response)
            
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    success(Mapper<ShipmentRates>().map(JSON: value as! [String : Any])!)
                    
                }
            }else{
                failure(NSError())
            }
        }
        
    }
    
    
    func requestShipment(
        request_id : String ,
        shipment_id : String ,
        rate_id : String ,
       
        success : @escaping(ShipmentRates) -> Void ,
        failure : @escaping(NSError) -> Void)  {
        
        
        self.request(url: Constants.REQUEST_SHIPMENT  , method: .post, parameters: ["request_id":request_id ,"shipment_id":shipment_id ,"rate_id":rate_id  ], encoding: JSONEncoding.default, header: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
            print(response)
            
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    success(Mapper<ShipmentRates>().map(JSON: value as! [String : Any])!)
                    
                }
            }else{
                failure(NSError())
            }
        }
        
    }
    
    
    func UploadImages(params: Parameters,
                     images : UIImage,
                     success : @escaping (String) -> Void,
                     failure : @escaping (String) -> Void )  {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 400.0
        configuration.timeoutIntervalForResource = 400.0
        self.alamofireManager = Alamofire.SessionManager(configuration: configuration)
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in params {
                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
            }

            multipartFormData.append(images.jpegData(compressionQuality: 0.5)!, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
            
            
        }, usingThreshold:UInt64.init(), to: Constants.BASE_URL + "customer/products/request-new/images", method: .post,
           headers: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"], encodingCompletion: { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseString(completionHandler: { (res) in
                    print(res)
                    success("Product Added Successfully")
                })
                upload.responseJSON(completionHandler: { (res) in
                    print(res)
                    success("Product Added Successfully")
                })
                
            case .failure(let encodingError):
                failure(encodingError as! String )
                failure("error" )
            }
            
        })
        
    }
    
    
    func CancleRequest(
        request_id : String ,
        reason : String ,
        
        success : @escaping(LoginModel) -> Void ,
        failure : @escaping(NSError) -> Void)  {
        
        
        self.request(url: Constants.CANCLE_REQUEST + "\(request_id)/cancel"  , method: .post, parameters:["feedback": reason], encoding: JSONEncoding.default, header: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
            print(response)
            
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    success(Mapper<LoginModel>().map(JSON: value as! [String : Any])!)
                    
                }
            }else{
                failure(NSError())
            }
        }
        
    }
    
    
    
    func AllProductsRequest(
       
        success : @escaping([RequestStatusModel]) -> Void ,
        failure : @escaping(NSError) -> Void)  {
        
        
        self.request(url: Constants.ALL_PRODUCT_REQUEST  , method: .get, parameters:nil, encoding: JSONEncoding.default, header: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
            print(response)
            
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
//                    success(Mapper<RequestStatusModel>().map(JSON: value as! [String : Any])!)
                     success(Mapper<RequestStatusModel>().mapArray(JSONObject: value)!)
                }
            }else{
                failure(NSError())
            }
        }
        
    }
    
    
    func getSingalRequest(
        request_id : String ,
        
        
        success : @escaping(RequestStatusModel) -> Void ,
        failure : @escaping(NSError) -> Void)  {
        
        
        self.request(url: Constants.SINGAL_PRODUCT_REQUEST + "\(request_id)"  , method: .get, parameters:nil, encoding: JSONEncoding.default, header: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
            print(response)
            
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    success(Mapper<RequestStatusModel>().map(JSON: value as! [String : Any])!)
                    
                }
            }else{
                failure(NSError())
            }
        }
        
    }
    
    
   
    
}
