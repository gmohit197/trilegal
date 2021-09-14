//  REIMBURSEMENTENTRYVC.swift
//  Trilegal
//
//  Created by Acxiom Consulting on 11/05/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.
//        datePicker2?.preferredDatePickerStyle = .wheels

//MARK:- IMPORTS

import UIKit
import SQLite3
import MobileCoreServices
import Foundation


class REIMBURSEMENTENTRYVC: BASEACTIVITY , UITableViewDataSource , UITableViewDelegate  , UITextViewDelegate , SwiftySwitchDelegate , OptionButtonsDelegateRem , UITextFieldDelegate , UIImagePickerControllerDelegate , UINavigationControllerDelegate , UIDocumentPickerDelegate  {
    
    func closeFriendsTapped(at index: IndexPath) {
        print("Button Tapped at index = \(index.row)")
    }
    
    func toggleclicked(at index: IndexPath) {
        self.setTabledata()
    }
    
    func valueChanged(sender: SwiftySwitch) {
        if(sender == switchbtnSwifty){
        if sender.isOn {
            switchbtnSwifty.myColor = hexStringToUIColor(hex:"#003366")
            ChooseFileBtn.backgroundColor = hexStringToUIColor(hex:"#003366")
            ChooseFileBtn.isUserInteractionEnabled = true
        }
        else{
            ChooseFileBtn.backgroundColor = UIColor.lightGray
            switchbtnSwifty.myColor = UIColor.lightGray
            ChooseFileBtn.isUserInteractionEnabled = false
        }
        }
        else if(sender == edtswitchbtnSwifty){
            if sender.isOn {
                edtswitchbtnSwifty.myColor = hexStringToUIColor(hex:"#003366")
                edtChooseFileBtn.backgroundColor = hexStringToUIColor(hex:"#003366")
                edtChooseFileBtn.isUserInteractionEnabled = true
            }
            else{
                edtChooseFileBtn.backgroundColor = UIColor.lightGray
                edtswitchbtnSwifty.myColor = UIColor.lightGray
                edtChooseFileBtn.isUserInteractionEnabled = false
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int = 0
        if(tableView == reimbursementEntryTable){
            count = reimbursementEntryAdapter.count
        }
        if(tableView == fileAttachmentTable){
            count = fileAttachmentAdapter.count
        }
        if(tableView == edtfileAttachmentTable){
            count = edtfileAttachmentAdapter.count
        }
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        if(tableView == self.reimbursementEntryTable){
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReimbursementEntryCell", for:  indexPath) as! ReimbursementEntryCell
        let list: ReimbursementEntryAdapter
        list = reimbursementEntryAdapter[indexPath.row]
        self.setImageForBtnOutlet(button: cell.btnClick)
        
        cell.indexPath = indexPath
        cell.uid = list.Id
        cell.clientName.text = list.clientName
        cell.matterName.text = list.matterName
        cell.expenseDate.text = list.expenseDate
        cell.amount.text = list.amount
        cell.expenseCatg.text = list.expenseCategory
        cell.remark.text = list.remark
        
        cell.actionEditIcon = {
            self.setPopupData(uniqueId: list.Id!)
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
        if(tableView == fileAttachmentTable){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReimbursementFileAttachmentCell", for:  indexPath) as! ReimbursementFileAttachmentCell
            let list1: FileAttachmentAdapter
            list1 = fileAttachmentAdapter[indexPath.row]
            
            cell.indexPath = indexPath
            cell.filename.text = list1.filename
            
            cell.actionDeleteIcon = {
                self.presentDeletionFailsafeFileAttachment(indexPath: indexPath)
            }
            returnCell = cell
        }
        if(tableView == edtfileAttachmentTable){
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditReimbursementFileAttachmentCell", for:  indexPath) as! EditReimbursementFileAttachmentCell
            let list2: EditFileAttachmentAdapter
            list2 = edtfileAttachmentAdapter[indexPath.row]
            cell.indexPath = indexPath
            cell.filename.text = list2.filename
            cell.actionDeleteIcon = {
                self.presentDeletionFailsafeFileAttachmentEdit(indexPath: indexPath)
            }
            returnCell = cell
        }
        return returnCell

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
            let element = self.reimbursementEntryAdapter[indexPath.row]
            let uid = element.Id!
            self.delrementry(uid: uid)
            self.delAttachmentFileDetails(uid: uid)
            self.setTabledata()
            self.setTabledataAttachment(uid: uid)
        }
        alert.addAction(yesAction)
        // cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func AttachmentListClear(){
        self.fileAttachmentAdapter.removeAll()
        setTabledataAttachment(uid: "2021")
    }
    
    
    func presentDeletionFailsafeFileAttachment(indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: "Are you sure you'd like to delete this Line", preferredStyle: .alert)
                                        // yes action
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                            // replace data variable with your own data array
            let element = self.fileAttachmentAdapter[indexPath.row]
            let fileid = element.fileid!
            let uid = element.id!

            self.delAttachmentFileDetailsfileid(fileid: fileid)
            self.setTabledataAttachment(uid: uid)
        }
        alert.addAction(yesAction)
        // cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func presentDeletionFailsafeFileAttachmentEdit(indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: "Are you sure you'd like to delete this Line", preferredStyle: .alert)
                                        // yes action
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                            // replace data variable with your own data array
            let element = self.edtfileAttachmentAdapter[indexPath.row]
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


    
    @IBOutlet weak var remarksTxtView: UITextView!
    @IBOutlet weak var rightSideBtn: UIBarButtonItem!
    @IBOutlet weak var reimbursementEntryTable: UITableView!
    @IBOutlet weak var fileAttachmentTable: UITableView!
    @IBOutlet weak var edtfileAttachmentTable: UITableView!

    @IBOutlet weak var clientDropDown: DropDown!
    @IBOutlet weak var costCenterDropDown: DropDown!
    @IBOutlet weak var corporateCardDropDown: DropDown!
    @IBOutlet weak var expenseCatgDropDown: DropDown!
    @IBOutlet weak var paymentTypeDropDown: DropDown!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var matterDropDown: DropDown!
    @IBOutlet weak var payTestTxtField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var selectAllBtnOutlet: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var switchbtn : UISwitch!
    @IBOutlet weak var switchbtnSwifty : SwiftySwitch!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var ChooseFileBtn : UIButton!
    @IBOutlet weak var NofileChoosenTxt : UILabel!
    
    
    //MARK:- EDIT BUTTON POPUP
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

    @IBOutlet var rootview: UIView!
    
    var isAllSelected : Bool = false
    var reimbursementEntryAdapter = [ReimbursementEntryAdapter]()
    var fileAttachmentAdapter = [FileAttachmentAdapter]()
    var edtfileAttachmentAdapter = [EditFileAttachmentAdapter]()

    var datePicker: UIDatePicker?
    var datePicker1: UIDatePicker?
    var date = Date()
    let formatter = DateFormatter()
    var catgIdarr = [String]()
    var catgNamearr = [String]()
    var corpCardIdarr = [String]()
    var corpCardNamearr = [String]()
    var costIdarr = [String]()
    var costNamearr = [String]()
    var clientarr = [String]()
    var matterarr = [String]()
    var mattertype = [Int]()
    var uniqueId : String = ""
    var debitTo : String = "Client"
    var isAttachment : String = "0"
    var matterCode : String = ""
    var clientCode : String = ""
    var costCenterCode : String = ""
    var expenseCode : String = ""
    var cardCode : String = ""
    var statusId : String = "1"

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
    var ispopEnable : Bool = false



    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        setTabledata()
        edtsetTabledataAttachment(uid: "2021")
        setTabledataAttachment(uid: "2021")
        uniqueId = getuid()
        ChooseFileBtn.backgroundColor = UIColor.lightGray
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        if(AppDelegate.ntwrk > 0){
            showIndicator("Syncing", vc: self)
            self.getRMCorpCardData()
            self.getRMCostCenterData()
            self.getRMExpenseCatgData()
            self.getRMClientMatterData()
        }
        else {
            self.showtoast(controller: self, message: CONSTANT.NET_ERR, seconds: 1.0)
        }
    }
    
    override func insertionCompleted() {
        setDropDownData()
        edtsetDropDownData()
        self.hideindicator()
    }
    
    //MARK:- INIT DATA
    func initData(){
        if(setName().count>15){
            self.setnavReview(controller: self, title: "Reimbursement Entry" , spacing : 10)
        }
        else{
            self.setnav(controller: self, title: "Reimbursement Entry       " , spacing : 30)
        }

        AppDelegate.currScreen = "RE"
        dateTextField.text! = getCurrentShortDateRem()
        setUpSideBar()
        DatePicker()
        DatePickerEdit()
        textViewBorder()
        paymentTypeDropDownClick()
        edtpaymentTypeDropDownClick()
        setDropDownData()
        payTestTxtField.text = setName()
        setImageForBtnOutlet(button: selectAllBtnOutlet)
        switchBtnSetup()
        edtswitchBtnSetup()
        searchEnable()
        setupSegment()
        edtsetupSegment()
        borderToView()
        edtsetDropDownData()
       // self.deletetable(tbl: "ReimbursementEntry")
         view.addSubview(detailsView)
    }
    
    //MARK:- SETUP SEGMENT
    func setupSegment(){
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: .normal)
    }
    //MARK:- EDIT SETUP SEGMENT
    func edtsetupSegment(){
        edtsegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
        edtsegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: .normal)
    }
    //MARK:- SEARCH ENABLE
    func searchEnable(){
        self.clientDropDown.isSearchEnable = true
        self.matterDropDown.isSearchEnable = true
        self.corporateCardDropDown.isSearchEnable = true
        self.paymentTypeDropDown.isSearchEnable = true
        self.costCenterDropDown.isSearchEnable = true
        self.expenseCatgDropDown.isSearchEnable = true
    }
    
    //MARK:- SWITCH BTN SETUP
    func switchBtnSetup(){
        switchbtn.set(width: 70, height: 20)
        switchbtnSwifty.delegate = self
        switchbtnSwifty.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
        switchbtnSwifty.myColor = UIColor.lightGray
    }
    
    //MARK:- SWITCH BTN SETUP
    func edtswitchBtnSetup(){
        edtswitchbtn.set(width: 70, height: 20)
        edtswitchbtnSwifty.delegate = self
        edtswitchbtnSwifty.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
        edtswitchbtnSwifty.myColor = UIColor.lightGray
    }
    
    //MARK:- SEGMENT INDEX CHANGED
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: .normal)
            onToggleChanged(ischecked: false, client: clientDropDown, matter: matterDropDown)
        case 1:
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: .normal)
            onToggleChanged(ischecked: true, client: clientDropDown, matter: matterDropDown)

        default:
            break;
        }
    }
    
    //MARK:- SEGMENT INDEXC CHANGED
    @IBAction func edtindexChanged(sender: UISegmentedControl) {
        switch edtsegmentedControl.selectedSegmentIndex
        {
        case 0:
            edtsegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
            edtsegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: .normal)
            edtonToggleChanged(ischecked: false, client: edtclientDropDown, matter:edtmatterDropDown)
        case 1:
            edtsegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
            edtsegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: .normal)
            edtonToggleChanged(ischecked: true, client: edtclientDropDown, matter: edtmatterDropDown)
            
        default:
            break;
        }
    }

    
    //MARK:-  SELECT ALL BTN CLICK
    @IBAction func selectAllBtn(_ sender: UIButton) {
        isAllSelected = !isAllSelected
        self.updatestatusRem(status: isAllSelected ? "1" : "0", uid: "-1")
        animatebtnOutlet(button: self.selectAllBtnOutlet)
        self.setTabledata()
    }
    //MARK:- SETDROP DOWN DATA
    func setDropDownData(){
        setClientDropDown(mtname: "", isFirst: true)
        setMattterDropDown(clname: "")
        setPaymentDropDownRem(paymentDropDown: paymentTypeDropDown)
        setExpCatgDropDown()
        setCorpCardDropDown()
        setCostCenterDropDown()
    }
    
    //MARK:- SETDROP DOWN DATA
    func edtsetDropDownData(){
        edtsetClientDropDown(mtname: "")
        edtsetMattterDropDown(clname: "")
        setPaymentDropDownRem(paymentDropDown: edtpaymentTypeDropDown)
        edtsetExpCatgDropDown()
        edtsetCorpCardDropDown()
        edtsetCostCenterDropDown()
    }
    
    //MARK:- TEXTVIEW BORDER
    private func textViewBorder(){
        remarksTxtView.layer.borderColor = UIColor.lightGray.cgColor
        remarksTxtView.layer.borderWidth = 0.5
    }
    //MARK:- DATE PICKER
    fileprivate func setupDatePicker(){
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.maximumDate = self.date
        datePicker?.addTarget(self, action: #selector(REIMBURSEMENTENTRYVC.dateChanged(datePicker:)), for: .valueChanged)
        dateTextField.inputView = datePicker
    }
    //MARK:- DATE CHANGED
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
    }

    //MARK:- SIDE MENU BTN CLICK
    @IBAction func sideMenuBtn(_ sender: UIBarButtonItem) {
        onClickSideMenu()
    }
   
    //MARK:- TEXTVIEW NIL
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter Remarks"{
            textView.text = nil
            textView.textColor = UIColor.darkGray
        }
    }
    func isInvalidPaymentType(str : String) -> Bool{
        if(str == "Reimbursement" || str == "Non-Reimbursement" || str == "Corporate Card"){
            return false
        }
        return true
    }
    
    //MARK:- VALIDATION
    func validate() -> Bool {
        var validate : Bool = true
        if(dateTextField.text!.isEmpty || dateTextField.text == "DD/MMM/YYYY"){
            self.showtoast(controller: self, message: "Please Select Date", seconds: 1.0)
            validate = false
        }
        if(paymentTypeDropDown.text!.isEmpty || paymentTypeDropDown.text == "--Select--" || isInvalidPaymentType(str: paymentTypeDropDown.text!)){
            self.showtoast(controller: self, message: "Please Select Payment Type", seconds: 1.0)
            validate = false
        }
        if(corporateCardDropDown.isUserInteractionEnabled == true && (corporateCardDropDown.text!.isEmpty || corporateCardDropDown.text == "--Select--" || self.isInvalidateCorporateCard(str: corporateCardDropDown.text!))){
            self.showtoast(controller: self, message: "Please Select Corporate Card", seconds: 1.0)
            validate = false
        }
        if(clientDropDown.isUserInteractionEnabled == true && (clientDropDown.text!.isEmpty || clientDropDown.text == "--Select--" || self.isInvalidateRMClient(str: clientDropDown.text!))){
            self.showtoast(controller: self, message: "Please Select Client", seconds: 1.0)
            validate = false
        }
        if(matterDropDown.isUserInteractionEnabled == true && (matterDropDown.text!.isEmpty || matterDropDown.text == "--Select--" || self.isInvalidateRMMatter(str: matterDropDown.text!))){
            self.showtoast(controller: self, message: "Please Select Matter", seconds: 1.0)
            validate = false
        }
        if(expenseCatgDropDown.text!.isEmpty || expenseCatgDropDown.text == "--Select--" || self.isInvalidateExpenseCatg(str: expenseCatgDropDown.text!)){
            self.showtoast(controller: self, message: "Please Select Expense Category", seconds: 1.0)
            validate = false
        }
        if(((costCenterDropDown.text!.isEmpty == false) && self.isInvalidateCostCenter(str: costCenterDropDown.text!))){
            self.showtoast(controller: self, message: "Please Select Valid Cost Center", seconds: 1.0)
            validate = false
        }
        if(remarksTxtView.text!.isEmpty || remarksTxtView.text == "Enter Remarks"){
            self.showtoast(controller: self, message: "Please Enter Remarks", seconds: 1.0)
            validate = false
        }
        if(amountTextField.text!.isEmpty){
            self.showtoast(controller: self, message: "Please Enter Remarks", seconds: 1.0)
            validate = false
        }
        if((switchbtnSwifty.isOn) &&  (NofileChoosenTxt.text! == "No File Choosen")){
            self.showtoast(controller: self, message: "Please Choose File", seconds: 1.0)
            validate = false
        }
        return validate
    }
    
    func setPopupData(uniqueId : String){
        var stmt1:OpaquePointer?
        self.reimbursementEntryAdapter.removeAll()
        let query = "select id,date,payto,debitTo,attachment,choosefile, paymentType,corporateCard,client,matter,expenseCategory,remark,amount,post,checkbox,expensenumber,projid, clientid,catgid,cardid,statusId,rejectremark,extensionStr,costCenter from ReimbursementEntry where id = \(uniqueId) "
        
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let id = String(cString: sqlite3_column_text(stmt1, 0))
            let date = String(cString: sqlite3_column_text(stmt1, 1))
            let payto = String(cString: sqlite3_column_text(stmt1, 2))
            let debitTo = String(cString: sqlite3_column_text(stmt1, 3))
            let attachment = String(cString: sqlite3_column_text(stmt1, 4))
            let choosefile = String(cString: sqlite3_column_text(stmt1, 5))
            let paymentType = String(cString: sqlite3_column_text(stmt1, 6))
            let corporateCard = String(cString: sqlite3_column_text(stmt1, 7))
            let client = String(cString: sqlite3_column_text(stmt1, 8))
            let matter = String(cString: sqlite3_column_text(stmt1, 9))
            let expenseCategory = String(cString: sqlite3_column_text(stmt1, 10))
            let remark = String(cString: sqlite3_column_text(stmt1, 11))
            let amount = String(cString: sqlite3_column_text(stmt1, 12))
            let costcenter = String(cString: sqlite3_column_text(stmt1, 23))
            
            popupId = id
            edtdateTextField.text! = date
            edtpayTestTxtField.text! = payto
            edtpaymentTypeDropDown.text! = paymentType
            edtcorporateCardDropDown.text! = corporateCard
            edtclientDropDown.text! = client
            edtexpenseCatgDropDown.text! = expenseCategory
            edtremarksTxtView.text! = remark
            edtamountTextField.text! = amount
            edtmatterDropDown.text! = matter
            edtcostCenterDropDown.text! = costcenter
            edtChooseFileBtn.backgroundColor = UIColor.lightGray
            if(corporateCard.isEmpty){
                edtcorporateCardDropDown.isUserInteractionEnabled = false
            }
            else{
                edtcorporateCardDropDown.isUserInteractionEnabled = true
            }
            if(debitTo == "Client"){
                edtdebitTo = "Client"
                edtsegmentedControl.selectedSegmentIndex = 0
                edtclientDropDown.isUserInteractionEnabled = true
                edtmatterDropDown.isUserInteractionEnabled = true
            }
            else{
                edtdebitTo = "Office"
                edtsegmentedControl.selectedSegmentIndex = 1
                edtclientDropDown.isUserInteractionEnabled = false
                edtmatterDropDown.isUserInteractionEnabled = false
            }
            showDetailsView()
            edtisAttachment = "1"
            edtNofileChoosenTxt.text = "File Selected"
            edtsetTabledataAttachment(uid: popupId)
            //Attachemnt
            //Choose File
            //NofileChoosenTxt
            //Debit to
        }
    }
    
    private func borderToView(){
        edtremarksTxtView.layer.borderColor = UIColor.lightGray.cgColor
        edtremarksTxtView.layer.borderWidth = 1
        detailsView.layer.borderColor = UIColor.lightGray.cgColor
        detailsView.layer.borderWidth = 0.5
    }
    
    //MARK:- ADD BTN CLICK
    @IBAction func AddBtn(_ sender: UIButton) {
        if(validate() && compareFromStartDate(date: dateTextField.text!)){
            self.insertReimbursementEntry(id: uniqueId, date: dateTextField.text!, debitTo: debitTo, attachment: isAttachment, choosefile: "", paymentType: paymentTypeDropDown.text!, corporateCard: corporateCardDropDown.text!, client: clientDropDown.text!, matter: matterDropDown.text!, expenseCategory: expenseCatgDropDown.text!, remark: remarksTxtView.text!, amount: amountTextField.text!, costCenter: costCenterDropDown.text!, post: "0", checkbox: "0", expensenumber: "", projid: getMatteridRem(str: matterDropDown.text!), clientid: getclientidRem(str: clientDropDown.text!), catgid: getExpenseidRem(str : self.expenseCatgDropDown.text!), cardid: getCorporateidRem(str: self.corporateCardDropDown.text!), statusId: self.statusId, rejectremark: "", extensionStr: "", costcode: getCostCenteridRem(str: costCenterDropDown.text!),payto : self.payTestTxtField.text!)
            setTabledata()
            afterAddBtnClick()
            uniqueId = getuid()
        }
    }
    
    //MARK:- RESET BTN CLICK
    @IBAction func resetBtnClick(_ sender: UIButton) {
        dateTextField.text = ""
        dateTextField.placeholder = "DD/MMM/YYYY"
        paymentTypeDropDown.text = "Select Payment Type"
        corporateCardDropDown.text = "Select Corporate Card"
        clientDropDown.text = "Select Client"
        matterDropDown.text = "Select Matter"
        expenseCatgDropDown.text = "Select Expense"
        costCenterDropDown.text = "Select Cost Center"
        remarksTxtView.text = "Enter Remarks"
        amountTextField.text = ""
        setTabledataAttachment(uid: "2021")
    }
    //MARK:- AFTER ADD BTN CLICK
    func afterAddBtnClick(){
        remarksTxtView.text = "Enter Remarks"
        amountTextField.text = ""
        clientDropDown.text! = ""
        matterDropDown.text! = ""
        expenseCatgDropDown.text! = ""
        paymentTypeDropDown.text! = ""
        corporateCardDropDown.text! = ""
        costCenterDropDown.text! = ""
        ChooseFileBtn.backgroundColor = UIColor.lightGray
        NofileChoosenTxt.text = "No File Choosen"
        isAttachment = "0"
        switchbtnSwifty.isOn = false
        segmentedControl.isSelected = false
        segmentedControl.selectedSegmentIndex = 0
        setClientDropDown(mtname: "", isFirst: false)
        setMattterDropDown(clname: "")
        debitTo = "Client"
        AttachmentListClear()
    }
    
    //MARK:- DATE PICKER
    func DatePicker (){
        datePicker = UIDatePicker()
        datePicker?.preferredDatePickerStyle = .wheels
        datePicker?.datePickerMode = .date
        datePicker?.maximumDate = Date()
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
    }
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateTextField.text = formatter.string(from: self.datePicker!.date)
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    //MARK:- DATE PICKER
    func DatePickerEdit(){
        datePicker1 = UIDatePicker()
        datePicker1?.preferredDatePickerStyle = .wheels
        datePicker1?.datePickerMode = .date
        datePicker1?.maximumDate = Date()
        let toolbar = UIToolbar();
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

    
    //MARK:- SETUP MATTER DROPDOWN
    public func setMattterDropDown(clname: String){
        var count : Int = 0
        self.matterDropDown.text = "-Select-"
        var stmt1:OpaquePointer?
        matterarr.removeAll()
        mattertype.removeAll()
        matterDropDown.optionArray.removeAll()

        let str = clname == "-Select-" ? "" : clname
        
        let query = "select    ''   as MatterCode , '--Select--' as MatterDesc , '2' as MatterType UNION ALL select distinct(MatterCode) , MatterDesc , MatterType from GetRMClientMatter where ClientDesc like '%\(str)%'"
        
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        matterDropDown.text! = ""
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            count  = count + 1
            let code = String(cString: sqlite3_column_text(stmt1, 0))
            let str = String(cString: sqlite3_column_text(stmt1, 1))
            let type = sqlite3_column_int(stmt1, 2)
            matterDropDown.optionArray.append(str)
            matterarr.append(code)
            mattertype.append(Int(type))
        }
        if(count==2){
            matterDropDown.text! = matterDropDown.optionArray[1]
            matterCode = matterarr[1]
        }
        //MARK:- MATTER DROPDOWN CLICK
        matterDropDown.didSelect { (selection, index, id) in
            let str = self.clientDropDown.text! == "-Select-" ? "" : self.clientDropDown.text!
            self.matterCode = self.matterarr[index]
            if(str.count == 0){
                self.setClientDropDown(mtname: selection, isFirst: false)
                self.clientDropDown.text = self.clientDropDown.optionArray[1]
            }
            if(index > 0){
                self.setClientDropDown(mtname: selection, isFirst: false)
            }
            else{
                self.setClientDropDown(mtname: "", isFirst: false)
            }
        }
    }
    
  //  MARK:- SETUP CLIENT DROPDOWN
    public func setClientDropDown(mtname: String , isFirst : Bool){
        var count : Int = 0
        var stmt1:OpaquePointer?
        clientarr.removeAll()
        let str = mtname == "-Select-" ? "" : mtname
        let query = "select   ''   as ClientCode , '--Select--' as ClientDesc UNION ALL SELECT   distinct(ClientCode) , ClientDesc from GetRMClientMatter  where MatterDesc like '%\(str)%'"
        
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        clientDropDown.optionArray.removeAll()
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            count = count + 1
            let code = String(cString: sqlite3_column_text(stmt1, 0))
            let str = String(cString: sqlite3_column_text(stmt1, 1))
            clientDropDown.optionArray.append(str)
            clientarr.append(code)
        }
        //MARK:- CLIENT DROPDOWN CLICK
        clientDropDown.didSelect { (selection, index, id) in
            if(index == 0){
                self.setMattterDropDown(clname: "")
                self.setClientDropDown(mtname: "", isFirst: false)
            }
            else{
                self.setMattterDropDown(clname: selection)
            }
        }
        if(count == 2 && isFirst == false){
            self.clientDropDown.text! = self.clientDropDown.optionArray[1]
        }
    }
    //MARK:- SETUP EXPENSE CATG DROPDOWN
    public func setExpCatgDropDown(){
        var stmt1:OpaquePointer?
        catgIdarr.removeAll()
        catgNamearr.removeAll()
        expenseCatgDropDown.optionArray.removeAll()

        let query = "select   ''   as projCategoryId , '--Select--' as projCategoryName UNION ALL SELECT   distinct(projCategoryId) , projCategoryName from GetRMExpenseCatg"
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let code = String(cString: sqlite3_column_text(stmt1, 0))
            let str = String(cString: sqlite3_column_text(stmt1, 1))
            expenseCatgDropDown.optionArray.append(str)
            catgIdarr.append(code)
            catgNamearr.append(str)
        }
        //MARK:- CATG DROPDOWN DIDSELECT
        expenseCatgDropDown.didSelect { (selection, index, id) in
            self.expenseCode = self.catgIdarr[index]
        }
    }
    
    //MARK:- SETUP COST CENTER DROPDOWN
    public func setCostCenterDropDown(){
        var stmt1:OpaquePointer?
        costIdarr.removeAll()
        costNamearr.removeAll()
        costCenterDropDown.optionArray.removeAll()
        let query = "select   ''   as CodeName , '--Select--' as Name UNION ALL SELECT   distinct(CodeName) , Name from GetRemCostCenterData"
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let code = String(cString: sqlite3_column_text(stmt1, 0))
            let str = String(cString: sqlite3_column_text(stmt1, 1))
            costCenterDropDown.optionArray.append(str)
            costIdarr.append(code)
            costNamearr.append(str)
        }
        //MARK:- COST CENTER DROPDOWN CLICK
        costCenterDropDown.didSelect { (selection, index, id) in
            self.costCenterCode = self.costIdarr[index]
        }
    }
    
    //MARK:- CORP DROPDOWN CLICK
    public func setCorpCardDropDown(){
        var stmt1:OpaquePointer?
        corpCardIdarr.removeAll()
        corpCardNamearr.removeAll()
        corporateCardDropDown.optionArray.removeAll()
        let query = "select  ''  as CardId, '--Select--' as Description   UNION ALL select CardId, Description from GetRemCorpCardTypeData"
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let code = String(cString: sqlite3_column_text(stmt1, 0))
            let str = String(cString: sqlite3_column_text(stmt1, 1))
            corporateCardDropDown.optionArray.append(str)
            corpCardIdarr.append(code)
            corpCardNamearr.append(str)
        }
        //MARK:- CORP DROPDOWN CLICK
        corporateCardDropDown.didSelect { (selection, index, id) in
            self.cardCode = self.corpCardIdarr[index]
        }
    }
    //MARK:- PAYMENT DROPDOWN CLICK
    public func paymentTypeDropDownClick(){
        paymentTypeDropDown.didSelect { (selection, index, id) in
            self.paymentTypeDropDown(paymentType: selection, corporateCard: self.corporateCardDropDown)
        }
    }
    func onToggleChanged(ischecked : Bool,client:DropDown,matter:DropDown){
        if ischecked{
            client.isUserInteractionEnabled = false
            matter.isUserInteractionEnabled = false
            client.text = ""
            matter.text = ""
            client.placeholder = "--Select--"
            matter.placeholder = "--Select--"
            debitTo = "Office"
        }
        else{
            client.isUserInteractionEnabled = true
            matter.isUserInteractionEnabled = true
            client.text = ""
            matter.text = ""
            client.placeholder = "--Select--"
            matter.placeholder = "--Select--"
            debitTo = "Client"
        }
    }
    
    func edtonToggleChanged(ischecked : Bool,client:DropDown,matter:DropDown){
        if ischecked{
            client.isUserInteractionEnabled = false
            matter.isUserInteractionEnabled = false
            client.text = ""
            matter.text = ""
            client.placeholder = "--Select--"
            matter.placeholder = "--Select--"
            edtdebitTo = "Office"
        }
        else{
            client.isUserInteractionEnabled = true
            matter.isUserInteractionEnabled = true
            client.text = ""
            matter.text = ""
            client.placeholder = "--Select--"
            matter.placeholder = "--Select--"
            edtdebitTo = "Client"
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
    @IBAction func saveChangesBtnClick(_ sender: UIButton) {
        if(validateEdit() && compareFromStartDate(date: edtdateTextField.text!)){
            self.updateReimbursementEntry(id: popupId, date: edtdateTextField.text!, debitTo: edtdebitTo, attachment: edtisAttachment, choosefile: "", paymentType: edtpaymentTypeDropDown.text!, corporateCard: edtcorporateCardDropDown.text!, client: edtclientDropDown.text!, matter: edtmatterDropDown.text!, expenseCategory: edtexpenseCatgDropDown.text!, remark: edtremarksTxtView.text!, amount: edtamountTextField.text!, costCenter: edtcostCenterDropDown.text!, post: "0", checkbox: "0", expensenumber: "", projid: getMatteridRem(str: edtmatterDropDown.text!) , clientid: getclientidRem(str: edtclientDropDown.text!), catgid: getExpenseidRem(str: edtexpenseCatgDropDown.text!), cardid: getCorporateidRem(str: edtcorporateCardDropDown.text!), statusId: edtstatusId, rejectremark: "", extensionStr: "", costcode: getCostCenteridRem(str: edtcostCenterDropDown.text!), payto: edtpayTestTxtField.text!)
            self.hideDetailsView()
            setTabledata()
        }
    }
    
    func showDetailsView(){
        ispopEnable = true
        self.detailsView.isHidden = false
        self.blurView(view: rootview)
        view.bringSubviewToFront((detailsView))
    }

    func hideDetailsView(){
        ispopEnable = false
        self.detailsView.isHidden = true
        view.sendSubviewToBack(detailsView)
        removeBlurView()
    }
    //MARK:- CHOOSEFILE BTN CLICK
    @IBAction func chooseFileBtnClick(_ sender: UIButton) {
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
//        print(fileStream)
//        print(filePath.lastPathComponent)
//        print(filePath.pathExtension)
        if(ispopEnable){
            self.insertAttachmentFileDetails(filename: filePath.lastPathComponent, fileStr: fileStream, id: popupId, post: "0", extensionStr: "." + filePath.pathExtension, fileid: getuid())
            edtisAttachment = "1"
            edtNofileChoosenTxt.text = "File Selected"
            edtsetTabledataAttachment(uid: popupId)
        }
        else{
        self.insertAttachmentFileDetails(filename: filePath.lastPathComponent, fileStr: fileStream, id: uniqueId, post: "0", extensionStr: "." + filePath.pathExtension, fileid: getuid())
            isAttachment = "1"
            NofileChoosenTxt.text = "File Selected"
            setTabledataAttachment(uid: uniqueId)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- EDIT CHOOSEFILE BTN CLICK
    @IBAction func edtChooseFileBtnClick(_ sender: UIButton) {
        docPick()
    }
    
    //MARK:- BACK BTN CLICK
    @IBAction func backBtnClick(_ sender: UIButton) {
        hideDetailsView()
    }
    //MARK:- SETUP MATTER DROPDOWN
    public func edtsetMattterDropDown(clname: String){
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
//        //MARK:- MATTER DROPDOWN CLICK
//        edtmatterDropDown.didSelect { (selection, index, id) in
//            let str = self.edtclientDropDown.text! == "-Select-" ? "" : self.edtclientDropDown.text!
//            self.edtmatterCode = self.edtmatterarr[index]
//            if(str.count == 0){
//                self.edtsetClientDropDown(mtname: selection)
//                self.edtclientDropDown.text = self.edtclientDropDown.optionArray[1]
//            }
//        }
        
        //MARK:- MATTER DROPDOWN CLICK
        edtmatterDropDown.didSelect { (selection, index, id) in
            let str = self.edtclientDropDown.text! == "-Select-" ? "" : self.edtclientDropDown.text!
            self.edtmatterCode = self.edtmatterarr[index]
            if(str.count == 0){
                self.edtsetClientDropDown(mtname: selection)
                self.edtclientDropDown.text = self.clientDropDown.optionArray[1]
            }
            if(index > 0){
                self.edtsetClientDropDown(mtname: selection)
            }
            else{
                self.edtsetClientDropDown(mtname: "")
            }
        }

    }
    
  //  MARK:- SETUP CLIENT DROPDOWN
    public func edtsetClientDropDown(mtname: String ){
        var count : Int! = 0
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
            count = count + 1
            let code = String(cString: sqlite3_column_text(stmt1, 0))
            let str = String(cString: sqlite3_column_text(stmt1, 1))
            edtclientDropDown.optionArray.append(str)
            edtclientarr.append(code)
        }
        //MARK:- CLIENT DROPDOWN CLICK
//        edtclientDropDown.didSelect { (selection, index, id) in
//            self.edtclientCode = self.edtclientarr[index]
//            self.edtsetMattterDropDown(clname: selection)
//        }
        
        edtclientDropDown.didSelect { (selection, index, id) in
            if(index == 0){
                self.edtsetMattterDropDown(clname: "")
                self.edtsetClientDropDown(mtname: "")
            }
            else{
                self.edtsetMattterDropDown(clname: selection)
            }
        }
        if(count == 2){
            self.edtclientDropDown.text! = self.edtclientDropDown.optionArray[1]
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
    
    //MARK:- SETTABLEDATA
    private  func setTabledata(){
        var stmt1:OpaquePointer?
        self.reimbursementEntryAdapter.removeAll()
        let query = "select id,date,amount,client,matter,remark,expenseCategory,checkbox from ReimbursementEntry"
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let Id = String(cString: sqlite3_column_text(stmt1, 0))
            let expenseDate = String(cString: sqlite3_column_text(stmt1, 1))
            let amount = String(cString: sqlite3_column_text(stmt1, 2))
            let clientName = String(cString: sqlite3_column_text(stmt1, 3))
            let matterName = String(cString: sqlite3_column_text(stmt1, 4))
            let remark = String(cString: sqlite3_column_text(stmt1, 5))
            let expenseCatg = String(cString: sqlite3_column_text(stmt1, 6))
            let checkbox = sqlite3_column_int(stmt1, 7)
            
            self.reimbursementEntryAdapter.append(ReimbursementEntryAdapter(Id: Id, expenseDate: expenseDate, amount: amount, clientName: clientName, matterName: matterName, remark: remark, expenseCategory: expenseCatg, btnState: String(checkbox)))
        }
        self.reimbursementEntryTable.reloadData()
    }
    
    @IBAction func save(_ sender: UIButton) {
        if (self.checklist()){
            let alert = UIAlertController(title: "Alert", message: "Are you sure, you want to save?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .default) { (_) in
                alert.dismiss(animated: true, completion: nil)
                if (AppDelegate.ntwrk > 0){
                    self.showIndicator("Syncing...", vc: self)
                    self.post_Rem(type: 0 , isedit: false)
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
                self.post_Rem(type: 1 , isedit: false)
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
        if (self.reimbursementEntryAdapter.count > 0){
            for adapter in self.reimbursementEntryAdapter {
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
            self.delrementry(uid: id)
            self.delAttachmentFileDetails(uid: id)
        }
        self.setTabledata()
        self.showdonemsg(type: type)
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
            if (self.reimbursementEntryAdapter.count == 0){
                self.gotoHome()
            }else{
                self.setTabledata()
            }
        }
        alert.addAction(ok)
        if (msg.count > 0){
            self.present(alert, animated: true, completion: nil)
        }
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
    //MARK:- SETTABLEDATA
    private  func setTabledataAttachment(uid :String){
        var stmt1:OpaquePointer?
        var count : Int = 0
        self.fileAttachmentAdapter.removeAll()
        //create table if not exists  AttachmentFileDetails(filename text,fileStr text ,id text,post text,extension text,fileid text)
        let query = "select filename,fileStr,id,post,extension,fileid from AttachmentFileDetails where id = \(uid)"
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
            
            self.fileAttachmentAdapter.append(FileAttachmentAdapter(filename: filename, fileStr: fileStr, id: id, post: post, extensionStr: extensionStr, fileid: fileid))
        }
            if(count == 0){
                switchbtnSwifty.isOn = false
                switchbtnSwifty.myColor = UIColor.lightGray
                ChooseFileBtn.backgroundColor = UIColor.lightGray
                ChooseFileBtn.isUserInteractionEnabled = false
            }
            else{
                switchbtnSwifty.isOn = true
                switchbtnSwifty.myColor = hexStringToUIColor(hex:"#003366")
                ChooseFileBtn.backgroundColor = hexStringToUIColor(hex:"#003366")
                ChooseFileBtn.isUserInteractionEnabled = true
            }
            self.fileAttachmentTable.reloadData()
    }
    
    
    //MARK:- SETTABLEDATA
    private  func edtsetTabledataAttachment(uid :String){
        var stmt1:OpaquePointer?
        var count : Int = 0
        self.edtfileAttachmentAdapter.removeAll()
        //create table if not exists  AttachmentFileDetails(filename text,fileStr text ,id text,post text,extension text,fileid text)
        let query = "select filename,fileStr,id,post,extension,fileid from AttachmentFileDetails where id = \(uid)"
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
            
            self.edtfileAttachmentAdapter.append(EditFileAttachmentAdapter(filename: filename, fileStr: fileStr, id: id, post: post, extensionStr: extensionStr, fileid: fileid))
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
//extension  UIDocumentPickerDelegate{
//
//
//  public   func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
//
//               let cico = url as URL
//               print(cico)
//               print(url)
//
//               print(url.lastPathComponent)
//
//               print(url.pathExtension)
//
//              }
//  }

