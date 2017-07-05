//
//  TEAttendenceList.swift
//  TalentEdge
//
//

import UIKit

class TEAttendenceList: NSObject {

    var live_session_attendance = NSAMutableArray().withClassName(DataUtils.convertStringForAltaObjectParser("TEAttendenceData"))
    var own_attendacne_percentage = NSNumber()
    var total_attendance_count = NSNumber()
    var total_class_count = NSNumber()
    
}

