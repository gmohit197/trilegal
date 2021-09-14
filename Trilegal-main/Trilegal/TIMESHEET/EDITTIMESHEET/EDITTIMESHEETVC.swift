//
//  EDITTIMESHEETVC.swift
//  Trilegal
//
//  Created by Acxiom Consulting on 05/05/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.
//

import UIKit
import SQLite3

class EDITTIMESHEETVC: BASEACTIVITY  , UITableViewDelegate , UITableViewDataSource,OptionButtonsDelegate, SwiftySwitchDelegate {
        
    func valueChanged(sender: SwiftySwitch) {
        
        if self.billableswitchbtn.isOn {
            billableswitchbtn.myColor = hexStringToUIColor(hex:"#003366")
        }
        else{
            billableswitchbtn.myColor = UIColor.lightGray
        }
        if self.offConselswitchbtn.isOn {
            offConselswitchbtn.myColor = hexStringToUIColor(hex:"#003366")
        }
        else{
            offConselswitchbtn.myColor = UIColor.lightGray
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editTimeSheetAdapter.count
    }
    func toggleclicked(at index: IndexPath){
        
        self.setTabledata()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditTimesheetCell", for:  indexPath) as! EditTimesheetCell
        let list: TimeSheetEntryAdapter
        list = editTimeSheetAdapter[indexPath.row]
        setImageForBtnOutlet(button: cell.btnClick)
        
        cell.indexPath = indexPath
        cell.clientName.text = list.clientName
        cell.matterName.text = list.matterName
        cell.date.text = list.date
        cell.time.text = list.time
        cell.narration.text = list.narration
        cell.uid = list.uid!
        cell.remark.text = list.remark!
        
        switch (list.status!){
        case STATUS.NOT_SUBMITTED.rawValue : cell.status.text = "Not Submitted"
            break;
        case STATUS.REJECTED.rawValue : cell.status.text = "Rejected"
            break;
            
        default: cell.status.text = ""
        }
        
        cell.actionEditIcon = {
            self.initdata()
            self.clientDropDown.text  = list.clientName
            self.matterDropDown.text = list.matterName
            self.datetxtField.text = list.date
            self.datetxtField.isUserInteractionEnabled = false
            self.datetxtField.isEnabled = false
            self.timeTxtField.text = list.time
            self.narrationTxtView.text = list.narration
            self.billableswitchbtn.isOn = list.isbill == "1" ? true : false
            self.offConselswitchbtn.isOn = list.isoffc == "1" ? true : false
            self.billableswitchbtn.myColor = list.isbill == "1" ? self.hexStringToUIColor(hex:"#003366") : UIColor.lightGray
            self.offConselswitchbtn.myColor = list.isoffc == "1" ? self.hexStringToUIColor(hex:"#003366") : UIColor.lightGray
            self.datetxtField.isUserInteractionEnabled = false
            self.datetxtField.isEnabled = false
            self.index = indexPath.row
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "HH:mm"
            let date = dateFormatter.date(from: list.time!)
            self.datePicker2!.date = date!
            self.dateFormatter.dateFormat = "yyyy-MM-dd"
            self.datePicker?.date = self.dateFormatter.date(from: list.date!)!
            self.setMattterDropDown(clname: self.clientDropDown.text!, detail: false)
            self.showDetailsView()
        }
        cell.actionDeleteIcon = {
            self.presentDeletionFailsafe(indexPath: indexPath)
        }
        
        if (list.btnState == "0"){
            cell.btnClick.isSelected = false
        }else{
            cell.btnClick.isSelected = true
        }
        
        cell.delegate = self
        
        self.setBorders(view: cell.mainview, top: 0, bottom: 1, left: 0, right: 0, color: .lightGray)
        
        
        return cell
    }
    var type = ""
    func showDetailsView(){
        //  self.navigationController?.navigationBar.isUserInteractionEnabled = false
        //   self.navigationController?.navigationBar.isTranslucent = true
        self.detailsView.isHidden = false
        self.blurView(view: self.rootview)
        view.bringSubviewToFront((detailsView))
    }
    func initdata(){
        billableswitchbtn.delegate = self
        billableswitchbtn.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
        
        offConselswitchbtn.delegate = self
        offConselswitchbtn.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)

        self.setMattterDropDown()
        self.setClientDropDown()
        self.type = "-1"
    }
    func hideDetailsView(){
        //   self.navigationController?.navigationBar.isUserInteractionEnabled = true
        //   self.navigationController?.navigationBar.isTranslucent = false
        self.detailsView.isHidden = true
        view.sendSubviewToBack(detailsView)
        removeBlurView()
    }
    
