//
//  TechUserDefault.swift
//  
//
//
//

import UIKit

class TechUserDefault: NSObject {
   
    
   
    static let singleton: TechUserDefault  = {
//        struct Static {
//            static var onceToken: Int = 0
//            static var instance: TechUserDefault? = nil
//        }
        let instance = TechUserDefault ()
//        let sharedInstance:TechUserDefault = {
//            let instance = TechUserDefault ()
//            return instance
//        } ()
        
//        dispatch_once(&Static.onceToken) {
//            Static.instance = TechUserDefault()
//        }
        
//        _ = TechUserDefault.__once
        return instance
    }()
//    private static var __once: () = {
//        Static.instance = TechUserDefault()
//    }()
    
    var isGoogleLogin = false
    
    var isFBLogin = false
    
    fileprivate func userDefault() -> UserDefaults{
        return UserDefaults.standard
    }
    
    func userName() -> String?{
        return userDefault().object(forKey: "USER_NAME") as? String
    }
    
    func password() ->String?{
        return userDefault().object(forKey: "PASSWORD") as? String
    }
    
    func deviceToken() -> String?{
        return userDefault().object(forKey: "DEVICE_TOKEN") as? String
    }
    
    func setDeviceToken(_ deviceToken : String){
        userDefault().set(deviceToken, forKey: "DEVICE_TOKEN")
    }
    
    func setUserName(_ userName : String){
        userDefault().set(userName, forKey: "USER_NAME")
    }
    
    func setPassword(_ password : String){
        userDefault().set(password, forKey: "PASSWORD")
    }
    
    func isUserCredentialSaved() -> Bool{
        if(userName() == nil || password() == nil ){
            return false
        }
        return true
    }
    
    func removeUserCredential(){
        userDefault().removeObject(forKey: "USER_NAME")
        userDefault().removeObject(forKey: "PASSWORD")
    }

}
