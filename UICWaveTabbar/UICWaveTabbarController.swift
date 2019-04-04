//
//  ViewController.swift
//  UICWaveTabbar
//
//  Created by akademobi5 on 4.04.2019.
//  Copyright © 2019 Coder ACJHP. All rights reserved.
//

import UIKit

class UICWaveTabbarController: UITabBarController {

    private let darkPurpleColor = UIColor(red:0.26, green:0.11, blue:0.32, alpha:1.0)
    private let lightPurpleColor = UIColor(red:0.61, green:0.54, blue:0.65, alpha:1.0)
    
 
    private let titleList = ["Home", "Categories", "Favorites", "Recents", "Info"]
    private let iconList = [UIImage(named: "home")!, UIImage(named: "list")!,
                            UIImage(named: "heart")!, UIImage(named: "layers")!,
                            UIImage(named: "info")!,]
    
    
    
    @IBOutlet weak var customTabBar: UIView!
    @IBOutlet weak var bigCenterBtnView: UIView!
    @IBOutlet var tabBtnContainerCollection: [UIView]!
    @IBOutlet var tabBtntitleLabelCollection: [UILabel]!
    @IBOutlet var tabBtnIconViewCollection: [UIImageView]!
    
    // Wave effect variables
    private var tempView: UIView!
    private var darkWaveLayer = CAShapeLayer()
    private var lightWaveLayer = CAShapeLayer()
    private var offset :CGFloat = 0
    
    private var waveCurvature: CGFloat = 0
    private var waveSpeed: CGFloat = 0
    private var waveHeight: CGFloat = 0
    private var isStarting: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adjustTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startWaveEffect(forView: customTabBar)
    }

    fileprivate func adjustTabBar() {
        
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .clear
        tabBar.tintColor = .clear
        viewControllers = createAndRetrieveMockViewControllers()
        
        customTabBar.backgroundColor = darkPurpleColor
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customTabBar)
        
        NSLayoutConstraint.activate([
            customTabBar.widthAnchor.constraint(equalTo: tabBar.widthAnchor),
            customTabBar.heightAnchor.constraint(equalTo: tabBar.heightAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor),
            customTabBar.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor)
        ])
        
        bigCenterBtnView.backgroundColor = lightPurpleColor
        bigCenterBtnView.layer.cornerRadius = bigCenterBtnView.bounds.width / 2
        bigCenterBtnView.layer.masksToBounds = true
        bigCenterBtnView.layer.borderWidth = 5.0
        bigCenterBtnView.layer.borderColor = darkPurpleColor.cgColor
        
        setupTabBarButtons()
    }
    
    @IBAction fileprivate func actionEvent(_ sender: UIButton) {
        animatePressedButton(buttonTag: sender.tag)
        self.selectedIndex = sender.tag
    }
    
    // Setup button's title and icons
    private func setupTabBarButtons() {
        
        for index in 0 ..< tabBtnIconViewCollection.count {
            let iconView = tabBtnIconViewCollection[index]
            iconView.image = iconList[index]
            
            
            let titleLabel = tabBtntitleLabelCollection[index]
            if index != 2 {
                titleLabel.text = titleList[index]
                titleLabel.textColor = lightPurpleColor
            } else {
                titleLabel.isHidden = true
            }
        }
    }
    
    private func animatePressedButton(buttonTag index: Int) {
        
        let pressedBtnIconView = tabBtnIconViewCollection[index]
        let pressedBtnTitleLabel = tabBtntitleLabelCollection[index]
        pressedBtnIconView.alpha = 0
        pressedBtnTitleLabel.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            pressedBtnIconView.alpha = 1.0
            pressedBtnTitleLabel.alpha = 1.0
        }
    }
    
    private func startWaveEffect(forView: UIView) {
        tempView = forView
        
        var frame = forView.bounds
        frame.origin.y = frame.size.height
        frame.size.height = 0
        lightWaveLayer.frame = frame
        darkWaveLayer.frame = frame
        
        darkWaveLayer.fillColor = darkPurpleColor.cgColor
        lightWaveLayer.fillColor = darkPurpleColor.withAlphaComponent(0.4).cgColor
        
        forView.layer.insertSublayer(darkWaveLayer, at: 0)
        forView.layer.insertSublayer(lightWaveLayer, at: 0)
        
        isStarting = true
        let timer = CADisplayLink(target: self, selector: #selector(waveEffect))
        timer.add(to: .current, forMode: .common)
    }
    
    @objc private func waveEffect() {
        
        if isStarting {
            if waveHeight < 5.0 {
                waveHeight = waveHeight + 5.0/70.0
                var frame = tempView.bounds
                frame.origin.y = frame.minY - waveHeight
                frame.size.height = waveHeight
                lightWaveLayer.frame = frame
                darkWaveLayer.frame = frame
                waveCurvature = waveCurvature + 1.5 / 50.0
                waveSpeed = waveSpeed + 0.6 / 50.0
            } else {
                isStarting = false
            }
        }
        
        offset += waveSpeed
        
        let width = tempView.frame.width
        let height = CGFloat(waveHeight)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: height))
        var y: CGFloat = 0
        
        let maskpath = CGMutablePath()
        maskpath.move(to: CGPoint(x: 0, y: height))
        
        let offset_f = Float(offset * 0.045)
        let waveCurvature_f = Float(0.01 * waveCurvature)
        
        for x in 0...Int(width) {
            y = height * CGFloat(sinf( waveCurvature_f * Float(x) + offset_f))
            path.addLine(to: CGPoint(x: CGFloat(x), y: y))
            maskpath.addLine(to: CGPoint(x: CGFloat(x), y: -y))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        
        path.closeSubpath()
        self.darkWaveLayer.path = path
        
        maskpath.addLine(to: CGPoint(x: width, y: height))
        maskpath.addLine(to: CGPoint(x: 0, y: height))
        
        maskpath.closeSubpath()
        self.lightWaveLayer.path = maskpath
    }

    
    private func createAndRetrieveMockViewControllers() -> [UIViewController] {
        
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
}

