//  EDITREIMBURSEMENTVC.swift
//  Trilegal
//  Created by Acxiom Consulting on 10/05/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.

import UIKit
import SQLite3
import MobileCoreServices

class EDITREIMBURSEMENTVC: BASEACTIVITY , UITableViewDataSource , UITableViewDelegate , SwiftySwitchDelegate , OptionButtonsDelegateRemEdit , UIDocumentPickerDelegate {
    func valueChanged(sender: SwiftySwitch) {
        if self.edtswitchbtnSwifty.isOn {
            edtswitchbtnSwifty.myColor = hexStringToUIColor(hex:"#003366")
            edtChooseFileBtn.backgroundColor = hexStringToUIColor(hex:"#003366")
            edtChooseFileBtn.isUserInteractionEnabled = true
        }
        else{
            edtswitchbtnSwifty.myColor = UIColor.lightGray
            edtChooseFileBtn.backgroundColor = UIColor.lightGray
            edtChooseFileBtn.isUserInteractionEnabled = false
        }
    }
    func closeFriendsTapped(at index: IndexPath) {
        print("Button Tapped at index = \(index.row)")
    }
    
    func toggleclicked(at index: IndexPath) {
        self.setTabledataRem()
//        self.setTabledataRem(statusstr: self.statusDropDown.text!, paymentstr: self.paymentDropDown.text!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int = 0
        if(tableView == editReimbursementTable){
            count = editReimbursementAdapter.count
        }
        if(tableView == edtfileAttachmentTable){
            count = edtReimfileAttachmentAdapter.count
        }
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        if(tableView == editReimbursementTable){
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditReimbursementCell", for:  indexPath) as! EditReimbursementCell
        let list: EditReimbursementAdapter
        list = editReimbursementAdapter[indexPath.row]
        cell.btnClick.setImage(UIImage(named:"unselected1"), for: .normal)
        cell.btnClick.setImage(UIImage(named:"selected1"), for: .selected)
        cell.clientName.text = list.clientName
        cell.matterName.text = list.matterName
        cell.expenseDate.text = list.expenseDate
        cell.amount.text = list.amount
        cell.remark.text = list.remark
        cell.indexPath = indexPath
        cell.uid = list.expenseNo
        cell.rejectRemark.text = list.rejectRemark
        cell.paymentType.text = list.paymentType
        cell.actionEditIcon = {
            self.popupId = list.expenseNo!
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
            if(list.corporateCard!.isEmpty){
                self.edtcorporateCardDropDown.isUserInteractionEnabled = false
            }
            else{
                self.edtcorporateCardDropDown.isUserInteractionEnabled = true
            }
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
        cell.actionDeleteIcon = {
            self.presentDeletionFailsafe(indexPath: indexPath)
        }
        if (list.btnState == "0"){
            cell.btnClick.isSelected = false
        }else{
            cell.btnClick.isSelected = true
        }
        cell.delegate1 = self
         returnCell = cell
        }
        if(tableView == edtfileAttachmentTable){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReimbursementEditFileAttachmentCell", for:  indexPath) as! ReimbursementEditFileAttachmentCell
            //dtReimfileAttachmentAdapter = [EditReimbursementFileAttachmentAdapter]()
            let list3: EditReimbursementFileAttachmentAdapter
            list3 = edtReimfileAttachmentAdapter[indexPath.row]
            cell.indexPath = indexPath
            cell.filename.text = list3.filename
            cell.actionDeleteIcon = {
                self.presentDeletionFailsafeFileAttachmentEdit(indexPath: indexPath)
            }
            returnCell = cell
        }

        return returnCell
    }
    func presentDeletionFailsafeFileAttachmentEdit(indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: "Are you sure you'd like to delete this Line", preferredStyle: .alert)
                                        // yes action
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                            // replace data variable with your own data array
            let element = self.edtReimfileAttachmentAdapter[indexPath.row]
            let fileid = element.fileid!
            let uid = element.id!

            self.delAttachmentFileDetailsfileid(fileid: fileid)
            self.edtsetTabledataAttachment(uid: uid)
        }
        alert.addAction(yesAction)
        // cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
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
    
