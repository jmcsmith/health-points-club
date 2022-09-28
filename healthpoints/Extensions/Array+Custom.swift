//
//  Array+Custom.swift
//  healthpoints
//
//  Created by Joe Beaudoin on 9/28/22.
//  Copyright © 2022 Joseph Smith. All rights reserved.
//

import Foundation

extension Array {
    func split() -> [[Element]] {
        let ct = self.count
        let half = ct / 2
        let leftSplit = self[0 ..< half]
        let rightSplit = self[half ..< ct]
        return [Array(leftSplit), Array(rightSplit)]
    }
}
