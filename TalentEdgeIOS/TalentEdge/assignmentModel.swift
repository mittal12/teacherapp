//
//  assignmentModel.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 14/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import Foundation

class AssignmentModel:NSObject
{
    var id = String()
    var title = String()
    var start_date = String()
    var start_date_formatted = String()
    var end_date = String()
    var end_date_formatted = String()
    // var description = String()
    var is_grading_done = String()
    var avg_completion_percentage = String()
    var is_graded = String()
    var allowed_multiple = String()
    var total_marks = NSNumber()
    var passing_marks = String()
    var submission_mode = String()
    var cnt_submitted = String()
    var cnt_not_submitted = String()
    var module_name = String()
}
