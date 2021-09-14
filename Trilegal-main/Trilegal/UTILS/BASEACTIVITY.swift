//  BASEACTIVITY.swift
//  Trilegal
//  Created by Acxiom Consulting on 27/04/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.

//MARK:- IMPORTS
import Foundation
import UIKit
import MaterialComponents.MaterialSnackbar
import SQLite3


enum STATUS : String{
//    0-Not Submitted, 1-Submitted, 2-Approved, 3-Rejected, 10-All
    case NOT_SUBMITTED = "0"
    case SUBMITTED = "1"
    case APPROVED = "2"
    case REJECTED = "3"
    case ALL = "10"
}

public class BASEACTIVITY: EXECUTEAPI {
    var blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    var blurEffectView = UIVisualEffectView()
    //for bottomsheets
    static var bottomsheetblurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    static var bottomsheetEffectView = UIVisualEffectView()

    var currentScreen : String?
    var prevScreeen : String?
    var nextScreeen : String?
    
    //MARK:- OUTLETS
    var menuvc: menuViewController!
    let dateFormatter = DateFormatter()

    //MARK:- GOTOHOME
    public func gotoHome(){
        let storyboard = UIStoryboard(name: "HOME", bundle: nil)
        let registrationVC = storyboard.instantiateViewController(withIdentifier: "HOMENC") as! UINavigationController
        navigationController?.pushViewController(registrationVC.topViewController!, animated: true)
    }
    //MARK:- PUSH VIEW CONTROLLER
    public func push(storybId: String, vcId: String, vc: BASEACTIVITY ){
        let storyboard = UIStoryboard(name: storybId, bundle: nil)
        let registrationVC = storyboard.instantiateViewController(withIdentifier: vcId) as! UINavigationController
        navigationController?.pushViewController(registrationVC.topViewController!, animated: true)
    }
    //MARK:- SIDE BAR
    public func setUpSideBar(){
        AppDelegate.menubool = true
        let storyboard = UIStoryboard(name: "SIDEMENU", bundle: nil)
        menuvc = (storyboard.instantiateViewController(withIdentifier: "menuViewController") as! menuViewController)
        let swiperyt = UISwipeGestureRecognizer(target: self, action: #selector(self.gesturerecognise))
        swiperyt.direction = UISwipeGestureRecognizer.Direction.right
        let swipelft = UISwipeGestureRecognizer(target: self, action: #selector(self.gesturerecognise))
        swipelft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swiperyt)
        self.view.addGestureRecognizer(swipelft)
    }
    //MARK:- CLICK SIDE MENU
    public func onClickSideMenu(){
        if AppDelegate.menubool{
            showmenu()
        }
        else {
            hidemenu()
        }
    }
    //MARK:- SHOWTOAST
    public func showtoast(controller: UIViewController, message: String, seconds: Double){
        let alert = UIAlertController(title: nil, message: message,  preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds){
            alert.dismiss(animated : false)
        }
        UIApplication.shared.isIdleTimerDisabled = true
    }
    //MARK:- GESTURE SWIPE
    @objc func gesturerecognise (gesture : UISwipeGestureRecognizer)
    {
        switch gesture.direction {
        case UISwipeGestureRecognizer.Direction.left :
            hidemenu()
            break
        case UISwipeGestureRecognizer.Direction.right :
            showmenu()
            break
        default:
            break
        }
    }
    //MARK:- SHOW MENU
    func showmenu()
    {
        UIView.animate(withDuration: 0.4){ ()->Void in
            self.menuvc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.menuvc.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.addChild(self.menuvc)
            self.view.addSubview(self.menuvc.view)
            AppDelegate.menubool = false
        }
    }
    //MARK:- HIDE MENU
    public func hidemenu ()
    {
        UIView.animate(withDuration: 0.3, animations: { ()->Void in
            self.menuvc.view.frame = CGRect(x: -UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }) { (finished) in
            self.menuvc.view.removeFromSuperview()
        }
        AppDelegate.menubool = true
    }
    
    
    public func hideViewController(viewController : UIViewController){
        viewController.removeFromParent()
    }
    
    //MARK:- SETNAME
    public func setName() -> String{
        return UserDefaults.standard.string(forKey: "name") == nil ? "" : UserDefaults.standard.string(forKey: "name")!
    }
    func strtodate(str: String, format: String)-> Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        do {
            try dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from:str) {
                return date
            }else{
                return Date()
            }
        }catch {
            return Date()
        }
    }
    
