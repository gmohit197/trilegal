//  LOGINVC.swift
//  Trilegal
//
//  Created by Acxiom Consulting on 26/04/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.

import UIKit


class LOGINVC: BASEACTIVITY {
    var isCheck = false
    @IBOutlet weak var checkBoxOutlet:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        setCheckBoxImage()
    }
    
    @IBOutlet var usernamelbl: UITextField!
    @IBOutlet var pwdlbl: UITextField!
    
    @IBAction func loginBtnClick(_ sender: UIButton) {
        if (self.validate()){
            if (AppDelegate.ntwrk > 0){
                self.showIndicator("Logging in...", vc: self)
                self.postLoginAPI(userid: self.usernamelbl.text!, password: self.pwdlbl.text!)
            }else{
                self.showToast(message : "Enable internet")
            }
        }
    }
    
    func validate() -> Bool{
        var flag = true
        if (self.usernamelbl.text?.count == 0 ){
            flag = false
            self.showToast(message: "Please enter UserId")
        }else if (self.pwdlbl.text?.count == 0){
            self.showToast(message: "Please enter Password")
            flag = false
        }
        return flag
    }
    
    override func VD(){
        self.hideindicator()
        if (self.checkBoxOutlet.isSelected){
            UserDefaults.standard.setValue(true, forKey: "ischeck")
        }else{
            UserDefaults.standard.setValue(false, forKey: "ischeck")
        }
        UserDefaults.standard.setValue(self.usernamelbl.text! , forKey: "userid")
        UserDefaults.standard.setValue(self.pwdlbl.text!, forKey: "pwd")
        
        self.gotoHome()
        
    }
    
    override func INVD(msg: String) {
        self.hideindicator()
        self.showToast(message: msg)
    }
    
    @IBAction func checkBoxClicked(_ sender: UIButton) {
        animatebtn()
    }
    
    func setCheckBoxImage(){
        checkBoxOutlet.setImage(UIImage(named:"unchecking"), for: .normal)
        checkBoxOutlet.setImage(UIImage(named:"checking"), for: .selected)
    }
    
    func animatebtn(){
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
            self.checkBoxOutlet.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (success) in
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
                self.checkBoxOutlet.isSelected = !self.checkBoxOutlet.isSelected
                self.checkBoxOutlet.transform = .identity
                self.toggleclicked()
            }, completion: nil)
        }
    }
    
    func toggleclicked(){
        if (UserDefaults.standard.string(forKey: "userid") == nil || UserDefaults.standard.string(forKey: "userid") == ""){
            self.showToast(message: "Please login first")
            self.checkBoxOutlet.isSelected = false
        }
    }
}