    var datePicker: UIDatePicker?
    var datePicker2 : UIDatePicker?
    @IBOutlet var detailsView: UIView!
    @IBOutlet var matterDropDown: DropDown!
    @IBOutlet var datetxtField: UITextField!
    @IBOutlet var narrationTxtView: UITextView!
    
    @IBOutlet var timeTxtField: UITextField!
    @IBOutlet var clientDropDown: DropDown!
    
    @IBOutlet weak var rightSideBtn: UIBarButtonItem!
    @IBOutlet weak var statusDropDown: DropDown!
    @IBOutlet weak var selectAllBtnOutlet: UIButton!
    @IBOutlet weak var editTimeSheetTable: UITableView!
    @IBOutlet var billableswitchbtn: SwiftySwitch!
    @IBOutlet var offConselswitchbtn: SwiftySwitch!
    @IBOutlet var rootview: UIView!
    
    var editTimeSheetAdapter = [TimeSheetEntryAdapter]()
    var isAllSelected : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.currScreen = "EDITTS"
        if(setName().count>15){
            self.setnav(controller: self, title: "Edit Timesheet" , spacing : 30)
        }
        else{
            self.setnav(controller: self, title: "Edit Timesheet               " , spacing : 30)
        }
        
        setUpSideBar()
        //  rightSideBtn.title = setName()
        seteditTimeSheetStatusDropDown(statusDropDown:statusDropDown)
        statusDropDown.text = statusDropDown.optionArray[0]
        setImageForBtnOutlet(button: selectAllBtnOutlet)
        
        DatePicker()
        setImageForBtnOutlet(button: selectAllBtnOutlet)
        billableswitchbtn.delegate = self
        billableswitchbtn.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
        //        billableswitchbtn.myColor = UIColor.lightGray
        
        offConselswitchbtn.delegate = self
        offConselswitchbtn.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
        //        offConselswitchbtn.myColor = UIColor.lightGray
        
        self.clientDropDown.isSearchEnable = true
        self.matterDropDown.isSearchEnable = true
        
        self.statusDropDown.isSearchEnable = false
        borderToView()
        view.addSubview(detailsView)
        self.detailsView.isHidden = true
        
