//
//  PointsViewController.swift
//  healthpointsclub
//
//  Created by Joseph Smith on 10/2/17.
//  Copyright © 2017 Joseph Smith. All rights reserved.
//

import UIKit

class PointsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var heartImage: ThemeImageView!
    let hkHelper = HealthKitHelper()
    let defaults:UserDefaults = UserDefaults.standard
    var isfirstload: Bool = true
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var largeHeartImageView: ThemeImageView!
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    var movingIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name(rawValue: "updateUIFromHealthDay"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: .UIApplicationWillEnterForeground, object: nil)
        self.pointsLabel.text = HealthDay.shared.getPoints().description
        self.pointsLabel.accessibilityValue = HealthDay.shared.getPoints().description +  " Points"
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
        
        isfirstload = !defaults.bool(forKey: "hasopenedbefore" )
        
        print(isfirstload)
        if isfirstload {
            let currentVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
            defaults.set(currentVersion, forKey: "lastOpenVersion")
            self.performSegue(withIdentifier: "onboarding", sender: nil)
        }else{
            let lastopened = defaults.string(forKey: "lastOpenVersion")
            let currentVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
            if currentVersion != lastopened || lastopened == nil {
                self.performSegue(withIdentifier: "newVersion", sender: nil)
            }
        }
        let cal = Calendar.current
        
        var dateComponents = DateComponents()
        dateComponents.calendar = cal
        dateComponents.year = 2018
        dateComponents.month = 1
        dateComponents.day = 1
        if let date = dateComponents.date {
            hkHelper.getActivityRings(forDate: date) { (temp, _) -> Void in
                print("Activity Rings for Date: \(temp)")
                
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData();
    } 
    override func viewWillAppear(_ animated: Bool) {
        hkHelper.loadHealthDay()
        
        if Theme.current == Theme.pitchBlack{
            heartImage.image = #imageLiteral(resourceName: "heartdarkergray.png")
        }
        else{
            heartImage.image = #imageLiteral(resourceName: "LargeHeart.png")
        }
        super.viewWillAppear(animated)
        collectionView.collectionViewLayout.invalidateLayout()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let temp = HealthDay.shared.attributes[sourceIndexPath.row]
        
        HealthDay.shared.attributes.remove(at: sourceIndexPath.row)
        HealthDay.shared.attributes.insert(temp, at: destinationIndexPath.row)
        
        HealthDay.shared.saveAttributeOrder()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
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
        cell.pointLabel.text = HealthDay.shared.attributes[indexPath.row].getPoints(withWeight: 1, withBodyMass: HealthDay.shared.bodyMass).description
        cell.valueLabel.text = HealthDay.shared.attributes[indexPath.row].type.displayText(forValue: value)
        cell.backgroundColor = HealthDay.shared.attributes[indexPath.row].type.getBackgroundColor()
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //let cellsAcross: CGFloat = CGFloat(UserDefaults.standard.integer(forKey: "numberOfCellsInRow"))
        let cellsAcross: CGFloat = CGFloat(2)
        
        let spaceBetweenCells: CGFloat = 8
        let spacers = (cellsAcross-1)*spaceBetweenCells
        let dim = (collectionView.bounds.width - spacers) / cellsAcross
        let heightSpaces = spaceBetweenCells * 5
        let height = (collectionView.bounds.height - heightSpaces) / 5
        
        if let cell = collectionView.cellForItem(at: indexPath) as? AttributeCollectionViewCell{
            let size = 18.0
            
            //            switch cellsAcross {
            //            case 4.0:
            //                size = 14.0
            //            case 3.0:
            //                size = 24.0
            //            case 2.0:
            //                size = 50.0
            //            default:
            //                size = 14.0
            //            }
            
            cell.pointLabel.font = UIFont.systemFont(ofSize: (CGFloat(size)), weight: UIFont.Weight.heavy)
        }
        return CGSize(width: dim - 4, height: height)
    }
    
    func animatePickingUpCell(cell: AttributeCollectionViewCell?) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .beginFromCurrentState], animations: { () -> Void in
            cell?.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }, completion: { finished in
            
        })
    }
    @IBAction func handleSecretTaps(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "debugSegue", sender: nil)
    }
    
    
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            animatePickingUpCell(cell: collectionView.cellForItem(at: selectedIndexPath) as? AttributeCollectionViewCell)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @objc func getLatestData(){
        hkHelper.loadHealthDay()
        updateUI()
    }
    @objc func updateUI() {
        DispatchQueue.main.async {
            self.pointsLabel.text = HealthDay.shared.getPoints().description
            self.pointsLabel.accessibilityValue = HealthDay.shared.getPoints().description +  " Points"
            self.collectionView.reloadData()
            print("--------Notification Processed--------")
        }
        
    }
}
