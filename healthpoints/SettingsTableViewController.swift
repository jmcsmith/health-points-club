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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let iconName = UIApplication.shared.alternateIconName
        
        darkButton.imageView?.layer.cornerRadius = 10
        darkButton.imageView?.clipsToBounds = true
        darkButton.imageView?.layer.borderWidth = 3
        if iconName == "AppIcon-2" {
            darkButton.imageView?.layer.borderColor = UIColor.green.cgColor
        }else{
            darkButton.imageView?.layer.borderColor = UIColor.black.cgColor
        }
        
        
        lightButton.imageView?.layer.cornerRadius = 10
        lightButton.imageView?.clipsToBounds = true
        lightButton.imageView?.layer.borderWidth = 3
        if  ((iconName) != nil) {
            lightButton.imageView?.layer.borderColor = UIColor.black.cgColor
        }else{
            lightButton.imageView?.layer.borderColor = UIColor.green.cgColor
        }
        
        tableView.tableFooterView = UIView()
        
        let darkmodeOn = UserDefaults.standard.bool(forKey: "darkmodeOn")
        
        darkModeSwitch.isOn = darkmodeOn
        
        if darkmodeOn {
            EnableDarkMode()
        }else{
            DisableDarkMode()
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
        if sender.isOn {
            EnableDarkMode()
        }else{
            DisableDarkMode()
        }
    }
    
    func EnableDarkMode()  {
        tableView.backgroundColor = UIColor.darkGray
        for cell in tableView.visibleCells{
            cell.backgroundColor = UIColor.darkGray
        }
        for index in 0..<tableView.numberOfSections{
            
            
            tableView.headerView(forSection: index)?.backgroundView?.backgroundColor = UIColor.black
            tableView.headerView(forSection: index)?.textLabel?.textColor = UIColor.white
        }
        navigationController?.navigationBar.barTintColor = UIColor.darkGray
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    func DisableDarkMode()  {
        tableView.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.00)
        for cell in tableView.visibleCells{
            cell.backgroundColor = UIColor.white
        }
        for index in 0..<tableView.numberOfSections{
            
            
            tableView.headerView(forSection: index)?.backgroundView?.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.00)
            tableView.headerView(forSection: index)?.textLabel?.textColor = UIColor.darkGray
        }
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]

    }
    // MARK: - Table view data source
    
    
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
