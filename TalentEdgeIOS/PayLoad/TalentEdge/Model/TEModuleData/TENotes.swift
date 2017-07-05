//
//  TENotes.swift
//  TalentEdge
//
//

import UIKit

open class TENotes: NSObject {

    var id = NSNumber()
    var title = String()
    var desc = String()
    var content_type_id = NSNumber()
    var start_date = String()
    var end_date = String()
    var allow_download = NSNumber()
    var created = String()
    var created_by = String()
    var like = NSNumber()
    var like_text = String()
    var completion_percentage = NSNumber()
    var base_path = String()
    var content_path = String()
    var user_content_view = NSDictionary()
    var note = NSAMutableArray().withClassName(DataUtils.convertStringForAltaObjectParser("TENoteContent"))
}
