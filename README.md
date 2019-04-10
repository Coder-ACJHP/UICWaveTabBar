# UICWaveTabBar
Awesome tabbar with water wave effect for IOS written with Swift 4, easy to use it's compatible with all kind of iPhone, iPod and iPads regarding home indicator of X device series in protrait and landscape modes.

## Screen shots: 
<div align=center>
    <img style="display: inline-block;" src="https://github.com/Coder-ACJHP/UICWaveTabBarController/blob/master/UICWaveTabbar/Assets.xcassets/iPhone8.dataset/iPhone8.gif">
    <img style="display: inline-block;" src="https://github.com/Coder-ACJHP/UICWaveTabBarController/blob/master/UICWaveTabbar/Assets.xcassets/iPhoneX.dataset/iPhoneX.gif">
    <img style="display: inline-block;" src="https://github.com/Coder-ACJHP/UICWaveTabBar/blob/master/UICWaveTabbar/Assets.xcassets/TabBarScroll.dataset/TabBarScroll.gif">
</div>

## Options: 
1 - It's seperated component and it consist of two files : `UICWaveTabbar.xib` and `UICWaveTabBar.swift` so you don't need to storyboard. If you like to chage design only make change on `.xib`file. <br>
2 - Enable, disable animations<br>
3 - Enable, disable waving effect<br>
4 - Send notification from any VC to show badge on tab button (UserInfo must be `[String, tuple(tabIndex, yourMessage)]`)
    
    NotificationCenter.default.post(name: showBadgeNotification, object: nil, userInfo: ["index": (1, "New")])
   

## How to use? (implementation) 
Usage of UICWavetabBar is super easy 🎉<br>
1 - Download `UICWaveTabbar.xib`, `UICWaveTabBar.swift` files and import them to your project.<br>
2 - Just create an `UITabbarController` and use your custom tabbar.<br>
### For example: 
```
private var customTabBar: UICWaveTabBar!

override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .clear
        tabBar.tintColor = .clear
        viewControllers = DataProvider.shared.provideMockViewControllers() 
        
        let iconList = DataProvider.shared.provideTabIconList() 
        let titleList = DataProvider.shared.provideTabTitlesList()
        
        customTabBar = UICWaveTabBar(frame: tabBar.frame)
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
    
    // delegate method
    func tabChanged(_ tabBarView: UICWaveTabBar, toIndex: Int) {
        self.selectedIndex = toIndex
    }
```
##### Note : `DataProvider` class is custom util class that generate array of UIImage etc.
For more information please browse example project
##### Note 2: For more than 5 view controllers you must hide navigation bar thats appear automatically (more).
```
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
```

### Added new style tabbar 🎉
UICSlideTabBar is scrollable tabbar, you can add infinity items to it.<br>
It has glow effect, blurred background, image for background, tracking horizontal bar etc. and you can customize as you want.
<br>
## Requirements
Xcode 9 or later <br>
iOS 10.0 or later <br>
Swift 4 or later <br>

#### Licence : 
The MIT License (MIT)
