//
//  TEDiscussionCommentData.swift
//  TalentEdge
//
//

import UIKit

class TEDiscussionCommentData: NSObject {

    var comments = NSAMutableArray().withClassName(DataUtils.convertStringForAltaObjectParser("TEComment"))
    var discussion = TEDiscussion()
}
