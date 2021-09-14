//
//  MyTimesheetCell.swift
//  Trilegal
//
//  Created by Acxiom Consulting on 26/05/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.
//

import UIKit
import Foundation

class MyTimesheetCell: UITableViewCell {
    @IBOutlet weak var clientName : UILabel!
    @IBOutlet weak var matterName : UILabel!
    @IBOutlet weak var date : UILabel!
    @IBOutlet weak var time : UILabel!
    @IBOutlet weak var narration : UILabel!
    var actionBlock: (() -> Void)? = nil
    @IBOutlet var status: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet var mainview: UIStackView!
    @IBAction func view(_ sender: UIButton) {
        actionBlock?()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
