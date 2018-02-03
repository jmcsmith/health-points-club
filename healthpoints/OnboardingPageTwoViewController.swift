//
//  OnboardingPageTwoViewController.swift
//  healthpointsclub
//
//  Created by Joseph Smith on 10/2/17.
//  Copyright © 2017 Joseph Smith. All rights reserved.
//

import UIKit

class OnboardingPageTwoViewController: UIViewController {
    let defaults:UserDefaults = UserDefaults.standard
    let hkHelper = HealthKitHelper()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneOnboarding(_ sender: Any) {
//        hkHelper.authorizeHealthKit { (authorized, error) -> Void in
//            if authorized {
//                print("HealthKit authorization received.")
//                self.hkHelper.preLoadHealthDay()
//            } else {
//                print("HealthKit authorization denied!")
//                if error != nil {
//                    print("\(error.debugDescription)")
//                }
//            }
//        }
//        print("start healthkit queries")
        defaults.set(true, forKey: "hasopenedbefore")
       
        performSegue(withIdentifier: "doneOnboarding", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
