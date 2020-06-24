//
//  HistoryAttribute.swift
//  healthpoints
//
//  Created by Joseph Smith on 5/16/18.
//  Copyright © 2018 Joseph Smith. All rights reserved.
//

import Foundation

class HistoryAttribute {
    var type: HistoryAttributeType
    var value: Int = 0 {
        
        didSet {
            if value != oldValue {
                //HealthDay.shared.setUpdateNotification()
            }
        }
    }
    
    init(type: HistoryAttributeType, value: Int) {
        self.type = type
        self.value = value
    }
    
    
    func getPoints(withHistoryDay day: HistoryDay) -> Int {
        return type.calculatePoints(withHistoryDay: day, forValue: Double(value))
    }
}