    public func getuid()-> String{
        let uid = self.getdate(format: "yyyy-MM-dd HH:mm:ss.SSS")
        let lotid = uid.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: ":", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: " ", with: "")
        return lotid
    }
    
    func convertDateFormater(date: String,input: String,output: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = input
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = output
        return  dateFormatter.string(from: date!)
    }
    //MARK:- STATUSDROPDOWN
    public func setStatusDropDown(statusDropDown : DropDown)-> [Int]{
//        0-Not Submitted, 1-Submitted, 2-Approved, 3-Rejected, 10-All
        var arr = [Int]()
        arr.removeAll()
        statusDropDown.optionArray.removeAll()
        statusDropDown.optionArray.append("All")
        arr.append(10)
        statusDropDown.optionArray.append("NotSubmitted")
        arr.append(0)
        statusDropDown.optionArray.append("Submitted")
        arr.append(1)
        statusDropDown.optionArray.append("Approved")
        arr.append(2)
        statusDropDown.optionArray.append("Rejected")
        arr.append(3)
        
        return arr
    }
    
    //MARK:- PAYMENTDROPDOWN
       public func setPaymentDropDownMyReimbursement(paymentDropDown : DropDown){
           paymentDropDown.optionIds?.removeAll()
           paymentDropDown.optionArray.removeAll()
           paymentDropDown.optionArray.append("All")
           paymentDropDown.optionIds?.append(0)
           paymentDropDown.optionArray.append("Reimbursement")
           paymentDropDown.optionIds?.append(1)
           paymentDropDown.optionArray.append("Non Reimbursement")
           paymentDropDown.optionIds?.append(2)
           paymentDropDown.optionArray.append("Corporate Card")
       }
    
    //MARK:- PAYMENTDROPDOWN
    public func setPaymentDropDown(paymentDropDown : DropDown){
        paymentDropDown.optionArray.removeAll()
        paymentDropDown.optionArray.append("Select Payment Type")
        paymentDropDown.optionArray.append("Reimbursement")
        paymentDropDown.optionArray.append("Non-Reimbursement")
        paymentDropDown.optionArray.append("Corporate Card")
    }
    //MARK:- EDITDROPDOWN
    public func seteditTimeSheetStatusDropDown(statusDropDown : DropDown){
        statusDropDown.optionArray.removeAll()
        statusDropDown.optionArray.append("Both")
        statusDropDown.optionArray.append("NotSubmitted")
        statusDropDown.optionArray.append("Rejected")
    }
    //MARK:- CATEGORYDROPDOWN
    public func setExpenseCategoryDropDown(expenseDropDown : DropDown){
        expenseDropDown.optionArray.append("Select Expense Category")
        expenseDropDown.optionArray.append("Advertisment")
        expenseDropDown.optionArray.append("Annual Maintenance Charges")
        expenseDropDown.optionArray.append("Legal Expense")
    }
    //MARK:- COSTCENTERDROPDOWN
    public func setCostCenterDropDown(costCenterDropDown : DropDown){
        costCenterDropDown.optionArray.append("Select Cost Center")
        costCenterDropDown.optionArray.append("Client")
        costCenterDropDown.optionArray.append("Legal Expenses")
        costCenterDropDown.optionArray.append("Offical Expense")
    }
    //MARK:- CORPORATEDROPDOWN
    public func setCorporateCardDropDown(corporateCardDropDown : DropDown){
        corporateCardDropDown.optionArray.append("Select Corporate Card")
        corporateCardDropDown.optionArray.append("AMEX")
        corporateCardDropDown.optionArray.append("HDFC")
    }
    //MARK:- RESOURCESDROPDOWN
    public func setResourcesDropDown(resourcesDropDown : DropDown){
        resourcesDropDown.optionArray.append("Select Resources")
        resourcesDropDown.optionArray.append("Nikhil Dhomne")
        resourcesDropDown.optionArray.append("Rahul Bairagi")
        resourcesDropDown.optionArray.append("Alis")
        resourcesDropDown.optionArray.append("Yogesh Singh")
    }
    //MARK:- SET DATE
    public func setToDate()  -> String{
        let endate = UserDefaults.standard.string(forKey: "enddate")!.prefix(10)
        return String(endate)
    }
    //MARK:- FROMDATE
    public func setFromDate() -> String{
        let stdate = UserDefaults.standard.string(forKey: "startdate")!.prefix(10)
        return String(stdate)
    }
    //MARK:- NL Date
    public func setnlDate() -> String{
        let nldate = UserDefaults.standard.string(forKey: "nldate")!.prefix(10)
        return String(nldate)
    }
    public func compareFromStartDate(date : String) ->Bool{
        if(date.prefix(10) > setFromDate()){
            return true
        }
        else{
            self.showmsg(msg: "Date Should be within Range of Lock Date")
            return false
        }
    }
    public func setImageForBtnOutlet(button : UIButton){
        button.setImage(UIImage(named:"unselected1"), for: .normal)
        button.setImage(UIImage(named:"selected1"), for: .selected)
    }
    public func borderToView(view : UIView , borderColor : UIColor , borderWidth : CGFloat){
        view.layer.borderColor = borderColor.cgColor
        view.layer.borderWidth = borderWidth
    }
    public func animatebtnOutlet(button : UIButton){
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            button.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
                button.isSelected = !button.isSelected
                button.transform = .identity
            }, completion: nil)
        }
    }
    public func animatebtnOutletWitthoutChnage(button : UIButton){
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            button.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
                button.transform = .identity
            }, completion: nil)
        }
    }
    public func showView(view : UIView){
        view.isHidden = false
    }
    public func hideView(view : UIView){
        view.isHidden = true
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func ShowAlert(){
        let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setnav(controller: UIViewController, title: String , spacing : CGFloat) {
        
           let titleStackView: UIStackView = {
               let titleLabel = UILabel()
               titleLabel.textAlignment = .left
               titleLabel.font = UIFont(name: "Whitney", size: 16)
               // titleLabel.font = .boldSystemFont(ofSize: 14)
               titleLabel.text = title
               titleLabel.textColor = UIColor.white
              // titleLabel.numberOfLines = 2
               
                let subtitleLabel = UILabel()
                subtitleLabel.text = setName()
               subtitleLabel.textAlignment = .right
               subtitleLabel.font = UIFont(name: "Whitney", size: 16)
               subtitleLabel.textColor = UIColor.white
               subtitleLabel.isUserInteractionEnabled = false
            
               let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
               stackView.spacing = spacing
               NSLayoutConstraint.activate([
                   stackView.heightAnchor.constraint(equalToConstant: navigationController?.navigationBar.frame.height ?? 35),
               ])
               stackView.axis = .horizontal
               stackView.sizeToFit()
               
               stackView.alignment = .top
               stackView.distribution = .fillProportionally
               
               return stackView
           }()
           let appColor = hexStringToUIColor(hex:"#003366")
           controller.navigationController?.navigationBar.tintColor =  appColor
           controller.navigationController?.navigationBar.barTintColor =  appColor
           controller.navigationController?.navigationBar.backgroundColor =  appColor
           controller.navigationItem.titleView = titleStackView
           if(!(title == "Home")) {
            AppDelegate.showAlert = true
           }
        
       }
    func setnavReview(controller: UIViewController, title: String , spacing : CGFloat) {
        
           let titleStackView: UIStackView = {
               let titleLabel = UILabel()
               titleLabel.textAlignment = .left
               titleLabel.font = UIFont(name: "Whitney", size: 14)
               // titleLabel.font = .boldSystemFont(ofSize: 14)
               titleLabel.text = title
               titleLabel.textColor = UIColor.white
              // titleLabel.numberOfLines = 2
               
                let subtitleLabel = UILabel()
                subtitleLabel.text = setName()
               subtitleLabel.textAlignment = .right
               subtitleLabel.font = UIFont(name: "Whitney", size: 14)
               subtitleLabel.textColor = UIColor.white
               subtitleLabel.isUserInteractionEnabled = false
            
               let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
               stackView.spacing = spacing
               NSLayoutConstraint.activate([
                   stackView.heightAnchor.constraint(equalToConstant: navigationController?.navigationBar.frame.height ?? 35),
               ])
               stackView.axis = .horizontal
               stackView.sizeToFit()
               
               stackView.alignment = .top
               stackView.distribution = .fillProportionally
               
               return stackView
           }()
           let appColor = hexStringToUIColor(hex:"#003366")
           controller.navigationController?.navigationBar.tintColor =  appColor
           controller.navigationController?.navigationBar.barTintColor =  appColor
           controller.navigationController?.navigationBar.backgroundColor =  appColor
           controller.navigationItem.titleView = titleStackView
           if(!(title == "Home")) {
            AppDelegate.showAlert = true
           }
        
       }

    
    public func getCurrentShortDate() -> String {
        var todaysDate = NSDate()
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy"
        let DateInFormat = dateFormatter.string(from: todaysDate as Date)

        return DateInFormat
    }
    
    public func getMonthYear() -> String {
        var todaysDate = NSDate()
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yy"
        let DateInFormat = dateFormatter.string(from: todaysDate as Date)

        return DateInFormat
    }
    

    
    //MARK:- HIDE MENU
    public func hidemenuNew (vc : UIViewController)
       {
           UIView.animate(withDuration: 0.3, animations: { ()->Void in
               vc.view.frame = CGRect(x: -UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
           }) { (finished) in
               vc.view.removeFromSuperview()
           }
           AppDelegate.menubool = true
       }
    func removeBlurView()
    {
        blurEffectView.removeFromSuperview()
    }
    func blurView(view: UIView){
        blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.backgroundColor = UIColor.lightGray
        blurEffectView.alpha = 0.2
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
    }
    
    public func hidemenuCLick ()
    {
        UIView.animate(withDuration: 0.3, animations: { ()->Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }) { (finished) in
            self.view.removeFromSuperview()
        }
        AppDelegate.menubool = true
    }
//    MARK:- Alert box
    public func showToast(message : String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Dismiss", style: .destructive) { action in
            self.dismiss()
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    public func dismiss(){}
    
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
        var activityIndicator = UIActivityIndicatorView()
        var strLabel = UILabel()
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        
    func showIndicator(_ title: String,vc: UIViewController) {
        self.navigationController?.view.isUserInteractionEnabled = false
        self.view.isUserInteractionEnabled = false
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
            strLabel.removeFromSuperview()
            activityIndicator.removeFromSuperview()
            effectView.removeFromSuperview()
            strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 180, height: 46))
            strLabel.text = title
            strLabel.font = .systemFont(ofSize: 15, weight: .medium)
        strLabel.textColor = UIColor.white
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: vc.view.frame.midY - strLabel.frame.height/2 , width: 180, height: 46)
            effectView.layer.cornerRadius = 15
            effectView.layer.masksToBounds = true
        activityIndicator = UIActivityIndicatorView(style: .white)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
            activityIndicator.startAnimating()
            effectView.contentView.addSubview(activityIndicator)
            effectView.contentView.addSubview(strLabel)
            vc.view.addSubview(effectView)
        }
    public func showmsg(msg: String){
        let mymessage = MDCSnackbarMessage()
        mymessage.text = msg
        mymessage.duration=TimeInterval(exactly: 3)!
        MDCSnackbarManager.messageTextColor = .black
        MDCSnackbarManager.snackbarMessageViewBackgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        MDCSnackbarManager.show(mymessage)
    }
    public func hideindicator(){
        if (activityIndicator.isAnimating){
            self.activityIndicator.stopAnimating()
            self.effectView.removeFromSuperview()
            self.navigationController?.view.isUserInteractionEnabled = true
            self.view.isUserInteractionEnabled = true
            self.navigationController?.navigationBar.isUserInteractionEnabled = true
        }
    }
    public func getdate (format: String) -> String {
        let date = Date()
        var currdate : String = ""
        do{
            let formatter = DateFormatter()
            formatter.dateFormat = format
            currdate = formatter.string(from: date)
        }catch{
            print("unsupported Date Format...")
        }
        
        return currdate
    }
    
//    Wednesday, Sep 12, 2018           --> EEEE, MMM d, yyyy
//    09/12/2018                        --> MM/dd/yyyy
//    09-12-2018 14:11                  --> MM-dd-yyyy HH:mm
//    Sep 12, 2:11 PM                   --> MMM d, h:mm a
//    September 2018                    --> MMMM yyyy
//    Sep 12, 2018                      --> MMM d, yyyy
//    Wed, 12 Sep 2018 14:11:54 +0000   --> E, d MMM yyyy HH:mm:ss Z
//    2018-09-12T14:11:54+0000          --> yyyy-MM-dd'T'HH:mm:ssZ
//    12.09.18                          --> dd.MM.yy
//    10:41:02.112                      --> HH:mm:ss.SSS

    public func downloadall(){
        if (AppDelegate.ntwrk > 0){
            CONSTANT.apicall = 0
            CONSTANT.failapi = 0
            self.showIndicator("Syncing...", vc: self)
            self.getClientMatterData()
            self.getTSentryData()
//            self.getRMCorpCardData()
//            self.getRMCostCenterData()
//            self.getRMExpenseCatgData()
//            self.getRMClientMatterData()
        }
    }
    public func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 60) % 60)
    }
    func gettime(min: Int)-> String{
        let (h,m,_) = self.secondsToHoursMinutesSeconds(seconds: Int(min*60))
            
        var hr = ""
        var mn = ""
        if (h < 10){
            hr = "0\(h)"
        }else{
            hr = "\(h)"
        }
        
        if (m < 10){
            mn = "0\(m)"
        }else{
            mn = "\(m)"
        }
        return "\(hr):\(mn)"
    }
    public func getCurrentShortDateRem() -> String {
        var todaysDate = NSDate()
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let DateInFormat = dateFormatter.string(from: todaysDate as Date)

        return DateInFormat
    }
    
    
    //MARK:- PAYMENTDROPDOWN
    public func setPaymentDropDownRem(paymentDropDown : DropDown){
        paymentDropDown.optionArray.removeAll()
        paymentDropDown.optionArray.append("--Select--")
        paymentDropDown.optionArray.append("Reimbursement")
        paymentDropDown.optionArray.append("Non-Reimbursement")
        paymentDropDown.optionArray.append("Corporate Card")
    }
    //MARK:- STATUSDROPDOWN
    public func setStatusDropDownEditRem(statusDropDown : DropDown)-> [Int]{
//        0-Not Submitted, 1-Submitted, 2-Approved, 3-Rejected, 10-All
        
        var arr = [Int]()
        arr.removeAll()
        statusDropDown.optionArray.removeAll()
        statusDropDown.optionArray.append("Both")
        arr.append(10)
        statusDropDown.optionArray.append("NotSubmitted")
        arr.append(0)
        statusDropDown.optionArray.append("Rejected")
        arr.append(3)
        
        return arr
    }

    
    
    
    public func setBorders(view: UIView, top topWidth: CGFloat, bottom bottomWidth: CGFloat, left leftWidth: CGFloat, right rightWidth: CGFloat, color: UIColor,inset:Bool = true) {
        var topBorderLayer:CALayer?
        var bottomBorderLayer:CALayer?
        var leftBorderLayer:CALayer?
        var rightBorderLayer:CALayer?
        
        let layerNameTopBorder = "topBorder"
        let layerNameBottomBorder = "bottomBorder"
        let layerNameLeftBorder = "leftBorder"
        let layerNameRightBorder = "rightBorder"
        
        for borderLayer in (view.layer.sublayers)! {
            if borderLayer.name == layerNameTopBorder {
                topBorderLayer = borderLayer
            } else if borderLayer.name == layerNameRightBorder {
                rightBorderLayer = borderLayer
            } else if borderLayer.name == layerNameLeftBorder {
                leftBorderLayer = borderLayer
            } else if borderLayer.name == layerNameBottomBorder {
                bottomBorderLayer = borderLayer
            }
           }


           // top border
           if topBorderLayer == nil {
               topBorderLayer = CALayer()
               topBorderLayer!.name = layerNameTopBorder
               view.layer.addSublayer(topBorderLayer!)
           }
           if inset {
               topBorderLayer!.frame = CGRect(x: view.bounds.minX, y: view.bounds.minY, width: view.bounds.width, height: topWidth)
           } else {
               topBorderLayer!.frame = CGRect(x: view.bounds.minX - leftWidth, y: view.bounds.minY - topWidth, width: view.bounds.width + leftWidth + rightWidth, height: topWidth)
           }
           topBorderLayer!.backgroundColor = color.cgColor


           // bottom border
           if bottomBorderLayer == nil {
               bottomBorderLayer = CALayer()
               bottomBorderLayer!.name = layerNameBottomBorder
               view.layer.addSublayer(bottomBorderLayer!)
           }
           if bottomWidth >= 0 {
               if inset {
                   bottomBorderLayer!.frame = CGRect(x: view.bounds.minX, y:view.bounds.size.height - bottomWidth, width:view.bounds.size.width, height: bottomWidth)
               } else {
                   bottomBorderLayer!.frame = CGRect(x: view.bounds.minX - leftWidth, y:view.bounds.size.height, width:view.bounds.size.width + leftWidth + rightWidth, height: bottomWidth)
               }
               bottomBorderLayer!.backgroundColor = color.cgColor
           }


           // left border
           if leftBorderLayer == nil {
               leftBorderLayer = CALayer()
               leftBorderLayer!.name = layerNameLeftBorder
               view.layer.addSublayer(leftBorderLayer!)
           }
           if inset {
               leftBorderLayer!.frame = CGRect(x: view.bounds.minX, y: view.bounds.minY, width: leftWidth, height: view.bounds.height)
           } else {
               leftBorderLayer!.frame = CGRect(x: view.bounds.minX - leftWidth, y: view.bounds.minY, width: leftWidth, height: view.bounds.height)
           }
           leftBorderLayer!.backgroundColor = color.cgColor


           // right border
           if rightBorderLayer == nil {
               rightBorderLayer = CALayer()
               rightBorderLayer!.name = layerNameRightBorder
               view.layer.addSublayer(rightBorderLayer!)
           }
           if inset {
               rightBorderLayer!.frame = CGRect(x: view.bounds.width - rightWidth, y: 0, width: rightWidth, height: view.bounds.height)
           } else {
               rightBorderLayer!.frame = CGRect(x: view.bounds.width, y: 0, width: rightWidth, height: view.bounds.height)
           }
           rightBorderLayer!.backgroundColor = color.cgColor
       }
    func didPickDocument(document: Document?) {
            if let pickedDoc = document {
                let fileURL = pickedDoc.fileURL
                let data = try! Data(contentsOf: fileURL)
                print(data)
                /// do what you want with the file URL
            }
        }
    
}










