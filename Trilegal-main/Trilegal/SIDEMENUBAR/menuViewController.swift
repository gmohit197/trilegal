//
//  menuViewController.swift
//  Trilegal
//
//  Created by Acxiom Consulting on 27/05/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.
//

import UIKit

class menuViewController: BASEACTIVITY {
    @IBOutlet weak var homeStackView: UIStackView!
    @IBOutlet weak var timesheetEntryStackView: UIStackView!
    @IBOutlet weak var myTimesheetStackView: UIStackView!
    @IBOutlet weak var reviewTmesheetStackView: UIStackView!
    @IBOutlet weak var editTimesheetStackView: UIStackView!
    @IBOutlet weak var myCalendarStackView: UIStackView!
    @IBOutlet weak var reimbursementEntryStackView: UIStackView!
    @IBOutlet weak var myReimbursementStackView: UIStackView!
    @IBOutlet weak var reviewReimbursementStackView: UIStackView!
    @IBOutlet weak var editReimbursementStackView: UIStackView!
    @IBOutlet weak var logoutStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuvc = (self.storyboard?.instantiateViewController(withIdentifier: "menuViewController") as! menuViewController)
        homeStackView.isUserInteractionEnabled = true
        
        let tapHome = UITapGestureRecognizer(target: self, action: #selector(clickHome))
        tapHome.numberOfTapsRequired=1
        homeStackView.addGestureRecognizer(tapHome)
        
        timesheetEntryStackView.isUserInteractionEnabled = true
        let taptimesheetntry = UITapGestureRecognizer(target: self, action: #selector(clicktimesheetntry))
        taptimesheetntry.numberOfTapsRequired=1
        timesheetEntryStackView.addGestureRecognizer(taptimesheetntry)
        
        myTimesheetStackView.isUserInteractionEnabled = true
        let tapTimesheet = UITapGestureRecognizer(target: self, action: #selector(clickTimesheet))
        tapTimesheet.numberOfTapsRequired=1
        myTimesheetStackView.addGestureRecognizer(tapTimesheet)
        
        reviewTmesheetStackView.isUserInteractionEnabled = true
        let tapReviewTimesheet = UITapGestureRecognizer(target: self, action: #selector(clickReviewTimesheet))
        tapReviewTimesheet.numberOfTapsRequired=1
        reviewTmesheetStackView.addGestureRecognizer(tapReviewTimesheet)
        
        editTimesheetStackView.isUserInteractionEnabled = true
        let tapEditTimesheet = UITapGestureRecognizer(target: self, action: #selector(clickEditTimesheet))
        tapEditTimesheet.numberOfTapsRequired=1
        editTimesheetStackView.addGestureRecognizer(tapEditTimesheet)
        
        myCalendarStackView.isUserInteractionEnabled = true
        let tapCalendar = UITapGestureRecognizer(target: self, action: #selector(clickCalendar))
        tapCalendar.numberOfTapsRequired=1
        myCalendarStackView.addGestureRecognizer(tapCalendar)
        
        reimbursementEntryStackView.isUserInteractionEnabled = true
        let tapreimbursementEntry = UITapGestureRecognizer(target: self, action: #selector(clickReimbursementEntry))
        tapreimbursementEntry.numberOfTapsRequired=1
        reimbursementEntryStackView.addGestureRecognizer(tapreimbursementEntry)
        
        myReimbursementStackView.isUserInteractionEnabled = true
        let tapMyReimbursement = UITapGestureRecognizer(target: self, action: #selector(clickMyReimbursement))
        tapMyReimbursement.numberOfTapsRequired=1
        myReimbursementStackView.addGestureRecognizer(tapMyReimbursement)
        
        reviewReimbursementStackView.isUserInteractionEnabled = true
        let tapReviewReimbursement = UITapGestureRecognizer(target: self, action: #selector(clickReviewReimbursement))
        tapReviewReimbursement.numberOfTapsRequired=1
        reviewReimbursementStackView.addGestureRecognizer(tapReviewReimbursement)
        
        editReimbursementStackView.isUserInteractionEnabled = true
        let tapEditReimbursement = UITapGestureRecognizer(target: self, action: #selector(clickEditReimbursement))
        tapEditReimbursement.numberOfTapsRequired=1
        editReimbursementStackView.addGestureRecognizer(tapEditReimbursement)
        
        logoutStackView.isUserInteractionEnabled = true
        let tapLogout = UITapGestureRecognizer(target: self, action: #selector(clickLogout))
        tapLogout.numberOfTapsRequired=1
        logoutStackView.addGestureRecognizer(tapLogout)
    }
    @objc func clickLogout(){
        //        AppDelegate.nextScreen = "LOGOUT"
        //        self.hidemenuCLick()
        ////        if(AppDelegate.showAlert && self.isNotCurrScreenHome()){
        ////            self.push(storybId: "LOGIN", vcId: "LOGINNC", vc: self)
        ////        }
        AppDelegate.nextScreen = "LOGOUT"
        self.hidemenuCLick()
        if(CheckShowAlert()){
            if(AppDelegate.showAlert && self.isNotCurrScreenHome() && self.checkNextScreen()){
                ShowAlert(storybId: "LOGIN", vcId: "LOGINNC")
                self.deletetable(tbl: "ReimbursementEntry")
                self.deletetable(tbl: "TSEentry")
            }
            else {
                self.deletetable(tbl: "ReimbursementEntry")
                self.deletetable(tbl: "TSEentry")
                self.push(storybId: "LOGIN", vcId: "LOGINNC", vc: self)
            }
        }
    }
    
    func CheckShowAlert() -> Bool{
        if (AppDelegate.nextScreen == AppDelegate.currScreen){
            return false
        }
        self.hidemenuCLick()
        return true
    }
    
    func checkNextScreen() -> Bool{
        if (AppDelegate.currScreen == "RVRE" || AppDelegate.currScreen == "MYRE" || AppDelegate.currScreen == "REVIEWTS" || AppDelegate.currScreen == "MYTS" || AppDelegate.currScreen == "CALENDAR" ){
            return false
        }
        return true
    }
    
    @objc func clickEditReimbursement(){
        AppDelegate.nextScreen = "EDITRE"
        self.hidemenuCLick()
        if(CheckShowAlert()){
            if(AppDelegate.showAlert && self.isNotCurrScreenHome() && self.checkNextScreen()){
            ShowAlert(storybId: "EDITREIMBURSEMENT", vcId: "EDITREIMBURSEMENTNC")
        }
        else {
            self.push(storybId: "EDITREIMBURSEMENT", vcId: "EDITREIMBURSEMENTNC", vc: self)
        }
        }
    }
    @objc func clickReviewReimbursement(){
        AppDelegate.nextScreen = "RVRE"
        self.hidemenuCLick()
        if(CheckShowAlert()){
        if(AppDelegate.showAlert && self.isNotCurrScreenHome() && self.checkNextScreen()){
            ShowAlert(storybId: "REVIEWREIMBURSEMENT", vcId: "REVIEWREIMBURSEMENTNC")
        }
        else {
            self.push(storybId: "REVIEWREIMBURSEMENT", vcId: "REVIEWREIMBURSEMENTNC", vc: self)
        }
        }
    }
    @objc func clickMyReimbursement(){
        AppDelegate.nextScreen = "MYRE"
        self.hidemenuCLick()
        if(CheckShowAlert()){
        if(AppDelegate.showAlert && self.isNotCurrScreenHome() && self.checkNextScreen()){
            ShowAlert(storybId: "MYREIMBURSEMENT", vcId: "MYREIMBURSEMENTNC")
        }
        else {
            self.push(storybId: "MYREIMBURSEMENT", vcId: "MYREIMBURSEMENTNC", vc: self)
        }
        }
    }
    @objc func clickReimbursementEntry(){
        AppDelegate.nextScreen = "RE"
        self.hidemenuCLick()
        if(CheckShowAlert()){
        if(AppDelegate.showAlert && self.isNotCurrScreenHome() && self.checkNextScreen()){
            ShowAlert(storybId: "REIMBURSEMENTENTRY", vcId: "REIMBURSEMENTENTRYNC")
        }
        else {
            self.push(storybId: "REIMBURSEMENTENTRY", vcId: "REIMBURSEMENTENTRYNC", vc: self)
        }
        }
    }
    @objc func clickCalendar(){
        AppDelegate.nextScreen = "CALENDAR"
        self.hidemenuCLick()
        if(CheckShowAlert()){
            if(AppDelegate.showAlert && self.isNotCurrScreenHome() && self.checkNextScreen()){
                ShowAlert(storybId: "CALENDAR", vcId: "CALENDARNC")
            }
            else {
                self.push(storybId: "CALENDAR", vcId: "CALENDARNC", vc: self)
            }
        }
    }
    
    func isNotCurrScreenHome()->Bool{
        if AppDelegate.currScreen == "HOME"{
            self.hidemenuCLick()
            return false
        }
        return true
    }
    
    @objc func clickEditTimesheet(){
        AppDelegate.nextScreen = "EDITTS"
        self.hidemenuCLick()
        if(CheckShowAlert()){
            if(AppDelegate.showAlert && self.isNotCurrScreenHome() && self.checkNextScreen()){
                ShowAlert(storybId: "EDITTIMESHEET", vcId: "EDITTIMESHEETNC")
            }
            else {
                self.push(storybId: "EDITTIMESHEET", vcId: "EDITTIMESHEETNC", vc: self)
            }
        }
    }
    
    @objc func clickReviewTimesheet(){
        AppDelegate.nextScreen = "REVIEWTS"
        self.hidemenuCLick()
        if(CheckShowAlert()){
            if(AppDelegate.showAlert && self.isNotCurrScreenHome() && self.checkNextScreen()){
                ShowAlert(storybId: "REVIEWTIMESHEET", vcId: "REVIEWTIMESHEETNC")
            }
            else {
                self.push(storybId: "REVIEWTIMESHEET", vcId: "REVIEWTIMESHEETNC", vc: self)
            }
        }
    }
    
    
    
    @objc func clicktimesheetntry(){
        AppDelegate.nextScreen = "TS"
        self.hidemenuCLick()
        if(CheckShowAlert()){
        if(AppDelegate.showAlert && self.isNotCurrScreenHome() && self.checkNextScreen()){
            ShowAlert(storybId: "TIMESHEETENTRY", vcId: "TIMESHEETENTRYNC")
        }
        else {
            self.push(storybId: "TIMESHEETENTRY", vcId: "TIMESHEETENTRYNC", vc: self)
        }
    }
    }
    
    @objc func clickHome(){
        AppDelegate.nextScreen = "HOME"
        self.hidemenuCLick()
        if(CheckShowAlert()){
        if(AppDelegate.showAlert && self.isNotCurrScreenHome() && self.checkNextScreen()){
            ShowAlert(storybId: "HOME", vcId: "HOMENC")
        }
        else {
            self.push(storybId: "HOME", vcId: "HOMENC", vc: self)
        }
    }
    }
    
    @objc func clickTimesheet(){
        AppDelegate.nextScreen = "MYTS"
        self.hidemenuCLick()
        if(CheckShowAlert()){
        if(AppDelegate.showAlert && self.isNotCurrScreenHome() && self.checkNextScreen()){
            ShowAlert(storybId: "MYTIMESHEET", vcId: "MYTIMESHEETNC")
        }
        else {
            self.push(storybId: "MYTIMESHEET", vcId: "MYTIMESHEETNC", vc: self)
        }
    }
    }
    
   
    
    func ShowAlert(storybId : String , vcId : String ){
        let alertController = UIAlertController(title: "", message: "Are you sure you want to discard your unsaved changes?", preferredStyle: .alert)
        // Create the actions
        let cancelAction = UIAlertAction(title: "KEEP EDITING", style: UIAlertAction.Style.default) {
            UIAlertAction in
            let topvc = UIApplication.getTopViewController(base: self)
            self.hidemenuNew(vc : topvc!)
        }
        let okAction = UIAlertAction(title: "DISCARD CHANGES", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.push(storybId: storybId , vcId: vcId, vc: self)
        }
        // Add the actions
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func isIntent(Enabled : Bool) -> Bool{
        return Enabled
    }
    
}
