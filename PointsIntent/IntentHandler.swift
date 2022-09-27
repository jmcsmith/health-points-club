//
//  IntentHandler.swift
//  PointsIntent
//
//  Created by Joseph Smith on 10/1/20.
//  Copyright © 2020 Joseph Smith. All rights reserved.
//

import Intents

class IntentHandler: INExtension, ConfigurationIntentHandling {

    
    func provideAttributeOptionsCollection(for intent: ConfigurationIntent, with completion: @escaping (INObjectCollection<Attribute>?, Error?) -> Void) {
        completion(INObjectCollection(items: [
            Attribute(identifier: "10", display: "Total Points"),
            Attribute(identifier: "0", display: "Steps"),
            Attribute(identifier: "1", display: "Workouts"),
            Attribute(identifier: "2", display: "Water"),
            Attribute(identifier: "3", display: "Sleep"),
            Attribute(identifier: "4", display: "Mind Sessions"),
            Attribute(identifier: "5", display: "Stand Hours"),
            Attribute(identifier: "6", display: "Exercise"),
            Attribute(identifier: "7", display: "Move"),
            Attribute(identifier: "8", display: "Rings"),
            Attribute(identifier: "9", display: "Calories")
        ]),nil)
    }
    func defaultAttribute(for intent: ConfigurationIntent) -> Attribute? {
        return Attribute(identifier: "10", display: "Total Points")
    }
    
}
