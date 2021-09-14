//
//  REVIEWREIMBURSEMENTVC.swift
//  Trilegal
//
//  Created by Acxiom Consulting on 07/05/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.
//

import UIKit
import SQLite3

class REVIEWREIMBURSEMENTVC: BASEACTIVITY , UITableViewDataSource , UITableViewDelegate , UITextViewDelegate, SwiftySwitchDelegate , OptionButtonsDelegateReview {

    var uid = ""
    
    func toggleclicked(at index: IndexPath){
        let list : ReviewReimbursementAdapter
        list = reviewreimbursementAdapter[index.row]
        self.setTabledata(clName: self.clientDropDown.text!, matterName: self.matterDropDown.text!, resourceName: self.resourcesDropDown.text!)
        if (self.checkrbtn()){
            self.uid = list.transactionId!
            self.showRejectBtn(isEnabled: true)
        }else{
            self.showRejectBtn(isEnabled: false)
        }
    }

    
    func valueChanged(sender: SwiftySwitch) {
        if sender.isOn {
            edtswitchbtnSwifty.myColor = hexStringToUIColor(hex:"#003366")
        }
        else{
            edtswitchbtnSwifty.myColor = UIColor.lightGray
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewreimbursementAdapter.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewReimbursementCell", for:  indexPath) as! ReviewReimbursementCell
        let list: ReviewReimbursementAdapter
        list = reviewreimbursementAdapter[indexPath.row]
        setImageForBtnOutlet(button: cell.btnClick)

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
        cell.clientName.text = list.clientName
        cell.matterName.text = list.matterName
        cell.expenseDate.text = list.expenseDate
        cell.amount.text = list.amount
        cell.remark.text = list.remark
        cell.uid = list.transactionId!
        cell.indexPath = indexPath
        cell.delegateReview = self
        if (list.btnState == "0"){
            cell.btnClick.isSelected = false
        }else{
            cell.btnClick.isSelected = true
        }
        return cell
    }
    
    @IBOutlet weak var rightSideBtn: UIBarButtonItem!
    @IBOutlet weak var matterDropDown: DropDown!
    @IBOutlet weak var resourcesDropDown: DropDown!
    @IBOutlet weak var clientDropDown: DropDown!
    @IBOutlet weak var reviewReimbursementTable: UITableView!
    @IBOutlet weak var rejectView: UIView!
    @IBOutlet weak var rejectTxtView: UITextView!
    @IBOutlet weak var rejectBtnOutlet: UIButton!
    @IBOutlet weak var selectionBtnOutlet: UIButton!
    @IBOutlet var rootview: UIView!
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

    var isAllSelected : Bool = false
    var reimbursementEntryAdapter = [ReimbursementEntryAdapter]()
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
    var clientIdarr = [String]()
    var matterIdarr = [String]()
    var matterNamearr = [String]()
    var clientNamearr = [String]()
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
    var resIdarr = [String]()
    var resNamearr = [String]()
    var popupId : String = ""
    var rejectBtnCheck : Bool = false
    var reviewSelectedCount : Int! = 0
    var reviewUnSelectedCount : Int! = 0
    var firstBool : Bool = false
    var checkCount : Int = 0
    var checkCountSelectAll : Int = 0
    var reviewreimbursementAdapter = [ReviewReimbursementAdapter]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.getReviewReimbursementData()
    }
    func getReviewReimbursementData(){
        if (AppDelegate.ntwrk > 0){
            self.showIndicator("Syncing...", vc: self)
            getreviewReimbursement()
        } else{
            self.showToast(message: "Please check your Internet connection")
        }
    }
    override func VD() {
        self.hideindicator()
        self.setTabledata()
        setClientDropDown(mtname: "", isfirst: true)
        setMattterDropDown(clname: "", isfirst: true)
        setResourceDropDown(resname: "", isfirst: true)
    }
    override func VD1() {
        self.hideindicator()
    }
    override func INVD(msg: String) {
        self.hideindicator()
        showtoast(controller: self, message: "No Record Found!!", seconds: 1.0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.currScreen = "RVRE"
        firstBool = true
        if(setName().count>15){
            self.setnavReview(controller: self, title: "Review Reimbursement" , spacing : 5)
        }
        else{
            self.setnav(controller: self, title: "Review Reimbursement" , spacing : 30)
        }

        setUpSideBar()
        self.view.addSubview(rejectView)
        self.rejectView.layer.borderColor = UIColor.lightGray.cgColor
        self.rejectView.layer.borderWidth = 0.5
        self.rejectTxtView.layer.borderColor = UIColor.lightGray.cgColor
        self.rejectTxtView.layer.borderWidth = 0.5
        setImageForBtnOutlet(button: selectionBtnOutlet)
        invalidateTouch()
        borderToView()
        edtswitchBtnSetup()
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
    @IBAction func selectionBtn(_ sender: UIButton) {
        isAllSelected = !isAllSelected
        self.updatestatusEditRemTrans(status: isAllSelected ? "1" : "0", TransactionId: "-1")
        animatebtnOutlet(button: self.selectionBtnOutlet)
        self.setTabledata(clName: self.clientDropDown.text!, matterName: self.matterDropDown.text!,resourceName: self.resourcesDropDown.text!)
        self.showRejectBtn(isEnabled: false)
    }
    @IBAction func sideMenuBtn(_ sender: UIBarButtonItem) {
        onClickSideMenu()
    }
    @IBAction func rejectViewBackBtn(_ sender: UIButton) {
           rejectView.isHidden = true
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
    @IBAction func backBtn(_ sender: UIButton) {
        hideDetailsView()
    }
    @IBAction func reloadBtn(_ sender: UIButton) {
        self.getReviewReimbursementData()
    }

    func showDetailsView(){
        self.detailsView.isHidden = false
        self.blurView(view: rootview)
        view.bringSubviewToFront((detailsView))
    }
    func hideDetailsView(){
        self.detailsView.isHidden = true
        view.sendSubviewToBack(detailsView)
        removeBlurView()
    }
    //MARK:- SETTABLEDATA
    private  func setTabledata(){
        var count : Int = 0
        var stmt1:OpaquePointer?
        self.reviewreimbursementAdapter.removeAll()
        var payStr : String = ""
        let query = "select TransDate,ClaimAmount,ClientName,ProjectName,Remarks,Status, paymentType,ResourceName,CardName,CategotyName,CostCenterName,AttachmentPath,ClientOffice,checkbox,ExpenseNumber,TransactionId from ReimbursementMaster order by TransDate desc"
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
            let btnState = String(cString: sqlite3_column_text(stmt1, 13))
            let expenseno = String(cString: sqlite3_column_text(stmt1, 14))
            let transactionId = String(cString: sqlite3_column_text(stmt1, 15))
            
            if (paymentType == "0"){
                payStr = "Reimbursement"
            }
            else if (paymentType == "1"){
                payStr = "Non-Reimbursement"
            }
            else if (paymentType == "2"){
                payStr = "Corporate Card"
            }
            self.reviewreimbursementAdapter.append(ReviewReimbursementAdapter(expenseDate: expenseDate, amount: amount, clientName: clientName, matterName: matterName, remark: remark, status: status, paymentType: payStr, payto: payto, corporateCard: corporateCard, expenseCatg: expenseCatg, costCenter: costCenter, noFileChoosenTxt: noFileChoosenTxt, debitToTxt: debitToTxt,btnState: btnState,expenseno: expenseno, transactionId: transactionId))
        }
        self.reviewReimbursementTable.reloadData()
        if(count == 0){
            showtoast(controller: self, message: "No Record Found!!", seconds: 2.0)
        }
    }
    //  MARK:- SETUP CLIENT DROPDOWN
    public func setClientDropDown(mtname: String ,isfirst : Bool){
        var stmt1:OpaquePointer?
        clientIdarr.removeAll()
        clientNamearr.removeAll()
          let str = mtname == "-Select-" ? "" : mtname
           
          let query = "select   ''   as clientid , '-Select-' as ClientName UNION ALL SELECT   distinct(clientid) , ClientName from ReimbursementMaster  where ProjectName like '%\(str)%'"
          if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
              let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
              print("error preparing get: \(errmsg)")
              return
          }
          clientDropDown.optionArray.removeAll()
          while(sqlite3_step(stmt1) == SQLITE_ROW){
              let code = String(cString: sqlite3_column_text(stmt1, 0))
              let str = String(cString: sqlite3_column_text(stmt1, 1))
              clientDropDown.optionArray.append(str)
              clientIdarr.append(code)
          }
          //MARK:- CLIENT DROPDOWN CLICK
          clientDropDown.didSelect { (selection, index, id) in
            self.clientDropDown.text! = selection
            if(index == 0){
                self.setMattterDropDown(clname: "", isfirst: false)
                self.setClientDropDown(mtname: "", isfirst: false)
                self.setTabledata(clName: "", matterName: "", resourceName: self.resourcesDropDown.text!)
            }
            else{
                self.setMattterDropDown(clname: self.clientDropDown.text!, isfirst: false)
                self.setTabledata(clName: self.clientDropDown.text!, matterName: self.matterDropDown.text!, resourceName: self.resourcesDropDown.text!)
            }
          }
        if(isfirst){
            clientDropDown.text = clientDropDown.optionArray[0]
        }
      }
    
    //MARK:- SETUP MATTER DROPDOWN
    public func setMattterDropDown(clname: String , isfirst : Bool){
        var count : Int = 0
        var stmt1:OpaquePointer?
        matterIdarr.removeAll()
        matterNamearr.removeAll()
        let str = clname == "-Select-" ? "" : clname
        let query = "select ''  as projid , '-Select-' as ProjectName  UNION ALL select distinct(projid) , ProjectName  from ReimbursementMaster where ClientName like '%\(str)%'"
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        matterDropDown.optionArray.removeAll()
        matterDropDown.text! = ""
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            count  = count + 1
            let code = String(cString: sqlite3_column_text(stmt1, 0))
            let str = String(cString: sqlite3_column_text(stmt1, 1))
            matterDropDown.optionArray.append(str)
            matterIdarr.append(code)
            matterNamearr.append(str)
        }
        if(count==2){
            matterDropDown.text! = matterDropDown.optionArray[1]
        }
        //MARK:- MATTER DROPDOWN CLICK
        matterDropDown.didSelect { (selection, index, id) in
            self.matterDropDown.text! = selection
            
//            let str = self.clientDropDown.text! == "-Select-" ? "" : self.clientDropDown.text!
//            if(str.count == 0){
//                self.setClientDropDown(mtname: selection, isfirst: false)
//                self.clientDropDown.text = self.clientDropDown.optionArray[1]
//            }
            if(index > 0){
                self.setClientDropDown(mtname: selection, isfirst: false)
                self.setMattterDropDown(clname: self.clientDropDown.text!, isfirst: false)
            }
            else{
                self.setClientDropDown(mtname: "", isfirst: false)
                self.setMattterDropDown(clname: self.clientDropDown.text!, isfirst: false)
            }
            self.setTabledata(clName: self.clientDropDown.text!, matterName: self.matterDropDown.text!, resourceName: self.resourcesDropDown.text!)
        }
        if(isfirst){
            self.matterDropDown.text = self.matterDropDown.optionArray[0]
        }
    }
    
