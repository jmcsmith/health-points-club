//
//  HealthDay.swift
//  healthpoints
//
//  Created by Joseph Smith on 5/4/17.
//  Copyright © 2017 healthpoints. All rights reserved.
//

import UIKit

final class HealthDay {
    private init() {
        //if date != current date, reset?
        attributes.append(Attribute(type: .steps, value: 0))
        attributes.append(Attribute(type: .workouts, value: 0))
        attributes.append(Attribute(type: .water, value: 0))
        attributes.append(Attribute(type: .sleep, value: 0))
        attributes.append(Attribute(type: .mind, value: 0))
        attributes.append(Attribute(type: .stand, value: 0))
        attributes.append(Attribute(type: .exercise, value: 0))
        attributes.append(Attribute(type: .move, value: 0))
        attributes.append(Attribute(type: .rings, value: 0))
        attributes.append(Attribute(type: .calories, value: 0))
    }
    
    static let shared = HealthDay()
    
    var date: Date = Date()
    
    var attributes: [Attribute] = []
    
    var moveGoal: Double = 0.0
    var history: [HistoryDay] = []
    func setUpdateNotification() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateUIFromHealthDay"), object: nil)
    }
    
    func getPoints() -> Int {
        var points = 0
        let cal = Calendar.current
        
        let dateComponents = cal.dateComponents(
            [ .year, .month, .day ],
            from: Date()
        )
        
        for a in attributes {
            points += a.getPoints(withWeight: 1)
        }
        if let index = history.index(where: {cal.dateComponents([ .year, .month, .day ], from: $0.date) == dateComponents}){
            history[index].points = points
        }else{
            history.append(HistoryDay(date: cal.date(from: dateComponents)!,points: points))
        }
        let h = NSKeyedArchiver.archivedData(withRootObject: history)
        //UserDefaults.standard.set(h, forKey: "history")
        return points
    }
}
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
    
    func calculatePoints(withWeight weight: Double, forValue value: Double) -> Int {
        switch self {
        case .steps:
            return (Int((value/1000)*weight))
        case .stand:
            if value >= 12 {
                return Int(1*weight)
            } else {
                return 0
            }
            
        case .workouts:
            return Int(value*weight)
        case .water:
            if value >= 8.0 {
                return Int(1*weight)
            } else {
                return 0
            }
        case .mind:
            return Int(value)
        case .exercise:
            if value >= 30 {
                let base = value/30.0
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
            let stand = (HealthDay.shared.attributes.first(where: {$0.type == .stand})?.getPoints(withWeight: weight))!
            let move = (HealthDay.shared.attributes.first(where: {$0.type == .move})?.getPoints(withWeight: weight))!
            let exercise = (HealthDay.shared.attributes.first(where: {$0.type == .exercise})?.getPoints(withWeight: weight))!
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
            if value >= 480 {
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
        default:
            return 0
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
            return "\(value) cups"
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
        default:
            return ""
        }
    }
    func getBackgroundColor() -> UIColor {
        switch self {
        case .steps:
            return UIColor(red:0.91, green:0.36, blue:0.28, alpha:1.00)
        case .stand:
            return UIColor(red:0.38, green:0.87, blue:0.84, alpha:1.00)
        case .workouts:
            return UIColor(red:0.91, green:0.36, blue:0.28, alpha:1.00)
        case .water:
            return UIColor(red:0.32, green:0.71, blue:0.30, alpha:1.00)
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
        default:
            return UIColor.darkGray
        }
    }
}
class Attribute {
    var type: AttributeType
    var value: Int = 0 {
        
        didSet {
            if value != oldValue {
                HealthDay.shared.setUpdateNotification()
            }
            
            
        }
    }
    
    init(type: AttributeType, value: Int) {
        self.type = type
        self.value = value
    }
    
    func getPoints(withWeight weight: Double) -> Int {
        return type.calculatePoints(withWeight: weight, forValue: Double(value))
    }
}
class HistoryDay: NSObject, NSCoding {
    var date: Date = Date()
    var points: Int = 0

    init(date: Date, points: Int) {
        self.date = date
        self.points = points
    }
    
    required init(coder aDecoder: NSCoder) {
        date = aDecoder.decodeObject(forKey: "date") as! Date
        points = Int(aDecoder.decodeCInt(forKey: "points"))
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "date")
        aCoder.encode(points, forKey: "points")
    }
}
