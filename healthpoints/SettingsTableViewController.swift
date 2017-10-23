//
//  SettingsTableViewController.swift
//  healthpoints
//
//  Created by Joseph Smith on 5/3/17.
//  Copyright © 2017 healthpoints. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var darkButton: UIButton!
    @IBOutlet weak var lightButton: UIButton!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var darkModeSwitchLabel: UILabel!
    
    @IBOutlet weak var dailyCalories: UITextField!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var attributesLabel: UILabel!
    @IBOutlet weak var cellNumberSegmentedControl: UISegmentedControl!
    
    var darkmodeOn: Bool = false
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let iconName = UIApplication.shared.alternateIconName
        
        darkButton.imageView?.layer.cornerRadius = 10
        darkButton.imageView?.clipsToBounds = true
        darkButton.imageView?.layer.borderWidth = 3
        if iconName == "AppIcon-2" {
            darkButton.imageView?.layer.borderColor = UIColor.green.cgColor
        } else {
            darkButton.imageView?.layer.borderColor = UIColor.black.cgColor
        }
        
        lightButton.imageView?.layer.cornerRadius = 10
        lightButton.imageView?.clipsToBounds = true
        lightButton.imageView?.layer.borderWidth = 3
        if  (iconName) != nil {
            lightButton.imageView?.layer.borderColor = UIColor.black.cgColor
        } else {
            lightButton.imageView?.layer.borderColor = UIColor.green.cgColor
        }
        
        tableView.tableFooterView = UIView()
        
        darkmodeOn = UserDefaults.standard.bool(forKey: "darkmodeOn")
        
        darkModeSwitch.isOn = darkmodeOn
        
       
        
        dailyCalories.text = UserDefaults.standard.string(forKey: "dailyCalorieGoal")
        cellNumberSegmentedControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "numberOfCellsInRow")-2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func darkButtonClicked(_ sender: Any) {
        UIApplication.shared.setAlternateIconName("AppIcon-2") { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Success!")
                self.darkButton.imageView?.layer.borderColor = UIColor.green.cgColor
                self.lightButton.imageView?.layer.borderColor = UIColor.black.cgColor
            }
        }
    }
    
    @IBAction func lightButtonClicked(_ sender: Any) {
        
        UIApplication.shared.setAlternateIconName(nil) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Success!")
                self.darkButton.imageView?.layer.borderColor = UIColor.black.cgColor
                self.lightButton.imageView?.layer.borderColor = UIColor.green.cgColor
            }
        }
    }
    @IBAction func darkModeSwitched(_ sender: UISwitch) {
        
        UserDefaults.standard.setValue(sender.isOn, forKey: "darkmodeOn")
        darkmodeOn = sender.isOn
        if sender.isOn {
            Theme.dark.apply()
            
        } else {
            Theme.default.apply()
        }
        refreshUITheme()
    }
    func refreshUITheme(){
        for window in UIApplication.shared.windows {
            for view in window.subviews {
                view.removeFromSuperview()
                window.addSubview(view)
            }

        }
    }
    
    @IBAction func dailyCaloriesChanged(_ sender: UITextField) {
        UserDefaults.standard.setValue(sender.text, forKey: "dailyCalorieGoal")
    }
    @IBAction func cellNumberChanged(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex+2, forKey: "numberOfCellsInRow")
        
    }
    
 
    // MARK: - Table view data source
    
   
    
}

