//  TIMESHEETENTRYVC.swift
//  Trilegal

//  Created by Acxiom Consulting on 11/05/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.
// datePicker?.preferredDatePickerStyle = .wheels
import UIKit
import SQLite3

class TIMESHEETENTRYVC: BASEACTIVITY , UITextViewDelegate , UITableViewDelegate , UITableViewDataSource , OptionButtonsDelegate , SwiftySwitchDelegate{
    @IBOutlet var rootview: UIView!

    var BlurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    var BlurEffectView = UIVisualEffectView()
    
    func valueChanged(sender: SwiftySwitch) {
        
        if sender.isOn {
            sender.myColor = hexStringToUIColor(hex:"#003366")
        }
        else{
            sender.myColor = UIColor.lightGray
        }
//        if self.offConselswitchbtn.isOn {
//            offConselswitchbtn.myColor = hexStringToUIColor(hex:"#003366")
//        }
//        else{
//            offConselswitchbtn.myColor = UIColor.lightGray
//        }
    }
    
    func toggleclicked(at index: IndexPath){
       
        self.setTabledata()
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeSheetEntryAdapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeSheeetEntryCell", for:  indexPath) as! TimeSheeetEntryCell
        let list: TimeSheetEntryAdapter
        list = timeSheetEntryAdapter[indexPath.row]
        setImageForBtnOutlet(button: cell.btnClick)
        cell.indexPath = indexPath
        cell.clientName.text = list.clientName
        cell.matterName.text = list.matterName
        cell.date.text = list.date
        cell.time.text = list.time
        cell.narration.text = list.narration
        cell.uid = list.uid!
        
        cell.actionEditIcon = {
            self.clientPopupDropDown.text  = list.clientName
            self.matterPopupDropDown.text = list.matterName
            self.datePopuptxtField.text = list.date
            self.datePopuptxtField.isUserInteractionEnabled = false
            self.datePopuptxtField.isEnabled = false
            self.timePopupTxtField.text = list.time
            self.narrationDetailsTxtView.text = list.narration
            self.billopoup.isOn = list.isbill! == "1" ? true : false
            self.offcpopup.isOn = list.isoffc! == "1" ? true : false
            self.billopoup.myColor = list.isbill! == "1" ? self.hexStringToUIColor(hex:"#003366") : UIColor.lightGray
            self.offcpopup.myColor = list.isoffc! == "1" ? self.hexStringToUIColor(hex:"#003366") : UIColor.lightGray
            self.index = indexPath.row
            self.dateFormatter.dateFormat = "HH:mm"
            self.datePicker4?.date = self.dateFormatter.date(from: list.time!)!
            self.dateFormatter.dateFormat = "yyyy-MM-dd"
            self.datePicker3?.date = self.dateFormatter.date(from: list.date!)!
            self.initdata()
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
         return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                self.presentDeletionFailsafe(indexPath: indexPath)
                completionHandler(true)
            }
            deleteAction.image = UIImage(systemName: "trash")
            deleteAction.backgroundColor = .systemRed
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let list: TimeSheetEntryAdapter
            list = timeSheetEntryAdapter[indexPath.row]
            index = indexPath.row
    }
    
    func showDetailsView(){
      //  self.navigationController?.navigationBar.isUserInteractionEnabled = false
     //   self.navigationController?.navigationBar.isTranslucent = true
        
        self.detailsView.isHidden = false
        self.blurView(view: rootview)
        view.bringSubviewToFront((detailsView))
    }
    
    func hideDetailsView(){
     //   self.navigationController?.navigationBar.isUserInteractionEnabled = true
     //   self.navigationController?.navigationBar.isTranslucent = false
        self.detailsView.isHidden = true
        view.sendSubviewToBack(detailsView)
        removeBlurView()
    }

    
    func showfaddedView(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        self.detailsView.isHidden = false
        self.view.bringSubviewToFront(self.detailsView)
    }
    
