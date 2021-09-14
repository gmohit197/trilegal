//  EXECUTEAPI.swift
//  Trilegal
//
//  Created by Acxiom Consulting on 27/04/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.
//AAYSUH 14 JUL 2021
import Foundation
import  UIKit
import IQKeyboardManagerSwift
import Alamofire
import SQLite3

public class EXECUTEAPI : DBConnection {
    
    //    {
    //        "Response": {
    //            "status": true,
    //            "code": 100,
    //            "msg": null
    //        },
    //        "Data": [
    //            {
    //                "MatterCode": "DEL/13-14/00764",
    //                "MatterDesc": "HSPL - Arbitration",
    //                "MatterType": false,
    //                "ClientCode": "CUST000000020",
    //                "ClientDesc": "Abu Dhabi National Energy Company PJSC (TAQA)"
    //            }
    //        ]
    //    }
    //    MARK:- POST LOGIN DETAILS
    func postLoginAPI(userid : String , password : String){
        print("url======> \(CONSTANT.base_url+CONSTANT.login_url+userid+"&csPassword="+password)")
        AF.request(CONSTANT.base_url+CONSTANT.login_url+userid+"&csPassword="+password, method: .post).validate().responseJSON {
            response in
            
            switch response.result {
            case .success(let value): print("success======> \(value)")
                
                if let json = value as? [String:Any]{
                      let response = json["Response"] as! [String:Any]
                      let status = response["status"] as! Int

                    if (status == 1){
                        self.VD()
                        let data = json["Data"] as! [String:Any]
                        let name = data["ResourceName"] as! String
                        let employeeId = data["EmployeeId"] as! String
                        UserDefaults.standard.setValue(name, forKey: "name")
                        UserDefaults.standard.setValue(employeeId, forKey: "EmployeeId")
                    }else{
                        let msg = response["msg"] as! String
                        self.INVD(msg: msg)
                    }
                }
                break
            case .failure(let error): print("error======> \(error)")
                print("Error")
                self.INVD(msg: CONSTANT.SERVER_ERR)
                break
            }
        }
    }
    
