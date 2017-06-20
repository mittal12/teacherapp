//
//  TLiveData.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 13/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import Foundation
class TLiveData:NSObject
{
/*
     "id": "130",
     "title": "Admin Dashboard Live Class 4",
     "start_date": "2017-04-20 10:55:00",
     "start_date_formatted": "Apr 20, 2017 10:55 AM",
     "end_date": "2017-04-20 11:25:00",
     "end_date_formatted": "Apr 20, 2017 11:25 AM",
     "description": "test",
     "content_duration": "30",
     "content_duration_formatted": "00:30 Hrs",
     "is_demo_live_class": "0",
     "total_invitees_in_live_class": "2",
     "total_invitees_attended_in_live_class": "0",
     "total_invitees_attended_in_recorded_class": "0",
     "participation_percentage_in_live_class": "0",
     "participation_percentage_in_recorded_class": "0",
     "attendance_in_recorded_session": "1",
     "recorded_session_url_synced": "0",
     "avg_time_live_class_attended": "",
     "avg_time_live_class_attended_formatted": "",
     "module_name": "mods 11"
     
     
     
     //get the attendance api json
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
     "recorded_session_attendee_info_section":
     
     
     
 */
    
    var id = String()
    var title = String()
    var start_date = String()
    var start_date_formatted = String()
    var end_date = String()
    var end_date_formatted = String()
   // var description = String()

    var content_duration = String()
     var content_duration_formatted = String()
     var is_demo_live_class = String()
     var total_invitees_in_live_class = String()
     var total_invitees_attended_in_live_class = String()
     var total_invitees_attended_in_recorded_class = String()
    
    var participation_percentage_in_live_class = String()
    var participation_percentage_in_recorded_class = String()
   
    var attendance_in_recorded_session = String()
    var recorded_session_url_synced = String()
    var avg_time_live_class_attended = String()
    var avg_time_live_class_attended_formatted = String()
    var module_name = String()
    
}
