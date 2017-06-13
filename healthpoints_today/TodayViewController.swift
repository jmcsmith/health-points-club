//
//  TodayViewController.swift
//  healthpoints_today
//
//  Created by Joseph Smith on 6/2/17.
//  Copyright © 2017 healthpoints. All rights reserved.
//

import UIKit
import NotificationCenter


class TodayViewController: UIViewController, NCWidgetProviding, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let defaults = UserDefaults(suiteName: "group.HealthPointsClub")
    var list: [[Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        //collectionView.reloadData()
        let data = defaults?.object(forKey: "widgetValues") as! Data
        list = NSKeyedUnarchiver.unarchiveObject(with: data) as! [[Any]]
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        var dateString = formatter.string(from: Date())
        var total = 0
        for attribute in list {
            total += attribute[1] as! Int
        }
        list.insert([dateString,total,UIColor.white], at: 0)
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 170) : maxSize
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "widgetCell", for: indexPath) as! WidgetCollectionViewCell
        cell.descriptionsLabel.text = (list[indexPath.row][0] as! String).description
        cell.pointsLabel.text = (list[indexPath.row][1] as! Int).description
        cell.backgroundColor = (list[indexPath.row][2] as! UIColor)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellsAcross: CGFloat = CGFloat(5)
        //let cellsAcross: CGFloat = CGFloat(4)
        
        let spaceBetweenCells: CGFloat = 1
        let spacers = (cellsAcross-1)*spaceBetweenCells
        let dim = ((collectionView.bounds.width - spacers)) / cellsAcross
        
        
        return CGSize(width: dim, height: dim)
    }
}
