//
//  Constants.swift
//  SnapToSell
//
//  Created by Apple on 8/23/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import Firebase

class Constants {
    
    static let BASE_URL = "http://71.78.236.22/laptop-zone-stage/public/api/"
    
//    static let BASE_URL = "http://192.168.100.54/sts-laravel/public/api/"
    static let LOGIN = "auth/login"
    static let REGISTER = "auth/signup"
    static let SOCIAL_LOGIN = "auth/google"
    static let PROFILE = "customer/profile"
    static let ADD_NEW_ADDRESS = "customer/profile/address"
    static let UPDATE_ADDRESS = "customer/profile/address/"
    static let GET_ADDRESS = "customer/profile/addresses"
    static let DELETE_ADDRESS = "customer/profile/address/"
    static let DEFAULT_ADDRESS = "customer/profile/address"
    static let ADD_NEW_ORDER = "customer/sell-requests"
    static let PRODUCT_STATUS = "customer/products/productsByStatus"
    static let OFFERS = "customer/sell-requests/"
    static let CHECK_AVAILBILITY = "customer/profile/address/"
    static let PICKUP = "customer/sell-requests/request-pickup"
    static let DROPOFF = "customer/sell-requests/schedule-drop-off"
    static let REQUEST_SHIPMENT_Rates = "customer/profile/address/shipment-rates"
    static let REQUEST_SHIPMENT = "customer/sell-requests/register-shipment"
    static let CANCLE_REQUEST = "customer/sell-requests/requests/"
    static let ALL_PRODUCT_REQUEST = "customer/sell-requests"
    static let SINGAL_PRODUCT_REQUEST = "customer/sell-requests/"
    
    static let CANCLE_SINGLE_OFFER = "customer/sell-requests/"
    static let PAYPAL = "customer/profile/paypal"
    
    static let REQUESTOTP = "auth/forgot-password"
    static let RESETPASSWORDWITHOTP = "auth/forgot-password/reset"
    static let RESETPASSWORDUSINGOLDPASSWORD = "auth/reset-password"
    static let FORGOTPASSWORDVERIFY = "auth/forgot-password/verify"
    static let UPDATETOKEN = "customer/devices"
    
    static var address = AddressesModel()
    static var CheckAvailbility = Bool()
    static var addressId = String()
    
    static var requestId = String()
    
    
    static var height = String()
    static var weight = String()
    static var width = String()
    static var length = String()
    
    static var brandId = String()
    static var seriesId = String()
    static var modelId = String()
    static var issuesId = String()
    
    
}


struct Constant{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chats")
    }
}
