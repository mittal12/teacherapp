//
//  TEModuleDetailData.swift
//  TalentEdge
//
//

import UIKit

open class TEModuleDetailData: NSObject {
    var id = NSNumber()
    var parent_id = NSNumber()
    var module_id = NSNumber()
    var module_name = String()
    var title = String()
    var desc = String()
    var content_type_id = NSNumber()
    var submission_mode = String()
    var allow_edit = NSNumber()
    var is_graded = String()
    var total_marks = NSNumber()
    var total_marks_label = String()
    var passing_marks = String()
    var passing_marks_label = String()
    var is_draft = NSNumber()
    var allow_view = NSNumber()
    var submission_count = NSNumber()
    var submission_label = String()
    var start_date_label = String()
    var start_date_value = String()
    var action = String()
    var ref_type = String()
    var content_path = String()
    var content_duration_formated = String()
    var end_date_label = String()
    var end_date_value = String()
    var published_by_label = String()
    var published_by_value = String()
    var completion_percentage = NSNumber()
    var notes_count = NSNumber()
    var start_date = String()
    var total_questions = NSNumber()
    var total_duration = String()
    var is_locked = NSNumber()
    var total_assessment = NSNumber()
    var total_assignment = NSNumber()
    var total_interactive_video = NSNumber()
    var total_notes = NSNumber()
    var total_video = NSNumber()
    var view_count = NSNumber()
    var likes_count = NSNumber()
    var avg_completion_percentage = NSNumber()
    var cnt_completed = NSNumber()
    var cnt_not_completed = NSNumber()
    
    var total_invitees_attended_in_live_class = NSNumber()
    var total_invitees_attended_in_recorded_class = NSNumber()
   
    var participation_percentage_in_live_class = NSNumber()
    var participation_percentage_in_recorded_class = NSNumber()
   // var attendance_in_recorded_session = NSNumber()
//for assessment
    var cnt_attempted = NSNumber()
    var cnt_not_attempted = NSNumber()
    
    //for assignment
    var cnt_submitted = NSNumber()
    var cnt_not_submitted = NSNumber()
   // open var description = NSString()

    var test_type = NSNumber()
    var test_type_label = String()
}

