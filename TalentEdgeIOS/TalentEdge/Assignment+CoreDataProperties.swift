//
//  Assignment+CoreDataProperties.swift
//  TalentEdge
//
//

import Foundation
import CoreData


extension Assignment {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest(entityName: "Assignment");
    }

    @NSManaged public var name: String?
    @NSManaged public var file: Data?

}
