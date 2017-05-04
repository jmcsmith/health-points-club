//
//  HealthDay.swift
//  healthpoints
//
//  Created by Joseph Smith on 5/4/17.
//  Copyright © 2017 healthpoints. All rights reserved.
//

import UIKit

class HealthDay: NSObject, NSCoding {
    var date = Date()

    override init() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        date =  aDecoder.decodeObject(forKey: "date") as! Date
        
        
    }
    
    
    
    //health attruibutes
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "date")
    }
}
