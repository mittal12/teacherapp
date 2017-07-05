//
//  JsonObjectParser.swift
//
//
//
//

import UIKit

class JsonObjectParser: NSObject {
    
    func getAllPropertyList(_ className : AnyClass) -> [String] {
        var count = UInt32()
//        let properties : UnsafeMutablePointer <objc_property_t> = class_copyPropertyList(className, &count)
        
//        class_copyPropertyList(object_getClass(className), &count)
        guard let properties = class_copyPropertyList(className, &count) else {
            return [""]
        }
        
        
        var propertyNames = [String]()
        let intCount = Int(count)
        for i in 0 ..< intCount {
            let property : objc_property_t = properties[i]!
            let propertyName = NSString(utf8String: property_getName(property)) as? String
            propertyNames.append(propertyName!)
        }
        free(properties)
        return propertyNames
    }
    
    func getDeclarationTypeForProperty(_ propertyName : String , classToInspect : AnyClass) -> AnyClass? {
        let declarationDetailsCString = property_getAttributes(class_getProperty(classToInspect, propertyName))
        let dividedStringArray = String(cString: declarationDetailsCString!).components(separatedBy: ",")
        let typeString : String = (dividedStringArray[0] as NSString).substring(from: 1)
        if typeString.hasPrefix("@") && typeString.characters.count > 1{
            return NSClassFromString(((typeString as NSString) .replacingOccurrences(of: "@\"", with: "") as NSString).replacingOccurrences(of: "\"", with: ""))
        }else {
            return nil
        }
    }
    
    func parseJsonData(_ className : String , jsonData : NSDictionary) -> AnyObject? {
        let classToInspect: AnyClass! = NSClassFromString(className)
        let propertyList = getAllPropertyList(classToInspect)
        let anyobjectype : AnyObject.Type = classToInspect
        let nsobjectype : NSObject.Type = anyobjectype as! NSObject.Type
        let classObj: AnyObject = nsobjectype.init()
        for i in 0 ..< propertyList.count {
            let propertyName = propertyList[i]
            let x: AnyObject = NSNull()
            if (((jsonData.value(forKey: propertyName) as AnyObject).isEqual(x)) == true) && propertyName == "purpose" {
                break
            }
        
            if propertyName == "desc"{
                let tempPropertyClass: (AnyClass?) = (getDeclarationTypeForProperty(propertyName, classToInspect: classToInspect))
                if tempPropertyClass != nil && tempPropertyClass?.description() == Bundle.main.infoDictionary!["CFBundleName"] as! String + ".NSAMutableArray" {
                    let altaArray : NSAMutableArray = classObj.value(forKey: propertyName) as! NSAMutableArray
                    let altaArrayType: AnyClass! = NSClassFromString(altaArray.getClassName())
                    for j in 0 ..< (jsonData.value(forKey: propertyName)! as AnyObject).count  {
                        let innerDict: NSDictionary? = (jsonData.value(forKey: propertyName) as AnyObject).object(at: j) as? NSDictionary
                        altaArray.add(self.parseJsonData(altaArrayType.description(), jsonData: innerDict!)!)
                    }
                }else if tempPropertyClass != nil && tempPropertyClass?.description() == "NSMutableArray" || tempPropertyClass?.description() == "NSMutableDictionary" || tempPropertyClass?.description() == "NSArray" || tempPropertyClass?.description() == "NSDictionary" || tempPropertyClass?.description() == "NSString" || tempPropertyClass?.description() == "NSNumber" {
                    classObj.setValue(jsonData.value(forKey: "description"), forKey: propertyName)
                }else if tempPropertyClass != nil && tempPropertyClass!.description() != Bundle.main.infoDictionary!["CFBundleName"] as! String + ".CKCurrencyDetailModel" {
                    classObj.setValue(parseJsonData(tempPropertyClass!.description(), jsonData: (jsonData.value(forKey: "description")) as! NSDictionary), forKey: propertyName)
                }else {
                    classObj.setValue(jsonData.value(forKey: "description") == nil ? false : jsonData.value(forKey: "description"), forKey: propertyName)
                }
            }else {
                let tempPropertyClass: (AnyClass?) = (getDeclarationTypeForProperty(propertyName, classToInspect: classToInspect))
                if tempPropertyClass != nil && tempPropertyClass?.description() == Bundle.main.infoDictionary!["CFBundleName"] as! String + ".NSAMutableArray" {
                    let altaArray : NSAMutableArray = classObj.value(forKey: propertyName) as! NSAMutableArray
                    let altaArrayType: AnyClass! = NSClassFromString(altaArray.getClassName())
                    for j in 0 ..< (jsonData.value(forKey: propertyName)! as AnyObject).count {
                        let innerDict: NSDictionary? = (jsonData.value(forKey: propertyName) as AnyObject).object(at: j) as? NSDictionary
                        altaArray.add(self.parseJsonData(altaArrayType.description(), jsonData: innerDict!)!)
                    }
                }else if tempPropertyClass != nil && tempPropertyClass?.description() == "NSMutableArray" || tempPropertyClass?.description() == "NSMutableDictionary" || tempPropertyClass?.description() == "NSArray" || tempPropertyClass?.description() == "NSDictionary" || tempPropertyClass?.description() == "NSString" || tempPropertyClass?.description() == "NSNumber" {
                    let data = jsonData.value(forKey: propertyName)
                    switch data { // how to test for different possible types
                    case let data as NSNull:
                    classObj.setValue("", forKey: propertyName)
                    default:
                        classObj.setValue(jsonData.value(forKey: propertyName), forKey: propertyName)
                    }
                }else if tempPropertyClass != nil && tempPropertyClass!.description() != Bundle.main.infoDictionary!["CFBundleName"] as! String + ".CKCurrencyDetailModel" {
                    classObj.setValue(parseJsonData(tempPropertyClass!.description(), jsonData: (jsonData.value(forKey: propertyName)) as! NSDictionary), forKey: propertyName)
                }else {
                    classObj.setValue(jsonData.value(forKey: propertyName) == nil ? false : jsonData.value(forKey: propertyName), forKey: propertyName)
                }
            }
        }
        return classObj
    }
    
    func parseJsonArray(_ className : String , jsonData : NSArray) -> AnyObject? {
        let returnArray = NSMutableArray()
        for i in 0 ..< jsonData.count {
            let dict: AnyObject = jsonData.object(at: i) as AnyObject
            returnArray.add(parseJsonData(className, jsonData: dict as! NSDictionary)!)
        }
        return returnArray
    }
    
}
