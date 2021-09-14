//
//  SPLASHVC.swift
//  Trilegal
//
//  Created by Acxiom Consulting on 26/04/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.
//

import UIKit

class SPLASHVC: BASEACTIVITY {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        DBConnection.createdatabase()
        DispatchQueue.main.asyncAfter(deadline: .now()+3.0){
            if (UserDefaults.standard.bool(forKey: "ischeck") == true){
                self.gotoHome()
            }else{
                self.push(storybId: "LOGIN", vcId: "LOGINNC", vc: self)}
            }
            
    }
}

