//
//  EditTimesheetAdapter.swift
//  Trilegal
//
//  Created by Acxiom Consulting on 28/05/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.
//

import Foundation
class EditTimesheetAdapter{
    var clientName: String?
    var matterName: String?
    var date: String?
    var time: String?
    var narration: String?
   
 
    init(clientName: String?, matterName: String?,date: String?, time: String?,narration: String?) {
        self.clientName = clientName
        self.matterName = matterName
        self.date = date
        self.time = time
        self.narration = narration
    }
}
