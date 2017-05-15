//
//  HealthKitHelper.swift
//  healthpoints
//
//  Created by Joseph Smith on 5/4/17.
//  Copyright © 2017 healthpoints. All rights reserved.
//
import UIKit
import Foundation
import HealthKit
import UserNotifications

class HealthKitHelper {

    let healthKitStore: HKHealthStore = HKHealthStore()

    init() {

    }

    func startObservingWaterChanges() {
        let sampleType =  HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)
        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType!, predicate: nil, updateHandler: self.waterChangedHandler)
        healthKitStore.execute(query)
        healthKitStore.enableBackgroundDelivery(for: sampleType!, frequency: .immediate, withCompletion: {(succeeded: Bool, error: Error!) in

            if succeeded {
                print("Enabled background delivery of water changes")
            } else {
                if let theError = error {
                    print("Failed to enable background delivery of water changes. ")
                    print("Error = \(theError)")
                }
            }
        })
    }
    func waterChangedHandler(query: HKObserverQuery!, completionHandler: HKObserverQueryCompletionHandler!, error: Error!) {
        getWaterData { (water, _) -> Void in
            DispatchQueue.main.async(execute: {

                HealthDay.shared.attributes.first(where: {$0.type == .water})?.value = Int(water)
                //                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateUIFromHealthDay"), object: nil)

            })
        }

        scheduleLocalNotification(title: "Health Data Changed", subtitle: "Changed steps in Health App", body: "")

        completionHandler()
    }
    func startObservingWorkoutChanges() {
        let sampleType = HKObjectType.workoutType()
        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType, predicate: nil, updateHandler: self.workoutChangedHandler)
        healthKitStore.execute(query)
        healthKitStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate, withCompletion: {(succeeded: Bool, error: Error!) in

            if succeeded {
                print("Enabled background delivery of workout changes")
            } else {
                if let theError = error {
                    print("Failed to enable background delivery of workout changes. ")
                    print("Error = \(theError)")
                }
            }
        })
    }
    func workoutChangedHandler(query: HKObserverQuery!, completionHandler: HKObserverQueryCompletionHandler!, error: Error!) {
        getWorkOutData { (eligible, _) -> Void in
            DispatchQueue.main.async(execute: {

                HealthDay.shared.attributes.first(where: {$0.type == .workouts})?.value = Int(eligible)
                //                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateUIFromHealthDay"), object: nil)

            })
        }

        scheduleLocalNotification(title: "Health Data Changed", subtitle: "Changed steps in Health App", body: "")

        completionHandler()
    }

    func startObservingStepChanges() {

        let sampleType =  HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)

        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType!, predicate: nil, updateHandler: self.stepChangedHandler)

        healthKitStore.execute(query)
        healthKitStore.enableBackgroundDelivery(for: sampleType!, frequency: .immediate, withCompletion: {(succeeded: Bool, error: Error!) in

            if succeeded {
                print("Enabled background delivery of Step changes")
            } else {
                if let theError = error {
                    print("Failed to enable background delivery of Step changes. ")
                    print("Error = \(theError)")
                }
            }
        })
    }

    func stepChangedHandler(query: HKObserverQuery!, completionHandler: HKObserverQueryCompletionHandler!, error: Error!) {
        getStepData { (temp, _) -> Void in
            DispatchQueue.main.async(execute: {

                HealthDay.shared.attributes.first(where: {$0.type == .steps})?.value = Int(temp)
                //                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateUIFromHealthDay"), object: nil)
                print(temp)
            })
        }

        scheduleLocalNotification(title: "Health Data Changed", subtitle: "Changed steps in Health App", body: "")

        completionHandler()
    }

    func authorizeHealthKit(completion: ((_ success: Bool, _ error: Error?) -> Void)!) {
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        let waterCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)
        //        let height = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)
        //        let weight = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)
        // 1. Set the types you want to read from HK Store
        let dataTypesToRead: Set<HKObjectType> = [stepsCount!, waterCount!, HKWorkoutType.workoutType(), HKActivitySummaryType.activitySummaryType()]

        // 2. Set the types you want to write to HK Store

        let dataTypesToWrite: Set<HKSampleType> = []

        // 3. If the store is not available (for instance, iPad) return an error and don't go on.
        if !HKHealthStore.isHealthDataAvailable() {
            let error = NSError(domain: "any.domain.com", code: 2, userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available in this Device"])

            if completion != nil {
                completion(false, error)
            }
            return
        }

        // 4.  Request HealthKit authorization
        healthKitStore.requestAuthorization(toShare: dataTypesToWrite, read: dataTypesToRead) { (success, error) -> Void in
            if completion != nil {

                DispatchQueue.main.async(execute: self.startObservingStepChanges)
                DispatchQueue.main.async(execute: self.startObservingWorkoutChanges)
                DispatchQueue.main.async(execute: self.startObservingWaterChanges)
                completion(success, error)
            }
        }
    }
    private func scheduleLocalNotification(title: String, subtitle: String, body: String) {

        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()

        // Configure Notification Content
        notificationContent.title = title
        notificationContent.subtitle = subtitle
        notificationContent.body = body

        // Add Trigger
        //let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)

        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "hkClub_local_notification", content: notificationContent, trigger: nil)

        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    func getStepData(_ completion: ((Double, Error?) -> Void)!) {
        let cal = Calendar.current

        let startDate = cal.startOfDay(for: Date())
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)

        let predicate = HKQuery.predicateForSamples(withStart: startDate as Date, end: Date() as Date, options: .strictStartDate)
        let interval: NSDateComponents = NSDateComponents()
        interval.day = 1

        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate as Date, intervalComponents:interval as DateComponents)
        query.initialResultsHandler = { query, results, error in

            if error != nil {

                //  Something went Wrong
                return
            }

            if let myResults = results {
                myResults.enumerateStatistics(from: startDate as Date, to: Date() as Date) {statistics, _ in

                    if let quantity = statistics.sumQuantity() {

                        let steps = quantity.doubleValue(for: HKUnit.count())

                        print("Steps = \(steps)")
                        completion(round(steps), error)

                    }
                }
            }

        }
        healthKitStore.execute(query)
    }

    func getWorkOutData(completion: ((Int, Error?) -> Void)!) {
        let cal = Calendar.current

        let startDate = cal.startOfDay(for: Date())
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: HKQueryOptions())
        let sampleQuery = HKSampleQuery(sampleType: HKWorkoutType.workoutType(), predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor]) { (_, results, error ) -> Void in

            print("Workouts = \(results!.count)")
            var eligible = 0
            for workout in (results as? [HKWorkout])! where workout.duration >= 600 {

                eligible += 1

            }

            print("Eligible Workouts = \(eligible)")
            completion(eligible, error)
        }

        healthKitStore.execute(sampleQuery)

        //print("Workouts = \(results?.count)")

    }
    func getWaterData(_ completion: ((Double, Error?) -> Void)!) {
        let cal = Calendar.current

        let startDate = cal.startOfDay(for: Date())
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)

        let predicate = HKQuery.predicateForSamples(withStart: startDate as Date, end: Date() as Date, options: .strictStartDate)
        let interval: NSDateComponents = NSDateComponents()
        interval.day = 1

        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate as Date, intervalComponents:interval as DateComponents)
        query.initialResultsHandler = { query, results, error in

            if error != nil {

                //  Something went Wrong
                return
            }
            var water = 0.0
            if let myResults = results {
                myResults.enumerateStatistics(from: startDate as Date, to: Date() as Date) {statistics, _ in

                    if let quantity = statistics.sumQuantity() {

                        water = quantity.doubleValue(for: HKUnit.cupUS())

                    }
                }
            }
            print("Water = \(water)")
            completion(water, error)

        }
        healthKitStore.execute(query)
    }
    func preLoadHealthDay() {
        getStepData { (temp, _) -> Void in

            HealthDay.shared.attributes.first(where: {$0.type == .steps})?.value = Int(temp)
            print("Preload \(temp)")

        }
        getWorkOutData { (eligible, _) -> Void in
            DispatchQueue.main.async(execute: {

                HealthDay.shared.attributes.first(where: {$0.type == .workouts})?.value = Int(eligible)

            })
        }
        getWaterData { (water, _) -> Void in
            DispatchQueue.main.async(execute: {

                HealthDay.shared.attributes.first(where: {$0.type == .water})?.value = Int(water)

            })
        }
    }
}
