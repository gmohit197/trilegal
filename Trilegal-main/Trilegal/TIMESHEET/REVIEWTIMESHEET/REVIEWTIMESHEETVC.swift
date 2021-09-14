//
//  REVIEWTIMESHEETVC.swift
//  Trilegal
//
//  Created by Acxiom Consulting on 18/05/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.
//

import UIKit
import SQLite3

class REVIEWTIMESHEETVC:  BASEACTIVITY , UITableViewDataSource , UITableViewDelegate  , UITextViewDelegate, OptionButtonsDelegate{
   
    func toggleclicked(at index: IndexPath){
       
        let list : TimeSheetEntryAdapter
        list = reviewtimesheetAdapter[index.row]
        
        self.setTabledata(clstr: self.clientDropDown.text!, mtstr: self.matterDropDown.text!, empname: self.resourcesDropDown.text!)
        if (self.checkrbtn()){
            self.uid = list.uid!
            self.showRejectBtn(isEnabled: true)
        }else{
            self.showRejectBtn(isEnabled: false)
        }
    }
    var uid = ""
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewtimesheetAdapter.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTimesheetCell", for:  indexPath) as! ReviewTimesheetCell
        
        let list: TimeSheetEntryAdapter
        list = reviewtimesheetAdapter[indexPath.row]
        setImageForBtnOutlet(button: cell.btnClick)
       cell.actionBlock = {
        self.clientspnr.text  = list.clientName
        self.matterspnr.text = list.matterName
        self.datetxt.text = list.date
        self.datetxt.isUserInteractionEnabled = false
        self.datetxt.isEnabled = false
        self.timetxt.text = list.time
        self.narrationtxt.text = list.narration
        self.billswitch.isOn = list.isbill == "1" ? true : false
        
        self.billswitch.myColor = list.isbill == "1" ? self.hexStringToUIColor(hex:"#003366") : UIColor.lightGray
       
        
        self.clientspnr.isUserInteractionEnabled = false
        self.clientspnr.isEnabled = false
        self.matterspnr.isUserInteractionEnabled = false
        self.matterspnr.isEnabled = false
        self.timetxt.isUserInteractionEnabled = false
        self.timetxt.isEnabled = false
        self.narrationtxt.isUserInteractionEnabled = false
        self.narrationtxt.isEditable = false
        self.billswitch.isUserInteractionEnabled = false
        self.billmainview.isUserInteractionEnabled = false
        
        self.showDetailsView()
        }
        cell.clientName.text = list.clientName
        cell.matterName.text = list.matterName
        cell.date.text = list.date
        cell.time.text = list.time
        cell.narration.text = list.narration
        cell.uid = list.uid!
        cell.indexPath = indexPath
        cell.delegate = self
        
