//
//  Theme.swift
//  healthpoints
//
//  Created by Joseph Smith on 10/15/17.
//  Copyright © 2017 Joseph Smith. All rights reserved.
//

import UIKit

enum Theme: Int {
    //1
    case `default`, dark
    
    //2
    private enum Keys {
        static let selectedTheme = "SelectedTheme"
    }
    
    //3
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
            
        }
    }
    func apply() {
        //1
        UserDefaults.standard.set(rawValue, forKey: Keys.selectedTheme)
        UserDefaults.standard.synchronize()
        
        //2
        UIApplication.shared.delegate?.window??.tintColor = mainColor
        
        UINavigationBar.appearance().barStyle = barStyle
        //UINavigationBar.appearance().backgroundColor = backgroundColor
        UINavigationBar.appearance().barTintColor = backgroundColor
        UINavigationBar.appearance().isTranslucent = false
        
        
        UITabBar.appearance().barTintColor = backgroundColor
        UITabBar.appearance().backgroundColor = backgroundColor
        
        UITableViewCell.appearance().backgroundColor = backgroundColor
        
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = textColor
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textColor = textColor
        
        UITextView.appearance().backgroundColor = backgroundColor
        UITextView.appearance().textColor = textColor
        ThemeView.appearance().backgroundColor = backgroundColor
        ThemeImageView.appearance().backgroundColor = backgroundColor
        
        UITableView.appearance().backgroundColor = backgroundColor
        UITableViewHeaderFooterView.appearance().backgroundColor = backgroundColor
        
        UICollectionView.appearance().backgroundColor = backgroundColor
        
        
        
        UISwitch.appearance().onTintColor = mainColor
        
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .default:
            return UIColor.white
        case .dark:
            return UIColor(red:0.24, green:0.25, blue:0.25, alpha:1.00)
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .default:
            return UIColor.black
        case .dark:
            return UIColor.white
        }
    }
    var barStyle: UIBarStyle {
        switch self {
        case .default:
            return .default
        case .dark:
            return .black
        }
    }
    var barTintColor: UIColor {
        switch self{
        case .default:
            return UIColor.white
        case .dark:
            return UIColor(red:0.14, green:0.15, blue:0.15, alpha:1.00)
        }
    }
    
    
}
