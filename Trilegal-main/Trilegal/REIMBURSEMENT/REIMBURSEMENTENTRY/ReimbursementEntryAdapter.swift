//  ReimbursementEntryAdapter.swift
//  Trilegal
//  Created by Acxiom Consulting on 25/05/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.

import Foundation
class ReimbursementEntryAdapter{
    var Id: String?
    var expenseDate: String?
    var amount: String?
    var clientName: String?
    var matterName: String?
    var remark: String?
    var expenseCategory: String?
    var btnState: String?
 
    init(Id:String?,expenseDate: String?, amount: String?,clientName: String?, matterName: String?,remark: String? , expenseCategory :String?, btnState :String?) {
        self.Id = Id
        self.expenseDate = expenseDate
        self.amount = amount
        self.clientName = clientName
        self.matterName = matterName
        self.remark = remark
        self.expenseCategory = expenseCategory
        self.btnState = btnState
    }
}
