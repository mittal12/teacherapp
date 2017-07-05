//
//  LearnerModel.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 24/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import Foundation

class LearnerModel:NSObject
{
//var basicModel = LearnerBasicInfoModel()
var attendance = String()
var query = NSNumber()
var assessment = LearnerBasicassessmentModel()
var assignment = LearnerBasicAssignmentModel()
    
    var id = NSNumber()
    var image = String()
    
    var name = String()
    var last_active = String()
    // var self` = NSNumber()
    var module_completed = String()
   
}
