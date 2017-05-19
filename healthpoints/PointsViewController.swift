//
//  PointsViewController.swift
//  healthpoints
//
//  Created by Joseph Smith on 5/3/17.
//  Copyright © 2017 healthpoints. All rights reserved.
//

import UIKit

//class PointsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
class PointsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name(rawValue: "updateUIFromHealthDay"), object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)

        //self.tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: -20, right: 0)
        // Do any additional setup after loading the view.

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

        //        tableView.backgroundColor = UIColor(red:0.24, green:0.25, blue:0.25, alpha:1.00)
        collectionView.backgroundColor = UIColor(red:0.24, green:0.25, blue:0.25, alpha:1.00)
        //        for cell in tableView.visibleCells {
        //            cell.backgroundColor = UIColor(red:0.18, green:0.20, blue:0.20, alpha:1.00)
        //            cell.textLabel?.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
        //            cell.detailTextLabel?.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
        //        }
    }

    func disableDarkMode() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]

        //        tableView.backgroundColor = UIColor.white
        collectionView.backgroundColor = UIColor.white

        //        for cell in tableView.visibleCells {
        //            cell.backgroundColor = UIColor.white
        //            cell.textLabel?.textColor = UIColor.black
        //            cell.detailTextLabel?.textColor = UIColor.black
        //        }

    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return HealthDay.shared.attributes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "atcell", for: indexPath) as! AttributeCollectionViewCell

        // Configure the cell
        cell.descriptionLabel.text = HealthDay.shared.attributes[indexPath.row].type.rawValue
        let value = HealthDay.shared.attributes[indexPath.row].value
        cell.pointLabel.text = HealthDay.shared.attributes[indexPath.row].getPoints(withWeight: 1).description
        cell.valueLabel.text = HealthDay.shared.attributes[indexPath.row].type.displayText(forValue: value)
        cell.backgroundColor = HealthDay.shared.attributes[indexPath.row].type.getBackgroundColor()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellsAcross: CGFloat = 4
        let spaceBetweenCells: CGFloat = 1
        let spacers = (cellsAcross-1)*spaceBetweenCells
        let dim = (collectionView.bounds.width - spacers) / cellsAcross

        return CGSize(width: dim, height: dim)
    }
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return HealthDay.shared.attributes.count
    //    }
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "attributeCell")!
    //        let attribute = HealthDay.shared.attributes[indexPath.row]
    //        cell.textLabel?.text = attribute.type.rawValue
    //        cell.detailTextLabel?.text = attribute.type.displayText(forValue: attribute.value)
    //
    //        return cell
    //    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func updateUI() {
        //        pointsLabel.text = HealthDay.shared.steps.description
        pointsLabel.text = HealthDay.shared.getPoints().description
        //tableView.reloadData()
        collectionView.reloadData()
    }
}
