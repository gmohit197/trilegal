//
//  ReimbursementFileAttachmentCell.swift
//  Trilegal
//
//  Created by Acxiom Consulting on 15/07/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.
//
//create table if not exists  AttachmentFileDetails(filename text,fileStr text ,id text,post text,extension text,fileid text)
import UIKit
import Foundation

class ReimbursementFileAttachmentCell: UITableViewCell {
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

