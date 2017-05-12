//
//  PointsViewController.swift
//  healthpoints
//
//  Created by Joseph Smith on 5/3/17.
//  Copyright © 2017 healthpoints. All rights reserved.
//

import UIKit

class PointsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    let datasource = ["Steps", "Water", "Stand", "Sleep", "Calorie Goal", "Workouts", "Sodium", "Carbs"]

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name(rawValue: "updateUIFromHealthDay"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)

        self.tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: -20, right: 0)
        // Do any additional setup after loading the view.
        print(HealthDay.shared.steps.description)
        pointsLabel.text = HealthDay.shared.steps.description
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
print(HealthDay.shared.steps.description)
        pointsLabel.text = HealthDay.shared.steps.description

        let darkmodeOn = UserDefaults.standard.bool(forKey: "darkmodeOn")

        if darkmodeOn {
            enableDarkMode()
        } else {
            disableDarkMode()
        }
    }
    func enableDarkMode() {
        view.backgroundColor = UIColor(red:0.24, green:0.25, blue:0.25, alpha:1.00)
        navigationController?.navigationBar.barTintColor = UIColor(red:0.14, green:0.15, blue:0.15, alpha:1.00)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)]

        tableView.backgroundColor = UIColor(red:0.24, green:0.25, blue:0.25, alpha:1.00)

        for cell in tableView.visibleCells {
            cell.backgroundColor = UIColor(red:0.18, green:0.20, blue:0.20, alpha:1.00)
            cell.textLabel?.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
            cell.detailTextLabel?.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
        }
    }

    func disableDarkMode() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]

        tableView.backgroundColor = UIColor.white

        for cell in tableView.visibleCells {
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.black
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "attributeCell")!
        cell.textLabel?.text = datasource[indexPath.row]

        return cell
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func updateUI() {
        pointsLabel.text = HealthDay.shared.steps.description
    }
}
