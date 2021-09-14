//
//  CONSTANT.swift
//  Trilegal
//
//  Created by Acxiom Consulting on 04/06/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.
//

import Foundation

public class CONSTANT {
    
    public static var base_url : String = "http://52.172.203.197:8084/api/"
    public static var login_url : String = "ValidateUser?csuserId="
    public static var client_matter_url : String = "GetTSClientMatter?&csuserId="
    public static var tsentry_url : String = "GetTSEntryInfo?csuserId="
    public static var SERVER_ERR : String = "Server not Reachable !"
    public static var rem_client_matter_url : String = "GetRemClientMatter?&csuserId="
    public static var rem_exp_catg_url : String = "GetRemExpenseCategory?&csuserId="
    public static var rem_corp_card_url : String = "GetRemCorpCardType?&csuserId="
    public static var rem_cost_center_url : String = "GetRemCostCenter?&csuserId="
    public static var rem_master_url : String = "GetReimbursement?"
    public static var API_ERR : String = "Error in API !"
    
    
    public static var NET_ERR : String = "Please check your internet connection."
    
    public static var failapi = 0
    public static var apicall = 4
    
}
