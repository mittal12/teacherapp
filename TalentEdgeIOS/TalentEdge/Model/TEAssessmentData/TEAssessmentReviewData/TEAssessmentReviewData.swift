//
//  TEAssessmentReviewData.swift
//  TalentEdge
//
//

import UIKit

class TEAssessmentReviewData: NSObject {

    var Content = TEAssessmentReviewContent()
    var Module = TEAssessmentModule()
    var Test = TEAssessmentReviewTest()
    var AttemptDetails = TEAssessmentAttemptDetails()
    var TestQuestion = NSAMutableArray().withClassName(DataUtils.convertStringForAltaObjectParser("TSAssessmentTestQuestion"))

}
