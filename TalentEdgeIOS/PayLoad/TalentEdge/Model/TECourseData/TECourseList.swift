//
//  TECourseList.swift
//  TalentEdge
//
//

import UIKit

class TECourseList: NSObject {

    var ongoingCourse = NSAMutableArray().withClassName(DataUtils.convertStringForAltaObjectParser("TECourseData"))
    var completedCourse = NSAMutableArray().withClassName(DataUtils.convertStringForAltaObjectParser("TECourseData"))
    var facultyOngoingCourse = NSAMutableArray().withClassName(DataUtils.convertStringForAltaObjectParser("TECourseData"))
    var facultyCompletedCourse = NSAMutableArray().withClassName(DataUtils.convertStringForAltaObjectParser("TECourseData"))
    var unread_notification = NSNumber()
}