        self.download()
    }
    private func borderToView(){
        detailsView.layer.borderColor = UIColor.lightGray.cgColor
        detailsView.layer.borderWidth = 0.5
        
        narrationTxtView.layer.borderColor = UIColor.lightGray.cgColor
        narrationTxtView.layer.borderWidth = 1
    }
    
    @IBAction func closedetail(_ sender: UIButton) {
        self.hideDetailsView()
    }

    
    @IBAction func savebtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure, you want to save?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .default) { (_) in
            alert.dismiss(animated: true, completion: nil)
            if (AppDelegate.ntwrk > 0){
                if (self.checklist()){
                    self.showIndicator("Syncing...", vc: self)
                    self.post_ts(type: 0,isedit: true)
                }
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
    
    @IBAction func submitbtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure want to save & submit?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .default) { (_) in
            alert.dismiss(animated: true, completion: nil)
            if (AppDelegate.ntwrk > 0){
                if (self.checklist()){
                    self.showIndicator("Syncing...", vc: self)
                    self.post_ts(type: 1,isedit: true)
                }
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
    func checklist()-> Bool{
        var flag = true
        var select = 0
        if (self.editTimeSheetAdapter.count > 0){
            for adapter in self.editTimeSheetAdapter {
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
    
    @IBAction func reload(_ sender: UIButton) {
        if (AppDelegate.ntwrk > 0){
            self.showIndicator("loading...", vc: self)
            if (self.statusDropDown.text! == self.statusDropDown.optionArray[0]){
                self.getmyts(startdate: self.setFromDate(), enddate: self.setToDate(), type: Int(STATUS.ALL.rawValue)!, isedit: true)
            }else if (self.statusDropDown.text! == self.statusDropDown.optionArray[1]){
                self.getmyts(startdate: self.setFromDate(), enddate: self.setToDate(), type: Int(STATUS.NOT_SUBMITTED.rawValue)!, isedit: true)
            }else{
                self.getmyts(startdate: self.setFromDate(), enddate: self.setToDate(), type: Int(STATUS.REJECTED.rawValue)!, isedit: true)
            }
        }else{
            self.showToast(message: CONSTANT.NET_ERR)
        }
    }
    
    func download(){
        if (AppDelegate.ntwrk > 0){
            self.showIndicator("loading...", vc: self)
            self.getts_forday(date: self.getdate(format: "yyyy-MM-dd"))
        }else{
            self.showToast(message: CONSTANT.NET_ERR)
            self.setData()
        }
    }
    override func VD() {
        self.getmyts(startdate: self.setFromDate(), enddate: self.setToDate(), type: Int(STATUS.ALL.rawValue)!, isedit: true)
    }
    
    override func tsdone(ids: [String],type: Int = 0){
        self.hideindicator()
        for id in ids{
            self.deleditts(uid: id)
        }
        self.isfirst = false
        self.setTabledata()
        if (self.editTimeSheetAdapter.count == 0){
            self.gotoHome()
        }else{
            self.download()
        }
    }
    
    override func INVD(msg: String) {
        self.hideindicator()
        self.showmsg(msg: "Please  try again later!!")
        self.showToast(message: msg)        
    }
    
    private  func setData(){
        setClientDropDown(mtname: self.matterDropDown.text!, detail: false)
        setMattterDropDown(clname: self.clientDropDown.text!, detail: false)
    }
    var isfirst : Bool = true
    override func mytsdone() {
        self.hideindicator()
        self.setData()
        self.setTabledata()
        if (!isfirst){
            let alert = UIAlertController(title: "", message: "Success", preferredStyle: .alert)
            
            let yes = UIAlertAction(title: "ok", style: .default,handler: nil)
            
            alert.addAction(yes)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBOutlet var billmainview: UIStackView!
    
    func presentDeletionFailsafe(indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete?", preferredStyle: .alert)// yes action
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in  // replace data variable with your own data array
            let element = self.editTimeSheetAdapter[indexPath.row]
            let uid = element.uid!
            self.deleditts(uid: uid)
            self.setTabledata()
        }
        alert.addAction(yesAction)
        // cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sideMenuBtn(_ sender: UIBarButtonItem) {
        onClickSideMenu()
    }
    @IBAction func selectAllBtn(_ sender: UIButton) {
        isAllSelected = !isAllSelected
        self.updateeditstatus(status: isAllSelected ? "1" : "0", uid: "-1")
        animatebtnOutlet(button: self.selectAllBtnOutlet)
        self.setTabledata()
    }
    func date_check(date: String, textfield: UITextField){
        if (self.checkdatafordate(date: date)){
            let prev_date = textfield.text!
            if (prev_date != date){
                let alert = UIAlertController(title: "Alert", message: "Change of date will delete the existing data of another date. Would you like to continue?", preferredStyle: .alert)
                let yes = UIAlertAction(title: "Yes", style: .default) { (result) in
                    self.deletetable(tbl: "EditTS")
                    textfield.text = date
                    self.setTabledata()
                    alert.dismiss(animated: true, completion: nil)
                }
                let no = UIAlertAction(title: "No", style: .destructive) { (result) in
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(yes)
                alert.addAction(no)
            }
        }else{
            textfield.text = date
        }
    }
    func checkdatafordate(date : String)-> Bool{
        var flag = true
        
        var stmt1:OpaquePointer?
        
        let query = "select * from EditTS where date = '\(date)'"

        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return false
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            flag = false
        }
        
        return flag
    }
    var date = Date()
    func DatePicker (){
        datePicker = UIDatePicker()
        datePicker?.preferredDatePickerStyle = .wheels
        datePicker?.datePickerMode = .date
        datePicker2 = UIDatePicker()
        datePicker2?.preferredDatePickerStyle = .wheels
        datePicker2?.datePickerMode = .time
        if (UserDefaults.standard.string(forKey: "startdate") != nil && UserDefaults.standard.string(forKey: "startdate") != ""){
            let mindate = self.strtodate(str: self.setFromDate(), format: "yyyy-MM-dd")
            datePicker?.minimumDate = mindate
        }
        if (UserDefaults.standard.string(forKey: "enddate") != nil && UserDefaults.standard.string(forKey: "enddate") != ""){
            let maxdate = self.strtodate(str: self.setToDate(), format: "yyyy-MM-dd")
            datePicker?.maximumDate = maxdate
        }
        datePicker?.maximumDate = self.date
        datePicker2?.locale = Locale.init(identifier: "en_gb")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        let date = dateFormatter.date(from: "00:00")
        datePicker2!.date = date!
        
        let toolbar = UIToolbar();
        let toolbar1 = UIToolbar();
        toolbar.sizeToFit()
        toolbar1.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        let donetButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatetPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        let spacetButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let canceltButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        datetxtField.inputAccessoryView = toolbar
        datetxtField.inputView = datePicker
        
        toolbar1.setItems([donetButton,spacetButton,canceltButton], animated: false)
        timeTxtField.inputAccessoryView = toolbar1
        timeTxtField.inputView = datePicker2
    }
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.date_check(date: formatter.string(from: self.datePicker!.date), textfield: datetxtField)
        //        dateTxtField.text = formatter.string(from: self.datePicker!.date)
        self.view.endEditing(true)
    }
    @objc func donedatetPicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeTxtField.text = formatter.string(from: self.datePicker2!.date)
        self.view.endEditing(true)
    }
    
    public func setMattterDropDown(clname: String = "", detail : Bool = true){
        
        if detail {
            self.matterDropDown.text = "-Select Matter-"
        }
        var stmt1:OpaquePointer?
        
        let str = clname == "-Select Client-" ? "" : clname
        
        var query = "select distinct(MatterCode) , MatterDesc , MatterType from ClientMaster"
        let id = self.getclidfromname(clname: str)
        if (str != "" && id != ""){
            query = query + " where ClientCode = '\(id)'"
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
            let str = String(cString: sqlite3_column_text(stmt1, 1))
            matterDropDown.optionArray.append(str)
        }
        
        if (matterDropDown.optionArray.count == 2 ){
            self.matterDropDown.text = matterDropDown.optionArray[1]
        }
        
        matterDropDown.didSelect { (selection, index, id) in
            if(index > 0){
                self.setClientDropDown(mtname: selection)
                self.clientDropDown.text = self.clientDropDown.optionArray[1]
            }
            else{
                self.setClientDropDown(mtname: selection)
                self.setMattterDropDown()
            }
            
            let type = self.getmattertype(str: selection)
            if ( type == "0"){
                self.billableswitchbtn.isUserInteractionEnabled = true
                self.billableswitchbtn.isOn = true
                self.billmainview.isUserInteractionEnabled = true
                self.billableswitchbtn.myColor = self.hexStringToUIColor(hex:"#003366")
            }else if (type == "1"){
                self.billableswitchbtn.isUserInteractionEnabled = false
                self.billableswitchbtn.isOn = false
                self.billmainview.isUserInteractionEnabled = false
                self.billableswitchbtn.myColor = UIColor.lightGray
            }else{
                self.billableswitchbtn.isUserInteractionEnabled = true
                self.billableswitchbtn.isOn = false
                self.billmainview.isUserInteractionEnabled = false
                self.billableswitchbtn.myColor = UIColor.lightGray
            }
        }
    }
    public func setClientDropDown(mtname: String = "", detail : Bool = true){
        
        if detail {
            self.clientDropDown.text = "-Select Client-"
        }
        
        var stmt1:OpaquePointer?
        
        let str = mtname == "-Select Matter-" ? "" : mtname
        
        var query = "select distinct(ClientCode) , ClientDesc from ClientMaster"
        let id = self.getmtidfromname(mtname: str)
        if (str != "" && id != ""){
                query = query + " where MatterCode = '\(id)'"
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
            let str = String(cString: sqlite3_column_text(stmt1, 1))
            clientDropDown.optionArray.append(str)
        }
        
        clientDropDown.didSelect { (selection, index, id) in
            if(index > 0){
                self.setMattterDropDown(clname: selection)
            }
            else{
                self.setMattterDropDown(clname: selection)
                self.setClientDropDown(mtname: "", detail: false)
            }
            
        }
    }
    
    var index = 0
    
    @IBAction func detailsSaveBtn(_ sender: UIButton) {
      if(validate()){
            let uid = self.editTimeSheetAdapter[index].uid
            let hr = String(self.timeTxtField.text!.prefix(2))
            let min = String(self.timeTxtField.text!.suffix(2))
            
            var time = (Int(hr)! * 60)
            time = time + Int(min)!
            
        if (self.checkdatafortime(time: time, date: datetxtField.text!)){
                self.update_tseditentry(uid: uid!, client: self.getclientid(str: self.clientDropDown.text!), matter: self.getmatterid(str: self.matterDropDown.text!), hours: hr, mins: min, time: "\(time)", narration: self.narrationTxtView.text!,billable: self.billableswitchbtn.isOn ? "1" : "0",offcounsel: self.offConselswitchbtn.isOn ? "1" : "0")
                self.setTabledata()
                self.hideDetailsView()
            }
        }
    }
    
    func checkdatafortime(time : Int,date: String)-> Bool{
        var flag = true
        
        var stmt1:OpaquePointer?
        var entrytime = 0, tottime = 0,dayhr = 24 * 60
        
        let query = "SELECT ifnull(sum(time),0) from EditTS where date = '\(date)'"
        
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return false
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            entrytime = Int(sqlite3_column_int(stmt1, 0))
            tottime = entrytime + time
            if (tottime >= dayhr){
                self.showToast(message: "Total Time should not exceed 24 hrs.")
                flag = false
            }
        }
        
        return flag
    }
    
    func validate() -> Bool {
        var validate : Bool = true
        if(clientDropDown.text?.count == 0 || self.getclientid(str: self.clientDropDown.text!) == "-1"){
            self.showtoast(controller: self, message: "Please Select Client", seconds: 1.0)
            validate = false
        }
        if(matterDropDown.text?.count == 0 || self.getmatterid(str: self.matterDropDown.text!) == "-1"){
            self.showtoast(controller: self, message: "Please Select Matter", seconds: 1.0)
            validate = false
        }
        if(datetxtField.text?.count == 0){
            self.showtoast(controller: self, message: "Please Select Date", seconds: 1.0)
            validate = false
        }
        if(timeTxtField.text?.count == 0){
            self.showtoast(controller: self, message: "Please Select Time", seconds: 1.0)
            validate = false
        }
        if(timeTxtField.text == "00:00"){
            self.showtoast(controller: self, message: "00:00 Time not allowed", seconds: 1.0)
            validate = false
        }
        if(narrationTxtView.text!.isEmpty || narrationTxtView.text == "Please Add Narration"){
            self.showtoast(controller: self, message: "Please Enter Narration", seconds: 1.0)
            validate = false
        }
        
        return validate
    }
    
    private  func setTabledata(){
        var stmt1:OpaquePointer?
        self.editTimeSheetAdapter.removeAll()
        let query = "select a.uid,b.ClientDesc,b.MatterDesc,a.date,a.time, a.narration,a.btnstate,a.isbillable,a.isoffcounsel,a.status,a.remark from EditTS a left outer join ClientMaster b on b.ClientCode = a.client and a.matter = b.MatterCode"
        
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
            let remark = String(cString: sqlite3_column_text(stmt1, 10))
            
            self.editTimeSheetAdapter.append(TimeSheetEntryAdapter(uid: uid,clientName: clname, matterName: mattername, date: date, time: self.gettime(min: Int(time)), narration: narration, btnState: state, status: status,isbill: isbill,isoffc: isoffc,remark: remark))
        }
        self.editTimeSheetTable.reloadData()
    }
    
    
}