    func presentDeletionFailsafe(indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete?", preferredStyle: .alert)// yes action
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in  // replace data variable with your own data array
            let element = self.timeSheetEntryAdapter[indexPath.row]
            let uid = element.uid!
            self.deltsentry(uid: uid)
            self.setTabledata()
          }
        alert.addAction(yesAction)
        // cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var narrationTxtView: UITextView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var rightSideBtn: UIBarButtonItem!
    @IBOutlet weak var narrationView: UIView!
    @IBOutlet weak var narrationPopupTxtView: UITextView!
    @IBOutlet weak var narrationTextandImageView: UIView!
    @IBOutlet weak var timeSheetTable: UITableView!
    @IBOutlet weak var detailsSaveBtn: UIButton!
    @IBOutlet weak var narrationDetailsTxtView: UITextView!
    @IBOutlet weak var timeTxtField: UITextField!
    @IBOutlet weak var clientDropDown: DropDown!
    @IBOutlet weak var dateTxtField: UITextField!
    @IBOutlet weak var matterDropDown: DropDown!
    @IBOutlet weak var datePopuptxtField: UITextField!
    @IBOutlet weak var timePopupTxtField: UITextField!
    @IBOutlet weak var matterPopupDropDown: DropDown!
    @IBOutlet weak var clientPopupDropDown: DropDown!
    @IBOutlet weak var selectAllBtnOutlet: UIButton!
    var isAllSelected : Bool = false
    
    var narrationTxt : String!
    var selecteditemIdarr = [String]()
    var itemIdarr = [String]()
    
    var timeSheetEntryAdapter = [TimeSheetEntryAdapter]()
    var datePicker: UIDatePicker?
    var datePicker2 : UIDatePicker?
    
    var datePicker3: UIDatePicker?
    var datePicker4 : UIDatePicker?
    var date = Date()
    var index : Int!
    
    @IBOutlet weak var billableswitchbtn : SwiftySwitch!
    @IBOutlet weak var offConselswitchbtn : SwiftySwitch!
    @IBOutlet var billopoup: SwiftySwitch!
    @IBOutlet var offcpopup: SwiftySwitch!
    
    @IBOutlet var tothrs: UILabel!
    @IBOutlet var approved: UILabel!
    @IBOutlet var rejected: UILabel!
    @IBOutlet var submitted: UILabel!
    @IBOutlet var nsubmitted: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.currScreen = "TS"
        //40
        if(setName().count>15){
            self.setnav(controller: self, title: "Timesheet Entry" , spacing : 20)
        }
        else{
            self.setnav(controller: self, title: "Timesheet Entry              " , spacing : 30)
        }
        self.download(date: self.getdate(format: "yyyy-MM-dd"))
        dateTxtField.text! = self.getdate(format: "yyyy-MM-dd")
        datePicker?.date
        setUpSideBar()
      //  rightSideBtn.title = setName()
        borderToView()
        view.addSubview(narrationView)
        view.addSubview(detailsView)
        DatePicker()
        datePickerPoup()
        setImageForBtnOutlet(button: selectAllBtnOutlet)
        billableswitchbtn.delegate = self
        billableswitchbtn.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
//        billableswitchbtn.myColor = UIColor.lightGray
        
        offConselswitchbtn.delegate = self
        offConselswitchbtn.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
        
        offConselswitchbtn.myColor = UIColor.lightGray
        billableswitchbtn.myColor = UIColor.lightGray
        
