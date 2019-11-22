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
               fcm_token: String ,
               success : @escaping(LoginModel) -> Void ,
               failure : @escaping(NSError) -> Void)  {
        
        self.request(url: Constants.LOGIN, method: .post, parameters: ["email":userNAme , "password" : password , "fcm_token" : fcm_token], encoding: JSONEncoding.default, header: ["Accept": "application/json"]) { (response) in
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
            guard (response.response?.statusCode) != nil else{
                failure(NSError())
                return
            }
            
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
    
    
    
    func socalFBLogin(Token: String ,
               
               success : @escaping(LoginModel) -> Void ,
               failure : @escaping(NSError) -> Void)  {
        
        self.request(url: Constants.SOCIAL_FB_LOGIN, method: .post, parameters: ["access_token":Token], encoding: JSONEncoding.default, header: ["Accept": "application/json"]) { (response) in
            print(response)
            print(response.response?.statusCode)
            //            let value = response.result.value
            //            success(Mapper<LoginModel>().map(JSON: value as! [String : Any])!)
            guard (response.response?.statusCode) != nil else{
                failure(NSError())
                return
            }
            
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
               success : @escaping(String) -> Void ,
               failure : @escaping(NSError) -> Void)  {
        
        self.request(url: Constants.REGISTER, method: .post, parameters: ["name":name ,"email":email , "password" : password, "password_confirmation" : Confirmpassword], encoding: JSONEncoding.default, header: ["Accept": "application/json"]) { (response) in
            print(response)
            //            let value = response.result.value
            //            success(Mapper<LoginModel>().map(JSON: value as! [String : Any])!)
            guard (response.response?.statusCode) != nil else{
                failure(NSError())
                return
            }
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    success("success")
                }
            }else if response.response!.statusCode < 500{
                print(response)
                if let value = response.result.value{
                    success("error")
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
                       
                       success : @escaping(LoginModel) -> Void ,
                       failure : @escaping(NSError) -> Void)    {
    
    
        self.request(url: Constants.ADD_NEW_ADDRESS, method: .post, parameters: ["contact_name" :contact_name,"street": street ,"apartment": apartment ,"city": city ,"state": state ,"zip": zip ,"phone": phone ,"is_default": is_default ], encoding: JSONEncoding.default , header: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
            
            guard (response.response?.statusCode) != nil else{
                failure(NSError())
                return
            }
            
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
                       success : @escaping(LoginModel) -> Void ,
                       failure : @escaping(NSError) -> Void)    {
        
        print(Constants.UPDATE_ADDRESS + "\(id)")
        self.request(url: Constants.UPDATE_ADDRESS + "\(id)", method: .put, parameters: ["contact_name" :contact_name,"street": street ,"apartment": apartment ,"city": city ,"state": state ,"zip": zip ,"phone": phone ,"is_default": is_default  ], encoding: JSONEncoding.default , header: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
            guard (response.response?.statusCode) != nil else{
                failure(NSError())
                return
            }
            
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
            guard (response.response?.statusCode) != nil else{
                failure(NSError())
                return
            }
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
            guard (response.response?.statusCode) != nil else{
                failure(NSError())
                return
            }
            print(response)
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    
//                    success(Mapper<AddressesModel>().mapArray(JSONObject: value)!)
                    success(Mapper<AddressesModel>().map(JSON: value as! [String : Any])!)
                }
            }else if response.response!.statusCode < 500{
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
                  offered_price: String ,
                  remarks: String ,
                  success : @escaping(NewRequest) -> Void ,
                  failure : @escaping(NSError) -> Void)  {
        
        self.request(url: Constants.ADD_NEW_ORDER, method: .post, parameters: ["title":title ,"asking-price":price , "remarks" : remarks, "offered_price" : offered_price], encoding: JSONEncoding.default, header: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
            print(response)
            //            let value = response.result.value
            //            success(Mapper<LoginModel>().map(JSON: value as! [String : Any])!)
            guard (response.response?.statusCode) != nil else{
                failure(NSError())
                return
            }
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
        searcInput : String ,
        success : @escaping([RequestStatusModel]) -> Void ,
        failure : @escaping(NSError) -> Void)  {
        
        
//        self.request2(url: "ljw_rep_sell_data" , method: .post, parameters: ["searcInput":searcInput], encoding: JSONEncoding.default, header: nil) { (response) in
//            
//            guard (response.response?.statusCode) != nil else{
//                failure(NSError())
//                return
//            }
//             if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
//                print(response)
//                if let value = response.result.value{
//                    success(Mapper<RequestStatusModel>().mapArray(JSONObject: value)!)
//                    
//                }
//            }else{
//                failure(NSError())
//            }
//        }
        
        
        Alamofire.request(URL(string: "http://71.78.236.20/laptopzone/reactcontroller/c_react/ljw_rep_sell_data")!, method: .post, parameters: [
            "searcInput" : searcInput,
            "user_id" : CustomUserDefaults.userId.value!]).responseJSON { (response) in
                          
                          print(response)
                   
                   
              guard (response.response?.statusCode) != nil else{
                       failure(NSError())
                       return
                   }
                   print(response.response!.statusCode)
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
            
            guard (response.response?.statusCode) != nil else{
                failure(NSError())
                return
            }
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
            guard (response.response?.statusCode) != nil else{
                failure(NSError())
                return
            }
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
            guard (response.response?.statusCode) != nil else{
                failure(NSError())
                return
            }
            
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
            guard (response.response?.statusCode) != nil else{
                failure(NSError())
                return
            }
            
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
            guard (response.response?.statusCode) != nil else{
                failure(NSError())
                return
            }
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
       
        success : @escaping(String) -> Void ,
        failure : @escaping(NSError) -> Void)  {
        
        
        self.request(url: Constants.REQUEST_SHIPMENT  , method: .post, parameters: ["request_id":request_id ,"shipment_id":shipment_id ,"rate_id":rate_id  ], encoding: JSONEncoding.default, header: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
            print(response)
            guard (response.response?.statusCode) != nil else{
                failure(NSError())
                return
            }
            
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    success("Success")
                    
                }
            }else if response.response!.statusCode >= 400{
                print(response)
                if let value = response.result.value{
                    success("Error")
                    
                }
            }else{
                failure(NSError())
            }
        }
        
    }
    
    
    func UploadImages(params: Parameters,
                     images : [UIImage],
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
            var i = 0
            for img in images{
                           
//               let data = img.jpegData(compressionQuality: 0.5)

//                MultipartFormData.append(data!, withName: "images[]", fileName: "images\(i).jpg", mimeType: "image/jpg")
                
                multipartFormData.append(img.jpegData(compressionQuality: 0.4)!, withName: "images[]", fileName: "images\(i).jpg", mimeType: "images/jpg")
                
               i += 1
           }
            
          
            
            
        }, usingThreshold:UInt64.init(), to: Constants.BASE_URL + "customer/sell-requests", method: .post,
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
                upload.uploadProgress { (pr) in
                    print(pr)
                }
                
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
            print(response.response?.statusCode)
            guard (response.response?.statusCode) != nil else{
                failure(NSError())
                return
            }
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
            
            
            guard (response.response?.statusCode) != nil else{
                failure(NSError())
                return
            }
            
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
            print(response.response?.statusCode)
            guard (response.response?.statusCode) != nil else{
                failure(NSError())
                return
            }
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
    
    
    func Profile(
   
        success : @escaping(ProfileModel) -> Void ,
        failure : @escaping(NSError) -> Void)  {
        
        
        self.request(url: Constants.PROFILE   , method: .get, parameters:nil, encoding: JSONEncoding.default, header: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
            print(response)
            guard (response.response?.statusCode) != nil else{
                failure(NSError())
                return
            }
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    success(Mapper<ProfileModel>().map(JSON: value as! [String : Any])!)
                }
            }else{
                failure(NSError())
            }
        }
        
    }
   
    
     func UpdateProfile(
        name:String,
        email:String,
         success : @escaping(ProfileModel) -> Void ,
         failure : @escaping(NSError) -> Void)  {
         
         
        self.request(url: Constants.PROFILE   , method: .post, parameters:["name" :name,"email":email ], encoding: JSONEncoding.default, header: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
             print(response)
             guard (response.response?.statusCode) != nil else{
                 failure(NSError())
                 return
             }
             if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                 print(response)
                 if let value = response.result.value{
                     success(Mapper<ProfileModel>().map(JSON: value as! [String : Any])!)
                 }
             }else{
                 failure(NSError())
             }
         }
         
     }
    
    func CancleOffer(
        requestId : String,
        offerid : String,
        success : @escaping(ProfileModel) -> Void ,
        failure : @escaping(NSError) -> Void)  {
        
        
        self.request(url: Constants.CANCLE_SINGLE_OFFER  + "\(requestId)/cancel"  , method: .post, parameters:nil, encoding: JSONEncoding.default, header: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
            print(response)
            guard (response.response?.statusCode) != nil else{
                failure(NSError())
                return
            }
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    success(Mapper<ProfileModel>().map(JSON: value as! [String : Any])!)
                }
            }else{
                failure(NSError())
            }
        }
        
    }
    
    
    
    
    func PaypalRequest(
        Email : String,
       
        success : @escaping(ProfileModel) -> Void ,
        failure : @escaping(NSError) -> Void)  {
        
        
        self.request(url: Constants.PAYPAL , method: .post, parameters:["paypal":Email], encoding: JSONEncoding.default, header: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
            print(response)
            guard (response.response?.statusCode) != nil else{
                failure(NSError())
                return
            }
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    success(Mapper<ProfileModel>().map(JSON: value as! [String : Any])!)
                }
            }else{
                failure(NSError())
            }
        }
        
    }
    
    
    
    func UploadReycleImages(params: Parameters,
                      images : [UIImage],
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
            
            for i in images {
                
                let size = i.jpegData(compressionQuality: 0.5)!.count / 1000
                print(size)
                multipartFormData.append(i.jpegData(compressionQuality: 0.5)!, withName: "images[]", fileName: "image.jpg", mimeType: "image/jpg")
                
            }
            
        }, usingThreshold:UInt64.init(), to: "http://71.78.236.20/laptopzone/reactcontroller/lz_website/c_lz_recycle/lz_recyle_form", method: .post,
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
    
    
    
    func RequestOTP(
        Email : String,
        
        success : @escaping(ProfileModel) -> Void ,
        failure : @escaping(NSError) -> Void)  {
        
        
        self.request(url: Constants.REQUESTOTP , method: .post, parameters:["email":Email], encoding: JSONEncoding.default, header: nil) { (response) in
            print(response)
            guard (response.response?.statusCode) != nil else{
                failure(NSError())
                return
            }
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    success(Mapper<ProfileModel>().map(JSON: value as! [String : Any])!)
                }
            }else{
                failure(NSError())
            }
        }
        
    }
    
    
    
    func ResetPasswordWithOTP(
        Email : String,
        password : String,
        otp : String,
        
        success : @escaping(ProfileModel) -> Void ,
        failure : @escaping(NSError) -> Void)  {
        
        
        self.request(url: Constants.RESETPASSWORDWITHOTP , method: .post, parameters:["email":Email,"password":password,"otp":otp], encoding: JSONEncoding.default, header: nil) { (response) in
            print(response)
            guard (response.response?.statusCode) != nil else{
                failure(NSError())
                return
            }
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    success(Mapper<ProfileModel>().map(JSON: value as! [String : Any])!)
                }
            }else{
                failure(NSError())
            }
        }
        
    }
    
    
    
    
    func ResetPasswordUsingOld(
        new_password : String,
        old_password : String,
        
        success : @escaping(ProfileModel) -> Void ,
        failure : @escaping(NSError) -> Void)  {
        
        print(old_password)
        print(new_password)
        self.request(url: Constants.RESETPASSWORDUSINGOLDPASSWORD , method: .post, parameters:["new_password":new_password,"old_password":old_password], encoding: JSONEncoding.default, header: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
            print(response)
            guard (response.response?.statusCode) != nil else{
                failure(NSError())
                return
            }
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    success(Mapper<ProfileModel>().map(JSON: value as! [String : Any])!)
                }
            }else{
                failure(NSError())
            }
        }
        
    }
    
    func OtpVerify(
          email : String,
          otp : String,
          
          success : @escaping(ProfileModel) -> Void ,
          failure : @escaping(NSError) -> Void)  {
          
          
          self.request(url: Constants.FORGOTPASSWORDVERIFY , method: .post, parameters:["email":email,"otp":otp], encoding: JSONEncoding.default, header: nil) { (response) in
              print(response)
              guard (response.response?.statusCode) != nil else{
                  failure(NSError())
                  return
              }
              if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                  print(response)
                  if let value = response.result.value{
                      success(Mapper<ProfileModel>().map(JSON: value as! [String : Any])!)
                  }
              }else{
                  failure(NSError())
              }
          }
          
      }
    
    func UpdateToken(
        fcm_token : String,
        
        success : @escaping(ProfileModel) -> Void ,
        failure : @escaping(NSError) -> Void)  {
        
        
        self.request(url: Constants.UPDATETOKEN , method: .post, parameters:["fcm_token":fcm_token], encoding: JSONEncoding.default, header: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
            print(response)
            guard (response.response?.statusCode) != nil else{
                failure(NSError())
                return
            }
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    success(Mapper<ProfileModel>().map(JSON: value as! [String : Any])!)
                }
            }else{
                failure(NSError())
            }
        }
        
    }
    
    func getBrnad(
        Id : String,
        
        success : @escaping(Buy_Sell) -> Void ,
        failure : @escaping(NSError) -> Void)  {
        
        
        Alamofire.request(URL(string: Constants.BASE_URL2 + "ljw_Brands")!, method: .post, parameters: ["get_product_name" : Id]).responseJSON { (response) in
                   
                   print(response)
            
            
       guard (response.response?.statusCode) != nil else{
                failure(NSError())
                return
            }
            print(response.response!.statusCode)
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                print(response)
                if let value = response.result.value{
                    success(Mapper<Buy_Sell>().map(JSON: value as! [String : Any])!)
                }
            }else{
                failure(NSError())
            }
        }
        
    }
    
    
    func getSeries(
          Id : String,
          
          success : @escaping(Buy_Sell) -> Void ,
          failure : @escaping(NSError) -> Void)  {
        
         
         Alamofire.request(URL(string: Constants.BASE_URL2 + "ljw_Series")!, method: .post, parameters: ["get_brand_name" : Id]).responseJSON { (response) in
                    
                    print(response)
             
             
        guard (response.response?.statusCode) != nil else{
                 failure(NSError())
                 return
             }
             print(response.response!.statusCode)
             if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                 print(response)
                 if let value = response.result.value{
                     success(Mapper<Buy_Sell>().map(JSON: value as! [String : Any])!)
                 }
             }else{
                 failure(NSError())
             }
         }
          
      }
      
    func getModel(
             Id : String,
             
             success : @escaping(Buy_Sell) -> Void ,
             failure : @escaping(NSError) -> Void)  {
             
             
               Alamofire.request(URL(string: Constants.BASE_URL2 + "ljw_Model")!, method: .post, parameters: ["get_series_name" : Id]).responseJSON { (response) in
                          
                          print(response)
                   
                   
              guard (response.response?.statusCode) != nil else{
                       failure(NSError())
                       return
                   }
                   print(response.response!.statusCode)
                   if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                       print(response)
                       if let value = response.result.value{
                           success(Mapper<Buy_Sell>().map(JSON: value as! [String : Any])!)
                       }
                   }else{
                       failure(NSError())
                   }
               }
        
         }
    

        func getCarier(
                 Id : String,
                 
                 success : @escaping(Buy_Sell) -> Void ,
                 failure : @escaping(NSError) -> Void)  {
            
            
                   Alamofire.request(URL(string: Constants.BASE_URL2 + "ljw_Carrier")!, method: .post, parameters: ["model_dt_id" : Id]).responseJSON { (response) in
                              
                              print(response)
                       
                       
                  guard (response.response?.statusCode) != nil else{
                           failure(NSError())
                           return
                       }
                       print(response.response!.statusCode)
                       if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                           print(response)
                           if let value = response.result.value{
                               success(Mapper<Buy_Sell>().map(JSON: value as! [String : Any])!)
                           }
                       }else{
                           failure(NSError())
                       }
                   }
            
             }
    
    
        func getStorage(
                        Id : String,
                        
                        success : @escaping(Buy_Sell) -> Void ,
                        failure : @escaping(NSError) -> Void)  {
                   
                   
                          Alamofire.request(URL(string: Constants.BASE_URL2 + "ljw_Storage")!, method: .post, parameters: ["carrier_id" : Id]).responseJSON { (response) in
                                     
                                     print(response)
                              
                              
                         guard (response.response?.statusCode) != nil else{
                                  failure(NSError())
                                  return
                              }
                              print(response.response!.statusCode)
                              if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                                  print(response)
                                  if let value = response.result.value{
                                      success(Mapper<Buy_Sell>().map(JSON: value as! [String : Any])!)
                                  }
                              }else{
                                  failure(NSError())
                              }
                          }
                   
                    }
               
    
    func getQuestions(
                   Id : String,
                   
                   success : @escaping([Buy_Sell_Questions]) -> Void ,
                   failure : @escaping(NSError) -> Void)  {
                      
                      
         Alamofire.request(URL(string: Constants.BASE_URL2 + "ljw_getAnOfferMobile")!, method: .post, parameters: ["object_id" : Id]).responseJSON { (response) in

            
            print(response)

            guard (response.response?.statusCode) != nil else{
                     failure(NSError())
                     return
            }
                 print(response.response!.statusCode)
                 if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                     print(response)
                     if let value = response.result.value{
                        success(Mapper<Buy_Sell_Questions>().mapArray(JSONObject: value)!)
                     }
                 }else{
                     failure(NSError())
                 }
         }
      
    }
    
