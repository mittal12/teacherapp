//
//  student_session_info.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 12/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import Foundation
class student_session_info:NSObject
{
    var id = NSNumber()
    var fname = String()
    var lname = String()
    var email = String()
    var mobile_no = String()
    var pic = String()
    var session_type = String()
    var total_visits = NSNumber()
    var total_duration = NSNumber()
    var time_details = NSAMutableArray().withClassName(DataUtils.convertStringForAltaObjectParser("time_details"))
}
