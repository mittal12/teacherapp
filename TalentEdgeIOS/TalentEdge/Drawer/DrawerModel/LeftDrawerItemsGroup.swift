//
//  LeftDrawerItemsGroup.swift
//
//
//
//

import UIKit

class LeftDrawerItemsGroup: NSObject {
    var title : String?
    var leftDrawerItems = NSMutableArray()
    
//    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
//        self.init()
//        
//        title = dictionary["title"] as? String
////        var leftDrawerItems : NSMutableArray
//        let arr  = dictionary ["leftDrawerItems"] as? NSMutableArray
//        for leftDrawerObj in arr!
//        {
//           
//            let leftDrawerItem =  LeftDrawerItem.init(leftDrawerObj as! Dictionary<String, AnyObject>)
//            leftDrawerItems.addObject(leftDrawerItem)
//        }
//    }
    
    init(dictionary : Dictionary<String, AnyObject>) {
        title = dictionary["title"] as? String
        //        var leftDrawerItems : NSMutableArray
//        print(dictionary ["leftDrawerItems"])
        let arr : NSArray = dictionary ["leftDrawerItems"] as! NSArray
        for leftDrawerObj in arr
        {
            
            let leftDrawerItem =  LeftDrawerItem.init(leftDrawerObj as! Dictionary<String, AnyObject>)
            leftDrawerItems.add(leftDrawerItem)
        }

    }


}

