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
    }
    
    static let shared = HealthDay()
    
    
    var date: Date = Date()
    var steps: Int = 0
}
