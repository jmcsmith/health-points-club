//
//  HistoryDay.swift
//  healthpoints
//
//  Created by Joseph Smith on 5/4/18.
//  Copyright © 2018 Joseph Smith. All rights reserved.
//

import Foundation

class HistoryDay: NSObject, NSCoding {
    var date: Date = Date()
    var points: Int = 0
    
    var attributes: [HistoryAttribute] = []
    var moveGoal: Double = 0.0
    var standGoal = 0.0
    var exerciseGoal = 0.0
    var bodyMass: Double = 0.0
    
    override init() {
        attributes.append(HistoryAttribute(type: .steps, value: 0))
        attributes.append(HistoryAttribute(type: .workouts, value: 0))
        attributes.append(HistoryAttribute(type: .water, value: 0))
        attributes.append(HistoryAttribute(type: .sleep, value: 0))
        attributes.append(HistoryAttribute(type: .mind, value: 0))
        attributes.append(HistoryAttribute(type: .stand, value: 0))
        attributes.append(HistoryAttribute(type: .exercise, value: 0))
        attributes.append(HistoryAttribute(type: .move, value: 0))
        attributes.append(HistoryAttribute(type: .rings, value: 0))
        attributes.append(HistoryAttribute(type: .calories, value: 0))
    }
    
    convenience init(date: Date, points: Int) {
        self.init()
        self.date = date
        self.points = points
    }
    func getPoints() -> Int {
        var points = 0
        let cal = Calendar.current
        
        let dateComponents = cal.dateComponents(
            [ .year, .month, .day ],
            from: date
        )
        
        for a in attributes {
            points += a.getPoints(withHistoryDay: self)
        }
        if let index = HealthDay.shared.history.firstIndex(where: {cal.dateComponents([ .year, .month, .day ], from: $0.date) == dateComponents}){
            HealthDay.shared.history[index].points = points
        }else{
            HealthDay.shared.history.append(HistoryDay(date: cal.date(from: dateComponents)!,points: points))
        }
        saveHistory()
        HealthDay.shared.updateWidgetValues()
        print("Get Points - \(points)")
        return points
    }
    func saveHistory(){
        let history = HealthDay.shared.history.sorted(by: {$0.date > $1.date} )
        let h = NSKeyedArchiver.archivedData(withRootObject: history)
        UserDefaults.standard.set(h, forKey: "history")
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
