# UICWaveTabBarController
Awesome tabbarcontroller with water wave effect for IOS written with Swift 4

## Options: 
1 - It's implemented from UITabbarController so you can customize it as you want<br>
2 - Enable, disable animations<br>
3 - Send notification from any VC to show badge on tab button (UserInfo must be `[String, tuple(tabIndex, yourMessage)]`)
    
    NotificationCenter.default.post(name: showBadgeNotification, object: nil, userInfo: ["index": (1, "New")])
   


## Screen shots: 

<div align=center>
    <img style="display: inline-block;" src="https://github.com/Coder-ACJHP/UICWaveTabBarController/blob/master/UICWaveTabbar/Assets.xcassets/iPhone8.dataset/iPhone8.gif">
    <img style="display: inline-block;" src="https://github.com/Coder-ACJHP/UICWaveTabBarController/blob/master/UICWaveTabbar/Assets.xcassets/iPhoneX.dataset/iPhoneX.gif">
</div>
