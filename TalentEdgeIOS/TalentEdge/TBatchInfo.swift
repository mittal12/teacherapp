//
//  TBatchInfo.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 02/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import Foundation

class TEBatchInfo:NSObject
{
    var batch = Batch()
    var course = Course()
    var institute = Institute()
    var faculty = NSArray()
    var analytics = Analytics()
    var queries = Queries()
    var live_classes = NSAMutableArray().withClassName(DataUtils.convertStringForAltaObjectParser("Live_Classes"))
    var notes = NSAMutableArray().withClassName(DataUtils.convertStringForAltaObjectParser("NotesAndVideo"))
    var video = NSAMutableArray().withClassName(DataUtils.convertStringForAltaObjectParser("NotesAndVideo"))
    var assignment = NSAMutableArray().withClassName(DataUtils.convertStringForAltaObjectParser("NotesAndVideo"))
    var assessment = NSAMutableArray().withClassName(DataUtils.convertStringForAltaObjectParser("NotesAndVideo"))
    
}
