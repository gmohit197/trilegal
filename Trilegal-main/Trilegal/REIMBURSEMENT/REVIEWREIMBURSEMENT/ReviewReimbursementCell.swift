//
//  ReviewReimbursementCell.swift
//  Trilegal
//
//  Created by Acxiom Consulting on 26/05/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.
//

import UIKit
import Foundation

protocol OptionButtonsDelegateReview{
    func toggleclicked(at index: IndexPath)
}

class ReviewReimbursementCell: UITableViewCell {
     var actionBlock: (() -> Void)? = nil
    @IBOutlet weak var btnClick : UIButton!
    @IBOutlet weak var expenseDate: UILabel!
    @IBOutlet weak var remark: UILabel!
    @IBOutlet weak var matterName: UILabel!
    @IBOutlet weak var amount : UILabel!
    @IBOutlet weak var clientName : UILabel!
    @IBOutlet weak var editBtnClick : UIButton!
    
    var actionEditIcon: (() -> Void)? = nil
    var uid : String!
    var delegateReview:OptionButtonsDelegateReview!
    var indexPath:IndexPath!

    override func awakeFromNib() {
        super.awakeFromNib()
        btnClick.setImage(UIImage(named:"unselected1"), for: .normal)
        btnClick.setImage(UIImage(named:"selected1"), for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func editBtnAction(_ sender: UIButton) {
        actionEditIcon?()
    }
    
    @IBAction func closeFriendsAction(_ sender: UIButton) {
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
                self.delegateReview.toggleclicked(at: self.indexPath)
            }, completion: nil)
        }
    }
    
    func update(){
        let db = DBConnection()
        db.updatestatusEditRemTrans(status: self.btnClick.isSelected ? "1" : "0", TransactionId: self.uid)
    }
}