//    func dropOff(
//                      product_name : String,
//                      brand_name : String,
//                      series_name : String,
//                      model_name : String,
//                      carrier_name : String,
//                      storage_name : String,
//                      answer_ids : String,
//                      gevin_offer : String,
//                      available_offer : String,
//                      select_option : String,
//                      payment_mode : String,
//                      paypalEmail : String,
//                      payable_to : String,
//                      checkEmail : String,
//                      address1 : String,
//                      address2 : String,
//                      cityName : String,
//                      stateName : String,
//                      zipCode : String,
//                      countryName : String,
//                      pick_address : String,
//                      pick_area : String,
//                      pick_city : String,
//                      pick_state : String,
//                      pick_zipcode : String,
//                      success : @escaping(LoginModel) -> Void ,
//                      failure : @escaping(NSError) -> Void)  {
////                         let ur = URL(string: "http://71.78.236.20/laptopzone/reactcontroller/c_react/ljw_saveBuySell")!
////                         print(ur)
//
//         let BASE_URL = URL(string: Constants.BASE_URL2 + "ljw_saveBuySell")
//            Alamofire.request(BASE_URL!, method: .post,
//
//                              parameters: ["product_name" : product_name,
//                             "brand_name" : brand_name,
//                             "series_name" : series_name,
//                             "model_name" : model_name,
//                             "carrier_name" : carrier_name,
//                             "storage_name" : storage_name,
//                             "answer_ids" : answer_ids,
//                             "gevin_offer" : gevin_offer,
//                             "available_offer" : available_offer,
//                             "select_option" : select_option,
//                             "paypalEmail" : paypalEmail,
//                             "address1" : address1,
//                             "address2" : address2,
//                             "cityName" : cityName,
//                             "stateName" : stateName,
//                             "zipCode" : zipCode,
//
//                             "countryName" : countryName,
//                             "pick_address" : pick_address,
//                             "pick_area" : pick_area,
//                             "pick_city" : pick_city,
//                             "pick_state" : pick_state,
//                             "pick_zipcode" : pick_zipcode]
//).responseJSON { (response) in
//
//
//               print(response)
//
//               guard (response.response?.statusCode) != nil else{
//                        failure(NSError())
//                        return
//               }
//                    print(response.response!.statusCode)
//                    if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
//                        print(response)
//                        if let value = response.result.value{
//                           success(Mapper<LoginModel>().map(JSON: value as! [String : Any])!)
//                        }
//                    }else{
//                        failure(NSError())
//                    }
//            }
//
//       }
    
        func dropOff(
            pra :Parameters,
                          success : @escaping(LoginModel) -> Void ,
                          failure : @escaping(NSError) -> Void)  {
    //                         let ur = URL(string: "http://71.78.236.20/laptopzone/reactcontroller/c_react/ljw_saveBuySell")!
    //                         print(ur)

             let BASE_URL = URL(string: Constants.BASE_URL2 + "ljw_saveBuySell")
                Alamofire.request(BASE_URL!, method: .post,
                                  
                                  parameters: pra
                ).responseJSON { (response) in

                   
                   print(response)

                   guard (response.response?.statusCode) != nil else{
                            failure(NSError())
                            return
                   }
                        print(response.response!.statusCode)
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
    
    
    func getShipmentRates(
        pra :Parameters,
                     success : @escaping(ShipmentRates) -> Void ,
                     failure : @escaping(NSError) -> Void)  {
//                         let ur = URL(string: "http://71.78.236.20/laptopzone/reactcontroller/c_react/ljw_saveBuySell")!
//                         print(ur)

        let BASE_URL = URL(string: "http://71.78.236.22/laptop-zone-stage/public/api/dummy/shipment-rates")
           Alamofire.request(BASE_URL!, method: .post,
                             
                             parameters: pra
                ).responseJSON { (response) in

              
              print(response)

              guard (response.response?.statusCode) != nil else{
                       failure(NSError())
                       return
              }
                   print(response.response!.statusCode)
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
    
    

    func saveRepairRequest(
                        pra :Parameters,
                        success : @escaping(LoginModel) -> Void ,
                        failure : @escaping(NSError) -> Void)  {
    //                         let ur = URL(string: "http://71.78.236.20/laptopzone/reactcontroller/c_react/ljw_saveBuySell")!
    //                         print(ur)

        let BASE_URL = URL(string: "http://71.78.236.20/laptopzone/reactcontroller/lz_website/c_lz_recycle/save_pull_request")
        Alamofire.request(BASE_URL!, method: .post,
                         
                         parameters: pra
            ).responseJSON { (response) in

          
          print(response)

          guard (response.response?.statusCode) != nil else{
                   failure(NSError())
                   return
          }
               print(response.response!.statusCode)
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
    

    func getShipmentImage(
        pra :Parameters,
                     success : @escaping(ShipmentRates) -> Void ,
                     failure : @escaping(NSError) -> Void)  {
//                         let ur = URL(string: "http://71.78.236.20/laptopzone/reactcontroller/c_react/ljw_saveBuySell")!
//                         print(ur)

        let BASE_URL = URL(string: "http://71.78.236.22/laptop-zone-stage/public/api/dummy/register")
           Alamofire.request(BASE_URL!, method: .post,
                             
                             parameters: pra
                ).responseJSON { (response) in

              
              print(response)

              guard (response.response?.statusCode) != nil else{
                       failure(NSError())
                       return
              }
                   print(response.response!.statusCode)
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
    
    
    

    func getMessages(
        
                     success : @escaping([MessageModel]) -> Void ,
                     failure : @escaping(NSError) -> Void)  {

       
            
        self.request(url: "customer/conversations", method: .get , header:["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
            print(CustomUserDefaults.Token.value)
            guard (response.response?.statusCode) != nil else{
              failure(NSError())
              return
            }
            print(response.response!.statusCode)
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
              print(response)
              if let value = response.result.value{
                success(Mapper<MessageModel>().mapArray(JSONObject: value)!)              }
            }else{
              failure(NSError())
            }
         }
      }
    
    

    func getMessagesDetails(
        id :String,
                     success : @escaping([MessageModel]) -> Void ,
                     failure : @escaping(NSError) -> Void)  {

       
            
        self.request(url: "customer/conversations/\(id)/messages", method: .get  , header:["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
            guard (response.response?.statusCode) != nil else{
              failure(NSError())
              return
            }
            print(response.response!.statusCode)
            if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
              print(response)
              if let value = response.result.value{
                success(Mapper<MessageModel>().mapArray(JSONObject: value)!)              }
            }else{
              failure(NSError())
            }
         }
      }
 
    

       func sendMessages(
           id :String,
           params: Parameters,
           content :UIImage?,
                        success : @escaping(MessageModel) -> Void ,
                        failure : @escaping(String) -> Void){
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 400.0
        configuration.timeoutIntervalForResource = 400.0
        self.alamofireManager = Alamofire.SessionManager(configuration: configuration)
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in params {
                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
            }

            if content != nil {
                multipartFormData.append((content?.jpegData(compressionQuality: 0.5)!)!, withName: "content", fileName: "content.jpg", mimeType: "content/jpg")
            }
            
            
        }, usingThreshold:UInt64.init(), to: Constants.BASE_URL + "customer/conversations/\(id)/messages", method: .post,
           headers: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"], encodingCompletion: { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseString(completionHandler: { (res) in
                    print(res)
//                    success("Product Added Successfully")
//                     success(Mapper<MessageModel>().map(JSON: value as! [String : Any])!)
                })
                upload.responseJSON(completionHandler: { (res) in
                    print(res)
                    
                    if let value = res.result.value{
//                     success(Mapper<ShipmentRates>().map(JSON: value as! [String : Any])!)
                        success(Mapper<MessageModel>().map(JSON: value as! [String : Any])!)
                  }
//                    success(Mapper<MessageModel>().map(JSON: value as! [String : Any])!)
//                    success("Product Added Successfully")
                })
                
            case .failure(let encodingError):
                failure(encodingError as! String )
                failure("error" )
            }
            
        })
        
    }
       //{

          
               
//           self.request(url: "customer/conversations/\(id)/messages", method: .post  , header:["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
//               guard (response.response?.statusCode) != nil else{
//                 failure(NSError())
//                 return
//               }
//               print(response.response!.statusCode)
//               if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
//                 print(response)
//                 if let value = response.result.value{
//                   success(Mapper<MessageModel>().mapArray(JSONObject: value)!)              }
//               }else{
//                 failure(NSError())
//               }
//            }
        
        
        
        
//         }
    
    
    
    func createConversations(
           id :String,
                        success : @escaping(MessageModel) -> Void ,
                        failure : @escaping(NSError) -> Void)  {

        Alamofire.request(Constants.BASE_URL + "customer/conversations", method: .post, parameters: ["request_id" : id], headers: ["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]).responseJSON { (response) in
           guard (response.response?.statusCode) != nil else{
             failure(NSError())
             return
           }
           print(response.response!.statusCode)
            print(response)
            
            print(response.response)
           if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
             print(response)
             if let value = response.result.value{
               success(Mapper<MessageModel>().map(JSON: value as! [String : Any])!)
                
            }
           }else{
             failure(NSError())
           }
        }
               
//        self.request(url: "customer/conversations", method: .post  ,parameters: ["request_id" : id], header:["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
//               guard (response.response?.statusCode) != nil else{
//                 failure(NSError())
//                 return
//               }
//               print(response.response!.statusCode)
//               if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
//                 print(response)
//                 if let value = response.result.value{
//                   success(Mapper<MessageModel>().map(JSON: value as! [String : Any])!)
//
//                }
//               }else{
//                 failure(NSError())
//               }
//            }
         }
    
    
    func UpdateDropOff(
           request_id :String,
           tracking_id :String,
           carrier_name :String,
                        success : @escaping(MessageModel) -> Void ,
                        failure : @escaping(NSError) -> Void)  {

          
               
        self.request(url: Constants.UPDATE_DROPOFF, method: .post  ,parameters: ["request_id" : request_id,"tracking_code" : tracking_id,"carrier_name" : carrier_name], header:["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
               guard (response.response?.statusCode) != nil else{
                 failure(NSError())
                 return
               }
            print(response)
               print(response.response!.statusCode)
               if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                 print(response)
                 if let value = response.result.value{
                   success(Mapper<MessageModel>().map(JSON: value as! [String : Any])!)
                    
                }
               }else{
                 failure(NSError())
               }
            }
         }
    
    
    
    
    func GetCount(
                    success : @escaping(MessageModel) -> Void ,
                    failure : @escaping(NSError) -> Void)  {

          
               
        self.request2(url: "ljw_rep_sell_counts", method: .post  ,parameters: [ "user_id" : CustomUserDefaults.userId.value!], header:["Accept": "application/json" , "Authorization": "Bearer \(CustomUserDefaults.Token.value!)"]) { (response) in
               guard (response.response?.statusCode) != nil else{
                 failure(NSError())
                 return
               }
            print(response)
               print(response.response!.statusCode)
               if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                 print(response)
                 if let value = response.result.value{
                   success(Mapper<MessageModel>().map(JSON: value as! [String : Any])!)
                    
                }
               }else{
                 failure(NSError())
               }
            }
         }
    
    
    
    func getRepRecData(
        searcInput : String,
        success : @escaping(RequestStatusModel) -> Void ,
        failure : @escaping(NSError) -> Void)  {
        
        Alamofire.request(URL(string: "http://71.78.236.20/laptopzone/reactcontroller/c_react/get_rep_rec_detail")!, method: .post, parameters: ["searcInput" : searcInput,
         "user_id" : CustomUserDefaults.userId.value!]).responseJSON { (response) in
                          
                          print(response)
                   
                   
              guard (response.response?.statusCode) != nil else{
                       failure(NSError())
                       return
                   }
                   print(response.response!.statusCode)
                   if response.response!.statusCode >= 200 && response.response!.statusCode < 300{
                       print(response)
                       if let value = response.result.value{
                        success(Mapper<RequestStatusModel>().map(JSON: value as! [String : Any])!)                       }
                   }else{
                       failure(NSError())
                   }
               }

    }
    
    
    
    func setRepRecProceed(
    pra :Parameters,
                  success : @escaping(LoginModel) -> Void ,
                  failure : @escaping(NSError) -> Void)  {
        
     let BASE_URL = URL(string:"http://71.78.236.20/laptopzone/reactcontroller/lz_website/c_lz_recycle/save_pull_request")
        
        Alamofire.request(BASE_URL!, method: .post,
                          
                          parameters: pra
        ).responseJSON { (response) in

           
           print(response)

           guard (response.response?.statusCode) != nil else{
                    failure(NSError())
                    return
           }
                print(response.response!.statusCode)
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
    
    
    func setRepRecPickup(
       pra :Parameters,
                     success : @escaping(LoginModel) -> Void ,
                     failure : @escaping(NSError) -> Void)  {
           
        let BASE_URL = URL(string:"http://71.78.236.20/laptopzone/reactcontroller/c_react/saveOptionData")
           
           Alamofire.request(BASE_URL!, method: .post,
                             
                             parameters: pra
           ).responseJSON { (response) in

              
              print(response)

              guard (response.response?.statusCode) != nil else{
                       failure(NSError())
                       return
              }
                   print(response.response!.statusCode)
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
       
    
    //      pickup
    //    http://71.78.236.20/laptopzone/reactcontroller/c_react/saveOptionData
            
   
}

