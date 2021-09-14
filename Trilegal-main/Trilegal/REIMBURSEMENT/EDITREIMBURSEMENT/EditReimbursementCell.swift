//
//  EditReimbursementCell.swift
//  Trilegal
//
//  Created by Acxiom Consulting on 28/05/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.
//

import UIKit

protocol OptionButtonsDelegateRemEdit{
    func closeFriendsTapped(at index:IndexPath)
    func toggleclicked(at index: IndexPath)
}
class EditReimbursementCell: UITableViewCell {
    var actionBlock: (() -> Void)? = nil
    var actionDeleteIcon: (() -> Void)? = nil
    var indexPath:IndexPath!
    
    @IBOutlet weak var btnClick : UIButton!
    @IBOutlet weak var expenseDate: UILabel!
    @IBOutlet weak var deleteBtnClick : UIButton!
    @IBOutlet weak var editBtnClick : UIButton!
    @IBOutlet weak var remark: UILabel!
    @IBOutlet weak var matterName: UILabel!
    @IBOutlet weak var amount : UILabel!
    @IBOutlet weak var clientName : UILabel!
    @IBOutlet weak var rejectRemark : UILabel!
    @IBOutlet weak var paymentType : UILabel!


    var actionEditIcon: (() -> Void)? = nil
    var delegate1:OptionButtonsDelegateRemEdit!
    var uid: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnClick.setImage(UIImage(named:"unselected1"), for: .normal)
        btnClick.setImage(UIImage(named:"selected1"), for: .selected)    }
    
    @IBAction func closeFriendsAction(_ sender: UIButton) {
        animatebtn()
    }
    @IBAction func editBtnAction(_ sender: UIButton) {
        actionEditIcon?()
    }
    @IBAction func deleteBtnAction(_ sender: UIButton) {
        actionDeleteIcon?()
    }
    func animatebtn(){
           UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
               self.btnClick.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
           }) { (success) in
               UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
                   self.btnClick.isSelected = !self.btnClick.isSelected
                   self.btnClick.transform = .identity
                self.update()
                self.delegate1.toggleclicked(at: self.indexPath)
               }, completion: nil)
           }
       }
    func update(){
        let db = DBConnection()
        db.updatestatusEditRem(status: self.btnClick.isSelected ? "1" : "0", ExpenseNumber: self.uid)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
