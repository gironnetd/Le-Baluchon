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
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage     = UIImage()
        UITabBar.appearance().clipsToBounds   = true
        UITabBar.appearance().tintColor = UIColor.orange
        // Do any additional setup after loading the view.
    }
}
