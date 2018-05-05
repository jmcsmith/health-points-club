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
    
    var attributes: [Attribute] = []
    var moveGoal: Double = 0.0
    var bodyMass: Double = 0.0
    
    override init() {
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
    
    convenience init(date: Date, points: Int) {
        self.init()
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
