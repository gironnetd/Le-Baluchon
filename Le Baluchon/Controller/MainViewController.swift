//
//  MainViewController.swift
//  Le Baluchon
//
//  Created by damien on 22/06/2022.
//

import UIKit

//
// MARK: - Main ViewController
//
class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage     = UIImage()
        UITabBar.appearance().clipsToBounds   = true
        UITabBar.appearance().tintColor = UIColor.orange
    }
}
