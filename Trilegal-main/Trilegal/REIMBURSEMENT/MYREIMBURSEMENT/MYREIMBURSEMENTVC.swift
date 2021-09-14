//
//  MYREIMBURSEMENTVC.swift
//  Trilegal
//
//  Created by Acxiom Consulting on 10/05/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.
//MARK:- IMPORTS
import UIKit
import SQLite3

//MARK:- BEGINNING OF CLASS
class MYREIMBURSEMENTVC: BASEACTIVITY , UITableViewDelegate , UITableViewDataSource , SwiftySwitchDelegate{
    //MARK:- VALUE CHANGED
    func valueChanged(sender: SwiftySwitch) {
        if sender.isOn {
            edtswitchbtnSwifty.myColor = hexStringToUIColor(hex:"#003366")
        }
        else{
            edtswitchbtnSwifty.myColor = UIColor.lightGray
        }
    }
    //MARK:- NUMBER OF ROWS IN SECTION
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myReimbursementAdapter.count
    }
    //MARK:- CELL FOR ROW AT
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyReimbursementCell", for:  indexPath) as! MyReimbursementCell
        let list: MyReimbursementAdapter
        list = myReimbursementAdapter[indexPath.row]
        cell.clientName.text = list.clientName
        cell.matterName.text = list.matterName
        cell.expenseDate.text = list.expenseDate
        cell.amount.text = list.amount
        cell.remark.text = list.remark
        cell.status.text = list.status
        cell.paymentType.text = list.paymentType
        cell.actionEditIcon = {
            self.edtclientDropDown.text  = list.clientName
            self.edtmatterDropDown.text = list.matterName
            self.edtdateTextField.text = list.expenseDate
            self.edtamountTextField.text = list.amount
            self.edtremarksTxtView.text = list.remark
            self.edtpayTestTxtField.text  = list.payto
            self.edtpaymentTypeDropDown.text = list.paymentType
            self.edtcorporateCardDropDown.text = list.corporateCard
            self.edtexpenseCatgDropDown.text = list.expenseCatg
            self.edtcostCenterDropDown.text = list.costCenter
            if(list.noFileChoosenTxt!.isEmpty){
                self.edtChooseFileBtn.backgroundColor = UIColor.lightGray
                self.edtswitchbtnSwifty.myColor = UIColor.lightGray
                self.edtNofileChoosenTxt.text = "No File Choosen"
                self.edtswitchbtnSwifty.isOn = false
            }
            else{
                self.edtChooseFileBtn.backgroundColor = self.hexStringToUIColor(hex:"#003366")
                self.edtswitchbtnSwifty.myColor = self.hexStringToUIColor(hex:"#003366")
                self.edtNofileChoosenTxt.text = "File Selected"
                self.edtswitchbtnSwifty.isOn = true
            }
            if(list.debitToTxt == "1"){
                self.edtsegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: .normal)
                self.edtsegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
                self.edtsegmentedControl.isSelected = false
            }
            else{
                self.edtsegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: .normal)
                self.edtsegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
                self.edtsegmentedControl.isSelected = true
            }
            self.showDetailsView()
        }
        return cell
    }
    //MARK:- BUTTON OUTLETS
    @IBOutlet weak var toDateTxtFeild: UITextField!
    @IBOutlet weak var fromDateTxtField: UITextField!
    @IBOutlet weak var statusDropDown: DropDown!
    @IBOutlet weak var paymentDropDown: DropDown!
    @IBOutlet weak var rightSideBtn: UIBarButtonItem!
    @IBOutlet weak var myReimbursementTable: UITableView!
    @IBOutlet var rootview: UIView!
    
    //MARK:- EDIT BUTTON OUTLETS
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var edtremarksTxtView: UITextView!
    @IBOutlet weak var edtclientDropDown: DropDown!
    @IBOutlet weak var edtcostCenterDropDown: DropDown!
    @IBOutlet weak var edtcorporateCardDropDown: DropDown!
    @IBOutlet weak var edtexpenseCatgDropDown: DropDown!
    @IBOutlet weak var edtpaymentTypeDropDown: DropDown!
    @IBOutlet weak var edtdateTextField: UITextField!
    @IBOutlet weak var edtmatterDropDown: DropDown!
    @IBOutlet weak var edtpayTestTxtField: UITextField!
    @IBOutlet weak var edtamountTextField: UITextField!
    @IBOutlet weak var edtsegmentedControl: UISegmentedControl!
    @IBOutlet weak var edtswitchbtn : UISwitch!
    @IBOutlet weak var edtswitchbtnSwifty : SwiftySwitch!
    @IBOutlet weak var edtChooseFileBtn : UIButton!
    @IBOutlet weak var edtNofileChoosenTxt : UILabel!

    //MARK:- VARIABLE DECLARATION
    var popupIndex : Int = 0
    var status = ""
    var payment = ""
    var myReimbursementAdapter = [MyReimbursementAdapter]()
    var datePicker: UIDatePicker?
    var datePicker2 : UIDatePicker?
    var date = Date()
    var type = 10
    var typearr = [Int]()
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.currScreen = "MYRE"
        if(setName().count>15){
            self.setnav(controller: self, title: "My Reimbursement" , spacing : 10)
        }
        else{
            self.setnav(controller: self, title: "My Reimbursement        " , spacing : 30)
        }

        setUpSideBar()
        setDates()
        DatePicker()
        setDropDownData()
        setPaymentDropDownMyReimbursement(paymentDropDown: paymentDropDown)
        fromDateTxtField.text! = self.setFromDateRem()
        toDateTxtFeild.text = setToDate()
        self.statusDropDown.text = self.statusDropDown.optionArray[0]
        self.paymentDropDown.text = self.paymentDropDown.optionArray[0]
        switchBtnSetup()
        invalidateTouch()
        borderToView()
        onSelectPaymentType()
    }
    //MARK:- SETDROPDOWN DATA
    private func setDropDownData(){
        self.typearr = setStatusDropDown(statusDropDown:statusDropDown)
        statusDropDown.didSelect { (selecttion, index, id) in
            self.type = self.typearr[index]
        }
    }
    //MARK:- VIEW DID APPEAR
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.getdatamyReimbursement(isBool: false)
    }
    //MARK:- API CALLING
    func getdatamyReimbursement(isBool : Bool){
        if (AppDelegate.ntwrk > 0){
            self.showIndicator("Syncing...", vc: self)
            getmyReimbursement(startdate: self.fromDateTxtField.text!, enddate: self.toDateTxtFeild.text!, type: type,isReloadClick: isBool)
        }else{
            self.showToast(message: "Please check your Internet connection")
        }
    }
    //MARK:- SET DATES
    func setDates(){
        fromDateTxtField.text = setFromDateRem()
        toDateTxtFeild.text = setToDate()
    }
    //MARK:- SIDE MENU BTN CLICK
    @IBAction func sideMenuBtn(_ sender: UIBarButtonItem) {
        onClickSideMenu()
    }
    //MARK:- RELOAD BTN CLICK
    @IBAction func relaadBtn(_ sender: UIButton) {
        status = statusDropDown.text!
        payment = paymentDropDown.text!
        UserDefaults.standard.setValue(self.paymentDropDown.text! , forKey: "payment")
        UserDefaults.standard.setValue(self.statusDropDown.text! , forKey: "status")
        reloadBtnClick()
    }
    //MARK:- BACK BTN CLICK
    @IBAction func backBtn(_ sender: UIButton) {
        hideDetailsView()
    }
    //MARK:- DATE PICKER
    func DatePicker (){
        datePicker = UIDatePicker()
        datePicker?.preferredDatePickerStyle = .wheels
        datePicker?.datePickerMode = .date
        datePicker2 = UIDatePicker()
        datePicker2?.preferredDatePickerStyle = .wheels
        datePicker2?.datePickerMode = .date
        datePicker?.maximumDate = self.date
        datePicker2?.maximumDate = self.date
        let toolbar = UIToolbar()
        let toolbar1 = UIToolbar()
        toolbar.sizeToFit()
        toolbar1.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let donetButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatetPicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        let spacetButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let canceltButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        fromDateTxtField.inputAccessoryView = toolbar
        fromDateTxtField.inputView = datePicker
        toolbar1.setItems([donetButton,spacetButton,canceltButton], animated: false)
        toDateTxtFeild.inputAccessoryView = toolbar1
        toDateTxtFeild.inputView = datePicker2
    }
    //MARK:- DONE DATE PICKER
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MMM-dd"
        fromDateTxtField.text = formatter.string(from: self.datePicker!.date)
        self.view.endEditing(true)
    }
    //MARK:- DONE DATE PICKER
    @objc func donedatetPicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MMM-dd"
        toDateTxtFeild.text = formatter.string(from: self.datePicker2!.date)
        self.view.endEditing(true)
    }
    //MARK:- CANCEL DATE PICKER
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    //MARK:- OVERRIDE
    override func VD() {
        self.hideindicator()
        self.setTabledata(statusstr: self.statusDropDown.optionArray[0], paymentstr: self.paymentDropDown.optionArray[0])
        self.statusDropDown.text = self.statusDropDown.optionArray[0]
        self.paymentDropDown.text = self.paymentDropDown.optionArray[0]
    }
    override func VD1() {
        self.hideindicator()
        self.edtsetTabledata(statusstr: self.status, paymentstr: self.payment)
    }
    override func INVD(msg: String) {
        self.hideindicator()
        self.setTabledata(statusstr: self.statusDropDown.optionArray[0], paymentstr: self.paymentDropDown.optionArray[0])
        self.showToast(message: msg)
    }
    //MARK:- SETTABLEDATAREIMBURSEMENT
    private  func setTabledata(statusstr: String, paymentstr: String){
        var count : Int = 0
        var stmt1:OpaquePointer?
        self.myReimbursementAdapter.removeAll()
        var pay : String = ""
        let statusstr = statusstr == "All" ? "" : statusstr
        let paymentstr = paymentstr == "All" ? "" : paymentstr
        if(paymentstr == "All"){
            pay = ""
        }
        else if (paymentstr == "Reimbursement"){
            pay = "0"
        }
        else if (paymentstr == "Non-Reimbursement"){
            pay = "1"
        }
        else if (paymentstr == "Corporate Card"){
            pay = "2"
        }

        let query = "select TransDate,ClaimAmount,ClientName,ProjectName,Remarks,Status, paymentType,ResourceName,CardName,CategotyName,CostCenterName,AttachmentPath,ClientOffice from ReimbursementMaster where Status like '%\(statusstr)%' and PaymentType like '%\(pay)%' order by TransDate desc"
        
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            count = count + 1
            let expenseDate = String(cString: sqlite3_column_text(stmt1, 0))
            let amount = String(cString: sqlite3_column_text(stmt1, 1))
            let clientName = String(cString: sqlite3_column_text(stmt1, 2))
            let matterName = String(cString: sqlite3_column_text(stmt1, 3))
            let remark = String(cString: sqlite3_column_text(stmt1, 4))
            let status = String(cString: sqlite3_column_text(stmt1, 5))
            let paymentType = String(cString: sqlite3_column_text(stmt1, 6))
            let payto = String(cString: sqlite3_column_text(stmt1, 7))
            let corporateCard = String(cString: sqlite3_column_text(stmt1, 8))
            let expenseCatg = String(cString: sqlite3_column_text(stmt1, 9))
            let costCenter = String(cString: sqlite3_column_text(stmt1, 10))
            let noFileChoosenTxt = String(cString: sqlite3_column_text(stmt1, 11))
            let debitToTxt = String(cString: sqlite3_column_text(stmt1, 12))
            if (paymentType == "0"){
                pay = "Reimbursement"
            }
            else if (paymentType == "1"){
                pay = "Non-Reimbursement"
            }
            else if (paymentType == "2"){
                pay = "Corporate Card"
            }
            self.myReimbursementAdapter.append(MyReimbursementAdapter(expenseDate: expenseDate, amount: amount, clientName: clientName, matterName: matterName, remark: remark, status: status, paymentType: pay, payto: payto, corporateCard: corporateCard, expenseCatg: expenseCatg, costCenter: costCenter, noFileChoosenTxt: noFileChoosenTxt, debitToTxt: debitToTxt))
        }
        if(count == 0){
            showtoast(controller: self, message: "No Record Found!!", seconds: 2.0)
        }
        self.myReimbursementTable.reloadData()
    }
    //MARK:- RELOAD DATA
    func reloadBtnClick(){
        getdatamyReimbursement(isBool: true)
    }
    //MARK:- SHOW DETAILS
    func showDetailsView(){
        self.detailsView.isHidden = false
        self.blurView(view: rootview)
        view.bringSubviewToFront((detailsView))
    }
    //MARK:- HIDE DETAILS
    func hideDetailsView(){
        self.detailsView.isHidden = true
        view.sendSubviewToBack(detailsView)
        removeBlurView()
    }
    //MARK:- INVALIDATE TOUCH
    func invalidateTouch(){
        self.edtremarksTxtView.isUserInteractionEnabled = false
        self.edtclientDropDown.isUserInteractionEnabled = false
        self.edtcostCenterDropDown.isUserInteractionEnabled = false
        self.edtcorporateCardDropDown.isUserInteractionEnabled = false
        self.edtexpenseCatgDropDown.isUserInteractionEnabled = false
        self.edtpaymentTypeDropDown.isUserInteractionEnabled = false
        self.edtdateTextField.isUserInteractionEnabled = false
        self.edtmatterDropDown.isUserInteractionEnabled = false
        self.edtpayTestTxtField.isUserInteractionEnabled = false
        self.edtsegmentedControl.isUserInteractionEnabled = false
        self.edtswitchbtn.isUserInteractionEnabled = false
        self.edtswitchbtnSwifty.isUserInteractionEnabled = false
        self.edtChooseFileBtn.isUserInteractionEnabled = false
        self.edtamountTextField.isUserInteractionEnabled = false
    }
    //MARK:- SWITCH BTN SETUP
    func switchBtnSetup(){
        edtswitchbtn.set(width: 70, height: 20)
        edtswitchbtnSwifty.delegate = self
        edtswitchbtnSwifty.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
        edtswitchbtnSwifty.myColor = UIColor.lightGray
    }
    //MARK:- BORDER TO VIEW
    private func borderToView(){
        edtremarksTxtView.layer.borderColor = UIColor.lightGray.cgColor
        edtremarksTxtView.layer.borderWidth = 1
        detailsView.layer.borderColor = UIColor.lightGray.cgColor
        detailsView.layer.borderWidth = 0.5
    }
    //MARK:- SETTABLEDATA
    private  func edtsetTabledata(statusstr: String, paymentstr: String){
        var count : Int = 0
        var stmt1:OpaquePointer?
        self.myReimbursementAdapter.removeAll()
        var pay : String = ""
        var statusstr : String = ""
        var paymentstr : String = ""
        var query : String = ""
        statusstr = UserDefaults.standard.string(forKey: "status")!
        paymentstr = UserDefaults.standard.string(forKey: "payment")!
        statusstr = statusstr == "All" ? "" : statusstr
        paymentstr = paymentstr == "All" ? "" : paymentstr
        if(paymentstr == "All"){
            pay = ""
        }
        else if (paymentstr == "Reimbursement"){
            pay = "0"
        }
        else if (paymentstr == "Non-Reimbursement"){
            pay = "1"
        }
        else if (paymentstr == "Corporate Card"){
            pay = "2"
        }
        if(statusstr == ""){
        query = "select TransDate,ClaimAmount,ClientName,ProjectName,Remarks,Status, paymentType,ResourceName,CardName,CategotyName,CostCenterName,AttachmentPath,ClientOffice from ReimbursementMaster where Status like '%\(statusstr)%' and PaymentType like '%\(pay)%' order by TransDate desc"
        }
        else{
            query = "select TransDate,ClaimAmount,ClientName,ProjectName,Remarks,Status, paymentType,ResourceName,CardName,CategotyName,CostCenterName,AttachmentPath,ClientOffice from ReimbursementMaster where Status = '\(statusstr)' and PaymentType like '%\(pay)%' order by TransDate desc"
        }
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            count = count + 1
            let expenseDate = String(cString: sqlite3_column_text(stmt1, 0))
            let amount = String(cString: sqlite3_column_text(stmt1, 1))
            let clientName = String(cString: sqlite3_column_text(stmt1, 2))
            let matterName = String(cString: sqlite3_column_text(stmt1, 3))
            let remark = String(cString: sqlite3_column_text(stmt1, 4))
            let status = String(cString: sqlite3_column_text(stmt1, 5))
            let paymentType = String(cString: sqlite3_column_text(stmt1, 6))
            let payto = String(cString: sqlite3_column_text(stmt1, 7))
            let corporateCard = String(cString: sqlite3_column_text(stmt1, 8))
            let expenseCatg = String(cString: sqlite3_column_text(stmt1, 9))
            let costCenter = String(cString: sqlite3_column_text(stmt1, 10))
            let noFileChoosenTxt = String(cString: sqlite3_column_text(stmt1, 11))
            let debitToTxt = String(cString: sqlite3_column_text(stmt1, 12))
            if (paymentType == "0"){
                pay = "Reimbursement"
            }
            else if (paymentType == "1"){
                pay = "Non-Reimbursement"
            }
            else if (paymentType == "2"){
                pay = "Corporate Card"
            }
            self.myReimbursementAdapter.append(MyReimbursementAdapter(expenseDate: expenseDate, amount: amount, clientName: clientName, matterName: matterName, remark: remark, status: status, paymentType: pay, payto: payto, corporateCard: corporateCard, expenseCatg: expenseCatg, costCenter: costCenter, noFileChoosenTxt: noFileChoosenTxt, debitToTxt: debitToTxt))
        }
        if(count == 0){
            showtoast(controller: self, message: "No Record Found!!", seconds: 2.0)
        }
        self.myReimbursementTable.reloadData()

    }
    //MARK:- SET FROM DATE
    public func setFromDateRem() -> String{
           let dateNew1 = Date()
           dateFormatter.dateFormat = "yyyy-MM-dd"
           let dateData = dateNew1.addingTimeInterval(-604800.0)
           let result = dateFormatter.string(from: dateData)
           return result
       }
    //MARK:- SETTABLEDATA
    private  func setTabledataRem(statusstr: String, paymentstr: String){
        var count : Int = 0
        var stmt1:OpaquePointer?
        self.myReimbursementAdapter.removeAll()
        var pay : String = ""
        let statusstr = statusstr == "All" ? "" : statusstr
        let paymentstr = paymentstr == "All" ? "" : paymentstr
        if(paymentstr == "All"){
            pay = ""
        }
        else if (paymentstr == "Reimbursement"){
            pay = "0"
        }
        else if (paymentstr == "Non-Reimbursement"){
            pay = "1"
        }
        else if (paymentstr == "Corporate Card"){
            pay = "2"
        }

        let query = "select TransDate,ClaimAmount,ClientName,ProjectName,Remarks,Status, paymentType,ResourceName,CardName,CategotyName,CostCenterName,AttachmentPath,ClientOffice from ReimbursementMaster where Status like '\(statusstr)%' and PaymentType like '%\(pay)%' order by TransDate desc"
        
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            count = count + 1
            let expenseDate = String(cString: sqlite3_column_text(stmt1, 0))
            let amount = String(cString: sqlite3_column_text(stmt1, 1))
            let clientName = String(cString: sqlite3_column_text(stmt1, 2))
            let matterName = String(cString: sqlite3_column_text(stmt1, 3))
            let remark = String(cString: sqlite3_column_text(stmt1, 4))
            let status = String(cString: sqlite3_column_text(stmt1, 5))
            let paymentType = String(cString: sqlite3_column_text(stmt1, 6))
            let payto = String(cString: sqlite3_column_text(stmt1, 7))
            let corporateCard = String(cString: sqlite3_column_text(stmt1, 8))
            let expenseCatg = String(cString: sqlite3_column_text(stmt1, 9))
            let costCenter = String(cString: sqlite3_column_text(stmt1, 10))
            let noFileChoosenTxt = String(cString: sqlite3_column_text(stmt1, 11))
            let debitToTxt = String(cString: sqlite3_column_text(stmt1, 12))
            if (paymentType == "0"){
                pay = "Reimbursement"
            }
            else if (paymentType == "1"){
                pay = "Non-Reimbursement"
            }
            else if (paymentType == "2"){
                pay = "Corporate Card"
            }
            self.myReimbursementAdapter.append(MyReimbursementAdapter(expenseDate: expenseDate, amount: amount, clientName: clientName, matterName: matterName, remark: remark, status: status, paymentType: pay, payto: payto, corporateCard: corporateCard, expenseCatg: expenseCatg, costCenter: costCenter, noFileChoosenTxt: noFileChoosenTxt, debitToTxt: debitToTxt))
        }
        if(count == 0){
            showtoast(controller: self, message: "No Record Found!!", seconds: 2.0)
        }
        self.myReimbursementTable.reloadData()

    }
    //MARK:- ON SELECT PAYMENT TYPE
    func onSelectPaymentType(){
        paymentDropDown.didSelect { (selecttion, index, id) in
            self.setTabledataRem(statusstr: self.statusDropDown.text!, paymentstr: selecttion)
        }
    }
}
