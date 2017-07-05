//
//  NSAMutableArray.swift
//

import UIKit

class NSAMutableArray: NSMutableArray {

    var tempArray : NSMutableArray!
    var className : String!
    
    func withClassName(_ className : String) -> NSAMutableArray {
        tempArray = NSMutableArray()
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
    
    override func object(at index: Int) -> Any {
        assert(index < count, "The index is out of bounds")
        return tempArray.object(at: index)
    }
    
    override func add(_ anObject: Any) {
        tempArray.add(anObject)
    }
    
    override func insert(_ anObject: Any, at index: Int) {
        tempArray.insert(anObject, at: index)
    }
    
    override func sort(using sortDescriptors: [NSSortDescriptor]) {
        tempArray.sort(using: sortDescriptors)
    }
    
    override func contains(_ anObject: Any) -> Bool {
        return tempArray.contains(anObject)
    }
    
    override func removeObject(at index: Int) {
        tempArray.removeObject(at: index)
    }
    
    override func remove(_ anObject: Any) {
        tempArray.remove(anObject)
    }
    
    override func replaceObject(at index: Int, with anObject: Any) {
        tempArray.replaceObject(at: index, with: anObject)
    }

}
