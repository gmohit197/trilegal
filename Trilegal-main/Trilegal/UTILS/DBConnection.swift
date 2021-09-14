//
//  DBConnection.swift
//  Trilegal
//
//  Created by Acxiom Consulting on 13/06/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.
//

import Foundation
import SQLite3
import UIKit

public class DBConnection: UIViewController {
    public static var dbs: OpaquePointer?
    
    public static func createdatabase (){
        
        let fileUrl = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("TrilegalDB.sqlite")
        
        if sqlite3_open(fileUrl.path, &DBConnection.dbs) != SQLITE_OK{
            print("Error in opening Database")
            return
        }
        print("database created")
        print("path======> (\(fileUrl))")
        
        let CREATE_TABLE_ClientMaster = "CREATE TABLE IF NOT EXISTS ClientMaster(MatterCode text,MatterDesc text, MatterType text, ClientCode text, ClientDesc text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_ClientMaster, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - ClientMaster")
            return
        }
        let CREATE_TABLE_TSEentry = "CREATE TABLE IF NOT EXISTS TSEentry(uid text, client text, matter text, date text,hours text, mins text, time text, isbillable text, isoffcounsel text, narration text ,status text, post text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_TSEentry, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - TSEentry")
            return
        }
        let CREATE_TABLE_TSdatesum = "CREATE TABLE IF NOT EXISTS TSdatesum(tothrs text, apphrs text, rejhrs text, subhrs text, nshrs text, totmin text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_TSdatesum, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - TSdatesum")
            return
        }
        let CREATE_TABLE_myTS = "CREATE TABLE IF NOT EXISTS MyTS(uid text, client text, matter text, date text,hours text, mins text, time text, isbillable text, isoffcounsel text, narration text ,status text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_myTS, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - MyTS")
            return
        }
        let CREATE_TABLE_EditMyTimesheet = "create table if not exists EditTS(uid text, client text, matter text, date text,hours text, mins text, time text, isbillable text, isoffcounsel text, narration text ,status text, btnstate text,empname text,remark text ,post text)"
         
        if sqlite3_exec(dbs, CREATE_TABLE_EditMyTimesheet, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - EditTS")
            return
        }
        let CREATE_TABLE_GetRMClientMatter = "create table if not exists  GetRMClientMatter(MatterCode text,MatterDesc text,MatterType text,ClientCode text,ClientDesc text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_GetRMClientMatter, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - GetRMClientMatter")
            return
        }
        
        let CREATE_TABLE_GetRMExpenseCatg = "create table if not exists  GetRMExpenseCatg(projCategoryId text,projCategoryName text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_GetRMExpenseCatg, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - GetRMExpenseCatg")
            return
        }
        
        let CREATE_TABLE_GetRemCorpCardTypeData = "create table if not exists  GetRemCorpCardTypeData(CardId text,Description text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_GetRemCorpCardTypeData, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - GetRemCorpCardTypeData")
            return
        }
        
        let CREATE_TABLE_GetRemCostCenterData = "create table if not exists  GetRemCostCenterData(CodeName text,Name text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_GetRemCostCenterData, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - GetRemCostCenterData")
            return
        }
        
        
        let CREATE_TABLE_ReimbursementEntry = "create table if not exists ReimbursementEntry(id text,date text,payto text,debitTo text,attachment text,choosefile text,paymentType text,corporateCard text,client text,matter text,expenseCategory text,remark text,amount text,costCenter text,post text,checkbox text,expensenumber text,projid text,clientid text,catgid text,cardid text,statusId text,rejectremark text,extensionStr text,costcode text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_ReimbursementEntry, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - ReimbursementEntry")
            return
        }
        
        let CREATE_TABLE_ReimbursementMaster = "create table if not exists  ReimbursementMaster (ExpenseNumber text, TransactionId text,TransDate text,ProjId text,ProjectName text,ClientId  text,ClientName  text,CategoryId text,CategotyName text,CardId text,CardName text,DimensionCostCenter text,CostCenterName text,ReimbursementAmount text,ClaimAmount text,Remarks text,PaymentType text,ClientOffice text,AttachmentPath text,userName text,WorkerId text,ResourceName text,StatusId text,Status text,RejectedRemarks text,post text,checkbox text,debitto text,isattachment text,extensionStr text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_ReimbursementMaster, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - ReimbursementMaster")
            return
        }
        
        let CREATE_TABLE_Attachment_File_Details = "create table if not exists  AttachmentFileDetails(filename text,fileStr text ,id text,post text,extension text,fileid text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_Attachment_File_Details, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - AttachmentFileDetails")
            return
        }

        let CREATE_TABLE_calendar = "create table if not exists calendar (date text, status text, totmins text, billmins text, billhrs text, tothrs text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_calendar, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - calendar")
            return
        }
        
        
    }
    
    //MARK:- DELETE TABLE
    public func deletetable(tbl: String){
        let query = "delete from \(tbl)"
        
        if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting \(tbl) Table data")
            return
        }
    }
    public func deleteposttable(tbl: String){
        let query = "delete from \(tbl) where post = '2'"
        
        if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting \(tbl) Table data")
            return
        }
    }
    //MARK:- PRECHECK
    public func insertclientmaster(MatterCode : String, MatterDesc : String, MatterType : String, ClientCode : String, ClientDesc : String){
//     ClientMaster(   MatterCode , MatterDesc , MatterType , ClientCode , ClientDesc
        let query = "Insert into ClientMaster (MatterCode , MatterDesc , MatterType , ClientCode , ClientDesc) VALUES ('\(MatterCode)','\(MatterDesc)','\(MatterType)','\(ClientCode)','\(ClientDesc)')"
        
        if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in ClientMaster Table")
            return
        }
    }

    public func insert_tsentry(uid: String,client : String, matter : String, date : String, hours: String, mins: String, time : String, isbillable : String, isoffcounsel : String, narration : String, status: String = "0" ,post: String){
        //    TSEentry(uid text, client text, matter text, date text,hours text, mins text, time text, isbillable text, isoffcounsel text, narration text,status , post )
        let query = "Insert into TSEentry(uid , client , matter , date , hours , mins , time , isbillable , isoffcounsel , narration, status, post  ) VALUES ('\(uid)' , '\(client)' , '\(matter)' , '\(date)' , '\(hours)' , '\(mins)' , '\(time)' , '\(isbillable)' , '\(isoffcounsel)' , '\(narration)', '\(status)' , '\(post)')"
        
        if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in TSEentry Table")
            return
        }
    }
    
    public func updatestatus(status: String,uid: String){
        var query = ""
        if (uid == "-1"){
            query = "update TSEentry set status = '\(status)'"
        }else{
            query = "update TSEentry set status = '\(status)' where uid = '\(uid)'"
        }
        
        if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating status in TSEentry Table")
            return
        }
    }
    
    public func deltsentry(uid: String){
        let query = "delete from TSEentry where uid = '\(uid)'"
        
        if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting entry in TSEentry Table")
            return
        }
    }   
    
    public func update_tseditentry(uid: String,client : String, matter : String, hours: String, mins: String, time : String, narration : String,billable: String,offcounsel: String){
        let query = "update EditTS set client = '\(client)',  matter = '\(matter)' ,  hours = '\(hours)',  mins = '\(mins)',  time = '\(time)',  narration = '\(narration)' , isbillable = '\(billable)',isoffcounsel = '\(offcounsel)', post = '0' where  uid = '\(uid)'" 
        
        if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating in EditTS Table")
            return
        }
    }
    
    public func insert_editts(uid: String,client : String, matter : String, date : String, hours: String, mins: String, time : String, isbillable : String, isoffcounsel : String, narration : String, btnstate: String = "0",status: String ,post: String,empname: String = "", remark: String = ""){
        //    TSEentry(uid text, client text, matter text, date text,hours text, mins text, time text, isbillable text, isoffcounsel text, narration text,status , post )
        let query = "Insert into EditTS(uid , client , matter , date , hours , mins , time , isbillable , isoffcounsel , narration, btnstate ,status, empname,remark ,post  ) VALUES ('\(uid)' , '\(client)' , '\(matter)' , '\(date)' , '\(hours)' , '\(mins)' , '\(time)' , '\(isbillable)' , '\(isoffcounsel)' , '\(narration)', '\(btnstate)','\(status)','\(empname)', '\(remark)' , '\(post)')"
        
        if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in EditTS Table")
            return
        }
    }
    
    public func updateeditstatus(status: String,uid: String){
        var query = ""
        if (uid == "-1"){
            query = "update EditTS set btnstate = '\(status)' , post = '0'"
        }else{
            query = "update EditTS set btnstate = '\(status)' , post = '0' where uid = '\(uid)'"
        }
        
        if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating btnstate in EditTS Table")
            return
        }
    }
    
    public func deleditts(uid: String){
        let query = "delete from EditTS where uid = '\(uid)'"
        
        if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting entry in EditTS Table")
            return
        }
    }
    
    public func update_tsentry(uid: String,client : String, matter : String, hours: String, mins: String, time : String, narration : String,billable: String,offcounsel: String){
        
        
        let query = "update TSEentry set client = '\(client)',  matter = '\(matter)' ,  hours = '\(hours)',  mins = '\(mins)',  time = '\(time)',  narration = '\(narration)', isbillable = '\(billable)',isoffcounsel = '\(offcounsel)' where  uid = '\(uid)'"
        
        if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating in TSEentry Table")
            return
        }
    }
    
    
    public func insert_myts(uid: String,client : String, matter : String, date : String, hours: String, mins: String, time : String, isbillable : String, isoffcounsel : String, narration : String, status: String = "0" ){
        //    TSEentry(uid text, client text, matter text, date text,hours text, mins text, time text, isbillable text, isoffcounsel text, narration text,status , post )
        var stmt1:OpaquePointer?

        var query = "select * from MyTS where uid = '\(uid)'"
        
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            query = "update MyTS set client = '\(client)',  matter = '\(matter)',  hours = '\(hours)',  mins = '\(mins)',  time = '\(time)',  isbillable = '\(isbillable)',  isoffcounsel = '\(isoffcounsel)',  narration = '\(narration)' where uid = '\(uid)'"
        }else{
        query = "Insert into MyTS(uid , client , matter , date , hours , mins , time , isbillable , isoffcounsel , narration, status ) VALUES ('\(uid)' , '\(client)' , '\(matter)' , '\(date)' , '\(hours)' , '\(mins)' , '\(time)' , '\(isbillable)' , '\(isoffcounsel)' , '\(narration)', '\(status)')"
        }
        if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error executing - \(query) in MyTS Table")
            return
        }
    }
    public func insert_tsdatesum(tothrs : String, apphrs : String, rejhrs : String, subhrs : String, nshrs : String, totmin : String){
//        TSdatesum(tothrs text, apphrs text, rejhrs text, subhrs text, nshrs text, totmin text)
        self.deletetable(tbl: "TSdatesum")
        
        let query = "Insert into TSdatesum(tothrs , apphrs , rejhrs , subhrs , nshrs , totmin ) VALUES ('\(tothrs)' , '\(apphrs)' , '\(rejhrs)' , '\(subhrs)' , '\(nshrs)' , '\(totmin )')"
        
        if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in TSdatesum Table")
            return
        }
    }
    
    public func getclientid(str: String)-> String{
        var id = "-1"
        
        var stmt1:OpaquePointer?

        let query = "select ClientCode from ClientMaster where ClientDesc = '\(str)'"
        
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return id
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            id = String(cString: sqlite3_column_text(stmt1, 0))
        }
        
        return id
    }
    public func getmatterid(str: String)-> String{
        var id = "-1"
        
        var stmt1:OpaquePointer?

        let query = "select MatterCode from ClientMaster where MatterDesc = '\(str)'"
        
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return id
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            id = String(cString: sqlite3_column_text(stmt1, 0))
        }
        
        return id
    }
        
        public func getmattertype(str: String)-> String{
            var id = "-1"
            
            var stmt1:OpaquePointer?

            let query = "select MatterType from ClientMaster where MatterDesc = '\(str)'"
            
            if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return id
            }
            
            if(sqlite3_step(stmt1) == SQLITE_ROW){
                id = String(cString: sqlite3_column_text(stmt1, 0))
            }
            
            return id
        }
    //MARK:- insertRemClientMatter
       public func insertRemClientMatter(MatterCode : String, MatterDesc : String, MatterType : String, ClientCode : String, ClientDesc : String){
           let query = "Insert into GetRMClientMatter (MatterCode , MatterDesc , MatterType , ClientCode , ClientDesc) VALUES ('\(MatterCode)','\(MatterDesc)','\(MatterType)','\(ClientCode)','\(ClientDesc)')"
           
           if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
               print("Error inserting in GetRMClientMatter Table")
               return
           }
        insertionCompleted()
       }
    
    public func insertionCompleted(){
        
    }
       //MARK:- insertRemExpenseCatg
       public func insertRemExpenseCatg(projCategoryId : String, projCategoryName : String){
           let query = "Insert into GetRMExpenseCatg (projCategoryId , projCategoryName) VALUES ('\(projCategoryId)','\(projCategoryName)')"
           
           if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
               print("Error inserting in GetRMExpenseCatg Table")
               return
           }
       }
       
       //MARK:- insertRemCorpCardData
       public func insertRemCorpCardData(CardId : String, Description : String){
           let query = "Insert into GetRemCorpCardTypeData (CardId , Description) VALUES ('\(CardId)','\(Description)')"
           
           if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
               print("Error inserting in GetRemCorpCardTypeData Table")
               return
           }
       }
   //        let CREATE_TABLE_GetRemCostCenterData = "create table if not exists  GetRemCostCenterData(CodeName text,Name text)"

       //MARK:- insertRemCostCenterData
       public func insertRemCostCenterData(CodeName : String, Name : String){
           let query = "Insert into GetRemCostCenterData (CodeName , Name) VALUES ('\(CodeName)','\(Name)')"
           
           if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
               print("Error inserting in GetRemCostCenterData Table")
               return
           }
       }
       //MARK:- insertReimbursementEntry
       public func insertReimbursementEntry(id : String, date : String,debitTo : String, attachment : String,choosefile : String, paymentType : String,corporateCard : String,client : String, matter : String,expenseCategory : String, remark : String,amount : String, costCenter : String,post : String, checkbox : String,expensenumber : String, projid : String,clientid : String, catgid : String,cardid : String, statusId : String, rejectremark : String, extensionStr : String, costcode : String,payto : String){
           let query = "Insert into ReimbursementEntry (id , date, debitTo, attachment, choosefile, paymentType, corporateCard, client, matter, expenseCategory, remark, amount, costCenter, post, checkbox, expensenumber, projid, clientid, catgid, cardid, statusId, rejectremark, extensionStr, costcode,payto) VALUES ('\(id)','\(date)','\(debitTo)','\(attachment)','\(choosefile)','\(paymentType)','\(corporateCard)','\(client)','\(matter)','\(expenseCategory)','\(remark)','\(amount)','\(costCenter)','\(post)','\(checkbox)','\(expensenumber)','\(projid)','\(clientid)','\(catgid)','\(cardid)','\(statusId)','\(rejectremark)','\(extensionStr)','\(costcode)','\(payto)')"
           if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
               print("Error inserting in ReimbursementEntry Table")
               return
           }
       }
       
   //create table if not exists  ReimbursementMaster (ExpenseNumber text, TransactionId text,TransDate text,ProjId text,ProjectName text,ClientId  text,ClientName  text,CategoryId text,CategotyName text,CardId text,CardName text,DimensionCostCenter text,CostCenterName text,ReimbursementAmount text,ClaimAmount text,Remarks text,PaymentType text,ClientOffice text,AttachmentPath text,userName text,WorkerId text,ResourceName text,StatusId text,Status text,RejectedRemarks text,post text,checkbox text,debitto text,isattachment text,extension text)
       
       //MARK:- insertReimbursementMaster
       public func insertReimbursementMaster(ExpenseNumber : String, TransactionId : String,TransDate : String, ProjId : String,ProjectName : String, ClientId : String,ClientName : String,CategoryId : String, CategotyName : String,CardId : String, CardName : String,DimensionCostCenter : String, CostCenterName : String,ReimbursementAmount : String, ClaimAmount : String,Remarks : String, PaymentType : String,ClientOffice : String, AttachmentPath : String,userName : String, WorkerId : String, ResourceName : String, StatusId : String, Status : String, RejectedRemarks : String, post : String, checkbox : String, debitto : String, isattachment : String, extensionStr : String){
           let query = "Insert into ReimbursementMaster (ExpenseNumber , TransactionId, TransDate, ProjId, ProjectName, ClientId, ClientName, CategoryId, CategotyName, CardId, CardName, DimensionCostCenter, CostCenterName, ReimbursementAmount, ClaimAmount, Remarks, PaymentType, ClientOffice, AttachmentPath, userName, WorkerId, ResourceName, StatusId, Status, RejectedRemarks, post, checkbox, debitto, isattachment, extensionStr) VALUES ('\(ExpenseNumber)','\(TransactionId)','\(TransDate)','\(ProjId)','\(ProjectName)','\(ClientId)','\(ClientName)','\(CategoryId)','\(CategotyName)','\(CardId)','\(CardName)','\(DimensionCostCenter)','\(CostCenterName)','\(ReimbursementAmount)','\(ClaimAmount)','\(Remarks)','\(PaymentType)','\(ClientOffice)','\(AttachmentPath)','\(userName)','\(WorkerId)','\(ResourceName)','\(StatusId)','\(Status)','\(RejectedRemarks)','\(post)','\(checkbox)','\(debitto)','\(isattachment)','\(extensionStr)')"
           if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
               print("Error inserting in ReimbursementMaster Table")
               return
           }
        insertionDoneReimbursementMaster()
       }
    
    public func insertionDoneReimbursementMaster(){
        
    }
       
       public func updateReimbursementEntry(id : String, date : String,debitTo : String, attachment : String,choosefile : String, paymentType : String,corporateCard : String,client : String, matter : String,expenseCategory : String, remark : String,amount : String, costCenter : String,post : String, checkbox : String,expensenumber : String, projid : String,clientid : String, catgid : String,cardid : String, statusId : String, rejectremark : String, extensionStr : String, costcode : String,payto : String){
           
           let query = "update ReimbursementEntry set date = '\(date)',  debitTo = '\(debitTo)' , attachment = '\(attachment)', choosefile = '\(choosefile)',  paymentType = '\(paymentType)',  corporateCard = '\(corporateCard)' ,  client = '\(client)' ,  matter = '\(matter)',  expenseCategory = '\(expenseCategory)',  remark = '\(remark)',  amount = '\(amount)',  costCenter = '\(costCenter)',  projid = '\(projid)' ,  clientid = '\(clientid)' ,  catgid = '\(catgid)',  cardid = '\(cardid)',  statusId = '\(statusId)',  costcode = '\(costcode)',  payto = '\(payto)' where  id = '\(id)'"
           
           if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
               print("Error updating in ReimbursementEntry Table")
               return
           }
       }
    public func getclidfromname(clname: String)-> String{
        var id = ""
        
        var stmt1:OpaquePointer?
                
        let query = "select distinct(ClientCode) from ClientMaster where ClientDesc = '\(clname)'"
        
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return ""
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            id = String(cString: sqlite3_column_text(stmt1, 0))
        }
        
        return id
    }
    public func getmtidfromname(mtname: String)-> String{
        var id = ""
        
        var stmt1:OpaquePointer?
                
        let query = "select distinct(MatterCode) from ClientMaster where MatterDesc = '\(mtname)'"
        
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return ""
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            id = String(cString: sqlite3_column_text(stmt1, 0))
        }
        
        return id
    }
    
    public func insertcalendar(date : String, status : String, totmins : String, billmins : String, billhrs : String, tothrs : String){
//        calendar (date text, status text, totmins text, billmins text, billhrs text, tothrs text)
        let query = "Insert into calendar (date , status, totmins, billmins, billhrs, tothrs) VALUES ('\(date)','\(status)','\(totmins)','\(billmins)','\(billhrs)','\(tothrs)')"
        
        if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in calendar Table")
            return
        }
    }
    public func updatestatusRem(status: String,uid: String){
        var query = ""
        if (uid == "-1"){
            query = "update ReimbursementEntry set checkbox = \(status)"
        }else{
            query = "update ReimbursementEntry set checkbox = \(status) where id = \(uid)"
        }
        
        if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating status in ReimbursementEntry Table")
            return
        }
    }
    public func updatestatusEditRemTrans(status: String,TransactionId: String){
        var query = ""
        if (TransactionId == "-1"){
            query = "update ReimbursementMaster set checkbox = \(status)"
        }else{
            query = "update ReimbursementMaster set checkbox = \(status) where TransactionId = '\(TransactionId)' "
        }
        
        if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating status in ReimbursementMaster Table")
            return
        }
    }
    public func updatestatusEditRem(status: String,ExpenseNumber: String){
        var query = ""
        if (ExpenseNumber == "-1"){
            query = "update ReimbursementMaster set checkbox = \(status)"
        }else{
            query = "update ReimbursementMaster set checkbox = \(status) where ExpenseNumber = '\(ExpenseNumber)' "
        }
        
        if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating status in ReimbursementMaster Table")
            return
        }
    }
    public func getclientidRem(str: String)-> String{
        var id = ""
        
        var stmt1:OpaquePointer?

        let query = "select ClientCode from GetRMClientMatter where ClientDesc = '\(str)'"
        
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return id
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            id = String(cString: sqlite3_column_text(stmt1, 0))
        }
        
        return id
    }
    
    public func getMatteridRem(str: String)-> String{
        var id = ""
        
        var stmt1:OpaquePointer?

        let query = "select MatterCode from GetRMClientMatter where MatterDesc = '\(str)'"
        
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return id
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            id = String(cString: sqlite3_column_text(stmt1, 0))
        }
        
        return id
    }
    
    public func getCorporateidRem(str: String)-> String{
        var id = ""
        
        var stmt1:OpaquePointer?

        let query = "select CardId from GetRemCorpCardTypeData where Description = '\(str)'"
        
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return id
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            id = String(cString: sqlite3_column_text(stmt1, 0))
        }
        
        return id
    }
    
    public func getCostCenteridRem(str: String)-> String{
        var id = ""
        
        var stmt1:OpaquePointer?

        let query = "select CodeName from GetRemCostCenterData where Name = '\(str)'"
        
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return id
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            id = String(cString: sqlite3_column_text(stmt1, 0))
        }
        
        return id
    }
    
    public func getExpenseidRem(str: String)-> String{
        var id = ""
        var stmt1:OpaquePointer?
        let query = "select projCategoryId from GetRMExpenseCatg where projCategoryName = '\(str)'"
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return id
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            id = String(cString: sqlite3_column_text(stmt1, 0))
        }
        return id
    }
    public func isInvalidateRMClient(str: String)-> Bool{
        var stmt1:OpaquePointer?
        let query = "select * from GetRMClientMatter where ClientDesc = '\(str)'"
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            return false
        }
        return true
    }
    public func isInvalidateRMMatter(str: String)-> Bool{
        var stmt1:OpaquePointer?
        let query = "select * from GetRMClientMatter where MatterDesc = '\(str)'"
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            return false
        }
        return true
    }
    public func isInvalidateExpenseCatg(str: String)-> Bool{
        var stmt1:OpaquePointer?
        let query = "select * from GetRMExpenseCatg where projCategoryName = '\(str)'"
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            return false
        }
        return true
    }
    public func isInvalidateCostCenter(str: String)-> Bool{
        var stmt1:OpaquePointer?
        let query = "select * from GetRemCostCenterData where Name = '\(str)'"
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            return false
        }
        return true
    }
    public func isInvalidateCorporateCard(str: String)-> Bool{
        var stmt1:OpaquePointer?
        let query = "select * from GetRemCorpCardTypeData where Description = '\(str)'"
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            return false
        }
        return true
    }
    public func delrementryEdit(ExpenseNumber: String){
        let query = "delete from ReimbursementMaster where ExpenseNumber = '\(ExpenseNumber)'"
        
        if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting entry in ReimbursementMaster Table")
            return
        }
    }
    public func getExpenseNameRem(str: String)-> String{
        var Name = ""
        var stmt1:OpaquePointer?
        let query = "select projCategoryName  from GetRMExpenseCatg where projCategoryId = '\(str)'"
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return Name
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            Name = String(cString: sqlite3_column_text(stmt1, 0))
        }
        return Name
    }
    
    public func getCostCenterNameRem(str: String)-> String{
        var Name = ""
        var stmt1:OpaquePointer?
        let query = "select Name  from GetRemCostCenterData where CodeName = '\(str)'"
        if  sqlite3_prepare_v2(DBConnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DBConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return Name
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            Name = String(cString: sqlite3_column_text(stmt1, 0))
        }
        return Name
    }
    
    public func updateReimbursementMaster(ExpenseNumber : String, TransDate : String,debitto : String, isattachment : String,AttachmentPath : String, PaymentType : String,CardName : String,ClientName : String, ProjectName : String,CategotyName : String, Remarks : String,ClaimAmount : String, CostCenterName : String,post : String, checkbox : String,expensenumber : String, ProjId : String,ClientId : String, CategoryId : String,CardId : String, StatusId : String, rejectremark : String, extensionStr : String, DimensionCostCenter : String,payto : String){
        
        let query = "update ReimbursementMaster set TransDate = '\(TransDate)',  debitto = '\(debitto)' , isattachment = '\(isattachment)', AttachmentPath = '\(AttachmentPath)',  PaymentType = '\(PaymentType)',  CardName = '\(CardName)' ,  ClientName = '\(ClientName)' ,  ProjectName = '\(ProjectName)',  CategotyName = '\(CategotyName)',  Remarks = '\(Remarks)',  ClaimAmount = '\(ClaimAmount)',  CostCenterName = '\(CostCenterName)',  ProjId = '\(ProjId)' ,  ClientId = '\(ClientId)' ,  CategoryId = '\(CategoryId)',  CardId = '\(CardId)',  StatusId = '\(StatusId)',  DimensionCostCenter = '\(DimensionCostCenter)',  ResourceName = '\(payto)' where  ExpenseNumber = '\(ExpenseNumber)'"
        
        if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating in ReimbursementMaster Table")
            return
        }
    }
    public func delrementry(uid: String){
        let query = "delete from ReimbursementEntry where id = '\(uid)'"
        
        if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting entry in ReimbursementEntry Table")
            return
        }
    }
    //create table if not exists  AttachmentFileDetails(filename text,fileStr text ,id text,post text,extensionStr text,fileid text)
    public func insertAttachmentFileDetails(filename : String, fileStr : String, id : String, post : String, extensionStr : String, fileid : String) {
        let query = "Insert into AttachmentFileDetails (filename , fileStr, id, post, extension, fileid) VALUES ('\(filename)','\(fileStr)','\(id)','\(post)','\(extensionStr)','\(fileid)')"
        
        if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in AttachmentFileDetails Table")
            return
        }
    }
    public func delAttachmentFileDetails(uid: String){
        let query = "delete from AttachmentFileDetails where id = '\(uid)'"
        
        if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting entry in AttachmentFileDetails Table")
            return
        }
    }
    public func delAttachmentFileDetailsfileid(fileid: String){
        let query = "delete from AttachmentFileDetails where fileid = '\(fileid)'"
        
        if sqlite3_exec(DBConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting entry in AttachmentFileDetails Table")
            return
        }
    }

    
}
