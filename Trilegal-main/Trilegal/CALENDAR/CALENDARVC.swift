//
//  CALENDARVC.swift
//  Trilegal
//
//  Created by Acxiom Consulting on 21/05/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.

//MARK:- IMPORTS
import UIKit
import FSCalendar
import SQLite3


class CALENDARVC: BASEACTIVITY , FSCalendarDataSource, FSCalendarDelegate , FSCalendarDelegateAppearance {
    @IBOutlet weak var rightSideBtn: UIBarButtonItem!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var upperView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if(setName().count>15){
            self.setnav(controller: self, title: "My Calendar" , spacing : 40)
        }
        else{
            self.setnav(controller: self, title: "My Calendar        " , spacing : 80)
        }

        AppDelegate.currScreen = "CALENDAR"
        self.deletetable(tbl: "calendar")
        setUpSideBar()
        // rightSideBtn.title = setName()
        self.setup()
        self.calendarApperreanceSetup()
        self.getdata(date: self.getdate(format: "yyyy-MM-dd"))
        self.monthlbl.text = ""
        self.calendar.isUserInteractionEnabled = false
        
    }
    
    
    @objc func getdata(date: String, isloader: Bool = false){
        if (AppDelegate.ntwrk > 0){
            print("calendar called --> \(self.getdate(format: "HH:mm:ss"))")
            if isloader {
                self.showIndicator("Syncing...", vc: self)
            }
            self.getcalendar(date: date)
        }else{
            self.showToast(message: CONSTANT.NET_ERR)
        }
    }
    
    override func gotcalndar(){
        self.hideindicator()
        self.calendar.reloadData()
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "en_US_POSIX")
        dateformatter.dateFormat = "yyyy-MM-dd"
        let currdate = dateformatter.date(from: self.getdate(format: "yyyy-MM-dd"))
        let nextdate = dateformatter.date(from: self.setnlDate())
        let daydiff = nextdate?.days(from: currdate!)
        dateformatter.dateFormat = "HH:mm"
        let currtime = dateformatter.date(from: self.getdate(format: "HH:mm"))
        var nexttime = UserDefaults.standard.string(forKey: "nldate")!
        let sindex = nexttime.index(nexttime.startIndex, offsetBy: 11)
        let eindex = nexttime.index(nexttime.endIndex, offsetBy: -4)
        nexttime = String(nexttime[sindex..<eindex])
        let ntime = dateformatter.date(from: nexttime)
        self.bhlbl.text = "\(daydiff!)D: \(self.gettimediff(date1: currtime!, date2: ntime!))"
        self.gettothr()
        self.caldate = self.getmonthdate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
            self.getdata(date: self.getmonthdate())
        }
    }
    
    func getmonthdate()-> String{
        let monthyeear = self.monthlbl.text!
        let date = self.convertDateFormater(date: "10 \(monthyeear)", input: "dd MMM yy", output: "yyyy-MM-dd")
        
        return date
    }
    
    func gettothr(){
        var stmt1:OpaquePointer?
//        select SUM(TotMins)as Total,SUM(BillMins)as TotalBill from GetMyCalendar where CalendarDate BETWEEN '" + startDate + "' AND '" + endDate + "';"
        var dayComponent    = DateComponents()
        dayComponent.day    = 1 // For removing one day (yesterday): -1
        let theCalendar     = Calendar.current
        let stDate        = theCalendar.date(byAdding: dayComponent, to: Date().startOfWeek!)
        let endate = theCalendar.date(byAdding: dayComponent, to: Date().endOfWeek!)
        
        var weekstartdate = "\(stDate!)"
        var endweeekdate = "\(endate!)"
        weekstartdate = String(weekstartdate.prefix(10))
        endweeekdate = String(endweeekdate.prefix(10))
        
        let query = "select SUM(totmins)as Total,SUM(billmins)as TotalBill from calendar where substr(date,1,10) BETWEEN '\(weekstartdate)' AND '\(endweeekdate)'"
        
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        var totmins = 0,billmins = 0
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            totmins = Int(sqlite3_column_int(stmt1, 0))
            billmins = Int(sqlite3_column_int(stmt1, 1))
        }
        self.thlbl.text = "TH \(self.gettime(min: totmins)) BH \(self.gettime(min: billmins)) Recorded this week"
    }
    
    
    @IBOutlet var bhlbl: UILabel!
    
    @IBOutlet var thlbl: UILabel!
    @IBOutlet var monthlbl: UILabel!
    
    @IBAction func sideMenuBtn(_ sender: UIBarButtonItem) {
        onClickSideMenu()
    }
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    fileprivate func calendarApperreanceSetup(){
        self.calendar.calendarWeekdayView.weekdayLabels[0].textColor  = UIColor.red
        self.calendar.calendarWeekdayView.weekdayLabels[1].textColor  = UIColor.black
        self.calendar.calendarWeekdayView.weekdayLabels[2].textColor  = UIColor.black
        self.calendar.calendarWeekdayView.weekdayLabels[3].textColor  = UIColor.black
        self.calendar.calendarWeekdayView.weekdayLabels[4].textColor  = UIColor.black
        self.calendar.calendarWeekdayView.weekdayLabels[5].textColor  = UIColor.black
        self.calendar.calendarWeekdayView.weekdayLabels[6].textColor  = UIColor.red
        self.calendar.appearance.weekdayTextColor = UIColor.black
        self.calendar.appearance.headerTitleColor = UIColor.black
        self.calendar.appearance.headerTitleFont = UIFont(name: "Whitney", size: 20.0)
        self.calendar.appearance.weekdayFont = UIFont(name: "Whitney", size: 16.0)
        self.calendar.appearance.caseOptions = .weekdayUsesUpperCase
        self.calendar.appearance.titleFont = .none
        self.calendar.appearance.titleDefaultColor = UIColor.black
        self.calendar.appearance.titlePlaceholderColor = UIColor.black
        self.calendar.appearance.subtitleFont = UIFont(name: "Whitney", size: 10.0)
        self.calendar.calendarWeekdayView.backgroundColor =  UIColor.white
        self.calendar.today = nil // Hide the today circle
        self.calendar.placeholderType = .fillHeadTail
        self.calendar.appearance.headerMinimumDissolvedAlpha = 0
        self.calendar.scrollEnabled = false
        self.calendar.pagingEnabled = false
        self.calendar.calendarHeaderView.isHidden = true
        self.calendar.calendarHeaderView.fs_height = 0.0
    }
    
    @IBAction func prevMonthBtnClicked(_ sender: UIButton) {
        var dayComponent    = DateComponents()
        dayComponent.month    = -1 // For removing one day (yesterday): -1
        let theCalendar     = Calendar.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: self.caldate){
        let stDate        = theCalendar.date(byAdding: dayComponent, to: date)
            self.caldate = dateFormatter.string(from: stDate!)
            print("caldate --> \(self.caldate)")
            self.moveCurrentPage(moveUp: false)
        }
    }
    
    @IBAction func nextMonthBtnClicked(_ sender: UIButton) {
        var dayComponent    = DateComponents()
        dayComponent.month    = 1 // For removing one day (yesterday): -1
        let theCalendar     = Calendar.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: self.caldate){
        let stDate        = theCalendar.date(byAdding: dayComponent, to: date)
            self.caldate = dateFormatter.string(from: stDate!)
            print("caldate --> \(self.caldate)")
            self.moveCurrentPage(moveUp: true)
        }
    }
    
    private var currentPage: Date?
    
    private lazy var today: Date = {
        return Date()
    }()
    private func moveCurrentPage(moveUp: Bool) {
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = moveUp ? 1 : -1
        
        self.currentPage = calendar.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
        self.calendar.setCurrentPage(self.currentPage!, animated: true)
    }
    func getweekday(myDate: Date)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekday = dateFormatter.string(from: myDate)
        print("\(myDate) -- > \(weekday)")
        return weekday
    }
    
    func getMonthAndYear(myDate: Date)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yy"
        let monthYear = dateFormatter.string(from: myDate)
        print("\(myDate) -- > \(monthYear)")
        monthlbl.text! = monthYear
        
        return monthYear
    }
    
    func getmonth() -> String{
        let str = monthlbl.text!
        let components = str.components(separatedBy: " ")
        print(components[0])
        return components[0]
    }
    
    func getCurrentMonth(myDate: Date)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        let monthYear = dateFormatter.string(from: myDate)
        print("\(myDate) -- > \(monthYear)")
        return monthYear
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        self.gettothr(date: date)
    }
    
    func calendar(_ calendar: FSCalendar, substrFor date: Date) -> String? {
        self.gettotbh(date: date)
    }
    
    func setnav() {
        let mainStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [upperView, calendar])
            return stackView
        }()
        
    }
    
    fileprivate func setup(){
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.white
        self.view = view
        let screenBounds = UIScreen.main.bounds
        let screen_width = screenBounds.width
        let screen_height = screenBounds.height
        let height: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 400 : 300
        let calendar = FSCalendar(frame: CGRect(x: 0, y: self.navigationController!.navigationBar.frame.maxY, width: screen_width - 10, height: 500))
        
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = false
        view.addSubview(calendar)
        view.addSubview(upperView)
        self.calendar = calendar
        calendar.appearance.eventOffset = CGPoint(x: 0, y: -7)
        calendar.today = nil // Hide the today circle
        calendar.firstWeekday = 2
        calendar.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
        //    calendar.clipsToBounds = false // Remove top/bottom line
        calendar.appearance.eventSelectionColor = UIColor.white
    }
    
    // MARK:- FSCalendarDataSource
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configureIndid(cell: cell, for: date, at: position)
    }
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
    
    // MARK:- FSCalendarDelegate
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    
    
    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    var caldate = ""
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        self.getdata(date: self.caldate,isloader: true)
    }
    
    override func INVD(msg: String) {
        self.hideindicator()
        self.showmsg(msg: msg)
    }
    
    private func configureDidSelect(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        let diyCell = (cell as! DIYCalendarCell)
        
        diyCell.circleImageView.isHidden = !self.gregorian.isDateInToday(date)
        diyCell.circleImageView.isHidden = true
        diyCell.backgroundView?.backgroundColor = UIColor.systemGreen
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        let diyCell = (cell as! DIYCalendarCell)
        
        diyCell.circleImageView.isHidden = !self.gregorian.isDateInToday(date)
        diyCell.circleImageView.isHidden = true
        diyCell.layer.borderColor = UIColor.white.cgColor
        diyCell.layer.borderWidth = 0.5
        self.getMonthAndYear(myDate: date)
        diyCell.backgroundView?.backgroundColor = UIColor.lightGray
    }
    
    private func configureIndid(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        let diyCell = (cell as! DIYCalendarCell)
        
        diyCell.circleImageView.isHidden = !self.gregorian.isDateInToday(date)
        diyCell.circleImageView.isHidden = true
        diyCell.layer.borderColor = UIColor.white.cgColor
        diyCell.layer.borderWidth = 0.5
        
        var str : String = self.getCurrentMonth(myDate: date)
        let day: String = self.getweekday(myDate: date)
        let tottime = self.gettottime(date: date)
        
        //  print(str)
        if (diyCell.titleLabel.textColor.description == "UIExtendedGrayColorSpace 0.666667 1"){
            diyCell.titleLabel.textColor = UIColor.white
            diyCell.subtitleLabel.textColor = UIColor.white
            diyCell.substrLabel.textColor = UIColor.white
            diyCell.backgroundView?.backgroundColor = UIColor.darkGray
        }else if (day == "Saturday" || day == "Sunday"){
            diyCell.subtitleLabel.textColor = UIColor.white
            diyCell.titleLabel.textColor = UIColor.white
            diyCell.substrLabel.textColor = UIColor.white
            diyCell.backgroundView?.backgroundColor = UIColor.systemRed
            self.getMonthAndYear(myDate: date)
        }else if (tottime > 1*60 && tottime < 8*60){
            diyCell.subtitleLabel.textColor = UIColor.black
            diyCell.titleLabel.textColor = UIColor.black
            diyCell.substrLabel.textColor = UIColor.black
            diyCell.backgroundView?.backgroundColor = UIColor.cyan
        }else if (tottime > 8*60){
            diyCell.subtitleLabel.textColor = UIColor.white
            diyCell.titleLabel.textColor = UIColor.white
            diyCell.substrLabel.textColor = UIColor.white
            diyCell.backgroundView?.backgroundColor = UIColor.systemBlue
        }else {
            diyCell.backgroundView?.backgroundColor = UIColor.lightGray
            diyCell.subtitleLabel.textColor = UIColor.black
            diyCell.titleLabel.textColor = UIColor.black
            diyCell.substrLabel.textColor = UIColor.black
            self.getMonthAndYear(myDate: date)
        }
    }
    
    public func gettottime(date: Date) -> Int{
        var hrs = 0
        var stmt1:OpaquePointer?
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        let cdate = dateformatter.string(from: date)
        
        let query = "select totmins from calendar where substr(date,1,10) = '\(cdate)'"
        
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return hrs
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            hrs = Int(sqlite3_column_int(stmt1, 0))
        }
        return hrs
    }
    public func gettothr(date: Date) -> String{
        var hrs = ""
        var stmt1:OpaquePointer?
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        let cdate = dateformatter.string(from: date)
        
        let query = "select 'TH ' || tothrs from calendar where substr(date,1,10) = '\(cdate)'"
        
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return hrs
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            hrs = String(cString: sqlite3_column_text(stmt1, 0))
        }
        return hrs
    }
    public func gettotbh(date: Date) -> String{
        //        select cast(substr(tothrs,1,2) as INT) from calendar
        var hrs = ""
        var stmt1:OpaquePointer?
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        let cdate = dateformatter.string(from: date)
        
        let query = "select 'BH ' || billhrs from calendar where substr(date,1,10) = '\(cdate)'"
        
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return hrs
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            hrs = String(cString: sqlite3_column_text(stmt1, 0))
        }
        return hrs
    }
    
    public func gettimediff(date1: Date, date2: Date)-> String{
        var str = ""
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: date1, to: date2)

        // To get the hours
        print("HH --->\(components.hour)")
        // To get the minutes
        print("MM --->\(components.minute)")
        
        str = "\(components.hour!)HH:\(components.minute!)MIN Submission due"
        
        return str
    }
    
    
}

