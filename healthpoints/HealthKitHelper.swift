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

    func authorizeHealthKit(completion: ((_ success: Bool, _ error: Error?) -> Void)!) {
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        let waterCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)
        let stand = HKObjectType.categoryType(forIdentifier: .appleStandHour)
        let mind = HKObjectType.categoryType(forIdentifier: .mindfulSession)!
        let move = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        let exercise = HKObjectType.quantityType(forIdentifier: .appleExerciseTime)
        let sleep = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)
        let calories = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)
        // 1. Set the types you want to read from HK Store
        let dataTypesToRead: Set<HKObjectType> = [stepsCount!, waterCount!, HKWorkoutType.workoutType(), stand!, mind, HKActivitySummaryType.activitySummaryType(), move, exercise!, sleep!, calories!]

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
                DispatchQueue.main.async(execute: self.startObservingStandHours)
                DispatchQueue.main.async(execute: self.startObservingMindSessions)
                DispatchQueue.main.async(execute: self.startObservingActiveCalories)
                DispatchQueue.main.async(execute: self.startObservingExerciseChanges)
                DispatchQueue.main.async(execute: self.startObservingCaloriesChanges)
                DispatchQueue.main.async(execute: self.startObservingSleep)
                completion(success, error)
            }
        }
    }
    func startObservingStandHours() {
        let sampleType = HKObjectType.categoryType(forIdentifier: .appleStandHour)!

        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType, predicate: nil, updateHandler: self.standHoursChangedHandler)

        healthKitStore.execute(query)
        healthKitStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate, withCompletion: {(succeeded: Bool, error: Error!) in

            if succeeded {
                print("Enabled background delivery of Stand Hour changes")
            } else {
                if let theError = error {
                    print("Failed to enable background delivery of Stand Hour changes. ")
                    print("Error = \(theError)")
                }
            }
        })
    }
    func standHoursChangedHandler(query: HKObserverQuery!, completionHandler: HKObserverQueryCompletionHandler!, error: Error!) {
        getStandHours { (temp, _) -> Void in


                HealthDay.shared.attributes.first(where: {$0.type == .stand})?.value = Int(temp)
          
        }

        completionHandler()
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


                HealthDay.shared.attributes.first(where: {$0.type == .water})?.value = Int(water)
    
        }

        completionHandler()
    }

    func startObservingCaloriesChanges() {
        let sampleType =  HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)
        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType!, predicate: nil, updateHandler: self.caloriesChangedHandler)
        healthKitStore.execute(query)
        healthKitStore.enableBackgroundDelivery(for: sampleType!, frequency: .immediate, withCompletion: {(succeeded: Bool, error: Error!) in

            if succeeded {
                print("Enabled background delivery of Calories changes")
            } else {
                if let theError = error {
                    print("Failed to enable background delivery of Calories changes. ")
                    print("Error = \(theError)")
                }
            }
        })
    }
    func caloriesChangedHandler(query: HKObserverQuery!, completionHandler: HKObserverQueryCompletionHandler!, error: Error!) {
        getCaloriesData { (water, _) -> Void in


                HealthDay.shared.attributes.first(where: {$0.type == .calories})?.value = Int(water)


        }

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


                HealthDay.shared.attributes.first(where: {$0.type == .workouts})?.value = Int(eligible)


         
        }

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
        

                HealthDay.shared.attributes.first(where: {$0.type == .steps})?.value = Int(temp)
          
        }

        completionHandler()
    }
    func startObservingExerciseChanges() {

        let sampleType =  HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)

        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType!, predicate: nil, updateHandler: self.exerciseChangedHandler)

        healthKitStore.execute(query)
        healthKitStore.enableBackgroundDelivery(for: sampleType!, frequency: .immediate, withCompletion: {(succeeded: Bool, error: Error!) in

            if succeeded {
                print("Enabled background delivery of Exercise changes")
            } else {
                if let theError = error {
                    print("Failed to enable background delivery of Exercise changes. ")
                    print("Error = \(theError)")
                }
            }
        })
    }

    func exerciseChangedHandler(query: HKObserverQuery!, completionHandler: HKObserverQueryCompletionHandler!, error: Error!) {
        getExerciseTime { (temp, _) -> Void in
         

                HealthDay.shared.attributes.first(where: {$0.type == .exercise})?.value = Int(temp)
          
        }

        completionHandler()
    }

    func startObservingActiveCalories() {
        let sampleType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!

        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType, predicate: nil, updateHandler: self.activeEnergyChangedHandler)

        healthKitStore.execute(query)
        healthKitStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate, withCompletion: {(succeeded: Bool, error: Error!) in

            if succeeded {
                print("Enabled background delivery of Active Energy changes")
            } else {
                if let theError = error {
                    print("Failed to enable background delivery of Active Energy changes. ")
                    print("Error = \(theError)")
                }
            }
        })
    }
    func activeEnergyChangedHandler(query: HKObserverQuery!, completionHandler: HKObserverQueryCompletionHandler!, error: Error!) {
        getActiveEnergy { (temp, _) -> Void in
        

                HealthDay.shared.attributes.first(where: {$0.type == .move})?.value = Int(temp)

                self.getActivityRings { (temp, _) -> Void in
                    HealthDay.shared.moveGoal = temp
                }
           
        }

        completionHandler()
    }

    func startObservingMindSessions() {
        let sampleType = HKObjectType.categoryType(forIdentifier: .mindfulSession)!

        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType, predicate: nil, updateHandler: self.mindSessionsChangedHandler)

        healthKitStore.execute(query)
        healthKitStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate, withCompletion: {(succeeded: Bool, error: Error!) in

            if succeeded {
                print("Enabled background delivery of Mind Session changes")
            } else {
                if let theError = error {
                    print("Failed to enable background delivery of Mind Session changes. ")
                    print("Error = \(theError)")
                }
            }
        })
    }
    func mindSessionsChangedHandler(query: HKObserverQuery!, completionHandler: HKObserverQueryCompletionHandler!, error: Error!) {
        getMindSessions { (temp, _) -> Void in


                HealthDay.shared.attributes.first(where: {$0.type == .mind})?.value = Int(temp)
     
        }

        completionHandler()
    }

    func startObservingSleep() {
        let sampleType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!

        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType, predicate: nil, updateHandler: self.sleepAnalysisChangedHandler)

        healthKitStore.execute(query)
        healthKitStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate, withCompletion: {(succeeded: Bool, error: Error!) in

            if succeeded {
                print("Enabled background delivery of Sleep Analysis changes")
            } else {
                if let theError = error {
                    print("Failed to enable background delivery of Sleep Analysis changes. ")
                    print("Error = \(theError)")
                }
            }
        })
    }
    func sleepAnalysisChangedHandler(query: HKObserverQuery!, completionHandler: HKObserverQueryCompletionHandler!, error: Error!) {
        getSleepAnalysis { (temp, _) -> Void in


                HealthDay.shared.attributes.first(where: {$0.type == .sleep})?.value = Int(temp)
    
        }

        completionHandler()
    }

    func getStepData(_ completion: ((Double, Error?) -> Void)!) {
        let cal = Calendar.current

        let startDate = cal.startOfDay(for: Date())
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)

        let predicate = HKQuery.predicateForSamples(withStart: startDate as Date, end: Date() as Date, options: HKQueryOptions())
        let interval: NSDateComponents = NSDateComponents()
        interval.day = 1

        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate as Date, intervalComponents:interval as DateComponents)
        query.initialResultsHandler = { query, results, error in

            if error != nil {

                //  Something went Wrong
                return
            }
            var steps = 0.0
            if let myResults = results {
                myResults.enumerateStatistics(from: startDate as Date, to: Date() as Date) {statistics, _ in

                    if let quantity = statistics.sumQuantity() {

                        steps = quantity.doubleValue(for: HKUnit.count())

                        print("Steps = \(steps)")

                    }
                    
                }
            }
            completion(round(steps), error)

        }
        healthKitStore.execute(query)
    }

    func getActiveEnergy(_ completion: ((Double, Error?) -> Void)!) {
        let cal = Calendar.current

        let startDate = cal.startOfDay(for: Date())
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)

        let predicate = HKQuery.predicateForSamples(withStart: startDate as Date, end: Date() as Date, options: .strictStartDate)
        let interval: NSDateComponents = NSDateComponents()
        interval.day = 1

        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate as Date, intervalComponents:interval as DateComponents)
        query.initialResultsHandler = { query, results, error in

            if error != nil {

                //  Something went Wrong
                return
            }
            var calories = 0.0
            if let myResults = results {
                myResults.enumerateStatistics(from: startDate as Date, to: Date() as Date) {statistics, _ in

                    if let quantity = statistics.sumQuantity() {

                        calories = quantity.doubleValue(for: HKUnit.kilocalorie())

                        print("Calories = \(calories)")

                    }
                    
                }
            }
            completion(round(calories), error)

        }
        healthKitStore.execute(query)
    }
    func getExerciseTime(_ completion: ((Double, Error?) -> Void)!) {
        let cal = Calendar.current

        let startDate = cal.startOfDay(for: Date())
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.appleExerciseTime)

        let predicate = HKQuery.predicateForSamples(withStart: startDate as Date, end: Date() as Date, options: .strictStartDate)
        let interval: NSDateComponents = NSDateComponents()
        interval.day = 1

        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate as Date, intervalComponents:interval as DateComponents)
        query.initialResultsHandler = { query, results, error in

            if error != nil {

                //  Something went Wrong
                return
            }
            var exercise = 0.0
            if let myResults = results {
                myResults.enumerateStatistics(from: startDate as Date, to: Date() as Date) {statistics, _ in

                    if let quantity = statistics.sumQuantity() {

                        exercise = quantity.doubleValue(for: HKUnit.minute())

                        print("Exercise Minutes = \(exercise)")

                    }
                    
                }
            }
            completion(round(exercise), error)

        }
        healthKitStore.execute(query)
    }

    func getWorkOutData(completion: ((Int, Error?) -> Void)!) {
        let cal = Calendar.current

        let startDate = cal.startOfDay(for: Date())
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: HKQueryOptions())
        let sampleQuery = HKSampleQuery(sampleType: HKWorkoutType.workoutType(), predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor]) { (_, results, error ) -> Void in

            var eligible = 0
            for workout in (results as? [HKWorkout])! where workout.duration >= 600 {

                eligible += 1

            }

            print("Eligible Workouts = \(eligible)")
            completion(eligible, error)
        }

        healthKitStore.execute(sampleQuery)

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
            completion(round(water), error)

        }
        healthKitStore.execute(query)

    }
    func getCaloriesData(_ completion: ((Double, Error?) -> Void)!) {
        let cal = Calendar.current

        let startDate = cal.startOfDay(for: Date())
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)

        let predicate = HKQuery.predicateForSamples(withStart: startDate as Date, end: Date() as Date, options: .strictStartDate)
        let interval: NSDateComponents = NSDateComponents()
        interval.day = 1

        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate as Date, intervalComponents:interval as DateComponents)
        query.initialResultsHandler = { query, results, error in

            if error != nil {

                //  Something went Wrong
                return
            }
            var calories = 0.0
            if let myResults = results {
                myResults.enumerateStatistics(from: startDate as Date, to: Date() as Date) {statistics, _ in

                    if let quantity = statistics.sumQuantity() {

                        calories = quantity.doubleValue(for: HKUnit.kilocalorie())

                    }
                }
            }
            print("Caloriesa = \(calories)")
            completion(calories, error)

        }
        healthKitStore.execute(query)

    }
    func getStandHours(_ completion: ((Int, Error?) -> Void)!) {
        let cal = Calendar.current

        var dateComponents = cal.dateComponents(
            [ .year, .month, .day ],
            from: Date()
        )
        dateComponents.calendar = cal
        let predicate = HKQuery.predicateForActivitySummary(with: dateComponents)

        let query = HKActivitySummaryQuery(predicate: predicate) { (_, summaries, error) in

            guard let summaries = summaries, summaries.count > 0
                else {
                    // No data returned. Perhaps check for error
                    return
            }
            let summary = summaries[0]

            let moveGoal = summary.appleStandHours.doubleValue(for: HKUnit.count())

            completion(Int(moveGoal), error)
        }
        healthKitStore.execute(query)
    }
    func getMindSessions(_ completion: ((Int, Error?) -> Void)!) {
        let cal = Calendar.current

        let startDate = cal.startOfDay(for: Date())
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: HKQueryOptions())
        let sampleQuery = HKSampleQuery(sampleType: HKObjectType.categoryType(forIdentifier: .mindfulSession)!, predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor]) { (_, results, error ) -> Void in

            print("Mind Sessions = \(results!.count)")
            completion(results!.count, error)
        }

        healthKitStore.execute(sampleQuery)
    }

    func getSleepAnalysis(_ completion: ((Int, Error?) -> Void)!) {
        let cal = Calendar.current

        let startDate = cal.startOfDay(for: Date()).addingTimeInterval(-3600*12)
        let endDate = cal.startOfDay(for: Date()).addingTimeInterval(3600*12)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions())
        let sampleQuery = HKSampleQuery(sampleType: HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!, predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor]) { (_, results, error ) -> Void in

            var minutes = 0
            for item in results! {
                if let sample = item as? HKCategorySample {

                    if sample.value == HKCategoryValueSleepAnalysis.asleep.rawValue {
                        minutes += Int(sample.endDate.timeIntervalSince(sample.startDate)/60)
                        print("Sleep Analysis = \(sample.endDate.timeIntervalSince(sample.startDate)/60)")
                    }
                }
            }
            completion(minutes, error)
        }

        healthKitStore.execute(sampleQuery)
    }

    func getActivityRings(_ completion: ((Double, Error?) -> Void)!) {
        let cal = Calendar.current

        var dateComponents = cal.dateComponents(
            [ .year, .month, .day ],
            from: Date()
        )
        dateComponents.calendar = cal
        let predicate = HKQuery.predicateForActivitySummary(with: dateComponents)

        let query = HKActivitySummaryQuery(predicate: predicate) { (_, summaries, error) in

            guard let summaries = summaries, summaries.count > 0
                else {
                    // No data returned. Perhaps check for error
                    return
            }
            let summary = summaries[0]

            let moveGoal = summary.activeEnergyBurnedGoal.doubleValue(for: HKUnit.kilocalorie())

            completion(moveGoal, error)
        }
        healthKitStore.execute(query)
    }

    func preLoadHealthDay() {
        getStepData { (temp, _) -> Void in

            HealthDay.shared.attributes.first(where: {$0.type == .steps})?.value = Int(temp)

        }
        getWorkOutData { (eligible, _) -> Void in


                HealthDay.shared.attributes.first(where: {$0.type == .workouts})?.value = Int(eligible)

        
        }
        getWaterData { (water, _) -> Void in
 
                HealthDay.shared.attributes.first(where: {$0.type == .water})?.value = Int(water)

         
        }
        getStandHours { (hours, _) -> Void in
   
                HealthDay.shared.attributes.first(where: {$0.type == .stand})?.value = Int(hours)
          

        }
        getMindSessions { (mins, _) -> Void in
 
                HealthDay.shared.attributes.first(where: {$0.type == .mind})?.value = Int(mins)
       

        }
        getActiveEnergy { (energy, _) -> Void in
  
                HealthDay.shared.attributes.first(where: {$0.type == .move})?.value = Int(energy)
     

        }
        getExerciseTime { (time, _) -> Void in

                HealthDay.shared.attributes.first(where: {$0.type == .exercise})?.value = Int(time)
        

        }
        getSleepAnalysis { (time, _) -> Void in
    
                HealthDay.shared.attributes.first(where: {$0.type == .sleep})?.value = Int(time)
     

        }
        getCaloriesData { (calories, _) -> Void in
 
                HealthDay.shared.attributes.first(where: {$0.type == .calories})?.value = Int(calories)
        

        }
    }
}
