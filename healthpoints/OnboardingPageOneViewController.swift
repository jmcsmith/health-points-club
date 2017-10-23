//
//  OnboardingPageOneViewController.swift
//  healthpointsclub
//
//  Created by Joseph Smith on 10/2/17.
//  Copyright © 2017 Joseph Smith. All rights reserved.
//

import UIKit

class OnboardingPageOneViewController: UIViewController {
    let hkHelper = HealthKitHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func authorize(_ sender: Any) {
        print("authorize Healthkit")
        hkHelper.authorizeHealthKit { (authorized, error) -> Void in
            if authorized {
                print("HealthKit authorization received.")
                self.hkHelper.preLoadHealthDay()
                DispatchQueue.main.async(execute: self.moveToPageTwo)
            } else {
                print("HealthKit authorization denied!")
                if error != nil {
                    print("\(error.debugDescription)")
                }
                DispatchQueue.main.async(execute: self.moveToPageTwo)
            }
        }
        
    }
    func moveToPageTwo() {
        self.performSegue(withIdentifier: "onboardingP2", sender: self)
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
