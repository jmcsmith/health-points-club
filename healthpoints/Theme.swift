//
//  Theme.swift
//  healthpoints
//
//  Created by Joseph Smith on 10/15/17.
//  Copyright © 2017 Joseph Smith. All rights reserved.
//

import UIKit

enum Theme: Int {
    case `default`, dark, pitchBlack

    private enum Keys {
        static let selectedTheme = "SelectedTheme"
    }
    
    static var current: Theme {
        let storedTheme = UserDefaults.standard.integer(forKey: Keys.selectedTheme)
        return Theme(rawValue: storedTheme) ?? .default
    }
    
    var mainColor: UIColor {
        switch self {
        case .default:
            return UIColor(red: 14.0/255.0, green: 122.0/255.0, blue: 254.0/255.0, alpha: 1.0)
        case .dark:
            return UIColor(red: 255.0/255.0, green: 115.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        case .pitchBlack:
            return .green
        }
    }
    func apply() {
        
        UserDefaults.standard.set(rawValue, forKey: Keys.selectedTheme)
        UserDefaults.standard.synchronize()
        
        //global
        UIApplication.shared.delegate?.window??.tintColor = mainColor
        UISwitch.appearance().onTintColor = mainColor
        
        //NavigationBar
        UINavigationBar.appearance().barStyle = barStyle
        UINavigationBar.appearance().isTranslucent = false
        //UINavigationBar.appearance().backgroundColor = barBackgroundColor
        UINavigationBar.appearance().barTintColor = navigationBarBackgroundColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]

        
        //tab bar
        UITabBar.appearance().barTintColor = barBackgroundColor
        UITabBar.appearance().backgroundColor = barBackgroundColor
        
        //table view and cell
        //UITableViewCell.appearance().backgroundColor = tableviewCellBackgroundColor
        UITableView.appearance().separatorColor = UIColor.darkGray
        UITableViewCell.appearance(whenContainedInInstancesOf: [HistoryTableViewController.self]).backgroundColor = backgroundColor
        UITableViewCell.appearance(whenContainedInInstancesOf: [SettingsTableViewController.self]).backgroundColor = tableviewCellBackgroundColor
        UITableView.appearance().backgroundColor = backgroundColor
        
        //specific labels
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = textColor
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textColor = textColor
        
        //text view
        UITextView.appearance().backgroundColor = backgroundColor
        UITextView.appearance().textColor = textColor
        
        UITextField.appearance().backgroundColor = backgroundColor
        UITextField.appearance().textColor = textColor
        //custom views
        ThemeView.appearance().backgroundColor = backgroundColor
        ThemeImageView.appearance().backgroundColor = backgroundColor
        
        //ccollection view
        UICollectionView.appearance().backgroundColor = backgroundColor
        
        UILabel.appearance(whenContainedInInstancesOf: [UIDocumentPickerViewController.self]).tintColor = mainColor

    }
    
    var backgroundColor: UIColor {
        switch self {
        case .default:
            return UIColor.white
        case .dark:
            return UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.00)
            //return .darkGray
        case .pitchBlack:
            return .black
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .default:
            return UIColor.black
        case .dark:
            return UIColor.white
        case .pitchBlack:
            return .white
        }
    }
    var barStyle: UIBarStyle {
        switch self {
        case .default:
            return .default
        case .dark:
            return .black
        case .pitchBlack:
            return .black
        }
    }
    var barTintColor: UIColor {
        switch self{
        case .default:
            return UIColor.white
        case .dark:
            return UIColor(red:0.14, green:0.15, blue:0.15, alpha:1.00)
        case .pitchBlack:
            return .black
        }
    }
    var barBackgroundColor: UIColor {
        switch self{
        case .default:
            return UIColor.white
        case .dark:
            return UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1.00)
        case .pitchBlack:
            return .black
        }
    }
    var navigationBarBackgroundColor: UIColor {
        switch self{
        case .default:
            return UIColor.white
        case .dark:
            return UIColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 1.00)
        case .pitchBlack:
            return UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1.00)
        }
    }
    var tableviewCellBackgroundColor: UIColor {
        switch self{
        case .default:
            return UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
        case .dark:
            return UIColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 1.00)
        case .pitchBlack:
            return UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1.00)
        }
    }
    
}
