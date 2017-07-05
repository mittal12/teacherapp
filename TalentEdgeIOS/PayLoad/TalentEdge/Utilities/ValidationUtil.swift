//
//  ValidationUtil.swift
//  
//
//
//

import UIKit

class ValidationUtil: NSObject {
    
    class func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{0,25}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func isValidNumber(_ testStr:String) -> Bool {
        let emailRegEx = "\\b([0-9%_.+\\-]+)\\b"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func isValidOnlyNumber(_ testStr:String) -> Bool {
        let emailRegEx = "^([0-9]*)$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func isValidString(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Za-z ]+"
        let emailTest = NSPredicate(format:"SELF MATCHES %@",  emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func isValidAlphanumericString(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Za-z0-9]+"
        let emailTest = NSPredicate(format:"SELF MATCHES %@",  emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    class func isValidNumberDecimal(_ testStr:String) -> Bool {
        let emailRegEx = "^([0-9]*|[0-9]*[.][0-9]*)$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func isValidPhoneNumber(_ testStr:String) -> Bool {
        let emailRegEx = "^([0-9]*)$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
//    class func isValidPassport(testStr:String) -> Bool {
//        let emailRegEx = "[A-Za-z]{1}+[0-9]{7}"
//        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        return emailTest.evaluateWithObject(testStr)
//    }
    
    class func isValidPassword(_ testStr:String) -> Bool {
        let emailRegEx = "^(?=.{6,20}$)(?=.*\\d)(?=.*[a-zA-Z]).*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func isAlpha (_ testStr:String) -> Bool {
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: NSRegularExpression.Options())
        if regex.firstMatch(in: testStr, options: NSRegularExpression.MatchingOptions(), range:NSMakeRange(0, testStr.characters.count)) != nil {
            print("could not handle special characters")
            return false
        }else{
            return true
        }
    }
    
    class func isValidPassport(_ testStr:String) -> Bool {
        if isValidString(testStr){
            return false
        }
        if isAlpha(testStr) {
            return true
        }else if isValidOnlyNumber(testStr) {
            return true
        }else {
            return false
        }
    }
}
