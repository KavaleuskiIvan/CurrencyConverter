//
//  MainTabBarViewController.swift
//  Currency Converter
//
//  Created by Kavaleuski Ivan on 18/06/2022.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    let namesOfSystemImages = ["chart.bar.xaxis","repeat"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        view.backgroundColor = .systemBackground
    }
    
    func setupTabBar() {
        tabBar.tintColor = .black
        
        let containerVC = ContainerViewController()
        let converterVC = ConverterViewController()
        
        containerVC.title = "Checking"
        converterVC.title = "Converting"
        
        self.setViewControllers([containerVC, converterVC], animated: true)
        
        if let items = self.tabBar.items {
            for i in 0..<items.count {
                items[i].image = UIImage(systemName: namesOfSystemImages[i])
            }
        }
    }
}
