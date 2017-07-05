//
//  ModelManager.swift
//
//
//

import UIKit

class ModelManager: NSObject {
    
//    private static var __once: () = {
//            Static.instance = ModelManager()
//        }()
    
     static let singleton: ModelManager = {
//        struct Static {
//            static var onceToken: Int = 0
//            static var instance: ModelManager? = nil
//        }
        
//        let sharedInstance:ModelManager = {
//            let instance = ModelManager ()
//            return instance
//        } ()
        
        let instance = ModelManager ()
        return instance
        
//        _ = ModelManager.__once
//        return Static.instance!
    }()
    
    var loginData : TELoginData!
    var selectedCourseObj : TECourseData!
    var batchList : [TEBatchData]!
    var courseImage : UIImage!


}
