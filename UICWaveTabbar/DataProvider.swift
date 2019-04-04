//
//  DataProvider.swift
//  UICWaveTabbar
//
//  Created by Onur Işık on 4.04.2019.
//  Copyright © 2019 Coder ACJHP. All rights reserved.
//

import UIKit

class DataProvider {
    
    static let shared = DataProvider()
    
    func provideMockViewControllers() -> [UIViewController] {
        
        var mockViewControllerList = [UIViewController]()
        
        let colorList: [UIColor] = [.yellow, .green, .orange, .red, .brown]
        
        for index in 0 ... 4 {
            let mockViewController = UIViewController()
            mockViewController.view.backgroundColor = colorList[index]
            
            let testLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
            testLabel.textAlignment = .center
            testLabel.font = UIFont.boldSystemFont(ofSize: 30)
            testLabel.text = "View Controller \(index)"
            mockViewController.view.addSubview(testLabel)
            testLabel.center = mockViewController.view.center
            
            mockViewControllerList.append(mockViewController)
        }
        return mockViewControllerList
    }
    
    func provideTabTitlesList() -> [String] {
        return ["Home", "Categories", "Favorites", "Recents", "Info"]
    }
    
    func provideTabIconList() -> [UIImage] {
        return [UIImage(named: "home")!, UIImage(named: "list")!,
                UIImage(named: "heart")!, UIImage(named: "layers")!,
                UIImage(named: "info")!]
    }
}
