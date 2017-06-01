//
//  InfoViewController.swift
//  healthpoints
//
//  Created by Joseph Smith on 5/31/17.
//  Copyright © 2017 healthpoints. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var instructionsTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let darkmodeOn = UserDefaults.standard.bool(forKey: "darkmodeOn")
        
        if darkmodeOn {
            enableDarkMode()
        } else {
            disableDarkMode()
        }
    }
    func enableDarkMode() {
        view.backgroundColor = UIColor(red:0.14, green:0.15, blue:0.15, alpha:1.00)
        navBar.barTintColor = UIColor(red:0.14, green:0.15, blue:0.15, alpha:1.00)
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)]
        instructionsTextView.backgroundColor = UIColor(red:0.14, green:0.15, blue:0.15, alpha:1.00)
        instructionsTextView.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
    }
    
    func disableDarkMode() {
        view.backgroundColor = UIColor.white
        navBar.barTintColor = UIColor.white
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        instructionsTextView.backgroundColor = UIColor.white
        instructionsTextView.textColor = UIColor.black
         }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func donePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
