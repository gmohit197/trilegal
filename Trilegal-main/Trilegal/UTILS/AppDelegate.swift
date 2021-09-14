//
//  AppDelegate.swift
//  Trilegal
//  Created by Acxiom Consulting on 26/04/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.

import UIKit
import IQKeyboardManagerSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var blureffectview = UIVisualEffectView()
    static var menubool = true
    static var showAlert :Bool = false
    static var nextScreen : String! = ""
    static var currScreen : String! = ""
    var reachability: Reachability!
    static var ntwrk = 0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        
        let navigationBarAppearace = UINavigationBar.appearance()
        
        let appColor = hexStringToUIColor(hex:"#003366")
        navigationBarAppearace.tintColor = appColor
        navigationBarAppearace.barTintColor = appColor
        navigationBarAppearace.isTranslucent = false
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font: UIFont(name: "Whitney", size: 16)]
        
        do {
        try reachability = Reachability()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: Notification.Name.reachabilityChanged, object: reachability)
        try reachability.startNotifier()
        } catch {
             print("This is not working.")
        }
        
        UIBarButtonItem.appearance().setTitleTextAttributes(
        [
            NSAttributedString.Key.font : UIFont(name: "Whitney", size: 16)!,
            NSAttributedString.Key.foregroundColor : UIColor.white
        ],
        for: [.normal,.disabled])
        UIBarButtonItem().isEnabled = false
        navigationBarAppearace.setTitleVerticalPositionAdjustment(CGFloat(7), for: UIBarMetrics.default)

//        let gai = GAI.sharedInstance()
////        else {
////          assert(false, "Google Analytics not configured correctly")
////          print()
////        }
//        gai!.tracker(withTrackingId: "G-S1NTL2ZG0P")
//        // Optional: automatically report uncaught exceptions.
//        gai!.trackUncaughtExceptions = true

        // Optional: set Logger to VERBOSE for debug information.
        // Remove before app release.
   //     gai.logger.logLevel = .verbose;

        return true
    }
    
    @objc func reachabilityChanged(_ note: NSNotification) {
    let reachability = note.object as! Reachability 
        var image = UIImage(named: "")
    if reachability.connection != .unavailable {
    if reachability.connection == .wifi {
    print("Reachable via WiFi")
        AppDelegate.ntwrk = 1
        
    } else {
    print("Reachable via Cellular")
        AppDelegate.ntwrk = 1
        
    }
    } else {
    print("Not reachable")
        AppDelegate.ntwrk = 0
        
    }
//        window = UIApplication.shared.windows[0]
//        if (window != nil) {
//        ((window!.rootViewController as? UINavigationController)?.topViewController as? BASEACTIVITY)?.setnav(title: "")
//        }
//        let base = BASEACTIVITY()
//        base.setnav(title: "")
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
   
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
   
}

