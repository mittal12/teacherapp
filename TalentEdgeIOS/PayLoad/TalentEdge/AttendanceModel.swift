//
//  AttendanceModel.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 14/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import Foundation
class AttendanceModel:NSObject
{
    var liveSessionAttendance = NSAMutableArray().withClassName(DataUtils.convertStringForAltaObjectParser("TAttendanceModel"))
    var batchPaticipationDetails = batchPaticipationDetailsModel()
}
