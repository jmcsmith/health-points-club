//
//  WidgetValue.swift
//  healthpoints
//
//  Created by Joe Beaudoin on 9/26/22.
//  Copyright © 2022 Joseph Smith. All rights reserved.
//

import Foundation
import UIKit

class WidgetValue: Codable {
    init(type: String, value: Int) {
        self.value = value
        self.type = type
    }
    var type: String
    var value: Int
}
