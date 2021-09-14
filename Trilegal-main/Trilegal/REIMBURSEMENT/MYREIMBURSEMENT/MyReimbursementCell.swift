//
//  MyReimbursementCell.swift
//  Trilegal
//
//  Created by Acxiom Consulting on 26/05/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.
//

import UIKit
import Foundation

class MyReimbursementCell: UITableViewCell {

    @IBOutlet weak var expenseDate: UILabel!
    @IBOutlet weak var remark: UILabel!
    @IBOutlet weak var matterName: UILabel!
    @IBOutlet weak var amount : UILabel!
    @IBOutlet weak var clientName : UILabel!
    @IBOutlet weak var status : UILabel!
    @IBOutlet weak var paymentType : UILabel!

    var actionEditIcon: (() -> Void)? = nil
    @IBOutlet weak var editBtnClick : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func editBtnAction(_ sender: UIButton) {
        actionEditIcon?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
