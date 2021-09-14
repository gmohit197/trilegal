//
//  MyTimeSheetAdapter.swift
//  Trilegal
//
//  Created by Acxiom Consulting on 26/05/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.
//

import Foundation
class MyTimeSheetAdapter{
    var clientName: String?
    var matterName: String?
    var date: String?
    var time: String?
    var narration: String?
    var status: String?
    var isbill: String?
    var isoffc: String?
 
    init(clientName: String?, matterName: String?,date: String?, time: String?,narration: String?,status: String?,isbill: String?, isoffc: String?) {
        self.clientName = clientName
        self.matterName = matterName
        self.date = date
        self.time = time
        self.narration = narration
        self.status = status
        self.isbill = isbill
        self.isoffc = isoffc
    }
}
