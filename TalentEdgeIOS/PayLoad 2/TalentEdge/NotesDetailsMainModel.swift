//
//  NotesDetailsMainModel.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 11/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import Foundation
class NotesDetailsMainModel :NSObject
{
        var content_info = NSAMutableArray().withClassName(DataUtils.convertStringForAltaObjectParser("NotesDetailsModel"))
     var student_view_info = NSAMutableArray().withClassName(DataUtils.convertStringForAltaObjectParser("Student_view_info"))
}
