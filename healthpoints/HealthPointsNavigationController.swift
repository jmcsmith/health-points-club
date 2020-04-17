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

        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let current = Theme.current
        print("theme "+current.description)
        if Theme.current == .default {
            if #available(iOS 13, *) {
                return .darkContent
            }
            return .default
        } else {
            return .lightContent
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
