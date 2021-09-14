//
//  HOMEVC.swift
//  Trilegal
//
//  Created by Acxiom Consulting on 27/04/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.

import UIKit
import Firebase
import FirebaseCrashlytics

class HOMEVC: BASEACTIVITY {

    @IBOutlet weak var timesheetEntry: UIView!
    @IBOutlet weak var myTimeSheet: UIView!
    @IBOutlet weak var reviewTimeSheet: UIView!
    @IBOutlet weak var editTimeSheet: UIView!
    @IBOutlet weak var reimbursementEntry: UIView!
    @IBOutlet weak var myReimbursement: UIView!
    @IBOutlet weak var reviewReimbursement: UIView!
    @IBOutlet weak var editReimbursement: UIView!
    @IBOutlet weak var myCalendar: UIView!
    override func viewWillAppear(_ animated: Bool) {
        sync_check()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.currScreen = "HOME"
        navigationController?.setNavigationBarHidden(false, animated: true)
        if(setName().count>15){
            self.setnav(controller: self, title: "Home" , spacing : 100)
        }
        else{
            self.setnav(controller: self, title: "Home" , spacing : 150)
        }
        setUpSideBar()
        getOnClick()
    }
    
    
    func sync_check(){
        if (self.getdate (format: "yyyy-MM-dd") != UserDefaults.standard.string(forKey: "syncdate") || UserDefaults.standard.string(forKey: "yyyy-MM-dd") == nil){
            self.api = 0
            self.downloadall()
        }
    }
    
    var api = 0
    
    override func VD() {
        self.api += 1
        if (self.api == CONSTANT.apicall){
            self.hideindicator()
            if (CONSTANT.failapi > 0){
//                self.showToast(message: "Data Sync failed...")
            }else{
//                self.showToast(message: "Data synced successfully")
                UserDefaults.standard.setValue(self.getdate(format: "yyyy-MM-dd"), forKey: "syncdate")
            }
            
        }
    }
    
    //CALENDARVC
    @objc
    func clicktimesheetEntry(sender : UITapGestureRecognizer) {
        self.push(storybId: "TIMESHEETENTRY", vcId: "TIMESHEETENTRYNC", vc: self)
    }
    @objc
    func clickmyTimeSheet(sender : UITapGestureRecognizer) {
        self.push(storybId: "MYTIMESHEET", vcId: "MYTIMESHEETNC", vc: self)
    }
    @objc
    func clickreviewTimeSheet(sender : UITapGestureRecognizer) {
        self.push(storybId: "REVIEWTIMESHEET", vcId: "REVIEWTIMESHEETNC", vc: self)
    }
    @objc
    func clickeditTimeSheet(sender : UITapGestureRecognizer) {
        self.push(storybId: "EDITTIMESHEET", vcId: "EDITTIMESHEETNC", vc: self)
    }
    @objc
    func clickreimbursementEntry(sender : UITapGestureRecognizer) {
        self.push(storybId: "REIMBURSEMENTENTRY", vcId: "REIMBURSEMENTENTRYNC", vc: self)
    }
    @objc
    func clickmyReimbursement(sender : UITapGestureRecognizer) {
        self.push(storybId: "MYREIMBURSEMENT", vcId: "MYREIMBURSEMENTNC", vc: self)
    }
    @objc
    func clickreviewReimbursement(sender : UITapGestureRecognizer) {
        self.push(storybId: "REVIEWREIMBURSEMENT", vcId: "REVIEWREIMBURSEMENTNC", vc: self)
    }
    @objc
    func clickeditReimbursement(sender : UITapGestureRecognizer) {
        self.push(storybId: "EDITREIMBURSEMENT", vcId: "EDITREIMBURSEMENTNC", vc: self)
    }
    
    @objc
    func clickmyCalendar(sender : UITapGestureRecognizer) {
        self.push(storybId: "CALENDAR", vcId: "CALENDARNC", vc: self)
    }
    
    @IBAction func sideMenuBtn(_ sender: UIBarButtonItem) {
        onClickSideMenu()
    }
    
    func getOnClick(){
        let timesheetEntrygesture = UITapGestureRecognizer(target: self, action:  #selector(self.clicktimesheetEntry(sender:)))
        self.timesheetEntry.addGestureRecognizer(timesheetEntrygesture)
        
        let myTimeSheetgesture = UITapGestureRecognizer(target: self, action:  #selector(self.clickmyTimeSheet(sender:)))
        self.myTimeSheet.addGestureRecognizer(myTimeSheetgesture)
        
        let reviewTimeSheetgesture = UITapGestureRecognizer(target: self, action:  #selector(self.clickreviewTimeSheet(sender:)))
        self.reviewTimeSheet.addGestureRecognizer(reviewTimeSheetgesture)
        
        let editTimeSheetgesture = UITapGestureRecognizer(target: self, action:  #selector(self.clickeditTimeSheet(sender:)))
        self.editTimeSheet.addGestureRecognizer(editTimeSheetgesture)
        
        let reimbursementEntrygesture = UITapGestureRecognizer(target: self, action:  #selector(self.clickreimbursementEntry(sender:)))
        self.reimbursementEntry.addGestureRecognizer(reimbursementEntrygesture)
        
        let myReimbursementgesture = UITapGestureRecognizer(target: self, action:  #selector(self.clickmyReimbursement(sender:)))
        self.myReimbursement.addGestureRecognizer(myReimbursementgesture)
        
        let reviewReimbursementgesture = UITapGestureRecognizer(target: self, action:  #selector(self.clickreviewReimbursement(sender:)))
        self.reviewReimbursement.addGestureRecognizer(reviewReimbursementgesture)
        
        let editReimbursement = UITapGestureRecognizer(target: self, action:  #selector(self.clickeditReimbursement(sender:)))
        self.editReimbursement.addGestureRecognizer(editReimbursement)
        
        let myCalendar = UITapGestureRecognizer(target: self, action:  #selector(self.clickmyCalendar))
        self.myCalendar.addGestureRecognizer(myCalendar)
        
    }
    
      
}
