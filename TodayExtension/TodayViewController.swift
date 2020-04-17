//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Joseph Smith on 10/28/17.
//  Copyright © 2017 Joseph Smith. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var todayPointTotal: UILabel!
    @IBOutlet weak var weeklyTotal: UILabel!
    @IBOutlet weak var allTimeHigh: UILabel!
    @IBOutlet weak var lifeTimeHigh: UILabel!
    let defaults = UserDefaults(suiteName: "group.HealthPointsClub")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        let data = defaults?.object(forKey: "widgetValues") as! Data
        let list = NSKeyedUnarchiver.unarchiveObject(with: data) as! [[Any]]
        
        var total = 0
        for attribute in list {
            total += attribute[1] as! Int
        }
        todayPointTotal.text = total.description
        
        let weeklyTotalValue = defaults?.integer(forKey: "weekTotal")
        weeklyTotal.text = "Weekly Total: " + (weeklyTotalValue?.description)!
        if let alltimeHighValue = defaults?.integer(forKey: "allTimeHigh"){
            allTimeHigh.text = "All Time High: " + (alltimeHighValue.description)
        }
        if let lifetimeTotalValue = defaults?.integer(forKey: "lifetimeTotal"){
            lifeTimeHigh.text = "Life Time Total: " + (lifetimeTotalValue.description)
        }
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let data = defaults?.object(forKey: "widgetValues") as! Data
        let list = NSKeyedUnarchiver.unarchiveObject(with: data) as! [[Any]]
        
        var total = 0
        for attribute in list {
            total += attribute[1] as! Int
        }
        todayPointTotal.text = total.description
        todayPointTotal.textColor = .white
        let weeklyTotalValue = defaults?.integer(forKey: "weekTotal")
        weeklyTotal.text = "Weekly Total: " + (weeklyTotalValue?.description)!
        if let alltimeHighValue = defaults?.integer(forKey: "allTimeHigh"){
            allTimeHigh.text = "All Time High: " + (alltimeHighValue.description)
        }
        if let lifetimeTotalValue = defaults?.integer(forKey: "lifetimeTotal"){
            lifeTimeHigh.text = "Life Time Total: " + (lifetimeTotalValue.description)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
