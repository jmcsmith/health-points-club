//
//  AttributeType.swift
//  healthpoints
//
//  Created by Joseph Smith on 5/5/18.
//  Copyright © 2018 Joseph Smith. All rights reserved.
//

import Foundation
import UIKit

enum AttributeType: String {
    case steps = "Steps"
    case water = "Water"
    case stand = "Stand Hours"
    case sleep = "Sleep"
    case workouts = "Workouts"
    case mind = "Mind Sessions"
    case move = "Move"
    case exercise = "Exercise"
    case rings = "⌚️ Rings"
    case calories = "Calories"
    
    func calculatePoints(withWeight weight: Double, forValue value: Double, withBodyMass bodyMass: Double) -> Int {
        switch self {
        case .steps:
            return (Int((value/1000)*weight))
        case .stand:
            let goal = HealthDay.shared.standGoal
            if goal > 0 && value >= goal {
                let base = value/goal
                return Int(base*weight)
            } else {
                return 0
            }
            
        case .workouts:
            return Int(value*weight)
        case .water:
            if bodyMass == 0.0 {
                if value >= 64.0 {
                    return Int(1*weight)
                } else {
                    return 0
                }
            } else {
                var base = bodyMass/2
                
                if let exercise = HealthDay.shared.attributes.first(where: {$0.type == .exercise})?.value {
                    let additional = Double(exercise) * 0.4
                    base += additional
                }
                if value >= base {
                    return 1
                }
                return 0
            }
        case .mind:
            return Int(value)
        case .exercise:
            let goal = HealthDay.shared.exerciseGoal
            if goal > 0 && value >= goal {
                let base = value/goal
                return Int(base*weight)
            } else {
                return 0
            }
        case .move:
            let goal = HealthDay.shared.moveGoal
            if goal > 0 {
                return Int((value/goal)*weight)
            } else {
                return 0
            }
        case .rings:
            let stand = (HealthDay.shared.attributes.first(where: {$0.type == .stand})?.getPoints(withWeight: weight, withBodyMass: bodyMass))!
            let move = (HealthDay.shared.attributes.first(where: {$0.type == .move})?.getPoints(withWeight: weight, withBodyMass: bodyMass))!
            let exercise = (HealthDay.shared.attributes.first(where: {$0.type == .exercise})?.getPoints(withWeight: weight, withBodyMass: bodyMass))!
            if stand >= 1 && move >= 1 && exercise >= 1 {
                
                HealthDay.shared.attributes.first(where: {$0.type == .rings})?.value = 3
                
                return Int(1*weight)
                
            } else {
                var temp  = 0
                if stand > 0 {
                    temp = temp + 1
                }
                if move > 0 {
                    temp = temp + 1
                }
                if exercise > 0 {
                    temp = temp + 1
                }
                HealthDay.shared.attributes.first(where: {$0.type == .rings})?.value = temp
                return 0
            }
        case .sleep:
            if value >= 420 && value < 540{
                return Int(1*weight)
            } else {
                return 0
            }
        case .calories:
            let goal = UserDefaults.standard.double(forKey: "dailyCalorieGoal")
            
            if value > 0 && goal > 0 && value <= goal {
                return Int(1*weight)
            } else {
                return 0
            }
            
        }
    }
    func displayText(forValue value: Int) -> String {
        
        switch self {
        case .steps:
            return "\(value)"
        case .stand:
            return "\(value) hours"
        case .workouts:
            return "\(value) > 10 mins"
        case .water:
            let bodyMass = HealthDay.shared.bodyMass
            if bodyMass == 0.0 {
                return "\(value) fl oz"
            } else {
                var base = bodyMass/2
                
                if let exercise = HealthDay.shared.attributes.first(where: {$0.type == .exercise})?.value {
                    let additional = Double(exercise) * 0.4
                    base += additional
                }
                return "\(value) of \(Int(base)) fl oz"
            }
        case .mind:
            return "\(value)"
        case .move:
            return "\(value) Calories"
        case .exercise:
            return "\(value) Minutes"
        case .rings:
            return "\(value) Rings Closed"
        case .sleep:
            return "\(value/60) Hours"
        case .calories:
            return "\(value) Consumed"
            
        }
    }
   public func getBackgroundColor() -> UIColor {
        switch self {
        case .steps:
            return UIColor(red:0.91, green:0.36, blue:0.28, alpha:1.00)
        case .stand:
            return UIColor(red:0.38, green:0.87, blue:0.84, alpha:1.00)
        case .workouts:
            return UIColor(red:0.91, green:0.36, blue:0.28, alpha:1.00)
        case .water:
            return UIColor(red:0.38, green:0.75, blue:0.98, alpha:1.00)
        case .mind:
            return UIColor(red:0.33, green:0.73, blue:0.82, alpha:1.00)
        case .exercise:
            return UIColor(red:0.66, green:0.95, blue:0.29, alpha:1.00)
        case .move:
            return UIColor(red:0.89, green:0.24, blue:0.37, alpha:1.00)
        case .sleep:
            return UIColor(red:0.49, green:0.36, blue:0.92, alpha:1.00)
        case  .calories:
            return UIColor(red:0.32, green:0.71, blue:0.30, alpha:1.00)
        case .rings:
            return UIColor.lightGray
            
        }
    }
}



