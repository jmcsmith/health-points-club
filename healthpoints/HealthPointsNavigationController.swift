//
//  HealthPointsNavigationController.swift
//  healthpoints
//
//  Created by Joseph Smith on 4/17/20.
//  Copyright © 2020 Joseph Smith. All rights reserved.
//

import UIKit

class HealthPointsNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if Theme.current == .default {
            if #available(iOS 13, *) {
                return .darkContent
            }
            return .default
        } else {
            return .lightContent
        }
    }


}