    //MARK:- SETUP MATTER DROPDOWN
    public func setResourceDropDown(resname: String,isfirst : Bool){
        var count : Int = 0
        var stmt1:OpaquePointer?
        resIdarr.removeAll()
        resNamearr.removeAll()
        let str = resname == "-Select-" ? "" : resname
        let query = "SELECT '-Select-' as  ResourceName UNION All select DISTINCT ResourceName from ReimbursementMaster where ResourceName <> '' and ResourceName like '%\(str)%'"
         if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        resourcesDropDown.optionArray.removeAll()
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            count  = count + 1
            let str = String(cString: sqlite3_column_text(stmt1, 0))
            resourcesDropDown.optionArray.append(str)
            resNamearr.append(str)
        }
        //MARK:- MATTER DROPDOWN CLICK
        resourcesDropDown.didSelect { (selection, index, id) in
            self.resourcesDropDown.text! = selection
          self.setTabledata(clName: self.clientDropDown.text!, matterName: self.matterDropDown.text!, resourceName: self.resourcesDropDown.text!)
        }
        if(isfirst){
            self.resourcesDropDown.text! = self.resourcesDropDown.optionArray[0]
        }
    }
    //MARK:- SETTABLEDATA
    private  func setTabledata(clName : String! , matterName : String! , resourceName : String!){
        var count : Int = 0
        var stmt1:OpaquePointer?
        self.reviewreimbursementAdapter.removeAll()
        var pay : String = ""
        var client : String = clName
        var matter : String = matterName
        var resource : String = resourceName

        if(client == "-Select-"){
            client = ""
        }
        if(matter == "-Select-"){
            matter = ""
        }
        if(resource == "-Select-"){
            resource = ""
        }

        let query = "select TransDate,ClaimAmount,ClientName,ProjectName,Remarks,Status, paymentType,ResourceName,CardName,CategotyName,CostCenterName,AttachmentPath,ClientOffice,checkbox,ExpenseNumber,TransactionId from ReimbursementMaster  where ClientName like '%\(client)%' and ProjectName like '%\(matter)%' and ResourceName like '%\(resource)%'  order by TransDate desc"
      print(query)
        
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
            let btnState = String(cString: sqlite3_column_text(stmt1, 13))
            let expenseno = String(cString: sqlite3_column_text(stmt1, 14))
            let TransactionId = String(cString: sqlite3_column_text(stmt1, 15))
            
            if (paymentType == "0"){
                pay = "Reimbursement"
            }
            else if (paymentType == "1"){
                pay = "Non-Reimbursement"
            }
            else if (paymentType == "2"){
                pay = "Corporate Card"
            }
            self.reviewreimbursementAdapter.append(ReviewReimbursementAdapter(expenseDate: expenseDate, amount: amount, clientName: clientName, matterName: matterName, remark: remark, status: status, paymentType: pay, payto: payto, corporateCard: corporateCard, expenseCatg: expenseCatg, costCenter: costCenter, noFileChoosenTxt: noFileChoosenTxt, debitToTxt: debitToTxt,btnState: btnState,expenseno: expenseno, transactionId: TransactionId))
        }
        self.reviewReimbursementTable.reloadData()
        if(count == 0){
            showtoast(controller: self, message: "No Record Found!!", seconds: 2.0)
        }
    }
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
        self.edtswitchbtnSwifty.isUserInteractionEnabled = false
        self.edtChooseFileBtn.isUserInteractionEnabled = false
        self.edtamountTextField.isUserInteractionEnabled = false
    }
    func checkrbtn()-> Bool{
        var flag = true
        var select = 0
        if (self.reviewreimbursementAdapter.count > 0){
            for adapter in self.reviewreimbursementAdapter {
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
    private func borderToView(){
        edtremarksTxtView.layer.borderColor = UIColor.lightGray.cgColor
        edtremarksTxtView.layer.borderWidth = 1
        detailsView.layer.borderColor = UIColor.lightGray.cgColor
        detailsView.layer.borderWidth = 0.5
        rejectView.layer.borderColor = UIColor.lightGray.cgColor
        rejectView.layer.borderWidth = 0.5
    }
    @IBAction func rejectViewBtn(_ sender: UIButton) {
        
        if(!(rejectTxtView.text.isEmpty || rejectTxtView.text == "Add Rejection remark" || rejectTxtView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)){
            self.rejectView.isHidden = true
            let alert = UIAlertController(title: "Alert", message: "Are you sure to reject?", preferredStyle: .alert)
            
            let yes = UIAlertAction(title: "Yes", style: .default) { (_) in
                alert.dismiss(animated: true, completion: nil)
                if (AppDelegate.ntwrk > 0){
                    self.showIndicator("Syncing...", vc: self)
                    self.postrejectRe(remarks: self.rejectTxtView.text!, trid: self.uid)
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
            self.rejectView.isHidden = false
        }
    }
    
    @IBAction func approveBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure to approve?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default) { (_) in
            alert.dismiss(animated: true, completion: nil)
            if (AppDelegate.ntwrk > 0){
                self.showIndicator("Syncing...", vc: self)
                self.postapproveRe()
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
        if (self.reviewreimbursementAdapter.count > 0){
            for adapter in self.reviewreimbursementAdapter {
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
    override func reviewdoneRem(){
        self.hideindicator()
        let alert = UIAlertController(title: "", message: "Success", preferredStyle: .alert)
        let yes = UIAlertAction(title: "ok", style: .default) { (_) in
            alert.dismiss(animated: true, completion: nil)
            if (AppDelegate.ntwrk > 0){
                self.showIndicator("Syncing...", vc: self)
                self.getReviewReimbursementData()
            }else{
                self.showToast(message: CONSTANT.NET_ERR)
            }
        }
        alert.addAction(yes)
        self.present(alert, animated: true, completion: nil)
    }
    //MARK:- SWITCH BTN SETUP
    func edtswitchBtnSetup(){
        edtswitchbtnSwifty.delegate = self
        edtswitchbtnSwifty.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
        edtswitchbtnSwifty.myColor = UIColor.lightGray
    }

}
