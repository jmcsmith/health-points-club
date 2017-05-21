//
//  SettingsTableViewController.swift
//  healthpoints
//
//  Created by Joseph Smith on 5/3/17.
//  Copyright © 2017 healthpoints. All rights reserved.
//

import UIKit
import HealthKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var darkButton: UIButton!
    @IBOutlet weak var lightButton: UIButton!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var darkModeSwitchLabel: UILabel!
    @IBOutlet weak var healthKitLabel: UILabel!
    var darkmodeOn: Bool = false

    let healthStore = HKHealthStore()

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

        if darkmodeOn {
            enableDarkMode()
        } else {
            disableDarkMode()
        }
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
            enableDarkMode()
        } else {
            disableDarkMode()
        }
    }

    func enableDarkMode() {
        tableView.backgroundColor = UIColor(red:0.24, green:0.25, blue:0.25, alpha:1.00)
        darkModeSwitchLabel.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
        healthKitLabel.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
        for cell in tableView.visibleCells {
            cell.backgroundColor = UIColor(red:0.18, green:0.20, blue:0.20, alpha:1.00)
        }
        for index in 0..<tableView.numberOfSections {

            tableView.headerView(forSection: index)?.backgroundView?.backgroundColor = UIColor(red:0.24, green:0.25, blue:0.25, alpha:1.00)
            tableView.headerView(forSection: index)?.textLabel?.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
        }
        navigationController?.navigationBar.barTintColor = UIColor(red:0.14, green:0.15, blue:0.15, alpha:1.00)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)]

    }

    func disableDarkMode() {
        tableView.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.00)
        darkModeSwitchLabel.textColor = UIColor.black
        healthKitLabel.textColor = UIColor.black
        for cell in tableView.visibleCells {
            cell.backgroundColor = UIColor.white
        }
        for index in 0..<tableView.numberOfSections {

            tableView.headerView(forSection: index)?.backgroundView?.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.00)
            tableView.headerView(forSection: index)?.textLabel?.textColor = UIColor.darkGray
        }
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]

    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if darkmodeOn {
            return .lightContent
        }
        return .default

    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.section == 2 && indexPath.row == 0 {
            let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
            let waterCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)

                  let dataTypesToWrite: Set<HKSampleType> = []
            let dataTypesToRead: Set<HKObjectType> = [stepsCount!, waterCount!, HKWorkoutType.workoutType(), HKActivitySummaryType.activitySummaryType()]

            healthStore.requestAuthorization(toShare: dataTypesToWrite, read: dataTypesToRead) { (_, _) -> Void in

            }

        }

    }

}
