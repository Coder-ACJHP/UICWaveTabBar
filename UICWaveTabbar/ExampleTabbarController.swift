//
//  ExampleTabbarController.swift
//  UICWaveTabbar
//
//  Created by Coder ACJHP on 4.04.2019.
//  Copyright © 2019 Onur Işık. All rights reserved.
//

import UIKit

class ExampleTabbarController: UITabBarController, UICSliderTabBarDelegate {
    
    //    private var customTabBar: UICWaveTabBar!
    //
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //
    //        tabBar.isTranslucent = false
    //        tabBar.backgroundColor = .clear
    //        tabBar.tintColor = .clear
    //        viewControllers = DataProvider.shared.provideMockViewControllers()
    //
    //        let iconList = DataProvider.shared.provideTabIconList()
    //        let titleList = DataProvider.shared.provideTabTitlesList()
    //
    //        customTabBar = UICWaveTabBar(frame: tabBar.frame)
    //        customTabBar.setupIconsAndTitles(iconList: iconList, titleList: titleList)
    //        customTabBar.delegate = self
    //        customTabBar.translatesAutoresizingMaskIntoConstraints = false
    //        view.addSubview(customTabBar)
    //
    //        NSLayoutConstraint.activate([
    //            customTabBar.widthAnchor.constraint(equalTo: tabBar.widthAnchor),
    //            customTabBar.heightAnchor.constraint(equalTo: tabBar.heightAnchor),
    //            customTabBar.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor),
    //            customTabBar.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor)
    //            ])
    //    }
    //
    //    func tabChanged(_ tabBarView: UICWaveTabBar, toIndex: Int) {
    //        self.selectedIndex = toIndex
    //    }
    
    private var customTabBar: UICSliderTabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .clear
        tabBar.tintColor = .clear
        viewControllers = DataProvider.shared.provideMockViewControllers()
        
        let iconList = DataProvider.shared.provideTabIconList()
        let titleList = DataProvider.shared.provideTabTitlesList()
        
        customTabBar = UICSliderTabBar(frame: tabBar.frame)
        customTabBar.barBackgroundColor = .orange
        customTabBar.selectedIconColor = .white
        customTabBar.selectedTitleColor = .white
        customTabBar.horizontalBarLineColor = .white
        customTabBar.isGlowing = false
        customTabBar.isScrollEnabledForMoreThanFiveElements = true
        customTabBar.setupIconsAndTitles(iconList: iconList, titleList: titleList)
        customTabBar.delegate = self
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customTabBar)
        
        NSLayoutConstraint.activate([
            customTabBar.widthAnchor.constraint(equalTo: tabBar.widthAnchor),
            customTabBar.heightAnchor.constraint(equalTo: tabBar.heightAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor),
            customTabBar.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor)
            ])
    }
    
    func tabChanged(_ tabBarView: UICSliderTabBar, toIndex: Int) {
        self.selectedIndex = toIndex
    }
    
    deinit {
        debugPrint("deinitilizing UICWaveTabBarController!")
    }
}

