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
    }

    static let shared = HealthDay()

    var date: Date = Date()

    var attributes: [Attribute] = []

    func setUpdateNotification() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateUIFromHealthDay"), object: nil)
    }

    func getPoints() -> Int {
        var points = 0
        for a in attributes {
            points += a.getPoints(withWeight: 1)
        }
        return points
    }
}
enum AttributeType: String {
    case steps = "Steps"
    case water = "Water"
    case stand = "Stand Hours"
    case sleep = "Sleep Hours"
    case workouts = "Workouts"

    func calculatePoints(withWeight weight: Double, forValue value: Double) -> Int {
        switch self {
        case .steps:
            return (Int((value/1000)*weight))
        case .stand:
            return Int(value)
        case .workouts:
            return Int(value)
        case .water:
            if value >= 8.0 {
                return 1
            } else {
                return 0
            }
        default:
            return 0
        }
    }
}
class Attribute {
    var type: AttributeType
    var value: Int = 0 {

        didSet {

            HealthDay.shared.setUpdateNotification()

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
