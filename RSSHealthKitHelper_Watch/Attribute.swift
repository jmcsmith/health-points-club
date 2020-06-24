//
//  Attribute.swift
//  healthpoints
//
//  Created by Joseph Smith on 5/5/18.
//  Copyright © 2018 Joseph Smith. All rights reserved.
//

import Foundation

public class Attribute {
    public var type: AttributeType
    public var value: Int = 0 {
        
        didSet {
            if value != oldValue {
                HealthDay.shared.setUpdateNotification()
            }
        }
    }
    
    public init(type: AttributeType, value: Int) {
        self.type = type
        self.value = value
    }
    
   public func getPoints(withWeight weight: Double, withBodyMass bodyMass: Double) -> Int {
        return type.calculatePoints(withWeight: weight, forValue: Double(value), withBodyMass: bodyMass)
    }
}