        self.clientDropDown.isSearchEnable = true
        self.matterDropDown.isSearchEnable = true
        self.clientPopupDropDown.isSearchEnable = true
        self.matterPopupDropDown.isSearchEnable = true

    }
    
    func download(date:  String){
        if (AppDelegate.ntwrk > 0){
            self.showIndicator("loading...", vc: self)
            self.getts_forday(date: date)
        }else{
            self.showToast(message: CONSTANT.NET_ERR)
            self.setData()
        }
    }
    
    override func VD() {
            self.hideindicator()
        if (self.datech){
            self.setdetails()
        }else{
            self.setData()
        }
            
    }
    var datech: Bool = false
    var isfirst : Bool = true
    override func tsdone(ids: [String],type: Int = -1){
        self.hideindicator()
        for id in ids{
            self.deltsentry(uid: id)
        }
        self.setTabledata()
        self.showdonemsg(type: type)
    }
    
    func showdonemsg(type: Int){
        var msg = ""
        if (type == 0){
            msg = "Time sheet saved successfully, but not submitted for approval."
        }else if (type == 1){
            msg = "Time sheet submitted for approval successfully."
        }
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .default) { (_) in
            if (self.timeSheetEntryAdapter.count == 0){
                self.gotoHome()
            }else{
                self.datech = false
                self.download(date: self.getdate(format: "yyyy-MM-dd"))
            }
        }
        alert.addAction(ok)
        if (msg.count > 0){
            self.present(alert, animated: true, completion: nil)
        }        
    }
    
    
    //MARK:-BLUR VIEW
 private func BlurView(view: UIView) {
//        BlurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
//        BlurEffectView = UIVisualEffectView(effect: BlurEffect)
//        BlurEffectView.backgroundColor = UIColor.lightGray
//        BlurEffectView.alpha = 0.2
//        BlurEffectView.frame = view.bounds
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.addSubview(BlurEffectView)
//        AppDelegate.blureffectview=BlurEffectView
//        view.addSubview(AppDelegate.blureffectview)
    
    }
    
    func blurEffectView( enable: Bool) {
        let enabled = self.BlurEffectView.effect != nil
        guard enable != enabled else { return }
        switch enable {
        case true:
            let blurEffect = UIBlurEffect(style: .dark)
            UIView.animate(withDuration: 1.5) {
                self.BlurEffectView.effect = blurEffect
            }
        case false:
            UIView.animate(withDuration: 0.1) {
                self.BlurEffectView.effect = nil
            }
        }
    }
    
    private func borderToView(){
        narrationTextandImageView.layer.borderColor = UIColor.lightGray.cgColor
        narrationTextandImageView.layer.borderWidth = 1
        detailsView.layer.borderColor = UIColor.lightGray.cgColor
        detailsView.layer.borderWidth = 0.5
        narrationDetailsTxtView.layer.borderColor = UIColor.lightGray.cgColor
        narrationDetailsTxtView.layer.borderWidth = 1
    }
    private func setPopupData(){
        setMattterDropDown()
        setClientDropDown()
    }
    func DatePicker (){
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.preferredDatePickerStyle = .wheels
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
        dateTxtField.inputAccessoryView = toolbar
        dateTxtField.inputView = datePicker
        
        toolbar1.setItems([donetButton,spacetButton,canceltButton], animated: false)
        timeTxtField.inputAccessoryView = toolbar1
        timeTxtField.inputView = datePicker2
    }
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.date_check(date: formatter.string(from: self.datePicker!.date), textfield: dateTxtField)
//        dateTxtField.text = formatter.string(from: self.datePicker!.date)
        self.view.endEditing(true)
    }
    @objc func donedatetPicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeTxtField.text = formatter.string(from: self.datePicker2!.date)
        self.view.endEditing(true)
    }
    @objc func donedatePicker1(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        self.date_check(date: formatter.string(from: self.datePicker3!.date), textfield: datePopuptxtField)
//        datePopuptxtField.text = formatter.string(from: self.datePicker3!.date)
        self.view.endEditing(true)
    }
    
    func date_check(date: String, textfield: UITextField){
        let ndate = textfield.text!
        let selected = date
        if (self.checkdatafordate(date: ndate)){
            if (ndate != date){
                let alert = UIAlertController(title: "Alert", message: "Change of date will delete the existing data of another date. Would you like to continue?", preferredStyle: .alert)
                let yes = UIAlertAction(title: "Yes", style: .default) { (result) in
                    self.deletetable(tbl: "TSEentry")
                    textfield.text = date
                    self.setTabledata()
                    alert.dismiss(animated: true, completion: nil)
                    self.view.endEditing(true)
                    self.datech = true
                    self.download(date: selected)
                }
                let no = UIAlertAction(title: "No", style: .destructive) { (result) in
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(yes)
                alert.addAction(no)
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            textfield.text = date
            self.view.endEditing(true)
            self.datech = true
            self.download(date: selected)
        }
    }
    func checkdatafordate(date : String)-> Bool{
        var flag = false
        
        var stmt1:OpaquePointer?
        
        let query = "select * from TSEentry where date = '\(date)'"
        print("query --> \(query)")

        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return false
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            flag = true
        }
        
        return flag
    }
    func checkdatafortime(time : Int,uid : String = "")-> Bool{
        var flag = true
        
        var stmt1:OpaquePointer?
        var entrytime = 0, tottime = 0,dayhr = 24 * 60
        
        let query = "select ((select totmin from TSdatesum) + (SELECT ifnull(sum(time),0) from TSEentry where uid <> '\(uid)'))"

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
    
    @objc func donedatetPicker2(){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timePopupTxtField.text = formatter.string(from: self.datePicker4!.date)
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker1(){
        self.view.endEditing(true)
    }
    func datePickerPoup (){
        datePicker3 = UIDatePicker()
        datePicker3?.preferredDatePickerStyle = .wheels
        datePicker3?.datePickerMode = .date
        datePicker4 = UIDatePicker()
        datePicker4?.preferredDatePickerStyle = .wheels
        datePicker4?.datePickerMode = .time
        datePicker4?.locale = Locale.init(identifier: "en_gb")
        
        let toolbar3 = UIToolbar();
        let toolbar4 = UIToolbar();
        toolbar3.sizeToFit()
        toolbar4.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker1));
        let donetButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatetPicker2));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker1));
        let spacetButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let canceltButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker1));
        toolbar3.setItems([doneButton,spaceButton,cancelButton], animated: false)
        datePopuptxtField.inputAccessoryView = toolbar3
        datePopuptxtField.inputView = datePicker3
        toolbar4.setItems([donetButton,spacetButton,canceltButton], animated: false)
        timePopupTxtField.inputAccessoryView = toolbar4
        timePopupTxtField.inputView = datePicker4
    }
    
    func initdata(){
        billopoup.delegate = self
        billopoup.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
        
        offcpopup.delegate = self
        offcpopup.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
        
        self.setMattterPopupDropDown(clname: self.clientPopupDropDown.text!, detail: false)
        self.setClientPopupDropDown(mtname: self.matterPopupDropDown.text!, detail: false)
        self.type = "-1"
    }
    
    private  func setData(){
        setClientDropDown()
        setMattterDropDown()
        setTabledata()
        self.setdetails()
    }
    func setdetails(){
        var stmt1:OpaquePointer?
        
        let query = "select tothrs , apphrs , rejhrs , subhrs , nshrs , totmin from TSdatesum"

        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let tothrs = String(cString: sqlite3_column_text(stmt1, 0))
            let apphrs = String(cString: sqlite3_column_text(stmt1, 1))
            let rejhrs = String(cString: sqlite3_column_text(stmt1, 2))
            let subhrs = String(cString: sqlite3_column_text(stmt1, 3))
            let nshrs = String(cString: sqlite3_column_text(stmt1, 4))
            
            self.tothrs.text = tothrs
            self.submitted.text = subhrs
            self.nsubmitted.text = nshrs
            self.approved.text = apphrs
            self.rejected.text = rejhrs
        }
    }
    
    public func setMattterPopupDropDown(clname: String = "", detail : Bool = true){
        
        if detail {
            self.matterPopupDropDown.text = "-Select Matter-"
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
        matterPopupDropDown.optionArray.removeAll()
        matterPopupDropDown.optionArray.append("-Select Matter-")
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let str = String(cString: sqlite3_column_text(stmt1, 1))
            matterPopupDropDown.optionArray.append(str)
        }
        
        if (matterPopupDropDown.optionArray.count == 2 ){
            self.matterPopupDropDown.text = matterPopupDropDown.optionArray[1]
        }
        
        matterPopupDropDown.didSelect { (selection, index, id) in
            self.setClientPopupDropDown(mtname: selection)
            self.clientPopupDropDown.text = self.clientPopupDropDown.optionArray[1]
            
            self.type = self.getmattertype(str: selection)
            if ( self.type == "0"){
                self.billopoup.isUserInteractionEnabled = true
                self.billopoup.isOn = true
                self.billopoup.myColor = self.hexStringToUIColor(hex:"#003366")
                self.billpopupview.isUserInteractionEnabled = true
            }else if (self.type == "1"){
                self.billopoup.isUserInteractionEnabled = false
                self.billopoup.isOn = false
                self.billopoup.myColor = UIColor.lightGray
                self.billpopupview.isUserInteractionEnabled = false
            }else{
                self.billopoup.isUserInteractionEnabled = true
                self.billopoup.isOn = false
                self.billopoup.myColor = UIColor.lightGray
                self.billpopupview.isUserInteractionEnabled = false
            }
        }
    }
    
    public func setMattterDropDown(clname: String = ""){
        self.matterDropDown.text = "-Select Matter-"
        var stmt1:OpaquePointer?
        
        matterarr.removeAll()
        mattertype.removeAll()
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
        
        matterDropDown.didSelect { (selection, index, id) in
            self.setClientDropDown(mtname: selection)
            self.clientDropDown.text = self.clientDropDown.optionArray[1]
            
            self.type = self.getmattertype(str: selection)
            if ( self.type == "0"){
                self.billableswitchbtn.isUserInteractionEnabled = true
                self.billableswitchbtn.isOn = true
                self.billableswitchbtn.myColor = self.hexStringToUIColor(hex:"#003366")
                self.billmainview.isUserInteractionEnabled = true
            }else if (self.type == "1"){
                self.billableswitchbtn.isUserInteractionEnabled = false
                self.billableswitchbtn.isOn = false
                self.billableswitchbtn.myColor = UIColor.lightGray
                self.billmainview.isUserInteractionEnabled = false
            }else{
                self.billableswitchbtn.isUserInteractionEnabled = true
                self.billableswitchbtn.isOn = false
                self.billableswitchbtn.myColor = UIColor.lightGray
                self.billmainview.isUserInteractionEnabled = false
            }
        }
    }
    
    @IBOutlet var billmainview: UIStackView!
    
    @IBOutlet var billpopupview: UIStackView!
    
    var type = ""
    var clientarr = [String]()
    var matterarr = [String]()
    var mattertype = [Int]()
    
    public func setClientDropDown(mtname: String = ""){
        self.clientDropDown.text = "-Select Client-"
        
        var stmt1:OpaquePointer?
        
        clientarr.removeAll()
        
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
            let code = String(cString: sqlite3_column_text(stmt1, 0))
            let str = String(cString: sqlite3_column_text(stmt1, 1))
            clientDropDown.optionArray.append(str)
            clientarr.append(code)
        }
        
        clientDropDown.didSelect { (selection, index, id) in
            self.setMattterDropDown(clname: selection)
        }
    }
    
    public func setClientPopupDropDown(mtname: String = "", detail : Bool = true){
        
        if detail {
            self.clientPopupDropDown.text = "-Select Client-"
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
        clientPopupDropDown.optionArray.removeAll()
        clientPopupDropDown.optionArray.append("-Select Client-")
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let code = String(cString: sqlite3_column_text(stmt1, 0))
            let str = String(cString: sqlite3_column_text(stmt1, 1))
            clientPopupDropDown.optionArray.append(str)
        }
        
        clientPopupDropDown.didSelect { (selection, index, id) in
            self.setMattterPopupDropDown(clname: selection)
        }
    }
    
    private  func setTabledata(){
        var stmt1:OpaquePointer?
        self.timeSheetEntryAdapter.removeAll()
        let query = "select a.uid,b.ClientDesc,b.MatterDesc,a.date,a.time, a.narration,a.status,a.isbillable,a.isoffcounsel from TSEentry a left outer join ClientMaster b on b.ClientCode = a.client and a.matter = b.MatterCode"
        
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
            
            self.timeSheetEntryAdapter.append(TimeSheetEntryAdapter(uid: uid,clientName: clname, matterName: mattername, date: date, time: self.gettime(min: Int(time)), narration: narration, btnState: state, isbill: isbill,isoffc: isoffc))
        }
        self.timeSheetTable.reloadData()
    }
    
    @IBAction func detailsSaveBtn(_ sender: UIButton) {
        if(validateDetailsView()){
            let uid = self.timeSheetEntryAdapter[index].uid
            let hr = String(self.timePopupTxtField.text!.prefix(2))
            let min = String(self.timePopupTxtField.text!.suffix(2))
            
            var time = (Int(hr)! * 60)
            time = time + Int(min)!
            
            if (self.checkdatafortime(time: time,uid: uid!)){
                self.update_tsentry(uid: uid!, client: self.getclientid(str: self.clientPopupDropDown.text!), matter: self.getmatterid(str: self.matterPopupDropDown.text!), hours: hr, mins: min, time: "\(time)", narration: self.narrationDetailsTxtView.text!,billable: self.billopoup.isOn ? "1" : "0",offcounsel: self.offcpopup.isOn ? "1" : "0")
                self.setTabledata()
                self.hideDetailsView()
            }
        }
    }
    
    @IBAction func detailsBackBtn(_ sender: UIButton) {
        self.hideDetailsView()
    }
    
    @IBAction func sideMenuBtn(_ sender: UIBarButtonItem) {
        onClickSideMenu()
    }
    
    @IBAction func expandImageBtn(_ sender: UIButton) {
        if(!(narrationTxtView.text.isEmpty || narrationTxtView.text == "Please Add Narration")){
            narrationPopupTxtView.text = narrationTxtView.text
        }
        showView()
    }
    
    @IBAction func selectAllBtn(_ sender: UIButton) {
        isAllSelected = !isAllSelected
        self.updatestatus(status: isAllSelected ? "1" : "0", uid: "-1")
        animatebtnOutlet(button: self.selectAllBtnOutlet)
        self.setTabledata()
    }
    
    @IBAction func AddBtn(_ sender: UIButton) {
        if(validate()){
            let date = self.dateTxtField.text!
            let hr = String(self.timeTxtField.text!.prefix(2))
            let min = String(self.timeTxtField.text!.suffix(2))
            
            var time = (Int(hr)! * 60)
            time = time + Int(min)!
            let ndate = self.dateTxtField.text!
            if (!self.checkdatafordate(date: ndate) && self.timeSheetEntryAdapter.count > 0){
                let alert = UIAlertController(title: "Alert", message: "Change of date will delete the existing data of another date. Would you like to continue?", preferredStyle: .alert)
                let yes = UIAlertAction(title: "Yes", style: .default) { (result) in
                    self.deletetable(tbl: "TSEentry")
                    if (self.checkdatafortime(time: time)){
                        self.insert_tsentry(uid: self.getuid(), client: self.getclientid(str: self.clientDropDown.text!), matter: self.getmatterid(str: self.matterDropDown.text!), date: date, hours: hr, mins: min, time: "\(time)", isbillable: self.billableswitchbtn.isOn ? "1" : "0", isoffcounsel: self.offConselswitchbtn.isOn ? "1" : "0", narration: self.narrationTxtView.text!, post: "0")
                        
                        self.setTabledata()
                        self.afterAddBtnClick() 
                    }
                    alert.dismiss(animated: true, completion: nil)
                    self.view.endEditing(true)
                }
                let no = UIAlertAction(title: "No", style: .destructive) { (result) in
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(yes)
                alert.addAction(no)
                self.present(alert, animated: true, completion: nil)
            }else{
                if (self.checkdatafortime(time: time)){
                    self.insert_tsentry(uid: self.getuid(), client: self.getclientid(str: self.clientDropDown.text!), matter: self.getmatterid(str: self.matterDropDown.text!), date: date, hours: hr, mins: min, time: "\(time)", isbillable: self.billableswitchbtn.isOn ? "1" : "0", isoffcounsel: self.offConselswitchbtn.isOn ? "1" : "0", narration: self.narrationTxtView.text!, post: "0")
                    
                    self.setTabledata()
                    self.afterAddBtnClick()
                }
            }
            
        }
    }
    
    @IBAction func resetBtnClick(_ sender: UIButton) {
        afterAddBtnClick()
    }
    
    
    @IBAction func save(_ sender: UIButton) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure, you want to save?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .default) { (_) in
            alert.dismiss(animated: true, completion: nil)
            if (AppDelegate.ntwrk > 0){
                self.showIndicator("Syncing...", vc: self)
                self.post_ts(type: 0)
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
    
    @IBAction func submit(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure want to save & submit?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .default) { (_) in
            alert.dismiss(animated: true, completion: nil)
            if (AppDelegate.ntwrk > 0){
                self.showIndicator("Syncing...", vc: self)
                self.post_ts(type: 1)
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
    
    func checklist()-> Bool{
        var flag = true
        var select = 0
        if (self.timeSheetEntryAdapter.count > 0){
            for adapter in self.timeSheetEntryAdapter {
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
    
    func afterAddBtnClick(){
        dateTxtField.text = self.getdate(format: "yyyy-MM-dd")
//        date
        timeTxtField.text = ""
        dateTxtField.placeholder = "YYYY-MM-DD"
        timeTxtField.placeholder = "HH:MM"
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        let date = dateFormatter.date(from: "00:00")
        datePicker2!.date = date!
        dateFormatter.dateFormat = "yyyy-MM-dd"
        datePicker?.date = dateFormatter.date(from: self.getdate(format: "yyyy-MM-dd"))!
        narrationTxtView.text = "Please Add Narration"
        narrationPopupTxtView.text = "Add Narration"
        offConselswitchbtn.isOn = false
        billableswitchbtn.isOn = false
        offConselswitchbtn.myColor = UIColor.lightGray
        billableswitchbtn.myColor = UIColor.lightGray
        self.setData()
        
    }
    
    override func INVD(msg: String) {
        self.hideindicator()
        self.showToast(message: msg)
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
        if(dateTxtField.text?.count == 0){
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
    
    func validateDetailsView() -> Bool {
        var validate : Bool = true
        if(clientPopupDropDown.text!.isEmpty || self.getclientid(str: self.clientPopupDropDown.text!) == "-1"){
            self.showtoast(controller: self, message: "Please Select Client", seconds: 1.0)
            validate = false
        }
        if(matterPopupDropDown.text!.isEmpty || self.getmatterid(str: self.matterPopupDropDown.text!) == "-1"){
            self.showtoast(controller: self, message: "Please Select Matter", seconds: 1.0)
            validate = false
            
        }
        if(datePopuptxtField.text!.isEmpty || datePopuptxtField.text == "YYYY-MM-DD"){
            self.showtoast(controller: self, message: "Please Select Date", seconds: 1.0)
            validate = false
            
        }
        if(timePopupTxtField.text!.isEmpty || timePopupTxtField.text == "HH:MM"){
            self.showtoast(controller: self, message: "Please Select Time", seconds: 1.0)
            validate = false
        }
        if(timePopupTxtField.text == "00:00"){
            self.showtoast(controller: self, message: "00:00 Time not allowed", seconds: 1.0)
            validate = false
        }
        if(narrationDetailsTxtView.text!.isEmpty || narrationDetailsTxtView.text == "Narration"){
            self.showtoast(controller: self, message: "Please Enter Narration", seconds: 1.0)
            validate = false
        }
        
        
        return validate
    }
    
    
    
    //MARK:- SHOW VIEW
    private  func showView(){
        narrationView.layer.borderColor = UIColor.lightGray.cgColor
        narrationView.layer.borderWidth = 1
        narrationPopupTxtView.layer.borderColor = UIColor.lightGray.cgColor
        narrationPopupTxtView.layer.borderWidth = 0.5
        self.narrationView.isHidden = false
        self.narrationPopupTxtView.text = self.narrationTxtView.text!
        let myUITextView = UITextView.init()
        myUITextView.delegate = self
    }
    //MARK:- TEXTVIEW NIL
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Please Add Narration"  || textView.text  == "Add Narration" || textView.text  == "Narration"{
            textView.text = nil
            textView.textColor = UIColor.darkGray
        }
    }
    //MARK:- CANCEL BTN
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        self.narrationView.isHidden = true
    }
    //MARK:- OK BTN
    @IBAction func okBtnClick(_ sender: UIButton) {
        if(!(narrationPopupTxtView.text == "Add Narration")){
            narrationTxtView.text = narrationPopupTxtView.text
            self.narrationView.isHidden = true
            view.endEditing(true)
        }
        else {
            self.showtoast(controller: self, message: "Please Enter Narration", seconds: 1.0)
        }
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
