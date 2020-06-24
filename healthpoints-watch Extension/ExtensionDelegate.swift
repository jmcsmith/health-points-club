//
//  ExtensionDelegate.swift
//  healthpoints-watch Extension
//
//  Created by Joseph Smith on 4/29/20.
//  Copyright © 2020 Joseph Smith. All rights reserved.
//

import WatchKit
import RSSHealthKitHelper_Watch
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        let hkHelper = HealthKitHelper()
        hkHelper.authorizeHealthKit { (authorized, error) -> Void in
            if authorized {
                print("HealthKit authorization received.")
                hkHelper.loadHealthDay()
                
            } else {
                print("HealthKit authorization denied!")
                if error != nil {
                    print("\(error.debugDescription)")
                }
                
            }
        }
        setupWatchConnectivity()
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        if let error = error {
            print("WC Session activation failed with error: \(error.localizedDescription)")
            return
        }
        print("WC Session activated with state: \(activationState.rawValue)")
    }
    func setupWatchConnectivity() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }
    
    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }
    func applicationWillEnterForeground() {
        let hkHelper = HealthKitHelper()
        hkHelper.loadHealthDay()
    }
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        print("Received")
        if (applicationContext["status"] as? String) != nil {
            if let weeklyTotal = applicationContext["weekTotal"] as? Int{
                HealthDay.shared.weeklyTotal = weeklyTotal
            }
            if let lifetimeTotal = applicationContext["lifetimeTotal"] as? Int{
                  HealthDay.shared.lifetimeTotal = lifetimeTotal
              }
            DispatchQueue.main.async {
                
                
                
                let hkHelper = HealthKitHelper()
                hkHelper.loadHealthDay()
                //WKInterfaceController.reloadRootPageControllers(withNames: ["ContentView"], contexts: nil, orientation: .vertical, pageIndex: 0)
                
                
                
                let server = CLKComplicationServer.sharedInstance()
                guard let complications = server.activeComplications else { return }
                for complication in complications { server.reloadTimeline(for: complication)
                }
            }
            
        }
        
    }
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompletedWithSnapshot(false)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
                // Be sure to complete the relevant-shortcut task once you're done.
                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
                // Be sure to complete the intent-did-run task once you're done.
                intentDidRunTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
    
}
