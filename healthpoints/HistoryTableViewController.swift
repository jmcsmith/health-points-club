//
//  HistoryTableViewController.swift
//  healthpointsclub
//
//  Created by Joseph Smith on 10/7/17.
//  Copyright © 2017 Joseph Smith. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func refreshHistory(_ sender: Any) {
        let alert = UIAlertController(title: "Update", message: "Your History is being updated. Please Wait.", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { action in
            //action.isEnabled = false
            alert.addAction(action)
           
        })
        print("refresh")
        self.present(alert, animated: true, completion: nil)
        self.refresh(alert: alert, action: action)
    }
    func refresh(alert: UIAlertController, action: UIAlertAction) {
        let original = HealthDay.shared.history.reduce(0) {$0 + $1.points}
        let originalHighScore = HealthDay.shared.history.map{ $0.points }.max()!
        var newTotal = 0
        var newHighScore = 0
        
        let hkHelper = HealthKitHelper()
        
        let group = DispatchGroup()
        
        for day in HealthDay.shared.history {
            group.enter()
            if let index = HealthDay.shared.history.firstIndex(of: day){
                hkHelper.loadHistoricDay(date: day.date) { (day) in
                    let points = day.getPoints()
                    print("\(day.date) - \(points)")
                    DispatchQueue.main.async {
                        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: UITableView.RowAnimation.none)
                    }
                    group.leave()
                }
            }
            
        }
        group.notify(queue: .main) {
            newTotal = HealthDay.shared.history.reduce(0) {$0 + $1.points}
            let points = HealthDay.shared.history.map{ $0.points }
            if let newscore = points.max() {
                newHighScore = newscore
            } else {
                newHighScore = 0
            }
            
            alert.message = "Total Points: \(original) -> \(newTotal) \nAll Time High: \(originalHighScore) -> \(newHighScore)"
            action.isEnabled = true
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HealthDay.shared.history.count
    }
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let refreshAction = UIContextualAction(style: .normal, title: "Refresh") { (contextaction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            print("update history day at \(indexPath.row)")
            let date = HealthDay.shared.history[indexPath.row].date
            let hkHelper = HealthKitHelper()
            
            hkHelper.loadHistoricDay(date: date) { (day) -> Void in
                _ = day.getPoints()
                DispatchQueue.main.async {
                    tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                }
                
            }
            completionHandler(true)
            
        }
        refreshAction.backgroundColor = UIColor.gray
        
        return UISwipeActionsConfiguration(actions: [refreshAction])
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell
        
        // Configure the cell...
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        cell.dateLabel?.text = formatter.string(from: HealthDay.shared.history[indexPath.row].date)
        cell.pointsLabel?.text = HealthDay.shared.history[indexPath.row].points.description
        
        return cell
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