    public func INVD(msg: String){}
    public func VD(){}
    //    MARK:- GET CLIENT MATTER
    func getClientMatterData(){
        self.deletetable(tbl: "ClientMaster")
        CONSTANT.apicall += 1
        let url = CONSTANT.base_url + CONSTANT.client_matter_url + UserDefaults.standard.string(forKey: "userid")! + "&csPassword=" + UserDefaults.standard.string(forKey: "pwd")!
        AF.request(url, method: .post).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
                print("response --> \(value)")
                if let json = value as? [String:Any]{
                    let response = json["Response"] as! [String:Any]
                    let status = response["status"] as! Int
                    let msg = json["msg"] as? String
                    if (status == 1){
                      if  let data = json["Data"] as? [[String:Any]]
                      {
                        self.deletetable(tbl: "ClientMaster")
                        for obj in data {
                            let MatterCode = obj["MatterCode"]! as! String
                            let MatterDesc = obj["MatterDesc"]! as! String
                            let MatterType = obj["MatterType"]! as! Int
                            let ClientCode = obj["ClientCode"]! as! String
                            let ClientDesc = obj["ClientDesc"]! as! String
                            
                            self.insertclientmaster(MatterCode: MatterCode, MatterDesc: MatterDesc.contains("'") ? MatterDesc.replacingOccurrences(of: "'", with: "''") :  MatterDesc, MatterType: "\(MatterType)", ClientCode: ClientCode, ClientDesc: ClientDesc.contains("'") ? ClientDesc.replacingOccurrences(of: "'", with: "''") :  ClientDesc)
                        }
                      }
                        self.VD()
                    }
                    
                    else{
                        CONSTANT.failapi += 1
                        self.VD()
                    }
                }
                
                break
            case .failure(let error): print("error======> \(error)")
                print("Error")
                CONSTANT.failapi += 1
                self.VD()
                break
            }
        }
    }
    //        acxiom&csPassword=welcome@123
    //    MARK:- GET TS DATES
    func getTSentryData(){
        
        CONSTANT.apicall += 1
        
        let url = CONSTANT.base_url + CONSTANT.tsentry_url + UserDefaults.standard.string(forKey: "userid")! + "&csPassword=" + UserDefaults.standard.string(forKey: "pwd")!
        
        print("url ---> \(url)")
        
        AF.request(url, method: .post).validate().responseJSON {
            response in
            
            switch response.result {
            case .success(let value):
                
                if let json = value as? [String:Any]{
                    let response = json["Response"] as! [String:Any]
                    let status = response["status"] as! Int
                    if (status == 1){
                        let data = json["Data"] as! [String:Any]
                        
                        var startdate = data["StartDate"] as! String
                        print("start date --> \(startdate)")
                        UserDefaults.standard.setValue(startdate, forKey: "startdate")
                        
                        var EndDate = data["EndDate"] as! String
                        print("end date --> \(EndDate)")
                        UserDefaults.standard.setValue(EndDate, forKey: "enddate")
                        
                        var NextLockingDate = data["NextLockingDate"] as! String
                        print("nl date --> \(NextLockingDate)")
                        UserDefaults.standard.setValue(NextLockingDate, forKey: "nldate")
                        
                        self.VD()
                    }else{
                        CONSTANT.failapi += 1
                        self.VD()
                    }
                }
                break
                
            case .failure(let error): print("error======> \(error)")
                print("Error")
                CONSTANT.failapi += 1
                self.VD()
                break
            }
        }
    }
    //      MARK:- GET TS ENTRIES
    public func getmyts(startdate: String, enddate: String,type: Int,isedit: Bool = false){
        let url = CONSTANT.base_url + "GetMyTimesheet"
        
        var body : [String: Any]
        body = [
            "UserId" : UserDefaults.standard.string(forKey: "userid")!,
            "Password" : UserDefaults.standard.string(forKey: "pwd")!,
            "StatusType" : type,
            "FromDate" : startdate,
            "ToDate" : enddate
        ]
        
        print("body --> \(body)")
        
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil, interceptor: .none, requestModifier: .none).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print("data --> \(value)")
                if let json = value as? [String:Any]{
                    let response = json["Response"] as! [String:Any]
                    let status = response["status"] as! Int
                    let msg = response["msg"] as! String
                    if (status == 1 && msg == "Success"){
                        let data = json["Data"] as! [[String:Any]]
                        if (isedit){
                            self.deletetable(tbl: "EditTS")
                        }else{
                            self.deletetable(tbl: "MyTS")
                        }
                        
                        for obj in data{
                            let uid = obj["transationId"] as! String
                            let mattercode = obj["MatterCode"] as! String
                            let mattername = obj["MatterDesc"] as! String
                            let clientcode = obj["ClientCode"] as! String
                            let clientname = obj["ClientDesc"] as! String
                            let isbill = obj["BHDesc"] as! String
                            let isoffcounsel = obj["Offcouncil"] as! Int
                            let narration = obj["Narration"] as! String
                            let hr = obj["hour"] as! Int
                            let mins = obj["minutes"] as! Int
                            let date = obj["WorkDate"] as! String
                            let status = obj["StatusId"] as! Int
                            let rremark = obj["rejectDescription"] as! String
                            
                            var totmins : Int = 0
                            totmins = hr * 60
                            totmins = totmins + mins
                            
                            if (isedit){
                                if ("\(type)" == STATUS.ALL.rawValue){
                                    if ("\(status)" == STATUS.NOT_SUBMITTED.rawValue || "\(status)" == STATUS.REJECTED.rawValue){
                                        self.insert_editts(uid: uid, client: clientcode, matter: mattercode, date: String(date.prefix(10)), hours: "\(hr)", mins: "\(mins)", time: "\(totmins)", isbillable: isbill == "Billable" ? "1" : "0", isoffcounsel: "\(isoffcounsel)", narration: narration, status: "\(status)", post: "2", remark: rremark)
                                    }
                                }else{
                                    self.insert_editts(uid: uid, client: clientcode, matter: mattercode, date: String(date.prefix(10)), hours: "\(hr)", mins: "\(mins)", time: "\(totmins)", isbillable: isbill == "Billable" ? "1" : "0", isoffcounsel: "\(isoffcounsel)", narration: narration, status: "\(status)", post: "2",remark: rremark)
                                }
                            }else{
                                self.insert_myts(uid: uid, client: clientname, matter: mattername, date: String(date.prefix(10)), hours: "\(hr)", mins: "\(mins)", time: "\(totmins)", isbillable: isbill == "Billable" ? "1" : "0", isoffcounsel: "\(isoffcounsel)", narration: narration, status: "\(status)")
                            }
                            
                        }
                        //                        {
                        //                        "transationId": "T001158030",
                        //                        "WorkDate": "2021-04-02T12:00:00",
                        //                        "MatterCode": "PROJ000002296",
                        //                        "MatterDesc": "NCC Contract Advise",
                        //                        "ClientCode": "CUST000000788",
                        //                        "ClientDesc": "OPGCL",
                        //                        "TaskId": "TS031",
                        //                        "EmployeeId": "000937",
                        //                        "EmployeeName": "Arjun Agarwal",
                        //                        "BHId": "BL",
                        //                        "BHDesc": "Billable",
                        //                        "Narration": "PoA Response 1. Discussion with local lawyer on the Hathway CBN legal notices 2. Final changes to the notices including proof reading and formatting 3. Coordination with local lawyer on the courier and email of notices 4. Update email to clients with all details including final executed notices, courier receipts and emails IDBI LETTER 1. Perused the documents in relation to the IDBI letter stopping operation of bank accounts 2. Prepared first draft of the response to the letter and internal discussion with Chitra on the same",
                        //                        "StatusId": 1,
                        //                        "Status": "Submitted",
                        //                        "rejectDescription": "",
                        //                        "NetworkId": "acxiom2",
                        //                        "npgCode": "Disp",
                        //                        "npgSectionId": "Disp",
                        //                        "hour": 4,
                        //                        "minutes": 0,
                        //                        "TotMins": 0,
                        //                        "ToBeInvoice": 0,
                        //                        "IsChargable": "1",
                        //                        "SubmittedDateTime": "2021-04-05T16:38:24",
                        //                        "Offcouncil": false,
                        //                        "ApproverName": "Sitesh Mukherjee"
                        if (isedit){
                            self.mytsdone()
                        }else{
                            self.VD()
                        }
                        
                    }else{
                        self.INVD(msg: msg)
                    }
                }
                break
                
            case .failure(let error): print("error======> \(error)")
                print("Error")
                self.INVD(msg: CONSTANT.SERVER_ERR)
                break
            }
        }
    }
    
    public func mytsdone(){}
    //    MARK:- GET TS HRS DETAILS
    public func getts_forday(date: String){
        let url = CONSTANT.base_url + "GetTSDateSummary?csuserId=\(UserDefaults.standard.string(forKey: "userid")!)&csPassword=\(UserDefaults.standard.string(forKey: "pwd")!)&dtDate=\(date)"
        CONSTANT.apicall += 1
        print("url --> \(url)")
        AF.request(url, method: .post).validate().responseJSON {
            response in
            
            switch response.result {
            case .success(let value):
                print("data --> \(value)")
                if let json = value as? [String:Any]{
                    let response = json["Response"] as! [String:Any]
                    let status = response["status"] as! Int
                    if (status == 1){
                        let data = json["Data"] as! [String:Any]
                        let obj = data
                        let tothrs = obj["TotHours"] as! String
                        let apphrs = obj["AppHours"] as! String
                        let rhrs = obj["RejHours"] as! String
                        let shrs = obj["SubHours"] as! String
                        let nshrs = obj["NSHours"] as! String
                        let totmins = obj["TotMins"] as! Int
                        self.insert_tsdatesum(tothrs: tothrs, apphrs: apphrs, rejhrs: rhrs, subhrs: shrs, nshrs: nshrs, totmin: "\(totmins)")
                        
                        //                        {
                        //                        "TotHours": "03:50",
                        //                        "AppHours": "00:00",
                        //                        "RejHours": "00:00",
                        //                        "SubHours": "01:20",
                        //                        "NSHours": "02:30",
                        //                        "TotMins": 230
                        //                        }
                        
                        self.VD()
                    }else{
                        CONSTANT.failapi += 1
                        self.VD()
                    }
                }
                break
                
            case .failure(let error): print("error======> \(error)")
                print("Error")
                break
            }
        }
    }
    //    MARK:- POST TS
    public func post_ts(type: Int,isedit: Bool = false){
        let url = CONSTANT.base_url + "EditTimeSheet"
        //        {"UserId" : "acxiom2",
        //            "Password":"welcome@123",
        //            "SaveType":0,
        //            "tsEntry":[
        //            {
        //            "TransactionId":"T001158059",
        //            "WorkDate":"2021-05-11",
        //            "MatterId":"DEL/14-15/03/02134",
        //            "Hours":1,
        //            "Minutes":30,
        //            "TotMins":900,
        //            "Narrations":"Backend Update",
        //            "Offcouncil":true,
        //            "TaskId":"TS031",
        //            "npgCode": "Disp",
        //            "npgSectionId": "",
        //            "IsChargable": "0",
        //            "SubmittedDateTime": "1900-01-01T00:00:00"
        //            }
        //            ]
        //        }
        var array : [Any]
        var body : [String: Any]
        var param : [String: Any]
        
        var idarr = [String]()
        var query = ""
        var stmt1:OpaquePointer?
        if (isedit){
            query = "select uid , client , matter , date , hours , mins , time , isbillable , isoffcounsel , narration, status from EditTS where post = '0' and btnstate = '1'"
        }else{
            query = "select uid , client , matter , date , hours , mins , time , isbillable , isoffcounsel , narration, status from TSEentry where post = '0' and status = '1'"
        }        
        
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        idarr.removeAll()
        array = []
        array.removeAll()
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let uid = String(cString: sqlite3_column_text(stmt1, 0))
            let matter = String(cString: sqlite3_column_text(stmt1, 2))
            let date = String(cString: sqlite3_column_text(stmt1, 3))
            let hrs = sqlite3_column_int(stmt1, 4)
            let min = sqlite3_column_int(stmt1, 5)
            let time = sqlite3_column_int(stmt1, 6)
            let isbill = String(cString: sqlite3_column_text(stmt1, 7))
            let isoffc = String(cString: sqlite3_column_text(stmt1, 8))
            let narration = String(cString: sqlite3_column_text(stmt1, 9))
            
            idarr.append(uid)
            
            param = [
                "TransactionId" : uid,
                "WorkDate" : date,
                "MatterId" : matter,
                "Hours" : hrs,
                "Minutes" : min,
                "TotMins" : time,
                "Narrations"  :  narration,
                "Offcouncil" : isoffc == "1" ? true : false,
                "IsChargable" :  isbill,
            ]
            array.append(param)
        }
        
        body = [
            "UserId" : UserDefaults.standard.string(forKey: "userid")!,
            "Password" : UserDefaults.standard.string(forKey: "pwd")!,
            "SaveType" : type,
            "tsEntry" : array as Any
        ]
        print("body----> \(body)")
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil, interceptor: .none, requestModifier: .none).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print("data --> \(value)")
                
                if let json = value as? [String:Any]{
                    let response = json["Response"] as! [String:Any]
                    let status = response["status"] as! Int
                    if (status == 1){
                        //                        let data = json["Data"] as! [[String:Any]]
                        
                        self.tsdone(ids: idarr,type: type)
                    }else{
                        let msg = response["msg"] as! String
                        self.INVD(msg: msg)
                    }
                }
                break
                
            case .failure(let error): print("error======> \(error)")
                print("Error")
                self.INVD(msg: CONSTANT.SERVER_ERR)
                break
            }
        }
    }
    public func tsdone(ids: [String],type: Int = -1){}
    //MARK:- RM CLIENTMATTER

       func getRMClientMatterData(){
        self.deletetable(tbl: "GetRMClientMatter")
           CONSTANT.apicall += 1
           
           let url = CONSTANT.base_url + CONSTANT.rem_client_matter_url + UserDefaults.standard.string(forKey: "userid")! + "&csPassword=" + UserDefaults.standard.string(forKey: "pwd")!
           AF.request(url, method: .post).validate().responseJSON {
               response in
               switch response.result {
               case .success(let value):
                   print("response --> \(value)")
                   if let json = value as? [String:Any]{
                       let response = json["Response"] as! [String:Any]
                       let status = response["status"] as! Int
                       if (status == 1){
                        if let data = json["Data"] as? [[String:Any]]{
                           self.deletetable(tbl: "GetRMClientMatter")
                           for obj in data {
                               let MatterCode = obj["MatterCode"]! as! String
                               let MatterDesc = obj["MatterDesc"]! as! String
                               let MatterType = obj["MatterType"]! as! Int
                               let ClientCode = obj["ClientCode"]! as! String
                               let ClientDesc = obj["ClientDesc"]! as! String
                               
                            self.insertRemClientMatter(MatterCode: MatterCode, MatterDesc: MatterDesc.replacingOccurrences(of: "'", with: ""), MatterType: "\(MatterType)", ClientCode: ClientCode, ClientDesc: ClientDesc.replacingOccurrences(of: "'", with: ""))
                            }
                           }
                           self.insertionCompleted()
                           self.VD()
                       }else{
                           self.insertionCompleted()
                           CONSTANT.failapi += 1
                           self.VD()
                       }
                   }
                   break
               case .failure(let error):
                   print("error======> \(error)")
                   print("Error")
                   self.insertionCompleted()
                   CONSTANT.failapi += 1
                   self.VD()
                   break
               }
           }
       }
       
       //MARK:- RM EXPENSECATG

       func getRMExpenseCatgData(){
        self.deletetable(tbl: "GetRMExpenseCatg")
           CONSTANT.apicall += 1
           
           let url = CONSTANT.base_url + CONSTANT.rem_exp_catg_url + UserDefaults.standard.string(forKey: "userid")! + "&csPassword=" + UserDefaults.standard.string(forKey: "pwd")!
           AF.request(url, method: .post).validate().responseJSON {
               response in
               
               switch response.result {
               case .success(let value):
                   print("response --> \(value)")
                   if let json = value as? [String:Any]{
                       let response = json["Response"] as! [String:Any]
                       let status = response["status"] as! Int
                       if (status == 1){
                           let data = json["Data"] as! [[String:Any]]
                           self.deletetable(tbl: "GetRMExpenseCatg")
                           for obj in data {
                               let projCategoryId = obj["projCategoryId"]! as! String
                            let projCategoryName = obj["projCategoryName"]! as! String
                            self.insertRemExpenseCatg(projCategoryId: projCategoryId, projCategoryName: projCategoryName.replacingOccurrences(of: "'", with: ""))
                           }
                           self.VD()
                       }else{
                           CONSTANT.failapi += 1
                           self.VD()
                       }
                   }

                   break
               case .failure(let error): print("error======> \(error)")
                   print("Error")
                   CONSTANT.failapi += 1
                   self.VD()
                   break
               }
           }
       }
       
       //MARK:- RM CORPCARDDATA
       func getRMCorpCardData(){
        self.deletetable(tbl: "GetRemCorpCardTypeData")
           CONSTANT.apicall += 1
           let url = CONSTANT.base_url + CONSTANT.rem_corp_card_url + UserDefaults.standard.string(forKey: "userid")! + "&csPassword=" + UserDefaults.standard.string(forKey: "pwd")!
           AF.request(url, method: .post).validate().responseJSON {
               response in
               
               switch response.result {
               case .success(let value):
                   print("response --> \(value)")
                   if let json = value as? [String:Any]{
                       let response = json["Response"] as! [String:Any]
                       let status = response["status"] as! Int
                       if (status == 1){
                           let data = json["Data"] as! [[String:Any]]
                           self.deletetable(tbl: "GetRemCorpCardTypeData")
                           for obj in data {
                               let CardId = obj["CardId"]! as! String
                               let Description = obj["Description"]! as! String
                               self.insertRemCorpCardData(CardId: CardId, Description: Description)
                           }
                           self.VD()
                       }else{
                           CONSTANT.failapi += 1
                           self.VD()
                       }
                   }

                   break
               case .failure(let error): print("error======> \(error)")
                   print("Error")
                   CONSTANT.failapi += 1
                   self.VD()
                   break
               }
           }
       }
       //MARK:- RM COSTCENTERDATA
       func getRMCostCenterData(){
        self.deletetable(tbl: "GetRemCostCenterData")
           CONSTANT.apicall += 1
           let url = CONSTANT.base_url + CONSTANT.rem_cost_center_url + UserDefaults.standard.string(forKey: "userid")! + "&csPassword=" + UserDefaults.standard.string(forKey: "pwd")!
           AF.request(url, method: .post).validate().responseJSON {
               response in
               
               switch response.result {
               case .success(let value):
                   print("response --> \(value)")
                   if let json = value as? [String:Any]{
                       let response = json["Response"] as! [String:Any]
                       let status = response["status"] as! Int
                       if (status == 1){
                           let data = json["Data"] as! [[String:Any]]
                           self.deletetable(tbl: "GetRemCostCenterData")
                           for obj in data {
                               let CodeName = obj["Code"]! as! String
                               let Name = obj["Name"]! as! String
                               self.insertRemCostCenterData(CodeName: CodeName, Name: Name)
                           }
                           self.VD()
                       }else{
                           CONSTANT.failapi += 1
                           self.VD()
                       }
                   }

                   break
               case .failure(let error): print("error======> \(error)")
                   print("Error")
                   CONSTANT.failapi += 1
                   self.VD()
                   break
               }
           }
       }
       
    
    //    MARK:- GET REVIEW TS
    public func getreviewts(){
        let url = CONSTANT.base_url + "GetApprovalTimesheet"
        
        var body : [String: Any]
        body = [
            "UserId" : UserDefaults.standard.string(forKey: "userid")!,
            "Password" : UserDefaults.standard.string(forKey: "pwd")!
        ]
        
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil, interceptor: .none, requestModifier: .none).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print("data --> \(value)")
                if let json = value as? [String:Any]{
                    let response = json["Response"] as! [String:Any]
                    let status = response["status"] as! Int
                    let msg = response["msg"] as! String
                    if (status == 1 && msg == "Success"){
                        let data = json["Data"] as! [[String:Any]]
                        
                        self.deletetable(tbl: "EditTS")
                        
                        for obj in data{
                            let uid = obj["transationId"] as! String
                            let mattercode = obj["MatterCode"] as! String
                            let mattername = obj["MatterDesc"] as! String
                            let clientcode = obj["ClientCode"] as! String
                            let clientname = obj["ClientDesc"] as! String
                            let isbill = obj["BHDesc"] as! String
                            let isoffcounsel = obj["Offcouncil"] as! Int
                            let narration = obj["Narration"] as! String
                            let hr = obj["hour"] as! Int
                            let mins = obj["minutes"] as! Int
                            let date = obj["WorkDate"] as! String
                            let status = obj["StatusId"] as! Int
                            let empname = obj["EmployeeName"] as! String
                            
                            var totmins : Int = 0
                            totmins = hr * 60
                            totmins = totmins + mins
                            
                            self.insert_editts(uid: uid, client: clientname, matter: mattername, date: String(date.prefix(10)), hours: "\(hr)", mins: "\(mins)", time: "\(totmins)", isbillable: isbill == "Billable" ? "1" : "0", isoffcounsel: "\(isoffcounsel)", narration: narration, status: "\(status)", post: "2", empname: empname)
                            
                        }
                        //                        {
                        //                        "transationId": "T001158038",
                        //                        "WorkDate": "2021-04-06T12:00:00",
                        //                        "MatterCode": "DEL/15-16/02/03573",
                        //                        "MatterDesc": "OERC Tariff Petition",
                        //                        "ClientCode": "CUST000000788",
                        //                        "ClientDesc": "OPGCL",
                        //                        "TaskId": "TS031",
                        //                        "EmployeeId": "000937",
                        //                        "EmployeeName": "Arjun Agarwal",
                        //                        "BHId": "BL",
                        //                        "BHDesc": "Billable",
                        //                        "Narration": "uhfiuewho",
                        //                        "StatusId": 1,
                        //                        "Status": "Submitted",
                        //                        "rejectDescription": "",
                        //                        "NetworkId": "Acxiom2",
                        //                        "npgCode": "Disp",
                        //                        "npgSectionId": "Disp",
                        //                        "hour": 3,
                        //                        "minutes": 0,
                        //                        "ToBeInvoice": 0,
                        //                        "IsChargable": "1",
                        //                        "SubmittedDateTime": "2021-04-06T12:05:18",
                        //                        "Offcouncil": false,
                        //                        "ApproverName": "Shankh Sengupta"
                        //                    },
                        
                        self.VD()
                    }else{
                        self.INVD(msg: msg)
                    }
                }
                break
                
            case .failure(let error): print("error======> \(error)")
                print("Error")
                self.INVD(msg: CONSTANT.SERVER_ERR)
                break
            }
        }
    }
    //    MARK:- POST REVIEW TS
    public func postapprovets(){
        let url = CONSTANT.base_url + "ApproveTimeSheet"
        
        var body : [String: Any]
        body = [
            "UserId" : UserDefaults.standard.string(forKey: "userid")!,
            "Password" : UserDefaults.standard.string(forKey: "pwd")!,
            "EmployeeId" : UserDefaults.standard.string(forKey: "EmployeeId")!,
            "tsRequest" : self.gettsappr_request()
        ]
        
        print("\n url --> \(url)\n body ==> \(body)")
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil, interceptor: .none, requestModifier: .none).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print("data --> \(value)")
                if let json = value as? [String:Any]{
                    let response = json["Response"] as! [String:Any]
                    let status = response["status"] as! Int
                    if (status == 1){
                        self.reviewdone()
                    }
                    else{
                        let msg = response["msg"] as! String
                        self.INVD(msg: msg)
                    }
                }else{
                    self.INVD(msg: CONSTANT.API_ERR)
                }
                break
                
            case .failure(let error): print("error======> \(error)")
                print("Error")
                self.INVD(msg: CONSTANT.SERVER_ERR)
                break
            }
        }
    }
    
    func gettsappr_request()->[Any]{
        
        var param : [String:Any]
        var array : [Any] = []
        
        var stmt1:OpaquePointer?
        array.removeAll()
        let query = "select uid from EditTS where btnstate = '1' and post = '0'"
        
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return array
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let str = String(cString: sqlite3_column_text(stmt1, 0))
            param = [
                "TransactionId" : str
            ]
            array.append(param)
        }
        
        return array
        
    }
    //    MARK:- POST REJECT TS
    public func postrejectts(remarks: String, trid: String){
        let url = CONSTANT.base_url + "RejectTimeSheet"
        
        var body : [String: Any]
        
        var param : [String : Any]
        var array : [Any] = []
        array.removeAll()
        param = [
            "TransactionId" : trid,
            "RejectRemarks" : remarks
        ]
        array.append(param)
        body = [
            "UserId" : UserDefaults.standard.string(forKey: "userid")!,
            "Password" : UserDefaults.standard.string(forKey: "pwd")!,
            "EmployeeId" : UserDefaults.standard.string(forKey: "EmployeeId")!,
            "tsRequest" : array
        ]
       
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil, interceptor: .none, requestModifier: .none).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print("data --> \(value)")
                if let json = value as? [String:Any]{
                    let response = json["Response"] as! [String:Any]
                    let status = response["status"] as! Int
                    if (status == 1){
                        self.reviewdone()
                    }
                    else{
                        let msg = response["msg"] as! String
                        self.INVD(msg: msg)
                    }
                }else{
                    self.INVD(msg: CONSTANT.API_ERR)
                }
                break
                
            case .failure(let error): print("error======> \(error)")
                print("Error")
                self.INVD(msg: CONSTANT.SERVER_ERR)
                break
            }
        }
    }
    
    public func reviewdone(){
        
    }