        if (list.btnState == "0"){
            cell.btnClick.isSelected = false
        }else{
            cell.btnClick.isSelected = true
        }
        return cell
    }
    
    @IBOutlet weak var rightSideBtn: UIBarButtonItem!
    @IBOutlet weak var matterDropDown: DropDown!
    @IBOutlet weak var clientDropDown: DropDown!
    @IBOutlet weak var resourcesDropDown: DropDown!
    @IBOutlet weak var reviewTimesheetTable: UITableView!
    @IBOutlet weak var rejectTimesheetView: UIView!
    @IBOutlet weak var rejectTxtView: UITextView!
    @IBOutlet weak var rejectBtnOutlet: UIButton!
    @IBOutlet weak var selectionBtnOutlet: UIButton!
    
    @IBAction func reload(_ sender: UIButton) {
        self.download()
    }
    
    @IBOutlet var clientspnr: DropDown!
    @IBOutlet var datetxt: UITextField!
    @IBOutlet var rootview: UIView!
    
    @IBOutlet var narrationtxt: UITextView!
    @IBOutlet var matterspnr: DropDown!
    @IBOutlet var timetxt: UITextField!
    @IBOutlet var billswitch: SwiftySwitch!
    @IBAction func closedetailsbtn(_ sender: UIButton) {
        self.hideDetailsView()
    }
    @IBOutlet var detailsview: UIView!
    
    @IBOutlet var billmainview: UIStackView!
    var isAllSelected : Bool = false
    var count : Int = 0
    var countreview : Int = 0
    var itemIdArray = [Int]()
    var checkCount : Int = 0

    var rejectBtnCheck : Bool = false

    var reviewtimesheetAdapter = [TimeSheetEntryAdapter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSideBar()
        AppDelegate.currScreen = "REVIEWTS"

        
        if(setName().count>15){
            self.setnav(controller: self, title: "Review Timesheet" , spacing : 20)
        }
        else{
            self.setnav(controller: self, title: "Review Timesheet              " , spacing : 30)
        }


    //    rightSideBtn.title = setName()
        borderToView()
        view.addSubview(detailsview)
        self.hideDetailsView()
        self.view.addSubview(rejectTimesheetView) 

        self.setresource()
        
        self.rejectTimesheetView.layer.borderColor = UIColor.lightGray.cgColor
        self.rejectTimesheetView.layer.borderWidth = 0.5
        
        self.rejectTxtView.layer.borderColor = UIColor.lightGray.cgColor
        self.rejectTxtView.layer.borderWidth = 0.5
        
        selectionBtnOutlet.setImage(UIImage(named:"unselected1"), for: .normal)
        selectionBtnOutlet.setImage(UIImage(named:"selected1"), for: .selected)

        self.clientDropDown.isSearchEnable = true
        self.matterDropDown.isSearchEnable = true
        
        self.download()
    }
    
    func download(){
        if (AppDelegate.ntwrk > 0){
            self.showIndicator("loading...", vc: self)
            self.getreviewts()
        }else{
            self.showToast(message: CONSTANT.NET_ERR)
            self.setData()
        }
    }
    
    override func VD() {
        self.hideindicator()
        self.setData()
    }
    
    override func INVD(msg: String) {
        self.hideindicator()
        self.showToast(message: msg)
    }
    
    private  func setData(){
        setClientDropDown()
        setMattterDropDown()
        
        self.setTabledata(clstr: "", mtstr: "")
    }
    
    public func setresource(){
        var stmt1:OpaquePointer?
                
        let query = "select distinct(empname) from EditTS order by date desc"
        
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        resourcesDropDown.optionArray.removeAll()
        resourcesDropDown.optionArray.append("-Select Resource-")
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let str = String(cString: sqlite3_column_text(stmt1, 0))
            resourcesDropDown.optionArray.append(str)
        }
        
        resourcesDropDown.text = resourcesDropDown.optionArray[0]
        
        resourcesDropDown.didSelect { (selection, index, id) in
            self.setTabledata(clstr: self.clientDropDown.text!, mtstr: self.matterDropDown.text!, empname: selection)
        }
    }
    func checklist()-> Bool{
        var flag = true
        var select = 0
        if (self.reviewtimesheetAdapter.count > 0){
            for adapter in self.reviewtimesheetAdapter {
                if (adapter.btnState != "0"){
                    select += 1
                }
            }
            if (select == 0){
                flag = false
                self.showToast(message: "Please select at least one entry")
            }
        }else{
            self.showToast(message: "Please add some data")
            flag = false
        }
        
        return flag
    }
    
    func checkrbtn()-> Bool{
        var flag = true
        var select = 0
        if (self.reviewtimesheetAdapter.count > 0){
            for adapter in self.reviewtimesheetAdapter {
                if (adapter.btnState != "0"){
                    select += 1
                }
            }
            if (select != 1){
                flag = false
            }
        }else{
            flag = false
        }
        
        return flag
    }
    
    func showDetailsView(){
      //  self.navigationController?.navigationBar.isUserInteractionEnabled = false
     //   self.navigationController?.navigationBar.isTranslucent = true
        self.blurView(view: self.rootview)
        self.detailsview.isHidden = false
        view.bringSubviewToFront((detailsview))
    }
    
    func hideDetailsView(){
     //   self.navigationController?.navigationBar.isUserInteractionEnabled = true
     //   self.navigationController?.navigationBar.isTranslucent = false
        self.removeBlurView()
        self.detailsview.isHidden = true
        view.sendSubviewToBack(detailsview)
    }
    private func borderToView(){
        narrationtxt.layer.borderColor = UIColor.lightGray.cgColor
        narrationtxt.layer.borderWidth = 1
        detailsview.layer.borderColor = UIColor.lightGray.cgColor
        detailsview.layer.borderWidth = 0.5
        rejectTimesheetView.layer.borderColor = UIColor.lightGray.cgColor
        rejectTimesheetView.layer.borderWidth = 0.5
    }
    
    public func setClientDropDown(mtname: String = ""){
        self.clientDropDown.text = "-Select Client-"
        
        var stmt1:OpaquePointer?
                
        let str = mtname == "-Select Matter-" ? "" : mtname
        var query = "select DISTINCT(client) from editts"
//        let id = self.getmtidfromname(mtname: str)
        if (str != ""){
            query = query + " where matter = '\(str)'"
        }
        print("cl query ===> \(query)")
        
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        clientDropDown.optionArray.removeAll()
        clientDropDown.optionArray.append("-Select Client-")
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let str = String(cString: sqlite3_column_text(stmt1, 0))
            clientDropDown.optionArray.append(str)
        }
        
        clientDropDown.didSelect { (selection, index, id) in
            self.setMattterDropDown(clname: selection)
            self.setTabledata(clstr: selection, mtstr: self.matterDropDown.text!,empname: self.resourcesDropDown.text!)
        }
    }
    
    public func setMattterDropDown(clname: String = ""){
        self.matterDropDown.text = "-Select Matter-"
        var stmt1:OpaquePointer?
        
        let str = clname == "-Select Client-" ? "" : clname
        
        var query = "select distinct(Matter) from Editts"
//        let id = self.getclidfromname(clname: str)
        if (str != "" ){
            query = query + " where Client = '\(str)'"
        }
        print("mt query ===> \(query)")
        
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        matterDropDown.optionArray.removeAll()
        matterDropDown.optionArray.append("-Select Matter-")
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let str = String(cString: sqlite3_column_text(stmt1, 0))
            matterDropDown.optionArray.append(str)
        }
        
        matterDropDown.didSelect { (selection, id, index) in
            
            self.setClientDropDown(mtname: selection)
            if (selection == "-Select Matter-"){
                self.clientDropDown.text = self.clientDropDown.optionArray[0]
            }else{
                self.clientDropDown.text = self.clientDropDown.optionArray[1]
            }
            
            self.setTabledata(clstr: self.clientDropDown.text!, mtstr: selection,empname: self.resourcesDropDown.text!)
        }
        
    }
    
    private  func setTabledata(clstr: String, mtstr: String,empname: String = ""){
        var stmt1:OpaquePointer?
        
        let mstr = mtstr == "-Select Matter-" ? "" : mtstr
        let cstr = clstr == "-Select Client-" ? "" : clstr
        let rstr = empname == "-Select Resource-" ? "": empname
        
        self.reviewtimesheetAdapter.removeAll()
        
        var query = "select uid,Client,Matter,date,time, narration,btnstate,isbillable,isoffcounsel,status from EditTS where cast(isoffcounsel as Int) < 10 "
        
        var clientcon = "", mattercon = "", rcon = ""
        
        if (cstr.count > 0 || mstr.count > 0 || rstr.count > 0){
            if (cstr.count > 0){
                clientcon += " and client = '\(cstr)'"
            }else{
                clientcon = ""
            }
            if (mstr.count > 0){
                mattercon = " and matter = '\(mstr)'"
            }else{
                mattercon = ""
            }
            if (rstr.count > 0){
                rcon = " and empname = '\(rstr)'"
            }else{
                rcon = ""
            }
            query = query + clientcon + mattercon + rcon
        }
        print("\nquery --> \(query)\n")
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let uid = String(cString: sqlite3_column_text(stmt1, 0))
            let clname = String(cString: sqlite3_column_text(stmt1, 1))
            let mattername = String(cString: sqlite3_column_text(stmt1, 2))
            let date = String(cString: sqlite3_column_text(stmt1, 3))
            let time = sqlite3_column_int(stmt1, 4)
            let narration = String(cString: sqlite3_column_text(stmt1, 5))
            let state = String(cString: sqlite3_column_text(stmt1, 6))
            let isbill = String(cString: sqlite3_column_text(stmt1, 7))
            let isoffc = String(cString: sqlite3_column_text(stmt1, 8))
            let status = String(cString: sqlite3_column_text(stmt1, 9))
            
            self.reviewtimesheetAdapter.append(TimeSheetEntryAdapter(uid: uid,clientName: clname, matterName: mattername, date: date, time: self.gettime(min: Int(time)), narration: narration, btnState: state, status: status,isbill: isbill,isoffc: isoffc))
        }
        self.reviewTimesheetTable.reloadData()
    }
    
    @IBOutlet var selectAllBtnOutlet: UIButton!
    @IBAction func selectAllBtn(_ sender: UIButton) {
        isAllSelected = !isAllSelected
        self.updateeditstatus(status: isAllSelected ? "1" : "0", uid: "-1")
        animatebtnOutlet(button: self.selectAllBtnOutlet)
        self.setTabledata(clstr: self.clientDropDown.text!, mtstr: self.matterDropDown.text!,empname: self.resourcesDropDown.text!)
        self.showRejectBtn(isEnabled: false)
    }
    
    @IBAction func sideMenuBtn(_ sender: UIBarButtonItem) {
        onClickSideMenu()
    }
    private func showRejectBtn(isEnabled : Bool){
        
        if(isEnabled){
            self.rejectBtnCheck = true
            self.rejectBtnOutlet.backgroundColor = self.hexStringToUIColor(hex: "#ff6633")
        }
        else{
            self.rejectBtnCheck = false
            self.rejectBtnOutlet.backgroundColor = UIColor.lightGray
        }
    }
    
    @IBAction func rejectViewBtn(_ sender: UIButton) {
        
        if(!(rejectTxtView.text.isEmpty || rejectTxtView.text == "Add Rejection remark" || rejectTxtView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)){
            self.rejectTimesheetView.isHidden = true
            let alert = UIAlertController(title: "Alert", message: "Are you sure to reject?", preferredStyle: .alert)
            
            let yes = UIAlertAction(title: "Yes", style: .default) { (_) in
                alert.dismiss(animated: true, completion: nil)
                if (AppDelegate.ntwrk > 0){
                    self.showIndicator("Syncing...", vc: self)
                    self.postrejectts(remarks: self.rejectTxtView.text!, trid: self.uid)
                }else{
                    self.showToast(message: CONSTANT.NET_ERR)
                }
            }
            
            let no = UIAlertAction(title: "No", style: .destructive) { (_) in
                alert.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(yes)
            alert.addAction(no)
            
                self.present(alert, animated: true, completion: nil)
            
        }
        else{
            self.showtoast(controller: self, message: "Please Enter Remarks first", seconds: 1.0)
        }
    }
    
    
    @IBAction func rejectBtn(_ sender: UIButton) {
        if(rejectBtnCheck){
            self.rejectTxtView.text = ""
            self.rejectTimesheetView.isHidden = false
        }
    }
    
    @IBAction func approveBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure to approve?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .default) { (_) in
            alert.dismiss(animated: true, completion: nil)
            if (AppDelegate.ntwrk > 0){
                self.showIndicator("Syncing...", vc: self)
                self.postapprovets()
            }else{
                self.showToast(message: CONSTANT.NET_ERR)
            }
        }
        
        let no = UIAlertAction(title: "No", style: .destructive) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(yes)
        alert.addAction(no)
        
        if (self.checklist()){
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func rejectViewBackBtn(_ sender: UIButton) {
        self.rejectTimesheetView.isHidden = true
    }
       
    //MARK:- TEXTVIEW NIL
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Add Remark"{
            textView.text = nil
            textView.textColor = UIColor.darkGray
        }
    }
    
    func animatebtn(){
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
            self.selectionBtnOutlet.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (success) in
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
                self.selectionBtnOutlet.isSelected = !self.selectionBtnOutlet.isSelected
                self.selectionBtnOutlet.transform = .identity
            }, completion: nil)
        }
    }
    
    override func reviewdone(){
        self.hideindicator()
        let alert = UIAlertController(title: "", message: "Success", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "ok", style: .default) { (_) in
            alert.dismiss(animated: true, completion: nil)
            if (AppDelegate.ntwrk > 0){
                self.showIndicator("Syncing...", vc: self)
                self.getreviewts()
            }else{
                self.showToast(message: CONSTANT.NET_ERR)
            }
        }
        
        alert.addAction(yes)
        self.present(alert, animated: true, completion: nil)
        
    }
}
