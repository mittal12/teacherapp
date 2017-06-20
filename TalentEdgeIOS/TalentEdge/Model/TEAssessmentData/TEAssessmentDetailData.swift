//
//  TEAssessmentDetailData.swift
//  TalentEdge
//
//

import UIKit

class TEAssessmentDetailData: NSObject {

    var Content = TEAssessmentContent()
    var Module = TEAssessmentModule()
    var Test = TEAssessmentTest()
    var TestQuestion = NSAMutableArray().withClassName(DataUtils.convertStringForAltaObjectParser("TEAsssessmentTestQuestion"))
    var is_already_attempt = NSNumber()
    var canAttempt = NSNumber()
    
}