    func presentDeletionFailsafe(indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: "Are you sure you'd like to delete this Line", preferredStyle: .alert)
                                        // yes action
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                            // replace data variable with your own data array
            //            let element = self.editReimbursementAdapter
            //            [indexPath.row]
            let uid = self.editReimbursementAdapter[indexPath.row].expenseNo!
            if(AppDelegate.ntwrk > 0){
                self.post_Rem_Delete(expenseNo: uid)
            }
            else{
                self.showToast(message: CONSTANT.NET_ERR)
            }
            }
        alert.addAction(yesAction)
        // cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    
    @IBOutlet weak var rightSideBtn: UIBarButtonItem!
    @IBOutlet weak var paymentDropDown: DropDown!
    @IBOutlet weak var statusDropDown: DropDown!
    @IBOutlet weak var selectAllBtnOutlet: UIButton!
    @IBOutlet weak var editReimbursementTable: UITableView!
    @IBOutlet weak var edtfileAttachmentTable: UITableView!

    
    //MARK:- EDIT BUTTON POPUP
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
    @IBOutlet weak var edtswitchbtnSwifty : SwiftySwitch!
    @IBOutlet weak var edtChooseFileBtn : UIButton!
    @IBOutlet weak var edtNofileChoosenTxt : UILabel!
    @IBOutlet var rootview: UIView!
    var popupId : String = ""
    var edtcatgIdarr = [String]()
    var edtcatgNamearr = [String]()
    var edtcorpCardIdarr = [String]()
    var edtcorpCardNamearr = [String]()
    var edtcostIdarr = [String]()
    var edtcostNamearr = [String]()
    var edtclientarr = [String]()
    var edtmatterarr = [String]()
    var edtmattertype = [Int]()
    var edtuniqueId : String = ""
    var edtdebitTo : String = "Client"
    var edtisAttachment : String = "0"
    var edtmatterCode : String = ""
    var edtclientCode : String = ""
    var edtcostCenterCode : String = ""
    var edtexpenseCode : String = ""
    var edtcardCode : String = ""
    var edtstatusId : String = "1"
    var popupIndex : Int = 0
    var status = ""
    var payment = ""
    var myReimbursementAdapter = [MyReimbursementAdapter]()
    var datePicker: UIDatePicker?
    var datePicker2 : UIDatePicker?
    var date = Date()
    var type = 10
    var isAllSelected : Bool = false
    var editReimbursementAdapter = [EditReimbursementAdapter]()
    var edtReimfileAttachmentAdapter = [EditReimbursementFileAttachmentAdapter]()
    var typearr = [Int]()
    var datePicker1: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.currScreen = "EDITRE"
        if(setName().count>15){
            self.setnav(controller: self, title: "Edit Reimbursement" , spacing : 10)
        }
        else{
            self.setnav(controller: self, title: "Edit Reimbursement          " , spacing : 30)
        }

        setUpSideBar()
        setImageForBtnOutlet(button: selectAllBtnOutlet)
        setPaymentDropDownMyReimbursement(paymentDropDown: paymentDropDown)
        switchBtnSetup()
        borderToView()
        onSelect()
        edtsetDropDownData()
        DatePickerEdit()
    }
    //MARK:- DATE PICKER
    func DatePickerEdit(){
        datePicker1 = UIDatePicker()
        datePicker1?.preferredDatePickerStyle = .wheels
        datePicker1?.datePickerMode = .date
        datePicker1?.maximumDate = Date()        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker1));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker1));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        edtdateTextField.inputAccessoryView = toolbar
        edtdateTextField.inputView = datePicker1
    }
    @objc func donedatePicker1(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        edtdateTextField.text = formatter.string(from: self.datePicker1!.date)
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker1(){
        self.view.endEditing(true)
    }

    func onSelect(){
        self.typearr = setStatusDropDownEditRem(statusDropDown: statusDropDown)
        statusDropDown.didSelect { (selecttion, index, id) in
            self.statusDropDown.text! = selecttion
            self.type = self.typearr[index]
        }
        paymentDropDown.didSelect { (selecttion, index, id) in
            self.paymentDropDown.text! = selecttion
            self.setTabledataRem(statusstr: self.statusDropDown.text!, paymentstr: self.paymentDropDown.text!)
        }
        self.statusDropDown.text! = self.statusDropDown.optionArray[0]
        self.paymentDropDown.text! = self.paymentDropDown.optionArray[0]
    }
    //MARK:- SWITCH BTN SETUP
    func switchBtnSetup(){
        edtswitchbtnSwifty.delegate = self
        edtswitchbtnSwifty.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
        edtswitchbtnSwifty.myColor = UIColor.lightGray
    }
    private func borderToView(){
        edtremarksTxtView.layer.borderColor = UIColor.lightGray.cgColor
        edtremarksTxtView.layer.borderWidth = 1
        detailsView.layer.borderColor = UIColor.lightGray.cgColor
        detailsView.layer.borderWidth = 0.5
    }
    @IBAction func selectBtn(_ sender: UIButton) {
        isAllSelected = !isAllSelected
        self.updatestatusEditRem(status: isAllSelected ? "1" : "0", ExpenseNumber: "-1")
        animatebtnOutlet(button: self.selectAllBtnOutlet)
        self.setTabledataRem()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.getdatamyReimbursement(isBool: false)
    }
    func getdatamyReimbursement(isBool : Bool){
        if (AppDelegate.ntwrk > 0){
            self.showIndicator("Syncing...", vc: self)
            getmyReimbursement(startdate: setFromDate(), enddate: setToDate(), type: type,isReloadClick: isBool)
        }else{
            self.showToast(message: "Please check your Internet connection")
        }
    }
    
    @IBAction func sideMenuBtn(_ sender: UIBarButtonItem) {
        onClickSideMenu()
    }
    //MARK:- SETTABLEDATA
    private  func setTabledataRem(statusstr: String, paymentstr: String){
        var count : Int = 0
        var stmt1:OpaquePointer?
        var query = ""
        self.editReimbursementAdapter.removeAll()
        var pay : String = ""
        let statusstr = statusstr == "Both" ? "" : statusstr
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
        if(statusstr == "" || paymentstr == ""){
            query = "select TransDate,ClaimAmount,ClientName,ProjectName,Remarks,Status, paymentType,ResourceName,CardName,CategotyName,CostCenterName,AttachmentPath,ClientOffice,ExpenseNumber,checkbox,RejectedRemarks from ReimbursementMaster where Status like  '%\(statusstr)%' and PaymentType like '%\(pay)%' and  status NOT IN('Submitted','Approved') order by TransDate desc"
        }
        else {
         query = "select TransDate,ClaimAmount,ClientName,ProjectName,Remarks,Status, paymentType,ResourceName,CardName,CategotyName,CostCenterName,AttachmentPath,ClientOffice,ExpenseNumber,checkbox,RejectedRemarks from ReimbursementMaster where Status = '\(statusstr)' and PaymentType = '\(pay)' and status NOT IN('Submitted','Approved') order by TransDate desc"
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
            let expenseNo = String(cString: sqlite3_column_text(stmt1, 13))
            let checkbox = String(cString: sqlite3_column_text(stmt1, 14))
            let rejectRemark = String(cString: sqlite3_column_text(stmt1, 15))
            
            if (paymentType == "0"){
                pay = "Reimbursement"
            }
            else if (paymentType == "1"){
                pay = "Non-Reimbursement"
            }
            else if (paymentType == "2"){
                pay = "Corporate Card"
            }
            self.editReimbursementAdapter.append(EditReimbursementAdapter(expenseDate: expenseDate, amount: amount, clientName: clientName, matterName: matterName, remark: remark, status: status, paymentType: pay, payto: payto, corporateCard: corporateCard, expenseCatg: expenseCatg, costCenter: costCenter, noFileChoosenTxt: noFileChoosenTxt, debitToTxt: debitToTxt,expenseNo : expenseNo, btnState: checkbox, rejectRemark: rejectRemark ))
        }
        if(count == 0){
            self.showtoast(controller: self, message: "No Record Found!!", seconds: 1.0)
        }
        self.editReimbursementTable.reloadData()
    }
    override func VD() {
        self.hideindicator()
        self.statusDropDown.text! = self.statusDropDown.optionArray[0]
        self.paymentDropDown.text! = self.paymentDropDown.optionArray[0]
        self.setTabledataRem()
    }
    override func VD1() {
        self.hideindicator()
        self.setTabledataRem()
//        self.setTabledataRem(statusstr: self.statusDropDown.text!, paymentstr: self.paymentDropDown.text!)
    }
    override func INVD(msg: String) {
        self.hideindicator()
        self.setTabledataRem()
       // self.showToast(message: msg)
    }
    @IBAction func backBtn(_ sender: UIButton) {
        hideDetailsView()
    }
    func hideDetailsView(){
        self.detailsView.isHidden = true
        view.sendSubviewToBack(detailsView)
        removeBlurView()
    }
    //MARK:- EDIT CHOOSEFILE BTN CLICK
    @IBAction func edtChooseFileBtnClick(_ sender: UIButton) {
        docPick()
    }
    func docPick(){
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)], in: .import)
        documentPicker.delegate = self
        self.present(documentPicker, animated: true)

    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
        let filePath = urls[0]
        let fileData = try! Data.init(contentsOf: filePath)
        let fileStream:String = fileData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
            self.insertAttachmentFileDetails(filename: filePath.lastPathComponent, fileStr: fileStream, id: popupId, post: "0", extensionStr: "." +  filePath.pathExtension, fileid: getuid())
            edtisAttachment = "1"
            edtNofileChoosenTxt.text = "File Selected"
            edtsetTabledataAttachment(uid: popupId)
    }

    @IBAction func relaadBtn(_ sender: UIButton) {
        status = statusDropDown.text!
        payment = paymentDropDown.text!
        UserDefaults.standard.setValue(self.paymentDropDown.text! , forKey: "payment")
        UserDefaults.standard.setValue(self.statusDropDown.text! , forKey: "status")
        reloadBtnClick()
    }
    func reloadBtnClick(){
        getdatamyReimbursement(isBool: true)
    }
    func showDetailsView(){
        edtsetTabledataAttachment(uid: popupId)
        self.detailsView.isHidden = false
        self.blurView(view: rootview)
        view.bringSubviewToFront((detailsView))
    }
    @IBAction func saveChangesBtnClick(_ sender: UIButton) {
        if(validateEdit() && compareFromStartDate(date: edtdateTextField.text!)){
            self.updateReimbursementMaster(ExpenseNumber: popupId, TransDate: edtdateTextField.text!, debitto: edtdebitTo, isattachment: edtisAttachment, AttachmentPath: "", PaymentType: edtpaymentTypeDropDown.text!, CardName: edtcorporateCardDropDown.text!, ClientName: edtclientDropDown.text!, ProjectName: edtmatterDropDown.text!, CategotyName: edtexpenseCatgDropDown.text!, Remarks: edtremarksTxtView.text!, ClaimAmount: edtamountTextField.text!, CostCenterName: edtcostCenterDropDown.text!, post: "0", checkbox: "0", expensenumber: "", ProjId: getMatteridRem(str: edtmatterDropDown.text!) , ClientId: getclientidRem(str: edtclientDropDown.text!), CategoryId: getExpenseidRem(str: edtexpenseCatgDropDown.text!), CardId: getCorporateidRem(str: edtcorporateCardDropDown.text!), StatusId: edtstatusId, rejectremark: "", extensionStr: "", DimensionCostCenter: getCostCenteridRem(str: edtcostCenterDropDown.text!), payto: edtpayTestTxtField.text!)
            self.hideDetailsView()
            setTabledataRem()
        }
    }
    func isInvalidPaymentType(str : String) -> Bool{
        if(str == "Reimbursement" || str == "Non-Reimbursement" || str == "Corporate Card"){
            return false
        }
        return true
    }
    //MARK:- VALIDATION
    func validateEdit() -> Bool {
        var validate : Bool = true
        if(edtdateTextField.text!.isEmpty || edtdateTextField.text == "DD/MMM/YYYY"){
            self.showtoast(controller: self, message: "Please Select Date", seconds: 1.0)
            validate = false
        }
        if(edtpaymentTypeDropDown.text!.isEmpty || edtpaymentTypeDropDown.text == "--Select--" || isInvalidPaymentType(str: edtpaymentTypeDropDown.text!)){
            self.showtoast(controller: self, message: "Please Select Payment Type", seconds: 1.0)
            validate = false
        }
        if(edtcorporateCardDropDown.isUserInteractionEnabled == true && (edtcorporateCardDropDown.text!.isEmpty || edtcorporateCardDropDown.text == "--Select--" || self.isInvalidateCorporateCard(str: edtcorporateCardDropDown.text!))){
            self.showtoast(controller: self, message: "Please Select Corporate Card", seconds: 1.0)
            validate = false
        }
        if(edtclientDropDown.isUserInteractionEnabled == true && (edtclientDropDown.text!.isEmpty || edtclientDropDown.text == "--Select--" || self.isInvalidateRMClient(str: edtclientDropDown.text!))){
            self.showtoast(controller: self, message: "Please Select Client", seconds: 1.0)
            validate = false
        }
        if(edtmatterDropDown.isUserInteractionEnabled == true && (edtmatterDropDown.text!.isEmpty || edtmatterDropDown.text == "--Select--" || self.isInvalidateRMMatter(str: edtmatterDropDown.text!))){
            self.showtoast(controller: self, message: "Please Select Matter", seconds: 1.0)
            validate = false
        }
        if(edtexpenseCatgDropDown.text!.isEmpty || edtexpenseCatgDropDown.text == "--Select--" || self.isInvalidateExpenseCatg(str: edtexpenseCatgDropDown.text!)){
            self.showtoast(controller: self, message: "Please Select Expense Category", seconds: 1.0)
            validate = false
        }
        if(((edtcostCenterDropDown.text!.isEmpty == false) && self.isInvalidateCostCenter(str: edtcostCenterDropDown.text!))){
            self.showtoast(controller: self, message: "Please Select Valid Cost Center", seconds: 1.0)
            validate = false
        }
        if(edtremarksTxtView.text!.isEmpty || edtremarksTxtView.text == "Enter Remarks"){
            self.showtoast(controller: self, message: "Please Enter Remarks", seconds: 1.0)
            validate = false
        }
        if(edtamountTextField.text!.isEmpty){
            self.showtoast(controller: self, message: "Please Enter Remarks", seconds: 1.0)
            validate = false
        }
        if((edtswitchbtnSwifty.isOn) &&  (edtNofileChoosenTxt.text! == "No File Choosen")){
            self.showtoast(controller: self, message: "Please Choose File", seconds: 1.0)
            validate = false
        }
        return validate
    }
    @IBAction func save(_ sender: UIButton) {
        if (self.checklist()){
            let alert = UIAlertController(title: "Alert", message: "Are you sure, you want to save?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .default) { (_) in
                alert.dismiss(animated: true, completion: nil)
                if (AppDelegate.ntwrk > 0){
                    self.showIndicator("Syncing...", vc: self)
                    self.post_Rem(type: 0 , isedit: true)
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
    }
    
    @IBAction func submit(_ sender: UIButton) {
        if (self.checklist()){
        let alert = UIAlertController(title: "Alert", message: "Are you sure want to save & submit?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default) { (_) in
            alert.dismiss(animated: true, completion: nil)
            if (AppDelegate.ntwrk > 0){
                    self.showIndicator("Syncing...", vc: self)
                self.post_Rem(type: 1 , isedit: true)
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
    }
    
    func checklist()-> Bool{
        var flag = true
        var select = 0
        if (self.editReimbursementAdapter.count > 0){
            for adapter in self.editReimbursementAdapter {
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
    override func remPostDone(ids: [String],type: Int = -1){
        self.hideindicator()
        for id in ids{
            self.delrementryEdit(ExpenseNumber: id)
        }
        self.setTabledataRem()
        self.showdonemsg(type: type)
    }
    
    override func remPostDoneDelete(expenseNo: String){
        self.hideindicator()
        self.getdatamyReimbursement(isBool: false)
    }
    func showdonemsg(type: Int){
        var msg = ""
        if (type == 0){
            msg = "Reimbursement entry saved successfully, but not submitted for approval"
        }else if (type == 1){
            msg = "Reimbursement Entry submitted for approval successfully."
        }
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .default) { (_) in
            if (self.editReimbursementAdapter.count == 0){
                self.gotoHome()
            }else{
                self.setTabledataRem()
            }
        }
        alert.addAction(ok)
        if (msg.count > 0){
            self.present(alert, animated: true, completion: nil)
        }
    }
    func showdonemsgDelete(){
        var msg = "Delete successfully"
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { (_) in
            if (self.editReimbursementAdapter.count == 0){
                self.gotoHome()
            }else{
                self.setTabledataRem()
            }
        }
        alert.addAction(ok)
        if (msg.count > 0){
            self.present(alert, animated: true, completion: nil)
        }
    }

    //MARK:- SETTABLEDATA
    private  func setTabledataRem(){
        var count : Int = 0
        var stmt1:OpaquePointer?
        var pay:String = ""
        self.editReimbursementAdapter.removeAll()
        
        let query = "select TransDate,ClaimAmount,ClientName,ProjectName,Remarks,Status, paymentType,ResourceName,CardName,CategotyName,CostCenterName,AttachmentPath,ClientOffice,ExpenseNumber,checkbox,RejectedRemarks from ReimbursementMaster where  status NOT IN('Submitted','Approved') order by TransDate desc"
        
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
            let ExpenseNumber = String(cString: sqlite3_column_text(stmt1, 13))
            let btnState = String(cString: sqlite3_column_text(stmt1, 14))
            let rejectRemark = String(cString: sqlite3_column_text(stmt1, 15))
            
            
            if (paymentType == "0"){
                pay = "Reimbursement"
            }
            else if (paymentType == "1"){
                pay = "Non-Reimbursement"
            }
            else if (paymentType == "2"){
                pay = "Corporate Card"
            }
            self.editReimbursementAdapter.append(EditReimbursementAdapter(expenseDate: expenseDate, amount: amount, clientName: clientName, matterName: matterName, remark: remark, status: status, paymentType: pay, payto: payto, corporateCard: corporateCard, expenseCatg: expenseCatg, costCenter: costCenter, noFileChoosenTxt: noFileChoosenTxt, debitToTxt: debitToTxt, expenseNo: ExpenseNumber, btnState: btnState, rejectRemark: rejectRemark))
        }
        if(count == 0){
            self.showtoast(controller: self, message: "No Record Found!!", seconds: 1.0)
        }
        self.editReimbursementTable.reloadData()
    }
    //MARK:- SEGMENT INDEXC CHANGED
    @IBAction func edtindexChanged(sender: UISegmentedControl) {
        switch edtsegmentedControl.selectedSegmentIndex
        {
        case 0:
            edtsegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
            edtsegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: .normal)
            onToggleChanged(ischecked: false, client: edtclientDropDown, matter:edtmatterDropDown)
        case 1:
            edtsegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
            edtsegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: .normal)
            onToggleChanged(ischecked: true, client: edtclientDropDown, matter: edtmatterDropDown)

        default:
            break;
        }
    }
    func onToggleChanged(ischecked : Bool,client:DropDown,matter:DropDown){
        if ischecked{
            edtdebitTo = "Office"
            client.isUserInteractionEnabled = false
            matter.isUserInteractionEnabled = false
            client.text = ""
            matter.text = ""
            client.placeholder = "--Select--"
            matter.placeholder = "--Select--"
        }
        else{
            edtdebitTo = "Client"
            client.isUserInteractionEnabled = true
            matter.isUserInteractionEnabled = true
            client.text = ""
            matter.text = ""
            client.placeholder = "--Select--"
            matter.placeholder = "--Select--"
        }
    }
    //MARK:- SETDROP DOWN DATA
    func edtsetDropDownData(){
        edtsetClientDropDown()
        edtsetMattterDropDown()
        setPaymentDropDownRem(paymentDropDown: edtpaymentTypeDropDown)
        edtsetExpCatgDropDown()
        edtsetCorpCardDropDown()
        edtsetCostCenterDropDown()
    }
    //  MARK:- SETUP CLIENT DROPDOWN
      public func edtsetClientDropDown(mtname: String = ""){
          var stmt1:OpaquePointer?
          edtclientarr.removeAll()
          let str = mtname == "-Select-" ? "" : mtname
          let query = "select   ''   as ClientCode , '--Select--' as ClientDesc UNION ALL SELECT   distinct(ClientCode) , ClientDesc from GetRMClientMatter  where MatterDesc like '%\(str)%'"
          
          if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
              let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
              print("error preparing get: \(errmsg)")
              return
          }
          edtclientDropDown.optionArray.removeAll()
          while(sqlite3_step(stmt1) == SQLITE_ROW){
              let code = String(cString: sqlite3_column_text(stmt1, 0))
              let str = String(cString: sqlite3_column_text(stmt1, 1))
              edtclientDropDown.optionArray.append(str)
              edtclientarr.append(code)
          }
//          //MARK:- CLIENT DROPDOWN CLICK
//          edtclientDropDown.didSelect { (selection, index, id) in
//              self.edtclientCode = self.edtclientarr[index]
//              self.edtsetMattterDropDown(clname: selection)
//          }
        edtclientDropDown.didSelect { (selection, index, id) in
            if(index == 0){
                self.edtsetMattterDropDown(clname: "")
                self.edtsetClientDropDown(mtname: "")
            }
            else{
                self.edtsetMattterDropDown(clname: selection)
            }
        }
      }
      //MARK:- SETUP EXPENSE CATG DROPDOWN
      public func edtsetExpCatgDropDown(){
          var stmt1:OpaquePointer?
          edtcatgIdarr.removeAll()
          edtcatgNamearr.removeAll()
          edtexpenseCatgDropDown.optionArray.removeAll()

          let query = "select   ''   as projCategoryId , '--Select--' as projCategoryName UNION ALL SELECT   distinct(projCategoryId) , projCategoryName from GetRMExpenseCatg"
          if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
              let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
              print("error preparing get: \(errmsg)")
              return
          }
          while(sqlite3_step(stmt1) == SQLITE_ROW){
              let code = String(cString: sqlite3_column_text(stmt1, 0))
              let str = String(cString: sqlite3_column_text(stmt1, 1))
              edtexpenseCatgDropDown.optionArray.append(str)
              edtcatgIdarr.append(code)
              edtcatgNamearr.append(str)
          }
          //MARK:- CATG DROPDOWN DIDSELECT
          edtexpenseCatgDropDown.didSelect { (selection, index, id) in
              self.edtexpenseCode = self.edtcatgIdarr[index]
          }
      }
      
      //MARK:- SETUP COST CENTER DROPDOWN
      public func edtsetCostCenterDropDown(){
          var stmt1:OpaquePointer?
          edtcostIdarr.removeAll()
          edtcostNamearr.removeAll()
        edtcostCenterDropDown.optionArray.removeAll()
          let query = "select   ''   as CodeName , '--Select--' as Name UNION ALL SELECT   distinct(CodeName) , Name from GetRemCostCenterData"
          if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
              let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
              print("error preparing get: \(errmsg)")
              return
          }
          while(sqlite3_step(stmt1) == SQLITE_ROW){
              let code = String(cString: sqlite3_column_text(stmt1, 0))
              let str = String(cString: sqlite3_column_text(stmt1, 1))
              edtcostCenterDropDown.optionArray.append(str)
              edtcostIdarr.append(code)
              edtcostNamearr.append(str)
          }
          //MARK:- COST CENTER DROPDOWN CLICK
          edtcostCenterDropDown.didSelect { (selection, index, id) in
              self.edtcostCenterCode = self.edtcostIdarr[index]
          }
      }
      
      //MARK:- CORP DROPDOWN CLICK
      public func edtsetCorpCardDropDown(){
          var stmt1:OpaquePointer?
          edtcorpCardIdarr.removeAll()
          edtcorpCardNamearr.removeAll()
          edtcorporateCardDropDown.optionArray.removeAll()
          let query = "select  ''  as CardId, '--Select--' as Description   UNION ALL select CardId, Description from GetRemCorpCardTypeData"
          if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
              let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
              print("error preparing get: \(errmsg)")
              return
          }
          while(sqlite3_step(stmt1) == SQLITE_ROW){
              let code = String(cString: sqlite3_column_text(stmt1, 0))
              let str = String(cString: sqlite3_column_text(stmt1, 1))
              edtcorporateCardDropDown.optionArray.append(str)
              edtcorpCardIdarr.append(code)
              edtcorpCardNamearr.append(str)
          }
          //MARK:- CORP DROPDOWN CLICK
          edtcorporateCardDropDown.didSelect { (selection, index, id) in
              self.edtcardCode = self.edtcorpCardIdarr[index]
          }
      }
      //MARK:- PAYMENT DROPDOWN CLICK
      public func edtpaymentTypeDropDownClick(){
          edtpaymentTypeDropDown.didSelect { (selection, index, id) in
              self.paymentTypeDropDown(paymentType: selection, corporateCard: self.edtcorporateCardDropDown)
          }
      }
    //MARK:- SETUP MATTER DROPDOWN
    public func edtsetMattterDropDown(clname: String = ""){
        var count : Int = 0
        self.edtmatterDropDown.text = "-Select-"
        var stmt1:OpaquePointer?
        edtmatterarr.removeAll()
        edtmattertype.removeAll()
        let str = clname == "-Select-" ? "" : clname
        
        let query = "select    ''   as MatterCode , '--Select--' as MatterDesc , '2' as MatterType UNION ALL select distinct(MatterCode) , MatterDesc , MatterType from GetRMClientMatter where ClientDesc like '%\(str)%'"
        
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        edtmatterDropDown.optionArray.removeAll()
        edtmatterDropDown.text! = ""
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            count = count + 1
            let code = String(cString: sqlite3_column_text(stmt1, 0))
            let str = String(cString: sqlite3_column_text(stmt1, 1))
            let type = sqlite3_column_int(stmt1, 2)
            edtmatterDropDown.optionArray.append(str)
            edtmatterarr.append(code)
            edtmattertype.append(Int(type))
        }
        if(count == 2){
            edtmatterDropDown.text! = edtmatterDropDown.optionArray[1]
        }
        //MARK:- MATTER DROPDOWN CLICK
        edtmatterDropDown.didSelect { (selection, index, id) in
            let str = self.edtclientDropDown.text! == "-Select-" ? "" : self.edtclientDropDown.text!
            self.edtmatterCode = self.edtmatterarr[index]
            if(str.count == 0){
                self.edtsetClientDropDown(mtname: selection)
                self.edtclientDropDown.text = self.edtclientDropDown.optionArray[1]
            }
            if(index > 0){
                self.edtsetClientDropDown(mtname: selection)
                self.edtsetMattterDropDown(clname: selection)
            }
            else{
                self.edtsetClientDropDown(mtname: "")
            }
        }
    }
    func paymentTypeDropDown(paymentType : String , corporateCard : DropDown){
        if((paymentType == "Reimbursement") || (paymentType == "Non-Reimbursement")){
            corporateCard.isUserInteractionEnabled = false
            corporateCard.text = ""
            corporateCard.placeholder = "--Select--"
        }
        else{
            corporateCard.isUserInteractionEnabled = true
            corporateCard.text = ""
            corporateCard.placeholder = "--Select--"
        }
    }
    //    var edtReimfileAttachmentAdapter = [EditReimbursementFileAttachmentAdapter]()

    //MARK:- SETTABLEDATA
    private  func edtsetTabledataAttachment(uid :String){
        var stmt1:OpaquePointer?
        var count : Int = 0
        self.edtReimfileAttachmentAdapter.removeAll()
        let query = "select filename,fileStr,id,post,extension,fileid from AttachmentFileDetails where id = '\(uid)'"
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            count = count + 1
            let filename = String(cString: sqlite3_column_text(stmt1, 0))
            let fileStr = String(cString: sqlite3_column_text(stmt1, 1))
            let id = String(cString: sqlite3_column_text(stmt1, 2))
            let post = String(cString: sqlite3_column_text(stmt1, 3))
            let extensionStr = String(cString: sqlite3_column_text(stmt1, 4))
            let fileid = String(cString: sqlite3_column_text(stmt1, 5))
            
            self.edtReimfileAttachmentAdapter.append(EditReimbursementFileAttachmentAdapter(filename: filename, fileStr: fileStr, id: id, post: post, extensionStr: extensionStr, fileid: fileid))
        }
        if(count == 0){
            edtisAttachment = "0"
            edtNofileChoosenTxt.text = "No File Choosen"
            edtswitchbtnSwifty.isOn = false
            edtswitchbtnSwifty.myColor = UIColor.lightGray
            edtChooseFileBtn.backgroundColor = UIColor.lightGray
            edtChooseFileBtn.isUserInteractionEnabled = false
        }
        else{
            edtisAttachment = "1"
            edtNofileChoosenTxt.text = "File Selected"
            edtswitchbtnSwifty.isOn = true
            edtswitchbtnSwifty.myColor = hexStringToUIColor(hex:"#003366")
            edtChooseFileBtn.backgroundColor = hexStringToUIColor(hex:"#003366")
            edtChooseFileBtn.isUserInteractionEnabled = true
        }
        self.edtfileAttachmentTable.reloadData()
    }

}
