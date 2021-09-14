//  MYTIMESHEETVC.swift
//  Trilegal
//
//  Created by Acxiom Consulting on 07/05/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.

//MARK:- IMPORTS
import UIKit
import SQLite3

//MARK:- TIMESHEETVC BEGNNING
class MYTIMESHEETVC: BASEACTIVITY , UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTimeSheetAdapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTimesheetCell", for:  indexPath) as! MyTimesheetCell
        let list: MyTimeSheetAdapter
        list = myTimeSheetAdapter[indexPath.row]
        cell.clientName.text = list.clientName
        cell.matterName.text = list.matterName
        cell.date.text = list.date
        cell.time.text = list.time
        cell.narration.text = list.narration
        
        cell.actionBlock = {
            self.clientspnr.text  = list.clientName
            self.matterspnr.text = list.matterName
            self.datetxt.text = list.date
            self.datetxt.isUserInteractionEnabled = false
            self.datetxt.isEnabled = false
            self.timetxt.text = list.time
            self.narrationtxt.text = list.narration
            self.billswitch.isOn = list.isbill == "1" ? true : false
            self.offcswitch.isOn = list.isoffc == "1" ? true : false
            self.billswitch.myColor = list.isbill == "1" ? self.hexStringToUIColor(hex:"#003366") : UIColor.lightGray
            self.offcswitch.myColor = list.isoffc == "1" ? self.hexStringToUIColor(hex:"#003366") : UIColor.lightGray
            
            self.clientspnr.isUserInteractionEnabled = false
            self.clientspnr.isEnabled = false
            self.matterspnr.isUserInteractionEnabled = false
            self.matterspnr.isEnabled = false
            self.timetxt.isUserInteractionEnabled = false
            self.timetxt.isEnabled = false
            self.narrationtxt.isUserInteractionEnabled = false
            self.narrationtxt.isEditable = false
            self.billswitch.isUserInteractionEnabled = false
            self.offcswitch.isUserInteractionEnabled = false
            
            
            self.showDetailsView()
        }
        if (list.status! == STATUS.NOT_SUBMITTED.rawValue){
            cell.status.text = "Not Submitted"
        }else if (list.status! == STATUS.REJECTED.rawValue){
            cell.status.text = "Rejected"
        }else if (list.status! == STATUS.APPROVED.rawValue){
            cell.status.text = "Approved"
        }else if (list.status! == STATUS.SUBMITTED.rawValue){
            cell.status.text = "Submitted"
        }
        self.setBorders(view: cell.mainview, top: 0, bottom: 1, left: 0, right: 0, color: .lightGray)
        
        return cell
    }
    
    //MARK:- OUTLETS
    var datePicker: UIDatePicker?
    var datePicker2 : UIDatePicker?
    var date = Date()
    var myTimeSheetAdapter = [MyTimeSheetAdapter]()
    
    //MARK:- IBOUTLETS
    @IBOutlet weak var rightSideBtn: UIBarButtonItem!
    @IBOutlet weak var matterDropDown: DropDown!
    @IBOutlet weak var clientDropDown: DropDown!
    @IBOutlet weak var statusDropDown: DropDown!
    @IBOutlet weak var toDateTextField: UITextField!
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var myTimeSheetTable: UITableView!
    
    @IBOutlet var clientspnr: DropDown!
    @IBOutlet var datetxt: UITextField!
    @IBOutlet var rootview: UIView!
    
    @IBOutlet var narrationtxt: UITextView!
    @IBOutlet var matterspnr: DropDown!
    @IBOutlet var timetxt: UITextField!
    @IBOutlet var billswitch: SwiftySwitch!
    @IBOutlet var offcswitch: SwiftySwitch!
    @IBAction func closedetailsbtn(_ sender: UIButton) {
        self.hideDetailsView()
    }
    @IBOutlet var detailsview: UIView!
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
       AppDelegate.currScreen = "MYTS"
        if(setName().count>15){
            self.setnav(controller: self, title: "My Timesheet" , spacing : 30)
        }
        else{
            self.setnav(controller: self, title: "My Timesheet               " , spacing : 30)
        }

        
        setUpSideBar()
       // rightSideBtn.title = setName()
        DatePicker()
        setDropDownData()
        borderToView()
        view.addSubview(detailsview)
        self.hideDetailsView()
        
        self.statusDropDown.text = self.statusDropDown.optionArray[0]
        self.getdata()
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
    var type = 10
    var typearr = [Int]()
    @IBAction func reloadbtn(_ sender: UIButton) {
        self.getdata()
    }
    func getdata(){
        if (AppDelegate.ntwrk > 0){
            self.showIndicator("loading...", vc: self)
            let stdate = self.fromDateTextField.text!
            let enddate = self.toDateTextField.text!
            
            self.getmyts(startdate: stdate, enddate: enddate, type: type)
        }else{
            self.showToast(message: CONSTANT.NET_ERR)
        }
    }
    
    override func VD() {
        self.hideindicator()
        self.setTabledata(clstr: "", mtstr: "")
        self.setClientDropDown()
        self.setMattterDropDown()
    }
    
    override func INVD(msg: String) {
        self.hideindicator()
        self.showToast(message: msg)
        self.deletetable(tbl: "MyTS")
        self.setDropDownData()
        self.setTabledata(clstr: "", mtstr: "")
    }
    
    public func setClientDropDown(mtname: String = ""){
        self.clientDropDown.text = "-Select Client-"
        
        var stmt1:OpaquePointer?
        
        clientarr.removeAll()
        
        let str = mtname == "-Select Matter-" ? "" : mtname

        var query = "select distinct(b.ClientCode) , b.ClientDesc from MyTS a left outer join ClientMaster b on a.client = b.ClientDesc"
        let id = self.getmtidfromname(mtname: str)
        if (str != "" && id != ""){
                query = query + " where b.MatterCode = '\(id)'"
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
            let code = String(cString: sqlite3_column_text(stmt1, 0))
            let str = String(cString: sqlite3_column_text(stmt1, 1))
            clientDropDown.optionArray.append(str)
            clientarr.append(code)
        }
        
        clientDropDown.didSelect { (selection, index, id) in
            self.setMattterDropDown(clname: selection)
            self.setTabledata(clstr: selection, mtstr: self.matterDropDown.text!)
        }
    }
    var clientarr = [String]()
    var matterarr = [String]()
    var mattertype = [Int]()
    //MARK:- SETDROPDOWN DATA
    private func setDropDownData(){
        self.typearr = setStatusDropDown(statusDropDown:statusDropDown)
        
        statusDropDown.didSelect { (selecttion, index, id) in
            
            self.type = self.typearr[index]
        }
        
        setClientDropDown()
        setMattterDropDown()
    }
    
    public func setMattterDropDown(clname: String = ""){
        self.matterDropDown.text = "-Select Matter-"
        var stmt1:OpaquePointer?
        
        matterarr.removeAll()
        mattertype.removeAll()
        let str = clname == "-Select Client-" ? "" : clname
        
        var query = "select distinct(b.MatterCode) , b.MatterDesc from MyTS a left outer join ClientMaster b on a.matter = b.MatterDesc"
        let id = self.getclidfromname(clname: str)
        if (str != "" && id != ""){
            query = query + " where b.ClientCode = '\(id)'"
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
            let code = String(cString: sqlite3_column_text(stmt1, 0))
            let str = String(cString: sqlite3_column_text(stmt1, 1))
            let type = sqlite3_column_int(stmt1, 2)
            matterDropDown.optionArray.append(str)
            matterarr.append(code)
            mattertype.append(Int(type))
        }
        if (matterDropDown.optionArray.count == 2 ){
            self.matterDropDown.text = matterDropDown.optionArray[1]
        }
        matterDropDown.didSelect { (selection, id, index) in
            
            self.setClientDropDown(mtname: selection)
            if (selection == "-Select Matter-"){
                self.clientDropDown.text = self.clientDropDown.optionArray[0]
            }else{
                self.clientDropDown.text = self.clientDropDown.optionArray[1]
            }
            
            self.setTabledata(clstr: self.clientDropDown.text!, mtstr: selection)
        }
        
    }
    //MARK:- SIDE MENU BTN
    @IBAction func sideMenuBtn(_ sender: UIBarButtonItem) {
        
        onClickSideMenu()
    }
    
    //MARK:- DATE PICKER
    func DatePicker (){
        datePicker = UIDatePicker()
        datePicker?.preferredDatePickerStyle = .wheels
        datePicker?.datePickerMode = .date
        datePicker2 = UIDatePicker()
        datePicker2?.preferredDatePickerStyle = .wheels
        datePicker2?.datePickerMode = .date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let todate = formatter.date(from: self.getdate(format: "yyyy-MM-dd"))
        let fromdate = Calendar.current.date(byAdding: .day, value: -7, to: todate!)
        datePicker?.maximumDate = todate
        datePicker?.date = fromdate!
        
        datePicker2?.maximumDate = todate
        datePicker2?.date = todate!
        
        let enddate = formatter.string(from: todate!)
        let stdate = formatter.string(from: fromdate!)
        fromDateTextField.text = stdate
        toDateTextField.text = enddate
        
        let toolbar = UIToolbar();
        let toolbar1 = UIToolbar();
        toolbar.sizeToFit()
        toolbar1.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let donetButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatetPicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        let spacetButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let canceltButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        fromDateTextField.inputAccessoryView = toolbar
        fromDateTextField.inputView = datePicker
        toolbar1.setItems([donetButton,spacetButton,canceltButton], animated: false)
        toDateTextField.inputAccessoryView = toolbar1
        toDateTextField.inputView = datePicker2
    }
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        fromDateTextField.text = formatter.string(from: self.datePicker!.date)
        self.view.endEditing(true)
    }
    @objc func donedatetPicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        toDateTextField.text = formatter.string(from: self.datePicker2!.date)
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    private func borderToView(){
        narrationtxt.layer.borderColor = UIColor.lightGray.cgColor
        narrationtxt.layer.borderWidth = 1
        detailsview.layer.borderColor = UIColor.lightGray.cgColor
        detailsview.layer.borderWidth = 0.5
       
    }
    //MARK:- SETTABLEDATA
    private  func setTabledata(clstr: String, mtstr: String){
        var stmt1:OpaquePointer?
        self.myTimeSheetAdapter.removeAll()
        let mstr = mtstr == "-Select Matter-" ? "" : mtstr
        let cstr = clstr == "-Select Client-" ? "" : clstr
        
        let query = "select uid,client,matter,date,time, narration,status,isbillable,isoffcounsel from MyTS where client like '%\(cstr)%' and matter like '%\(mstr)%' order by date desc"
        
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
            let status = String(cString: sqlite3_column_text(stmt1, 6))
            let isbill = String(cString: sqlite3_column_text(stmt1, 7))
            let offc = String(cString: sqlite3_column_text(stmt1, 8))

            self.myTimeSheetAdapter.append(MyTimeSheetAdapter(clientName: clname, matterName: mattername, date: date, time: self.gettime(min: Int(time)), narration: narration, status: status,isbill: isbill,isoffc: offc))
        }
        self.myTimeSheetTable.reloadData()
    }
}
