//
//  AttributesLoader.swift
//  healthpoints-watch Extension
//
//  Created by Joseph Smith on 10/2/20.
//  Copyright © 2020 Joseph Smith. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import RSSHealthKitHelper_Watch

class AttributesLoader: ObservableObject {
    var attributes: [Attribute]?
    let objectWillChange = PassthroughSubject<AttributesLoader?, Never>()
    func load() {
        attributes = HealthDay.shared.attributes
        self.objectWillChange.send(self)
    }
}
