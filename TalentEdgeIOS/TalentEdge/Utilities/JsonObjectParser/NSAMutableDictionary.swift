//
//  NSAMutableDictionary.swift
//

import UIKit

class NSAMutableDictionary: NSMutableDictionary {
    
    var tempArray : NSMutableDictionary!
    var className : String!
    
    func withClassName(_ className : String) -> NSAMutableDictionary {
        tempArray = NSMutableDictionary()
        self.className = className
        return self
    }
    
    override var count: Int {
        get {
            return tempArray.count
        }
    }
    
    func getClassName() -> String {
        return className
    }
    
//    override func objectAtIndex(index: Int) -> AnyObject {
//        assert(index < count, "The index is out of bounds")
//        return tempArray.objectAtIndex(index)
//    }
    
    override func value(forKey key: String) -> Any? {
        return tempArray.value(forKey: key)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        tempArray.setValue(value, forKey: key)
    }
    
    override func object(forKey aKey: Any) -> Any? {
        return tempArray.object(forKey: aKey)
    }

//    - (id)initWithClass:(Class)class
//    {
//    self = [super init];
//    if (self) {
//    dictionary = [NSMutableDictionary dictionary];
//    valueType = class;
//    }
//    return self;
//    }
//    -(void)setValue:(id)value forKey:(NSString *)key{
//    [dictionary setValue:value forKey:key];
//    }
//    -(NSUInteger)count{
//    return [dictionary count];
//    }
//    -(NSArray*)allKeys{
//    return [dictionary allKeys];
//    }
//    -(id)objectForKey:(id)key{
//    return [dictionary objectForKey:key];
//    }
//    -(id)valueForKey:(NSString*)key{
//    return [dictionary valueForKey:key];
//    }

}
