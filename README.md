# UICWaveTabBar
Awesome tabbar with water wave effect for IOS written with Swift 4, easy to use it's compatible with all kind of iPhone, iPod and iPads regarding home indicator of X device series in protrait and landscape modes.

## Screen shots: 
<div align=center>
    <img style="display: inline-block;" src="https://github.com/Coder-ACJHP/UICWaveTabBarController/blob/master/UICWaveTabbar/Assets.xcassets/iPhone8.dataset/iPhone8.gif">
    <img style="display: inline-block;" src="https://github.com/Coder-ACJHP/UICWaveTabBarController/blob/master/UICWaveTabbar/Assets.xcassets/iPhoneX.dataset/iPhoneX.gif">
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
// inside TabbarController class
private var customTabBar: UICWaveTabBar!

override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .clear
        tabBar.tintColor = .clear
        viewControllers = DataProvider.shared.provideMockViewControllers() // create your own list
        
        let iconList = DataProvider.shared.provideTabIconList() // create your own list
        let titleList = DataProvider.shared.provideTabTitlesList() // create your own list
        
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
    
    // Confirm delegate on your class and use this method
    func tabChanged(_ tabBarView: UICWaveTabBar, toIndex: Int) {
        // this line of code will make your controller change tab
        self.selectedIndex = toIndex
    }
```

