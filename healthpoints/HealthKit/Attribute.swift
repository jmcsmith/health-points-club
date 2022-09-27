//
//  Attribute.swift
//  healthpoints
//
//  Created by Joseph Smith on 5/5/18.
//  Copyright © 2018 Joseph Smith. All rights reserved.
//

import Foundation
import UIKit

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
    
    func getPoints(withWeight weight: Double, withBodyMass bodyMass: Double) -> Int {
        return type.calculatePoints(withWeight: weight, forValue: Double(value), withBodyMass: bodyMass)
    }
}

