import UIKit
class TalentEdgeUserDefault: NSObject {
   
//    private static var __once: () = {
//            Static.instance = TalentEdgeUserDefault()
//        }()
   
//    class var singleton: TalentEdgeUserDefault {
//        let sharedInstance:TalentEdgeUserDefault = {
//            let instance = TalentEdgeUserDefault ()
//            return instance
//        } ()
//        return sharedInstance
//
//    }
    
     static let singleton: TalentEdgeUserDefault = {
//        let sharedInstance:TalentEdgeUserDefault = {
            let instance = TalentEdgeUserDefault ()
            return instance
//        } ()
//        return sharedInstance
        
    }()
    
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
