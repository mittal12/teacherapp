//
//  TSAssessmentTestQuestion.swift
//  TalentEdge
//
//

import UIKit

class TSAssessmentTestQuestion: NSObject {
    
    var Question = TEAssesmentTestQuestionQuestion()
    var QuestionOption = NSAMutableArray().withClassName(DataUtils.convertStringForAltaObjectParser("TSAssementQuestionOption"))
    
    var isFlag = Bool()
}
