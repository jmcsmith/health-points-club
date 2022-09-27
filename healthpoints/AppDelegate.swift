//
//  AppDelegate.swift
//  healthpointsclub
//
//  Created by Joseph Smith on 10/2/17.
//  Copyright © 2017 Joseph Smith. All rights reserved.
//

import UIKit
import UserNotifications
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
//, WCSessionDelegate
{
    
    var window: UIWindow?
    let hkHelper = HealthKitHelper()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        if let data =  UserDefaults.standard.data(forKey: "history") {
            //if let history = NSKeyedUnarchiver.unarchiveObject(with: data) as? [HistoryDay]{
            if let history = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [HistoryDay] {
                HealthDay.shared.history = history
            }
        }
        let first = UserDefaults.standard.bool(forKey: "hasopenedbefore")
        
        if first {
            hkHelper.startObservingQueries()
            hkHelper.loadHealthDay()
        }
        
        
        Theme.current.apply()
//        setupWatchConnectivity()
        
        
        return true
    }
//    func setupWatchConnectivity() {
//        if WCSession.isSupported() {
//            let session = WCSession.default
//            session.delegate = self
//            session.activate()
//
//        }
//    }
//    func sendUpdateToWatch() {
//        if WCSession.isSupported() {
//
//        }
//    }
//    func session(_ session: WCSession,
//                 activationDidCompleteWith activationState: WCSessionActivationState,
//                 error: Error?) {
//        if let error = error {
//            print("WC Session activation failed with errors: \(error.localizedDescription)")
//            return
//        }
//        print("WC Session activated with state: \(activationState.rawValue)")
//    }
//    func sessionDidBecomeInactive(_ session: WCSession) {
//        print("WC Session did become inactive")
//    }
//    func sessionDidDeactivate(_ session: WCSession) {
//        print("WC Session did deactivate")
//        WCSession.default.activate()
//    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    }
    
    //    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
    //        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateUIFromHealthDay"), object: self)
    //    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        hkHelper.loadHealthDay()
        print("WillEnterForeground")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        print("Recieved context on phone")
        //        if let request = applicationContext["request"] as? String {
        //
        //        }
    }
}

