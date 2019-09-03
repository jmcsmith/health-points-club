//
//  HealthDay.swift
//  healthpoints
//
//  Created by Joseph Smith on 5/4/17.
//  Copyright © 2017 healthpoints. All rights reserved.
//

import UIKit

public class HealthDay {
    private init() {
        let defaults = UserDefaults(suiteName: "group.HealthPointsClub")
        defaultAttributes = defaults?.object(forKey: "attributeOrder") as? [String]
        if defaultAttributes != nil {
            for attribute in defaultAttributes!{
                attributes.append(Attribute(type: AttributeType.init(rawValue: attribute)!, value: 0))
            }
        }else{
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
            
            saveAttributeOrder()
        }
    }
    
    static let shared = HealthDay()
    
    var date: Date = Date()
    
    var attributes: [Attribute] = []
    var defaultAttributes: [String]? = []
    var moveGoal: Double = 0.0
    var history: [HistoryDay] = []
    var bodyMass: Double = 0.0
    
    let defaults = UserDefaults(suiteName: "group.HealthPointsClub")
    
    func setUpdateNotification() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateUIFromHealthDay"), object: nil)
        print("--------Notification Sent--------")
    }
    func saveAttributeOrder(){
        defaultAttributes = attributes.map({$0.type.rawValue})
        defaults?.set(defaultAttributes, forKey: "attributeOrder")
    }
    func getPoints() -> Int {
        var points = 0
        let cal = Calendar.current
        
        let dateComponents = cal.dateComponents(
            [ .year, .month, .day ],
            from: Date()
        )
        
        for a in attributes {
            points += a.getPoints(withWeight: 1, withBodyMass: bodyMass)
        }
        if let index = history.firstIndex(where: {cal.dateComponents([ .year, .month, .day ], from: $0.date) == dateComponents}){
            history[index].points = points
        }else{
            history.append(HistoryDay(date: cal.date(from: dateComponents)!,points: points))
        }
        saveHistory()
        print("Get Points - \(points)")
        updateWidgetValues()
        return points
    }
    func saveHistory(){
        history = history.sorted(by: {$0.date > $1.date} )
        let h = NSKeyedArchiver.archivedData(withRootObject: history)
        UserDefaults.standard.set(h, forKey: "history")
    }
    func updateWidgetValues(){
        let encoded = attributes.map {[$0.type.rawValue, $0.getPoints(withWeight: 1.0, withBodyMass: bodyMass), $0.type.getBackgroundColor()]}
        let values = NSKeyedArchiver.archivedData(withRootObject: encoded)
        defaults?.set(values, forKey: "widgetValues")
        
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dayOfWeek = calendar.component(.weekday, from: today)
        let week = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let days = (week.lowerBound ..< week.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
        
        var weekTotal = 0
        var lifetimeTotal = 0
        var alltimeHigh = 0
        for day in history{
            if day.points > alltimeHigh{
                alltimeHigh = day.points
            }
            if days.contains(day.date)
            {
                weekTotal += day.points
            }
            lifetimeTotal += day.points
        }
        defaults?.set(weekTotal, forKey: "weekTotal")
        defaults?.set(alltimeHigh, forKey: "allTimeHigh")
        defaults?.set(lifetimeTotal, forKey: "lifetimeTotal")
        
        
        
    }
}
