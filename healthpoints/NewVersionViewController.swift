//
//  NewVersionViewController.swift
//  healthpoints
//
//  Created by Joseph Smith on 2/3/18.
//  Copyright © 2018 Joseph Smith. All rights reserved.
//

import UIKit

class NewVersionViewController: UIViewController {
    let hkHelper = HealthKitHelper()
        let defaults:UserDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func authorizeNewVersionHealthKit(_ sender: Any) {
        let currentVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        self.defaults.set(currentVersion, forKey: "lastOpenVersion")
        hkHelper.authorizeHealthKit { (authorized, error) -> Void in
            if authorized {
                print("HealthKit authorization received.")
                self.hkHelper.loadHealthDay()
                
                //DispatchQueue.main.async(execute: self.closeView())
                self.dismiss(animated: true, completion: nil)
            } else {
                print("HealthKit authorization denied!")
                if error != nil {
                    print("\(error.debugDescription)")
                }
                
                //DispatchQueue.main.async(execute: self.closeView())
                self.dismiss(animated: true, completion: nil)
            }
        }
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
