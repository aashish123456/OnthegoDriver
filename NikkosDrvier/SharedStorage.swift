//
//  SharedStorage.swift
//  NikkosDrvier
//
//  Created by Umang on 9/1/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit

class SharedStorage: NSObject   
{
    static let URL : String = "http://wds2.projectstatus.co.uk/OnthegoWds/api/"
    //static let URL : String = "http://wds2.projectstatus.co.uk/OnthegoUAT/api/"
    //static let URL : String = "http://192.168.0.148/OnTheGo/api/"
    
    static func setIsOnlineOffine(_ status: Bool) -> Bool {
        UserDefaults.standard.set(status, forKey: "N_IsOnlineOffine")
        return UserDefaults.standard.synchronize()
    }
    static func getIsOnlineOffine() -> Bool {
        return UserDefaults.standard.bool(forKey: "N_IsOnlineOffine")
    }
    
    static func setselectedIndexForActiveVehicle(_ int: NSInteger) -> Bool {
        UserDefaults.standard.set(int, forKey: "N_IsActiveVehicle")
        return UserDefaults.standard.synchronize()
    }
    static func getselectedIndexForActiveVehicle() -> NSInteger {
        return (UserDefaults.standard.object(forKey: "N_IsActiveVehicle") as? NSInteger)!
    }
    
    static func getLanguage() -> String {
        
        let deviceToken : String = UserDefaults.standard.object(forKey: NikkosDriverManager.k_USER_LANG) as! String
        return deviceToken
    }
    
    static func setLanguage(_ language : String) -> Bool {
        UserDefaults.standard.set(language, forKey: NikkosDriverManager.k_USER_LANG)
        return UserDefaults.standard.synchronize()
    }

    
    static func setUserId(_ userId : NSNumber) -> Bool {
        
        UserDefaults.standard.set(userId, forKey: "N_user_id")
        return UserDefaults.standard.synchronize()
    }
    
//    static func getUserId() -> NSNumber {
//        var userDataId = UserDefaults.standard.object(forKey: "N_user_id") as? NSNumber
//        if userDataId == nil{
//            userDataId = NSNumber(value: 0 as Int)
//        }
//        return userDataId!
//    }
    
    static func getUserId() -> String {
        if (UserDefaults.standard.object(forKey: "N_user_id") != nil){
            let userDataId = UserDefaults.standard.object(forKey: "N_user_id") as! String
            return userDataId
        }else{
            return "0"
        }
    }
    
    static func setDriverId(_ driverId : NSNumber) -> Bool {
        
        UserDefaults.standard.set(driverId, forKey: "N_Driver_id")
        return UserDefaults.standard.synchronize()
    }
    
    static func getDriverId() -> NSNumber {
        var driverId = UserDefaults.standard.object(forKey: "N_Driver_id") as? NSNumber
        if driverId == nil{
            driverId = NSNumber(value: 0 as Int)
        }
        return driverId!
    }
    
    static func getCountryId() -> Int {
        if (SharedStorage.getUser().countryId != nil){
            return SharedStorage.getUser().countryId
        }else{
            return 0
        }
    }
    
    static func setUnderCapaDriverId(_ driverId : NSNumber) -> Bool {
        
        UserDefaults.standard.set(driverId, forKey: "N_Capa_Driver_id")
        return UserDefaults.standard.synchronize()
    }
    
    static func getUnderCapaDriverId() -> NSNumber {
        var driverId = UserDefaults.standard.object(forKey: "N_Capa_Driver_id") as? NSNumber
        if driverId == nil{
            driverId = NSNumber(value: 0 as Int)
        }
        return driverId!
    }

