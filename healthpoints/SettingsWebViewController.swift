//
//  SettingsWebViewController.swift
//  healthpoints
//
//  Created by Joseph Smith on 6/25/18.
//  Copyright © 2018 Joseph Smith. All rights reserved.
//

import UIKit
import WebKit

class SettingsWebViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    var urlString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: urlString)
        {
            let  urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
