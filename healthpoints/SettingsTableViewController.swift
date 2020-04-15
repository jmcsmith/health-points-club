//
//  SettingsTableViewController.swift
//  healthpoints
//
//  Created by Joseph Smith on 5/3/17.
//  Copyright © 2017 healthpoints. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UIDocumentPickerDelegate {
    
    
    
    @IBOutlet weak var darkButton: UIButton!
    @IBOutlet weak var lightButton: UIButton!
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var pitchBlackSwitch: UISwitch!
    
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
        
        switch Theme.current {
        case .dark:
            darkModeSwitch.isOn = true
            pitchBlackSwitch.isOn = false
        case .pitchBlack:
            pitchBlackSwitch.isOn = true
            darkModeSwitch.isOn = false
        default: 
            pitchBlackSwitch.isOn = false
            darkModeSwitch.isOn = false
        }
        
        
        
        
        
        dailyCalories.text = UserDefaults.standard.string(forKey: "dailyCalorieGoal")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 4 {
            switch indexPath.row {
            case 0:
                if let url = URL(string: "https://www.healthpoints.club/privacy") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            case 1:
                if let url = URL(string: "https://www.healthpoints.club"){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            case 2:
                if let url = URL(string: "https://www.roboticsnailsoftware.com"){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            default:
                return
            }
        }
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
        pitchBlackSwitch.isOn = false
        
        if sender.isOn {
            Theme.dark.apply()
            
        } else {
            Theme.default.apply()
        }
        refreshUITheme()
    }
    @IBAction func pitchBlackSwitch(sender: UISwitch) {
        darkModeSwitch.isOn = false
        if sender.isOn {
            Theme.pitchBlack.apply()
            
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
    
    
    @IBAction func backupButtonClicked(_ sender: Any) {
        exportHistoryToFile()
    }
    @IBAction func importButtonClicked(_ sender: Any) {
        importHistoryFromFile()
    }
    
    func exportHistoryToFile(){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let filename = "HealthPointsClubBackup_"+date.description+".csv"
        print(filename)
        let path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)
        print(path)
        let content = HealthDay.shared.history.map({$0.date.description+","+$0.points.description+"\n"}).joined()
        do{
            try content.write(to: path, atomically: true, encoding: String.Encoding.utf8)
            let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])
            let systemTint = UIButton.appearance().tintColor
            UIButton.appearance().tintColor = UIColor(red: 14.0/255.0, green: 122.0/255.0, blue: 254.0/255.0, alpha: 1.0)
            self.present(vc, animated: true){
                UIButton.appearance().tintColor = systemTint
            }
        } catch {
            print("Failed to export")
        }
    }
    func importHistoryFromFile(){
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.text"], in: UIDocumentPickerMode.import)
        documentPicker.delegate = self as UIDocumentPickerDelegate
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        let systemTint = UILabel.appearance().tintColor
        UILabel.appearance().tintColor = UIColor(red: 14.0/255.0, green: 122.0/255.0, blue: 254.0/255.0, alpha: 1.0)
        self.present(documentPicker, animated: true){
            UILabel.appearance().tintColor = systemTint
        }
        
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("selected")
        print(urls)
        let cal = Calendar.current
        
        
        //reading
        do {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            var lines: [String] = []
            let text2 = try String(contentsOf: urls[0], encoding: .utf8)
            text2.enumerateLines { line, _ in
                lines.append(line)
                let parts = line.components(separatedBy: ",")
                let d = formatter.date(from: parts[0])
                
                let historyday = HistoryDay(date: d!, points: Int(parts[1])!)
                let dateComponents = cal.dateComponents(
                    [ .year, .month, .day ],
                    from: historyday.date
                )
                if let index = HealthDay.shared.history.firstIndex(where: {cal.dateComponents([ .year, .month, .day ], from: $0.date) == dateComponents}){
                    HealthDay.shared.history[index] = historyday
                }else{
                    HealthDay.shared.history.append(historyday)
                }
                print(historyday)
            }
            print(HealthDay.shared.history)
            HealthDay.shared.saveHistory()
        }
        catch {/* error handling here */}
        
    }
    
    
    
}

