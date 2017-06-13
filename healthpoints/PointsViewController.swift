//
//  PointsViewController.swift
//  healthpoints
//
//  Created by Joseph Smith on 5/3/17.
//  Copyright © 2017 healthpoints. All rights reserved.
//

import UIKit

class PointsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name(rawValue: "updateUIFromHealthDay"), object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.collectionViewLayout.invalidateLayout()
        let darkmodeOn = UserDefaults.standard.bool(forKey: "darkmodeOn")
        
        if darkmodeOn {
            enableDarkMode()
        } else {
            disableDarkMode()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    func enableDarkMode() {
        view.backgroundColor = UIColor(red:0.24, green:0.25, blue:0.25, alpha:1.00)
        navigationController?.navigationBar.barTintColor = UIColor(red:0.14, green:0.15, blue:0.15, alpha:1.00)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)]
        tabBarController?.tabBar.barTintColor = UIColor(red:0.14, green:0.15, blue:0.15, alpha:1.00)
        collectionView.backgroundColor = UIColor(red:0.24, green:0.25, blue:0.25, alpha:1.00)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func disableDarkMode() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        tabBarController?.tabBar.barTintColor = UIColor.white
        collectionView.backgroundColor = UIColor.white
        setNeedsStatusBarAppearanceUpdate()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return HealthDay.shared.attributes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "atcell", for: indexPath) as! AttributeCollectionViewCell
        
        // Configure the cell
        cell.descriptionLabel.text = HealthDay.shared.attributes[indexPath.row].type.rawValue
        let value = HealthDay.shared.attributes[indexPath.row].value
        cell.pointLabel.text = HealthDay.shared.attributes[indexPath.row].getPoints(withWeight: 1).description
        //        let font = cell.pointLabel.font
        //        let labelsize = cell.pointLabel.bounds.height
        //        cell.pointLabel.font = font?.withSize(labelsize-4)
        cell.valueLabel.text = HealthDay.shared.attributes[indexPath.row].type.displayText(forValue: value)
        cell.backgroundColor = HealthDay.shared.attributes[indexPath.row].type.getBackgroundColor()
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellsAcross: CGFloat = CGFloat(UserDefaults.standard.integer(forKey: "numberOfCellsInRow"))
        //let cellsAcross: CGFloat = CGFloat(4)
        
        let spaceBetweenCells: CGFloat = 1
        let spacers = (cellsAcross-1)*spaceBetweenCells
        let dim = (collectionView.bounds.width - spacers) / cellsAcross
        
        if let cell = collectionView.cellForItem(at: indexPath) as? AttributeCollectionViewCell{
            var size = 14.0
            let font = cell.pointLabel.font
            switch cellsAcross {
            case 4.0:
                size = 14.0
            case 3.0:
                size = 24.0
            case 2.0:
                size = 50.0
            default:
                size = 14.0
            }
            
            cell.pointLabel.font = UIFont.systemFont(ofSize: (CGFloat(size)), weight: UIFontWeightHeavy)
        }
        return CGSize(width: dim, height: dim)
    }
    

    func updateUI() {
        DispatchQueue.main.async {
            self.pointsLabel.text = HealthDay.shared.getPoints().description
            self.collectionView.reloadData()
        }
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        if UserDefaults.standard.bool(forKey: "darkmodeOn") {
            return .lightContent
        } else {
            return .default
        }
    }
}
