//
//  student_attempt_info.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 12/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import Foundation

class student_attempt_info:NSObject
{
   /* "user_id": "33",
    "name": "Rajat Singh",
    "email": "yabc@mailinator.com",
    "pic": "http://localhost/LMS/img/img.jpg",
    "total_questions": "2",
    "attempt_id": "",
    "time_taken": 0,
    "marks": 0,
    "wrong_questions": 0,
    "correct_questions": 0,
    "attempted_questions": 0,
    "skipped_questions": 0,
    "total_marks": "100",
    "date_attempted": "",
    "date_attempted_formatted": ""
 */
    
    var user_id = NSNumber()
    var name = String()
    var email = String()
    var pic = String()
    var total_questions = NSNumber()
    var attempt_id = String()
    var time_taken = NSNumber()
    var marks = NSNumber()
    var wrong_questions = NSNumber()
    var correct_questions = NSNumber()
    var attempted_questions = NSNumber()
    var skipped_questions = NSNumber()
    var total_marks = NSNumber()
    var date_attempted = String()
    var date_attempted_formatted = String()
    
}