    static func setTripId(_ tripId : NSNumber) -> Bool {
        
        UserDefaults.standard.set(tripId, forKey: "N_TripId")
        return UserDefaults.standard.synchronize()
    }
    
    
    static func getTripId() -> NSNumber {
        var tripId = UserDefaults.standard.object(forKey: "N_TripId") as? NSNumber
        if tripId == nil{
            tripId = NSNumber(value: 0 as Int)
        }
        return tripId!
    }

    
    static func setAccessTypeRequest(_ status: Bool) -> Bool {
        UserDefaults.standard.set(status, forKey: "N_Access_Type")
        return UserDefaults.standard.synchronize()
    }
    static func getAccessTypeRequest() -> Bool {
        return UserDefaults.standard.bool(forKey: "N_Access_Type")
    }
    
    static func setUser(_ user : LoginModal) -> Bool {
        let userData:Data = NSKeyedArchiver.archivedData(withRootObject: user)
        
        UserDefaults.standard.set(userData, forKey: "NC_user")
        return UserDefaults.standard.synchronize()
    }
    
    static func getUser() -> LoginModal {
            let userData : Data = UserDefaults.standard.object(forKey: "NC_user") as! Data
            return NSKeyedUnarchiver.unarchiveObject(with: userData) as! LoginModal
    }
    
    static func checkObjectExist() -> Bool {
        
        let userData = UserDefaults.standard.object(forKey: "NC_user") as? Data
        if userData == nil{
            return false
        }
        return true
        
    }
    
    static func getIsRememberMe() -> Bool {
        return UserDefaults.standard.bool(forKey: "N_IsRememberMe")
    }
    
    static func setIsRememberMe(_ isRememberMe: Bool) -> Bool {
        UserDefaults.standard.set(isRememberMe, forKey: "N_IsRememberMe")
        return UserDefaults.standard.synchronize()
    }
    
    static func setUserNameText(_ userText: String) -> Bool {
        UserDefaults.standard.set(userText, forKey: "N_UserText")
        return UserDefaults.standard.synchronize()
    }
    static func getUserNameText() -> String {
        let userText  =  UserDefaults.standard.object(forKey: "N_UserText")
        if (userText != nil){
            return userText as! String
        }else{
            return ""
        }
    }
    
    static func setPasswordText(_ passwordText: String) -> Bool {
        UserDefaults.standard.set(passwordText, forKey: "N_PasswordText")
        return UserDefaults.standard.synchronize()
    }
    static func getPasswordText() -> String {
        let passwordText  =  UserDefaults.standard.object(forKey: "N_PasswordText")
        if(passwordText != nil){
            return passwordText! as! String
        }else{
            return ""
        }
        
    }
    
    static func getDeviceToken() -> String {
        
        let deviceToken : String = NikkosDriverManager.checkNullString(UserDefaults.standard.object(forKey: "N_DeviceToken") as AnyObject)
        return deviceToken
    }
    
    static func setDeviceToken(_ deviceToken : String) -> Bool {
        UserDefaults.standard.set(deviceToken, forKey: "N_DeviceToken")
        return UserDefaults.standard.synchronize()
    }
    
    static func setDriverImg(_ userImg: String) -> Bool {
        UserDefaults.standard.set(userImg, forKey: "N_userImg")
        return UserDefaults.standard.synchronize()
    }
    static func getDriverImg() -> String {
        let userImg  =  UserDefaults.standard.object(forKey: "N_userImg")
        return userImg! as! String
    }
    static func setDriverName(_ userName: String) -> Bool {
        
        UserDefaults.standard.set(userName, forKey: "N_DriverName")
        return UserDefaults.standard.synchronize()
    }
    static func getDriverName() -> String {
        let userName  =  UserDefaults.standard.object(forKey: "N_DriverName")
        return userName! as! String
    }
    static func setDriverEmail(_ userEmail: String) -> Bool {
        UserDefaults.standard.set(userEmail, forKey: "N_DriverEmail")
        return UserDefaults.standard.synchronize()
    }
    static func getDriverEmail() -> String {
        let userEmail  =  UserDefaults.standard.object(forKey: "N_DriverEmail")
        return userEmail! as! String
    }
    
}
