//
//  ReviewReimbursementAdapter.swift
//  Trilegal
//
//  Created by Acxiom Consulting on 26/05/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.
//

import Foundation
class ReviewReimbursementAdapter{
    var expenseDate: String?
    var amount: String?
    var clientName: String?
    var matterName: String?
    var remark: String?
    var status: String?
    var paymentType: String?
    var payto: String?
    var corporateCard: String?
    var expenseCatg: String?
    var costCenter: String?
    var noFileChoosenTxt: String?
    var debitToTxt: String?
    var btnState: String?
    var expenseno: String?
    var transactionId: String?
    
    init(expenseDate: String?, amount: String?,clientName: String?, matterName: String?,remark: String?,status: String?, paymentType: String?,payto: String?, corporateCard: String?,expenseCatg: String?, costCenter: String?,noFileChoosenTxt: String?,debitToTxt: String?,btnState: String?,expenseno: String?,transactionId: String?) {
        self.expenseDate = expenseDate
        self.amount = amount
        self.clientName = clientName
        self.matterName = matterName
        self.remark = remark
        self.status = status
        self.paymentType = paymentType
        self.payto = payto
        self.corporateCard = corporateCard
        self.expenseCatg = expenseCatg
        self.costCenter = costCenter
        self.noFileChoosenTxt = noFileChoosenTxt
        self.debitToTxt = debitToTxt
        self.btnState = btnState
        self.expenseno = expenseno
        self.transactionId = transactionId
    }
}
