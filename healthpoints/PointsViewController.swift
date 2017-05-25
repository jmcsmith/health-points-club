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
        collectionView.reloadData()
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
        
        collectionView.backgroundColor = UIColor(red:0.24, green:0.25, blue:0.25, alpha:1.00)
        
    }
    
    func disableDarkMode() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        
        collectionView.backgroundColor = UIColor.white
        
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
        cell.valueLabel.text = HealthDay.shared.attributes[indexPath.row].type.displayText(forValue: value)
        cell.backgroundColor = HealthDay.shared.attributes[indexPath.row].type.getBackgroundColor()
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellsAcross: CGFloat = CGFloat(UserDefaults.standard.integer(forKey: "numberOfCellsInRow"))
        let spaceBetweenCells: CGFloat = 1
        let spacers = (cellsAcross-1)*spaceBetweenCells
        let dim = (collectionView.bounds.width - spacers) / cellsAcross
        
        return CGSize(width: dim, height: dim)
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.pointsLabel.text = HealthDay.shared.getPoints().description
            self.collectionView.reloadData()
        }
        
    }
}
