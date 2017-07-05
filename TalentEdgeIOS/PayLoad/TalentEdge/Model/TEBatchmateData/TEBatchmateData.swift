//
//  TEBatchmateData.swift
//  TalentEdge
//
//

import UIKit

class TEBatchmateData: NSObject {
    var faculty = NSAMutableArray().withClassName(DataUtils.convertStringForAltaObjectParser("TEStudentData"))
    var srm = NSArray()
    var student = NSAMutableArray().withClassName(DataUtils.convertStringForAltaObjectParser("TEStudentData"))
}
