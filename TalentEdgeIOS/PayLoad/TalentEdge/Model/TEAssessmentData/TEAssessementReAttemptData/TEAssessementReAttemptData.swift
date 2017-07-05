//
//  TEAssessementReAttemptData.swift
//  TalentEdge
//
//

import UIKit

class TEAssessementReAttemptData: NSObject {
    var Content = TEAssessmentReviewContent()
    var Module = TEAssessmentModule()
    var Test = TEAssessmentReviewTest()
    var TestQuestion = NSAMutableArray().withClassName(DataUtils.convertStringForAltaObjectParser("TSAssessmentTestQuestion"))

}
