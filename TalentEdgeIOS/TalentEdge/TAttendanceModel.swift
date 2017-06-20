//
//  TAttendanceModel.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 14/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import Foundation
class TAttendanceModel:NSObject
{

    var module_name = String()
    var title = String()
    var id = String()
    var end_date = String()
    var start_date_formated = String()
    var start_date = String()
    var content_duration_formated = String()
    var content_duration = String()
    var total_invitees_in_live_class = String()
    var total_invitees_attended_in_live_class = String()
    var total_invitees_attended_in_recorded_class = String()
    var participation_percentage_in_live_class = String()
    var participation_percentage_in_recorded_class = String()
    var attendance_in_recorded_session = Bool()
    var average_percentage_in_live_class = NSNumber()
    var recorded_session_attendee_info_section = String()
    var content_duration_formatted = String()
    
    
    /*
     "module_name": "mods 11",
     "title": "Admin Dashboard Live Class 4",
     "id": "130",
     "end_date": "2017-04-20 11:25:00",
     "start_date_formated": "Apr 20, 2017 10:55 AM",
     "start_date": "2017-04-20 10:55:00",
     "content_duration": "30",
     "content_duration_formated": "30 Mins",
     "total_invitees_in_live_class": "2",
     "total_invitees_attended_in_live_class": "0",
     "total_invitees_attended_in_recorded_class": "0",
     "participation_percentage_in_live_class": "0",
     "participation_percentage_in_recorded_class": "0",
     "attendance_in_recorded_session": true,
     "average_percentage_in_live_class": 0,
     "recorded_session_attendee_info_section": "<strong>0</strong> <span><strong>[0%]</strong></span>"
     
     
     
     for assignment
     
     "id": "129",
     "title": "Assignment 3",
     "start_date": "2017-03-15 00:00:00",
     "start_date_formatted": "Mar 15, 2017",
     "end_date": "2017-08-31 00:00:00",
     "end_date_formatted": "Aug 31, 2017",
     "description": "test",
     "is_grading_done": "0",
     "avg_completion_percentage": "100",
     "is_graded": "Graded",
     "allowed_multiple": "0",
     "total_marks": "100",
     "passing_marks": "40",
     "submission_mode": "Offline",
     "cnt_submitted": "2",
     "cnt_not_submitted": "0",
     "module_name": "mods 1"

     
     

 */
   
}
