//
//  EditReimbursementFileAttachmentCell.swift
//  Trilegal
//
//  Created by Acxiom Consulting on 15/07/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.
//


import UIKit
import Foundation

class EditReimbursementFileAttachmentCell: UITableViewCell {
    var indexPath:IndexPath!
    @IBOutlet weak var filename: UILabel!
    var actionDeleteIcon: (() -> Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func actionDeleteIcon(_ sender: UIButton) {
        actionDeleteIcon?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

