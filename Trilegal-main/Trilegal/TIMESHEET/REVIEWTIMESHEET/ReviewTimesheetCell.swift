//
//  ReviewTimesheetCell.swift
//  Trilegal
//
//  Created by Acxiom Consulting on 26/05/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.
//

import Foundation
import UIKit

class ReviewTimesheetCell: UITableViewCell {
    var actionBlock: (() -> Void)? = nil
    var indexPath:IndexPath!
    @IBOutlet weak var btnClick : UIButton!
    @IBOutlet weak var clientName : UILabel!
    @IBOutlet weak var matterName : UILabel!
    @IBOutlet weak var date : UILabel!
    @IBOutlet weak var time : UILabel!
    @IBOutlet weak var narration : UILabel!
    var uid : String!
    var delegate:OptionButtonsDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnClick.setImage(UIImage(named:"unselected1"), for: .normal)
        btnClick.setImage(UIImage(named:"selected1"), for: .selected)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func details(_ sender: UIButton) {
        actionBlock?()
    }
    
    
    @IBAction func selectbtn(_ sender: UIButton) {
        self.animatebtn()
    }
    
    func animatebtn(){
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            self.btnClick.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
                self.btnClick.isSelected = !self.btnClick.isSelected
                self.btnClick.transform = .identity
                self.update()
                self.delegate.toggleclicked(at: self.indexPath)
            }, completion: nil)
        }
    }
    
    func update(){
        let db = DBConnection()
        db.updateeditstatus(status: self.btnClick.isSelected ? "1" : "0", uid: self.uid)
    }
}

