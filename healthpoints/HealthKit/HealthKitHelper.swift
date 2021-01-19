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
    
    public func authorizeHealthKit(completion: ((_ success: Bool, _ error: Error?) -> Void)!) {
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        let waterCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)
        let stand = HKObjectType.categoryType(forIdentifier: .appleStandHour)
        let mind = HKObjectType.categoryType(forIdentifier: .mindfulSession)!
        let move = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        let exercise = HKObjectType.quantityType(forIdentifier: .appleExerciseTime)
        let sleep = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)
        let calories = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)
        let weight = HKObjectType.quantityType(forIdentifier: .bodyMass)
        
        let dataTypesToRead: Set<HKObjectType> = [stepsCount!, waterCount!, HKWorkoutType.workoutType(), stand!, mind, HKActivitySummaryType.activitySummaryType(), move, exercise!, sleep!, calories!, weight!]
        
        let dataTypesToWrite: Set<HKSampleType> = []
        
        if !HKHealthStore.isHealthDataAvailable() {
            let error = NSError(domain: "any.domain.com", code: 2, userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available in this Device"])
            
            if completion != nil {
                completion(false, error)
            }
            return
        }
        
        healthKitStore.requestAuthorization(toShare: dataTypesToWrite, read: dataTypesToRead) { (success, error) -> Void in
            if completion != nil {
                
                self.startObservingQueries()
                completion(success, error)
            }
        }
    }
    
    func startObservingQueries() {
        DispatchQueue.main.async(execute: self.startObservingStepChanges)
        DispatchQueue.main.async(execute: self.startObservingWorkoutChanges)
        DispatchQueue.main.async(execute: self.startObservingWaterChanges)
        DispatchQueue.main.async(execute: self.startObservingStandHours)
        DispatchQueue.main.async(execute: self.startObservingMindSessions)
        DispatchQueue.main.async(execute: self.startObservingActiveCalories)
        DispatchQueue.main.async(execute: self.startObservingExerciseChanges)
        DispatchQueue.main.async(execute: self.startObservingCaloriesChanges)
        DispatchQueue.main.async(execute: self.startObservingSleep)
        DispatchQueue.main.async(execute: self.startObservingBodyMass)
    }
    
    func startObservingBodyMass() {
        let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)
        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType!, predicate: nil, updateHandler: self.valueChangedHandler)
        healthKitStore.execute(query)
        healthKitStore.enableBackgroundDelivery(for: sampleType!, frequency: .immediate, withCompletion: { (succeeded: Bool, error: Error!) in
            
            if succeeded {
                print("Enabled background delivery of body mass changes")
            } else {
                if let theError = error {
                    print("Failed to enable background delivery of body mass changes. ")
                    print("Error = \(theError)")
                }
            }
        })
    }
    
    func startObservingStandHours() {
        let sampleType = HKObjectType.categoryType(forIdentifier: .appleStandHour)!
        
        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType, predicate: nil, updateHandler: self.valueChangedHandler)
        
        healthKitStore.execute(query)
        healthKitStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate, withCompletion: { (succeeded: Bool, error: Error!) in
            
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
    
    func startObservingWaterChanges() {
        let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)
        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType!, predicate: nil, updateHandler: self.valueChangedHandler)
        healthKitStore.execute(query)
        healthKitStore.enableBackgroundDelivery(for: sampleType!, frequency: .immediate, withCompletion: { (succeeded: Bool, error: Error!) in
            
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
    
    func startObservingCaloriesChanges() {
        let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)
        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType!, predicate: nil, updateHandler: self.valueChangedHandler)
        healthKitStore.execute(query)
        healthKitStore.enableBackgroundDelivery(for: sampleType!, frequency: .immediate, withCompletion: { (succeeded: Bool, error: Error!) in
            
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
    
    func startObservingWorkoutChanges() {
        let sampleType = HKObjectType.workoutType()
        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType, predicate: nil, updateHandler: self.valueChangedHandler)
        healthKitStore.execute(query)
        healthKitStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate, withCompletion: { (succeeded: Bool, error: Error!) in
            
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
    
    func startObservingStepChanges() {
        
        let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        
        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType!, predicate: nil, updateHandler: self.valueChangedHandler)
        
        healthKitStore.execute(query)
        healthKitStore.enableBackgroundDelivery(for: sampleType!, frequency: .immediate, withCompletion: { (succeeded: Bool, error: Error!) in
            
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
    
    func startObservingExerciseChanges() {
        
        let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        
        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType!, predicate: nil, updateHandler: self.valueChangedHandler)
        
        healthKitStore.execute(query)
        healthKitStore.enableBackgroundDelivery(for: sampleType!, frequency: .immediate, withCompletion: { (succeeded: Bool, error: Error!) in
            
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
    
    func startObservingActiveCalories() {
        let sampleType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        
        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType, predicate: nil, updateHandler: self.valueChangedHandler)
        
        healthKitStore.execute(query)
        healthKitStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate, withCompletion: { (succeeded: Bool, error: Error!) in
            
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
    
    func startObservingMindSessions() {
        let sampleType = HKObjectType.categoryType(forIdentifier: .mindfulSession)!
        
        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType, predicate: nil, updateHandler: self.valueChangedHandler)
        
        healthKitStore.execute(query)
        healthKitStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate, withCompletion: { (succeeded: Bool, error: Error!) in
            
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
    
    func startObservingSleep() {
        let sampleType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        
        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType, predicate: nil, updateHandler: self.valueChangedHandler)
        
        healthKitStore.execute(query)
        healthKitStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate, withCompletion: { (succeeded: Bool, error: Error!) in
            
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
    
    func getStepData(forDate date: Date, _ completion: ((Double, Error?) -> Void)!) {
        let cal = Calendar.current
        
        let startDate = cal.startOfDay(for: date)
        var comps = DateComponents()
        comps.day = 1
        comps.second = -1
        
        let endDate = cal.date(byAdding: comps, to: startDate)
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions())
        let interval: NSDateComponents = NSDateComponents()
        interval.day = 1
        
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate as Date, intervalComponents: interval as DateComponents)
        query.initialResultsHandler = { query, results, error in
            
            if error != nil {
                
                //  Something went Wrong
                return
            }
            var steps = 0.0
            if let myResults = results, let endDate = endDate {
                myResults.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                    if let quantity = statistics.sumQuantity() {
                        steps = quantity.doubleValue(for: HKUnit.count())
                    }
                }
            }
            completion(round(steps), error)
        }
        healthKitStore.execute(query)
    }
    func getActiveEnergy(forDate date: Date, _ completion: ((Double, Error?) -> Void)!) {
        let cal = Calendar.current
        
        let startDate = cal.startOfDay(for: date)
        var comps = DateComponents()
        comps.day = 1
        comps.second = -1
        
        let endDate = cal.date(byAdding: comps, to: startDate)
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let interval: NSDateComponents = NSDateComponents()
        interval.day = 1
        
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate as Date, intervalComponents: interval as DateComponents)
        query.initialResultsHandler = { query, results, error in
            
            if error != nil {
                
                //  Something went Wrong
                return
            }
            var calories = 0.0
            if let myResults = results, let endDate = endDate {
                myResults.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                    if let quantity = statistics.sumQuantity() {
                        calories = quantity.doubleValue(for: HKUnit.kilocalorie())
                    }
                }
            }
            completion(round(calories), error)
        }
        healthKitStore.execute(query)
    }
    func getExerciseTime(forDate date: Date, _ completion: ((Double, Error?) -> Void)!) {
        let cal = Calendar.current
        
        let startDate = cal.startOfDay(for: date)
        var comps = DateComponents()
        comps.day = 1
        comps.second = -1
        
        let endDate = cal.date(byAdding: comps, to: startDate)
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.appleExerciseTime)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let interval: NSDateComponents = NSDateComponents()
        interval.day = 1
        
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate as Date, intervalComponents: interval as DateComponents)
        query.initialResultsHandler = { query, results, error in
            
            if error != nil {
                
                //  Something went Wrong
                return
            }
            var exercise = 0.0
            if let myResults = results, let endDate = endDate {
                myResults.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                    if let quantity = statistics.sumQuantity() {
                        exercise = quantity.doubleValue(for: HKUnit.minute())
                    }
                }
            }
            completion(round(exercise), error)
        }
        healthKitStore.execute(query)
    }
    
    func getWorkOutData(forDate date: Date, _ completion: ((Int, Error?) -> Void)!) {
        let cal = Calendar.current
        
        let startDate = cal.startOfDay(for: date)
        var comps = DateComponents()
        comps.day = 1
        comps.second = -1
        
        let endDate = cal.date(byAdding: comps, to: startDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions())
        let sampleQuery = HKSampleQuery(sampleType: HKWorkoutType.workoutType(), predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor]) { (_, results, error ) -> Void in
            
            var eligible = 0
            if let myResults = results as? [HKWorkout] {
                for workout in myResults where workout.duration >= 600 {
                    eligible += 1
                }
            }
            completion(eligible, error)
        }
        healthKitStore.execute(sampleQuery)
    }
    
    func getBodyMassData(forDate date: Date, _ completion: ((Double, Error?) -> Void)!) {
        let cal = Calendar.current
        var startComps = DateComponents()
        startComps.year = 2000
        startComps.month = 1
        startComps.day = 1
        let startDate = startComps.date
        var comps = DateComponents()
        comps.day = 1
        comps.second = -1
        
        let endDate = cal.date(byAdding: comps, to: cal.startOfDay(for: date))
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let weight = HKObjectType.quantityType(forIdentifier: .bodyMass)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: weight!, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            if error != nil {
                
                //  Something went Wrong
                return
            }
            var bodyMass = 0.0
            if let result = results?.first as? HKQuantitySample {
                bodyMass = result.quantity.doubleValue(for: HKUnit.pound())
            }
            completion(bodyMass, error)
        }
        healthKitStore.execute(query)
    }
    func getWaterData(forDate date: Date, _ completion: ((Double, Error?) -> Void)!) {
        let cal = Calendar.current
        
        let startDate = cal.startOfDay(for: date)
        var comps = DateComponents()
        comps.day = 1
        comps.second = -1
        
        let endDate = cal.date(byAdding: comps, to: startDate)
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let interval: NSDateComponents = NSDateComponents()
        interval.day = 1
        
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate, intervalComponents: interval as DateComponents)
        query.initialResultsHandler = { query, results, error in
            
            if error != nil {
                //  Something went Wrong
                return
            }
            var water = 0.0
            if let myResults = results, let endDate = endDate {
                myResults.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                    if let quantity = statistics.sumQuantity() {
                        water = quantity.doubleValue(for: HKUnit.fluidOunceUS())
                    }
                }
            }
            completion(floor(water), error)
        }
        healthKitStore.execute(query)
        
    }
    
    func getCaloriesData(forDate date: Date, _ completion: ((Double, Error?) -> Void)!) {
        let cal = Calendar.current
        
        let startDate = cal.startOfDay(for: date)
        var comps = DateComponents()
        comps.day = 1
        comps.second = -1
        
        let endDate = cal.date(byAdding: comps, to: startDate)
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let interval: NSDateComponents = NSDateComponents()
        interval.day = 1
        
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate as Date, intervalComponents: interval as DateComponents)
        query.initialResultsHandler = { query, results, error in
            
            if error != nil {
                //  Something went Wrong
                return
            }
            var calories = 0.0
            if let myResults = results, let endDate = endDate {
                myResults.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                    
                    if let quantity = statistics.sumQuantity() {
                        calories = quantity.doubleValue(for: HKUnit.kilocalorie())
                    }
                }
            }
            completion(calories, error)
        }
        healthKitStore.execute(query)
        
    }
    
    func getStandHours(forDate date: Date, _ completion: ((Int, Error?) -> Void)!) {
        let cal = Calendar.current
        
        var dateComponents = cal.dateComponents(
            [.year, .month, .day],
            from: date
        )
        dateComponents.calendar = cal
        let predicate = HKQuery.predicateForActivitySummary(with: dateComponents)
        
        let query = HKActivitySummaryQuery(predicate: predicate) { (_, summaries, error) in
            if error != nil {
                
                //  Something went Wrong
                return
            }
            var standHours = 0.0
            if let myResults = summaries {
                
                if myResults.count > 0 {
                    standHours = myResults[0].appleStandHours.doubleValue(for: HKUnit.count())
                }
            }
            completion(Int(standHours), error)
        }
        healthKitStore.execute(query)
    }
    
    func getMindSessions(forDate date: Date, _ completion: ((Int, Error?) -> Void)!) {
        let cal = Calendar.current
        
        let startDate = cal.startOfDay(for: date)
        var comps = DateComponents()
        comps.day = 1
        comps.second = -1
        
        let endDate = cal.date(byAdding: comps, to: startDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions())
        let sampleQuery = HKSampleQuery(sampleType: HKObjectType.categoryType(forIdentifier: .mindfulSession)!, predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor]) { (_, results, error ) -> Void in
            if error != nil {
                
                //  Something went Wrong
                return
            }
            var mindSessions = 0
            if let myResults = results {
                
                mindSessions = myResults.count
            }
            completion(mindSessions, error)
        }
        healthKitStore.execute(sampleQuery)
    }
    
    func getSleepAnalysis(forDate date: Date, _ completion: ((Int, Error?) -> Void)!) {
        let cal = Calendar.current
        
        let startDate = cal.startOfDay(for: date).addingTimeInterval(-3600 * 12)
        let endDate = cal.startOfDay(for: date).addingTimeInterval(3600 * 12)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions())
        let sampleQuery = HKSampleQuery(sampleType: HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!, predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor]) { (_, results, error ) -> Void in
            if error != nil {
                
                //  Something went Wrong
                return
            }
            var minutes = 0
            if let myResults = results {
                for item in myResults {
                    if let sample = item as? HKCategorySample {
                        
                        if sample.value == HKCategoryValueSleepAnalysis.asleep.rawValue {
                            minutes += Int(sample.endDate.timeIntervalSince(sample.startDate) / 60)
                        }
                    }
                }
            }
            completion(minutes, error)
        }
        
        healthKitStore.execute(sampleQuery)
    }
    
    func getActivityRings(forDate date: Date, _ completion: ((Double, Double, Double, Error?) -> Void)!) {
        let cal = Calendar.current
        
        var dateComponents = cal.dateComponents(
            [.year, .month, .day],
            from: date
        )
        dateComponents.calendar = cal
        let predicate = HKQuery.predicateForActivitySummary(with: dateComponents)
        
        let query = HKActivitySummaryQuery(predicate: predicate) { (_, summaries, error) in
            if error != nil {
                
                //  Something went Wrong
                return
            }
            var moveGoal = 0.0
            var standGoal = 0.0
            var exerciseGoal = 0.0
            if let myResults = summaries {
                
                if myResults.count > 0 {
                    moveGoal = myResults[0].activeEnergyBurnedGoal.doubleValue(for: HKUnit.kilocalorie())
                    standGoal = myResults[0].appleStandHoursGoal.doubleValue(for: .count())
                    exerciseGoal = myResults[0].appleExerciseTimeGoal.doubleValue(for: .minute())
                }
            }
            completion(moveGoal,exerciseGoal, standGoal, error)
        }
        healthKitStore.execute(query)
    }
    func loadHistoricDay(date: Date, _ completion: @escaping ((HistoryDay) -> Void)) {
        let historyDay = HistoryDay(date: date, points: 0)
        let group = DispatchGroup()
        
        group.enter()
        self.getActivityRings(forDate: date) { (mGoal,eGoal,sGoal, _) -> Void in
            historyDay.moveGoal = mGoal
            historyDay.exerciseGoal = eGoal
            historyDay.standGoal = sGoal
            group.leave()
        }
        group.enter()
        self.getStepData(forDate: date) { (temp, _) -> Void in
            historyDay.attributes.first(where: { $0.type == .steps})?.value = Int(temp)
            group.leave()
        }
        group.enter()
        self.getBodyMassData(forDate: date) { (temp, _) -> Void in
            historyDay.bodyMass = temp
            group.leave()
        }
        group.enter()
        self.getActiveEnergy(forDate: date) { (energy, _) -> Void in
            historyDay.attributes.first(where: { $0.type == .move })?.value = Int(energy)
            group.leave()
        }
        group.enter()
        self.getExerciseTime(forDate: date) { (time, _) -> Void in
            historyDay.attributes.first(where: { $0.type == .exercise })?.value = Int(time)
            group.leave()
        }
        group.enter()
        self.getWorkOutData(forDate: date) { (eligible, _) -> Void in
            historyDay.attributes.first(where: { $0.type == .workouts })?.value = Int(eligible)
            group.leave()
        }
        group.enter()
        self.getWaterData(forDate: date) { (water, _) -> Void in
            historyDay.attributes.first(where: { $0.type == .water })?.value = Int(water)
            group.leave()
        }
        group.enter()
        self.getStandHours(forDate: date) { (hours, _) -> Void in
            historyDay.attributes.first(where: { $0.type == .stand })?.value = Int(hours)
            group.leave()
        }
        group.enter()
        self.getMindSessions(forDate: date) { (mins, _) -> Void in
            historyDay.attributes.first(where: { $0.type == .mind })?.value = Int(mins)
            group.leave()
        }
        group.enter()
        self.getSleepAnalysis(forDate: date) { (time, _) -> Void in
            historyDay.attributes.first(where: { $0.type == .sleep })?.value = Int(time)
            group.leave()
        }
        group.enter()
        self.getCaloriesData(forDate: date) { (calories, _) -> Void in
            historyDay.attributes.first(where: { $0.type == .calories })?.value = Int(calories)
            group.leave()
            
        }
        group.notify(queue: .main) {
            completion(historyDay)
        }
    }
    
    
    
    
    
    
    func loadHealthDay() {
        
        getBodyMassData(forDate: Date()) { (bodyMass, _) -> Void in
            HealthDay.shared.bodyMass = bodyMass
        }
        getStepData(forDate: Date()) { (temp, _) -> Void in
            HealthDay.shared.attributes.first(where: { $0.type == .steps })?.value = Int(temp)
        }
        getWorkOutData(forDate: Date()) { (eligible, _) -> Void in
            HealthDay.shared.attributes.first(where: { $0.type == .workouts })?.value = Int(eligible)
        }
        getWaterData(forDate: Date()) { (water, _) -> Void in
            HealthDay.shared.attributes.first(where: { $0.type == .water })?.value = Int(water)
        }
        getStandHours(forDate: Date()) { (hours, _) -> Void in
            HealthDay.shared.attributes.first(where: { $0.type == .stand })?.value = Int(hours)
        }
        getMindSessions(forDate: Date()) { (mins, _) -> Void in
            HealthDay.shared.attributes.first(where: { $0.type == .mind })?.value = Int(mins)
        }
        getActiveEnergy(forDate: Date()) { (energy, _) -> Void in
            HealthDay.shared.attributes.first(where: { $0.type == .move })?.value = Int(energy)
        }
        getExerciseTime(forDate: Date()) { (time, _) -> Void in
            HealthDay.shared.attributes.first(where: { $0.type == .exercise })?.value = Int(time)
        }
        getSleepAnalysis(forDate: Date()) { (time, _) -> Void in
            HealthDay.shared.attributes.first(where: { $0.type == .sleep })?.value = Int(time)
        }
        getCaloriesData(forDate: Date()) { (calories, _) -> Void in
            HealthDay.shared.attributes.first(where: { $0.type == .calories })?.value = Int(calories)
        }
        getActivityRings(forDate: Date()) { (mGoal, eGoal, sGoal, _) -> Void in
            HealthDay.shared.moveGoal = mGoal
            HealthDay.shared.exerciseGoal = eGoal
            HealthDay.shared.standGoal = sGoal
        }
    }
    
    func valueChangedHandler(query: HKObserverQuery!, completionHandler: HKObserverQueryCompletionHandler!, error: Error!) {
        loadHealthDay()
        let defaults = UserDefaults.standard
        let lastUpdate = defaults.object(forKey: "lastUpdate") as? Date ?? Date()
        print("Last Update Date: \(lastUpdate.description) - Current Date: \(Date().description)")
        let calendar = Calendar.current
        let lastUpdateDay = calendar.component(.day, from: lastUpdate)
        let currentDay = calendar.component(.day, from: Date())
        
        if lastUpdateDay < currentDay {
            if let targetDate = calendar.date(byAdding: .day, value: -1, to: Date()) {
                loadHistoricDay(date: targetDate) { (day) in
                    let points = day.getPoints()
                    print("Ran Yesterday (\(targetDate.description): \(points)")
                    defaults.setValue(Date(), forKey: "lastUpdate")
                    //send local notification? - "Congrats you got X points yesterday"?
                }
            }
        }
        defaults.setValue(Date(), forKey: "lastUpdate")
        completionHandler()
    }
}