//    MARK:- Calendar
    public func getcalendar(date: String){
        let url = CONSTANT.base_url + "GetMyCalendar"
        
        var param : [String : Any]
      
        param = [
            "UserId" : UserDefaults.standard.string(forKey: "userid")!,
            "Password" : UserDefaults.standard.string(forKey: "pwd")!,
            "FromDate" : date
        ]
        
//        {
//
//        "UserId":"acxiom2",
//
//        "Password":"welcome@123",
//
//        "FromDate":"2021-05-11"
//
//        }
        
//        "CalendarDate": "2021-04-27T12:00:00",
//        "CalendarDayStatus": 0,
//        "TotMins": 0,
//        "BillMins": 0,
//        "BillHours": "00:00",
//        "TotHours": "00:00"
        print("bosy --> \(param)")
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil, interceptor: .none, requestModifier: .none).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print("data --> \(value)")
                if let json = value as? [String:Any]{
                    let response = json["Response"] as! [String:Any]
                    let status = response["status"] as! Int
//                    {
//                        code = 302;
//                        msg = "";
//                        status = 0;
//                    };
                    if (status == 1){
                        let data = json["Data"] as! [[String:Any]]
                        self.deletetable(tbl: "calendar")
                        for obj in data {
                            let date = obj["CalendarDate"]! as! String
                            let status = obj["CalendarDayStatus"]! as! Int
                            let totmins = obj["TotMins"]! as! Int
                            let billmins = obj["BillMins"]! as! Int
                            let billhrs = "\(obj["BillHours"]!)" == "<null>" ? "00:00" : "\(obj["BillHours"]!)"
                            let tothrs = "\(obj["TotHours"]!)" == "<null>" ? "00:00" : "\(obj["TotHours"]!)"
                            
                            self.insertcalendar(date: date, status: "\(status)", totmins: "\(totmins)", billmins: "\(billmins)", billhrs: billhrs, tothrs: tothrs)
                        }
                        self.gotcalndar()
                    }
                    else{
                        let msg = response["msg"] as! String
                        self.INVD(msg: msg)
                    }
                }else{
                    self.INVD(msg: CONSTANT.API_ERR)
                }
                break
                
            case .failure(let error): print("error======> \(error)")
                print("Error")
                self.INVD(msg: CONSTANT.SERVER_ERR)
                break
            }
        }
    }
    public func gotcalndar(){}
    
    
    //      MARK:- GET My Reimbursement
    public func getmyReimbursement(startdate: String, enddate: String,type: Int,isReloadClick : Bool){
     self.deletetable(tbl: "ReimbursementMaster")
            let url = CONSTANT.base_url + "GetReimbursement"
            var body : [String: Any]
            body = [
                "UserId" : UserDefaults.standard.string(forKey: "userid")!,
                "Password" : UserDefaults.standard.string(forKey: "pwd")!,
                "StatusType" : type,
                "FromDate" : startdate,
                "ToDate" : enddate,
                "EmployeeId" : UserDefaults.standard.string(forKey: "EmployeeId")!
            ]
            AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil, interceptor: .none, requestModifier: .none).validate().responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    print("data --> \(value)")
                    if let json = value as? [String:Any]{
                        let response = json["Response"] as! [String:Any]
                        let status = response["status"] as! Int
                         let msg = response["msg"] as! String
                     if ((status == 1) && !(msg == "No records found!!!")){
                       let data = json["Data"] as! [[String:Any]]
                            self.deletetable(tbl: "ReimbursementMaster")
                            for obj in data{
                                let ExpenseNumber = obj["ExpenseNumber"] as! String
                                let TransactionId = obj["TransactionId"] as! String
                                let TransDate = obj["TransDate"] as! String
                                let ProjId = obj["ProjId"] as! String
                                let ProjectName = obj["ProjectName"] as! String
                                let ClientId = obj["ClientId"] as! String
                                let ClientName = obj["ClientName"] as! String
                                let CategoryId = obj["CategoryId"] as! String
                                let CategotyName = obj["CategotyName"] as! String
                                let CardId = obj["CardId"] as! String
                                let CardName = obj["CardName"] as! String
                                let DimensionCostCenter = obj["DimensionCostCenter"] as! String
                                let CostCenterName = obj["CostCenterName"] as! String
                                let ReimbursementAmount = obj["ReimbursementAmount"] as! Double
                                let ClaimAmount = obj["ClaimAmount"] as! Double
                                let Remarks = obj["Remarks"] as! String
                                let PaymentType = obj["PaymentType"] as! String
                                let ClientOffice = obj["ClientOffice"] as! String
                                let AttachmentPath = obj["AttachmentPath"] as! String
                                let userName = obj["userName"] as! String
                                let WorkerId = obj["WorkerId"] as! String
                                let ResourceName = obj["ResourceName"] as! String
                                let StatusId = obj["StatusId"] as! Int
                                let Status = obj["Status"] as! String
                                let RejectedRemarks = obj["RejectedRemarks"] as! String
                                let post = "0"
                                let checkbox = "0"
                                let debitto = obj["ClientOffice"] as! String
                                var isAttachmentStr = ""
                                var debittoStr = ""
                                var exten = ""
                                if(debitto ==  "0"){
                                    debittoStr = "Client"
                                }
                                else{
                                    debittoStr = "Office"
                                }
                                if(AttachmentPath.isEmpty){
                                    isAttachmentStr = "0"
                                    exten = ""
                                }
                                else{
                                    isAttachmentStr = "1"
                                    exten = "1"
                                }
                                self.insertReimbursementMaster(ExpenseNumber: ExpenseNumber, TransactionId: TransactionId, TransDate: String(TransDate.prefix(10)), ProjId: ProjId, ProjectName: ProjectName, ClientId: ClientId, ClientName: ClientName, CategoryId: CategoryId, CategotyName: CategotyName, CardId: CardId, CardName: CardName, DimensionCostCenter: DimensionCostCenter, CostCenterName: CostCenterName, ReimbursementAmount: String(ReimbursementAmount), ClaimAmount: String(ClaimAmount), Remarks: Remarks, PaymentType: PaymentType, ClientOffice: ClientOffice, AttachmentPath: AttachmentPath, userName: userName, WorkerId: WorkerId, ResourceName: ResourceName, StatusId: String(StatusId), Status: Status, RejectedRemarks: RejectedRemarks, post: String(post), checkbox: checkbox, debitto: debittoStr, isattachment: isAttachmentStr, extensionStr: exten)
                            }
                            if(isReloadClick){
                                self.VD1()
                            }
                            else{
                                self.VD()
                            }
                        }else{
                            let msg = response["msg"] as! String
                            self.INVD(msg: msg)
                        }
                    }
                    break
                case .failure(let error): print("error======> \(error)")
                    print("Error")
                    self.INVD(msg: CONSTANT.SERVER_ERR)
                    break
                }
            }
        }
    public func VD1(){
    }
 
 public func post_Rem(type: Int,isedit: Bool ){
    var transId : String = ""
     let url = CONSTANT.base_url + "SaveReimbursement"
     var array : [Any]
     var body : [String: Any]
     var param : [String: Any]
     
     var idarr = [String]()
     var query = ""
     var stmt1:OpaquePointer?
     
     if (isedit){
         query = "select TransactionId, TransDate,ExpenseNumber,ProjId,ClientId,CategoryId,CardId,DimensionCostCenter,ClaimAmount,Remarks,PaymentType,debitto,isattachment,ResourceName,StatusId,RejectedRemarks from ReimbursementMaster where post='0' and checkbox = '1' "
     }else{
         query = "select id, date,expensenumber,projid,clientid,catgid,cardid,costcode,amount,remark,paymentType,debitTo,attachment,payto,statusId,rejectremark from ReimbursementEntry where post='0' and checkbox = '1' "
     }

     if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
         let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
         print("error preparing get: \(errmsg)")
         return
     }
     idarr.removeAll()
     array = []
     array.removeAll()
     while(sqlite3_step(stmt1) == SQLITE_ROW){
         let uid = String(cString: sqlite3_column_text(stmt1, 0))
         let TransDate = String(cString: sqlite3_column_text(stmt1, 1))
         let ExpenseNumber = String(cString: sqlite3_column_text(stmt1, 2))
         let ProjId = String(cString: sqlite3_column_text(stmt1, 3))
         let ClientId = String(cString: sqlite3_column_text(stmt1, 4))
         let CategoryId = String(cString: sqlite3_column_text(stmt1, 5))
         let CardId = String(cString: sqlite3_column_text(stmt1, 6))
         let DimensionCostCenter = String(cString: sqlite3_column_text(stmt1, 7))
         let ReimbursementAmount = String(cString: sqlite3_column_text(stmt1, 8))
         let ClaimAmount = String(cString: sqlite3_column_text(stmt1, 8))
         let Remarks = String(cString: sqlite3_column_text(stmt1, 9))
         let PaymentType = String(cString: sqlite3_column_text(stmt1, 10))
         let ClientOffice = String(cString: sqlite3_column_text(stmt1, 11))
         let IsAttachment =  sqlite3_column_int(stmt1, 12)
         let userName = UserDefaults.standard.string(forKey: "userid")!
         let WorkerId = UserDefaults.standard.string(forKey: "EmployeeId")!
         let ResourceName = String(cString: sqlite3_column_text(stmt1, 13))
         let StatusId = sqlite3_column_int(stmt1, 14)
         let RejectedRemarks = String(cString: sqlite3_column_text(stmt1, 15))
        
         if(isedit){
              idarr.append(ExpenseNumber)
              transId = uid
         }
         else{
             idarr.append(uid)
             transId = ""
         }
          
         param = [
             "TransactionId" : transId,
             "TransDate" : TransDate,
             "ExpenseNumber" : ExpenseNumber,
             "ProjId" : ProjId,
             "ClientId" : ClientId,
             "CategoryId"  :  CategoryId,
             "CardId" : CardId,
             "DimensionCostCenter" :  DimensionCostCenter,
             "ReimbursementAmount" : ReimbursementAmount,
             "ClaimAmount" : ClaimAmount,
             "Remarks" : Remarks,
             "PaymentType" : PaymentType,
             "ClientOffice" : ClientOffice,
             "IsAttachment"  :  IsAttachment,
             "userName" : userName,
             "WorkerId" :  WorkerId,
             "ResourceName" : ResourceName,
             "StatusId"  :  StatusId,
             "RejectedRemarks" : RejectedRemarks,
            "FileArray" : getFiledetails(Id: uid, Expensenumber: ExpenseNumber, isEditbool: isedit) as [AnyObject],
         ]
         array.append(param)
     }
     
     body = [
         "UserId" : UserDefaults.standard.string(forKey: "userid")!,
         "Password" : UserDefaults.standard.string(forKey: "pwd")!,
         "SaveType" : type,
         "ReimEntryLst" : array as Any
     ]
     print("body----> \(body)")
     AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil, interceptor: .none, requestModifier: .none).validate().responseJSON { (response) in
         switch response.result {
         case .success(let value):
             print("data --> \(value)")

             if let json = value as? [String:Any]{
                 let response = json["Response"] as! [String:Any]
                 let status = response["status"] as! Int
                 if (status == 1){
                     self.remPostDone(ids: idarr,type: type)
                 }else{
                     let msg = response["msg"] as! String
                     self.INVD(msg: msg)
                 }
             }
             break
             
         case .failure(let error): print("error======> \(error)")
             print("Error")
             self.INVD(msg: CONSTANT.SERVER_ERR)
             break
         }
     }
 }
 public func remPostDone(ids: [String],type: Int = -1){}
 
    func getFiledetails(Id : String , Expensenumber : String, isEditbool : Bool) -> [AnyObject] {
        var IdStr: String
        if(isEditbool) {
            IdStr = Expensenumber
        }
        else{
            IdStr = Id
        }
        var skuarray: [AnyObject] = []
        var skuparameters: [String: AnyObject] = [:]

        skuarray.removeAll()
        var stmt1:OpaquePointer?
        let query = "select fileStr,extension from AttachmentFileDetails where post = '0' and  id = '\(IdStr)'"
        
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return skuarray
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let fileStr = String(cString: sqlite3_column_text(stmt1, 0))
            let extensionStr = String(cString: sqlite3_column_text(stmt1, 1))
            skuparameters = [
                "FileData": fileStr as AnyObject,
                "FileExt": extensionStr as AnyObject,
            ]
            skuarray.append(skuparameters as AnyObject)
        }
        return skuarray
    }

 //      MARK:- GET REVIEW REIMBURSEMENT
 public func getreviewReimbursement(){
         let url = CONSTANT.base_url + "GetApprovalReimbursement"
         var body : [String: Any]
         body = [
             "UserId" : UserDefaults.standard.string(forKey: "userid")!,
             "Password" : UserDefaults.standard.string(forKey: "pwd")!,
             "EmployeeId" : UserDefaults.standard.string(forKey: "EmployeeId")!
         ]
         AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil, interceptor: .none, requestModifier: .none).validate().responseJSON { (response) in
             switch response.result {
             case .success(let value):
                 print("data --> \(value)")
                 if let json = value as? [String:Any]{
                     let response = json["Response"] as! [String:Any]
                     let status = response["status"] as! Int
                     let msg = response["msg"] as! String
                     if ((status == 1) && !(msg == "No records found!!!")){
                         let data = json["Data"] as! [[String:Any]]
                         self.deletetable(tbl: "ReimbursementMaster")
                         for obj in data{
                             let ExpenseNumber = obj["ExpenseNumber"] as! String
                             let TransactionId = obj["TransactionId"] as! String
                             let TransDate = obj["TransDate"] as! String
                             let ProjId = obj["ProjId"] as! String
                             let ProjectName = obj["ProjectName"] as! String
                             let ClientId = obj["ClientId"] as! String
                             let ClientName = obj["ClientName"] as! String
                             let CategoryId = obj["CategoryId"] as! String
                             let CategotyName = obj["CategotyName"] as! String
                             let CardId = obj["CardId"] as! String
                             let CardName = obj["CardName"] as! String
                             let DimensionCostCenter = obj["DimensionCostCenter"] as! String
                             let CostCenterName = obj["CostCenterName"] as! String
                             let ReimbursementAmount = obj["ReimbursementAmount"] as! Double
                             
                             let ClaimAmount = obj["ClaimAmount"] as! Double
                             let Remarks = obj["Remarks"] as! String
                             let PaymentType = obj["PaymentType"] as! String
                             let ClientOffice = obj["ClientOffice"] as! String
                             let AttachmentPath = obj["AttachmentPath"] as! String
                             let userName = obj["userName"] as! String
                             let WorkerId = obj["WorkerId"] as! String
                             let ResourceName = obj["ResourceName"] as! String
                             let StatusId = obj["StatusId"] as! Int
                             let Status = obj["Status"] as! String
                             let RejectedRemarks = obj["RejectedRemarks"] as! String
                             let post = "0"
                             let checkbox = "0"
                             let debitto = obj["ClientOffice"] as! String
                             var isAttachmentStr = ""
                             var debittoStr = ""
                             var exten = ""
                             if(debitto ==  "0"){
                                 debittoStr = "Client"
                             }
                             else{
                                 debittoStr = "Office"
                             }
                             if(AttachmentPath.isEmpty){
                                 isAttachmentStr = "0"
                                 exten = ""
                             }
                             else{
                                 isAttachmentStr = "1"
                                 exten = "1"
                             }
                             
                             self.insertReimbursementMaster(ExpenseNumber: ExpenseNumber, TransactionId: TransactionId, TransDate: String(TransDate.prefix(10)), ProjId: ProjId, ProjectName: ProjectName, ClientId: ClientId, ClientName: ClientName, CategoryId: CategoryId, CategotyName: self.getExpenseNameRem(str: CategoryId), CardId: CardId, CardName: CardName, DimensionCostCenter: DimensionCostCenter, CostCenterName: self.getCostCenterNameRem(str: DimensionCostCenter), ReimbursementAmount: String(ReimbursementAmount), ClaimAmount: String(ClaimAmount), Remarks: Remarks, PaymentType: PaymentType, ClientOffice: ClientOffice, AttachmentPath: AttachmentPath, userName: userName, WorkerId: WorkerId, ResourceName: ResourceName, StatusId: String(StatusId), Status: Status, RejectedRemarks: RejectedRemarks, post: String(post), checkbox: checkbox, debitto: debittoStr, isattachment: isAttachmentStr, extensionStr: exten)
                         }
                             self.VD()
                     }else{
                         let msg = response["msg"] as! String
                         self.INVD(msg: msg)
                     }
                 }
                 break
                 
             case .failure(let error): print("error======> \(error)")
                 print("Error")
                 self.INVD(msg: CONSTANT.SERVER_ERR)
                 break
             }
         }
     }
 public func post_Rem_Delete(expenseNo: String){
     let url = CONSTANT.base_url + "DeleteReimbursement"
     var array : [Any]
     var body : [String: Any]
     var param : [String: Any]
     
     array = []
     array.removeAll()
         param = [
             "ExpenseNumber" : expenseNo,
         ]
         array.append(param)

     body = [
         "UserId" : UserDefaults.standard.string(forKey: "userid")!,
         "Password" : UserDefaults.standard.string(forKey: "pwd")!,
         "EmployeeId" : UserDefaults.standard.string(forKey: "EmployeeId")!,
         "ReimRequest" : array as AnyObject,
     ]
     print("body----> \(body)")
     AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil, interceptor: .none, requestModifier: .none).validate().responseJSON { (response) in
         switch response.result {
         case .success(let value):
             print("data --> \(value)")
             if let json = value as? [String:Any]{
                 let response = json["Response"] as! [String:Any]
                 let status = response["status"] as! Int
                 if (status == 1){
                     self.remPostDoneDelete(expenseNo: expenseNo)
                 }else{
                     let msg = response["msg"] as! String
                     self.INVD(msg: msg)
                 }
             }
             break
             
         case .failure(let error): print("error======> \(error)")
             print("Error")
             self.INVD(msg: CONSTANT.SERVER_ERR)
             break
         }
     }
 }
 public func remPostDoneDelete(expenseNo: String){}

 //    MARK:- POST REJECT TS
 public func postrejectRe(remarks: String, trid: String){
     let url = CONSTANT.base_url + "RejectReimbursement"
     var body : [String: Any]
     var param : [String : Any]
     var array : [Any] = []
     array.removeAll()
     param = [
         "TransactionId" : trid,
         "RejectRemarks" : remarks
     ]
     array.append(param)
     body = [
         "UserId" : UserDefaults.standard.string(forKey: "userid")!,
         "Password" : UserDefaults.standard.string(forKey: "pwd")!,
         "EmployeeId" : UserDefaults.standard.string(forKey: "EmployeeId")!,
         "tsRequest" : array
     ]
     AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil, interceptor: .none, requestModifier: .none).validate().responseJSON { (response) in
         switch response.result {
         case .success(let value):
             print("data --> \(value)")
             if let json = value as? [String:Any]{
                 let response = json["Response"] as! [String:Any]
                 let status = response["status"] as! Int
                 if (status == 1){
                     self.reviewdoneRem()
                 }
                 else{
                     let msg = response["msg"] as! String
                     self.INVD(msg: msg)
                 }
             }else{
                 self.INVD(msg: CONSTANT.API_ERR)
             }
             break
         case .failure(let error): print("error======> \(error)")
             print("Error")
             self.INVD(msg: CONSTANT.SERVER_ERR)
             break
         }
     }
 }
 
 public func reviewdoneRem(){
     
 }
 //    MARK:- POST REVIEW TS
 public func postapproveRe(){
     let url = CONSTANT.base_url + "ApproveReimbursement"
     
     var body : [String: Any]
     body = [
         "UserId" : UserDefaults.standard.string(forKey: "userid")!,
         "Password" : UserDefaults.standard.string(forKey: "pwd")!,
         "EmployeeId" : UserDefaults.standard.string(forKey: "EmployeeId")!,
         "tsRequest" : self.getreappr_request()
     ]
     print("\n url --> \(url)\n body ==> \(body)")
     AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil, interceptor: .none, requestModifier: .none).validate().responseJSON { (response) in
         switch response.result {
         case .success(let value):
             print("data --> \(value)")
             if let json = value as? [String:Any]{
                 let response = json["Response"] as! [String:Any]
                 let status = response["status"] as! Int
                 if (status == 1){
                     self.reviewdoneRem()
                 }
                 else{
                     let msg = response["msg"] as! String
                     self.INVD(msg: msg)
                 }
             }else{
                 self.INVD(msg: CONSTANT.API_ERR)
             }
             break
             
         case .failure(let error): print("error======> \(error)")
             print("Error")
             self.INVD(msg: CONSTANT.SERVER_ERR)
             break
         }
     }
 }
 
 func getreappr_request()->[Any]{
     var param : [String:Any]
     var array : [Any] = []
     var stmt1:OpaquePointer?
     array.removeAll()
     let query = "select TransactionId from ReimbursementMaster where checkbox = '1' and post = '0'"
     if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
         let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
         print("error preparing get: \(errmsg)")
         return array
     }
     while(sqlite3_step(stmt1) == SQLITE_ROW){
         let str = String(cString: sqlite3_column_text(stmt1, 0))
         param = [
             "TransactionId" : str
         ]
         array.append(param)
     }
     return array
 }
    
}