//MARK:- EXTENSIONS
extension UIViewController
{
    func setLeftAlignedNavigationItemTitle(text: String,
                                           color: UIColor,
                                           margin left: CGFloat)
    {
        let titleLabel = UILabel()
        titleLabel.textColor = color
        titleLabel.text = text
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.navigationItem.titleView = titleLabel
        guard let containerView = self.navigationItem.titleView?.superview else { return }
        // NOTE: This always seems to be 0. Huh??
        let leftBarItemWidth = self.navigationItem.leftBarButtonItems?.reduce(0, { $0 + $1.width })
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor,
                                             constant: (leftBarItemWidth ?? 0) + left),
            titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor)
        ])
    }
}
extension UISwitch {

    func set(width: CGFloat, height: CGFloat) {

        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51

        let heightRatio = height / standardHeight
        let widthRatio = width / standardWidth

        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
}
extension UIWindow {

    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }

    static func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        if let navigationController = vc as? UINavigationController,
            let visibleController = navigationController.visibleViewController  {
            return UIWindow.getVisibleViewControllerFrom( vc: visibleController )
        } else if let tabBarController = vc as? UITabBarController,
            let selectedTabController = tabBarController.selectedViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: selectedTabController )
        } else {
            if let presentedViewController = vc.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController)
            } else {
                return vc
            }
        }
    }
}
extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
extension UIView {
  func blurView(style: UIBlurEffect.Style) {
    var blurEffectView = UIVisualEffectView()
    let blurEffect = UIBlurEffect(style: style)
    blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = bounds
    addSubview(blurEffectView)
  }
  
  func removeBlur() {
    for view in self.subviews {
      if let view = view as? UIVisualEffectView {
        view.removeFromSuperview()
      }
    }
  }
}
extension Date {
    
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }

    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
