//
//  TimeSheetEntryAdapter.swift
//  Trilegal
//
//  Created by Acxiom Consulting on 24/05/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.
//

import Foundation
class TimeSheetEntryAdapter{
    var uid: String?
    var clientName: String?
    var matterName: String?
    var date: String?
    var time: String?
    var narration: String?
    var btnState: String?
    var status: String?
    var isbill: String?
    var isoffc: String?
    var remark: String?
 
    init(uid: String?,clientName: String?, matterName: String?,date: String?, time: String?,narration: String? ,btnState: String?,status: String? = "",isbill: String?, isoffc: String?,remark: String = "") {
        self.uid = uid
        self.clientName = clientName
        self.matterName = matterName
        self.date = date
        self.time = time
        self.narration = narration
        self.btnState = btnState
        self.status = status
        self.isbill = isbill
        self.isoffc = isoffc
        self.remark = remark
    }
}
