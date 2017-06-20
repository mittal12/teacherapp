//
//  Constant.swift
//  TalentEdge
//
//

import UIKit

let JSONOBJECTPARSER = JsonObjectParser()
let AS_MUTABLEARRAY = NSAMutableArray()

let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate

let JSONPARSERKEY = "TalentEdge."


let kOrangeColor = DataUtils.colorWithHexString("e86822") // Orange color
let kBarButtonBottomDefaultColor = UIColor.clear
let kBarButtonBottomSelectedColor = DataUtils.colorWithHexString("008ebf")
let kBarButtonDefaultTextColor =  DataUtils.colorWithHexString("adadad")
let kGrayColor = UIColor.lightGray
let kNavigationBarColor = DataUtils.colorWithHexString("234796")
let IMAGE_URL = "http://sliq.talentedge.in/"
//let IMAGE_URL = "http://staging.talentedge.in/LMS/"
//let API_URL = "http://staging.talentedge.in/LMS/Api/"
//let API_URL = "http://staging.talentedge.in/dev/Api/"
let API_URL = "http://sliq.talentedge.in/Api/"


// API USED

let API_LOGIN = "login"
let API_LOGOUT = "logout"
let API_GET_COURSES_LIST = "courseList"
let API_GET_DISCUSSION_LIST = "getDiscussionList"
let API_GET_DISCUSSION_COMMENT_LIST = "getCommentList"
let API_GET_MODULE_LIST = "getModuleList"
let T_API_GET_BATCH_ANALYTICS = "getBatchAnalytics"
let API_GET_MODULE_CONTENT_LIST = "getContentList"
let API_GET_ASSESSNMENT_LIST = "assesmentList"
let API_GET_ASSESSMENT_DETAIL = "assesmentView"
let API_ASSESSMENT_REVIEW = "reviewTest"
let API_ASSESSMENT_REATTEMPT = "startTest"
let API_ASSESSMENT_SAVE = "saveAnswers"
let API_ASSESSMENT_COMPLETE = "completedTest"
let API_GET_ASSIGNMENT_LIST = "assignmentList"
let API_GET_ASSIGNMENT_DETAIL = "assignmentView"
let API_GET_TESTIMONIAL_LIST = "testimonials"
let API_ADD_TESTIMONIAL = "testimonialAdd"
let API_DELETE_TESTIMONIAL = "testimonialDelete"
let API_GET_LIVE_CLASS_LIST = "getLiveClassList"
let API_CHANGE_LIVE_CLASS_STATUS = "changeLiveClassStatus"
let API_JOIN_LIVE_CLASS = "joinLiveClass"
let API_GET_BATCHMATES_LIST = "finduserbybatch"
let API_GET_STUDENT_LIST = "getBatchStudentsListing"
let API_GET_ATTENDENCE_LIST = "myAttendance"
let API_SAVE_COMMENT = "saveComment"
let API_DELETE_COMMENT = "deleteComment"
let API_DELETE_MESSAGE = "messageDelete"
let API_SEND_MESSAGE = "messageCompose"
let API_MODULE_PLANNER_CONTENT = "getModulePlannerContentList"
let API_VIEW_INTERACTIVE_VIDEO = "viewVideo"
let API_VIEW_NOTES = "viewNotes"
let API_UPDATE_PROFILE = "updateProfile"
let API_FEATURED_COURSE_LIST = "suggestedCourseList"
let API_VIEW_NOTES_ACK = "contentAccessLog"
let API_UPLOAD_ASSIGNMENT = "uploadAssignment"

let API_GET_NOTIFICATION_LIST = "notificationList"
let API_VIEW_NOTIFICATION = "viewNotification"

let API_GET_MESSAGE_LIST = "messageList"

let API_FORGOT_PASSWORD = "forgotPassword"

let API_LIKE_CONTENT = "likeContent"
let API_NOTES_DETAILS = "facultyContentList"
let API_ATTENDANCE_COUNT = "getLiveClassAttendance"

class Constant: NSObject {

}
