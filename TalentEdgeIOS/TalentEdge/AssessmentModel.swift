//
//  AssessmentModel.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 14/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import Foundation

class AssessmentModel:NSObject
{
            var id = String()
            var title = String()
            var start_date = String()
            var start_date_formatted = String()
            var end_date = String()
            var end_date_formatted = String()
            //  var description = String()
            var avg_completion_percentage = String()
            var total_questions = NSNumber()
            var total_duration = String()
            var total_duration_formatted = String()
            var total_marks = NSNumber()
            var test_type = String()
            var cnt_attempted = String()
            var cnt_not_attempted = String()
            var module_name = String()

}
