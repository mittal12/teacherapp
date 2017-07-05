//
//  LeftDrawerItem.swift
//
//
//
//
import UIKit

class LeftDrawerItem: NSObject {
    var icon : String?
    var title : String?
    var className : String?
    var navigationTitle : String?
    var index : String?
    
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        
        title = dictionary["title"] as? String
        icon = dictionary["icon"] as? String
        className = dictionary["className"] as? String
        navigationTitle = dictionary["navigationTitle"] as? String
        index = dictionary["index"] as? String
    }

}
