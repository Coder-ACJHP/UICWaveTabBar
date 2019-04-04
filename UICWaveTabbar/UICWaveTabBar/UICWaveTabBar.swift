//
//  UICWaveTabBar.swift
//  UICWaveTabbar
//
//  Created by Onur Işık on 4.04.2019.
//  Copyright © 2019 Coder ACJHP. All rights reserved.
//

import UIKit

let showBadgeNotification = Notification.Name.init("showBadge")

protocol UICWaveTabBarDelegate: class {
    func tabChanged(_ tabBarView: UICWaveTabBar, toIndex: Int)
}

class UICWaveTabBar: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var bigCenterBtnView: UIView!
    @IBOutlet var tabBtnCollection: [UIButton]!
    @IBOutlet var tabBtnContainerCollection: [UIView]!
    @IBOutlet var tabBtntitleLabelCollection: [UILabel]!
    @IBOutlet var tabBtnBadgeLabelCollection: [UILabel]!
    @IBOutlet var tabBtnIconViewCollection: [UIImageView]!
    
    private let darkPurpleColor = UIColor(red:0.26, green:0.11, blue:0.32, alpha:1.0)
    private let lightPurpleColor = UIColor(red:0.61, green:0.54, blue:0.65, alpha:1.0)
    
    private var titleList = [String]()
    private var iconList = [UIImage]()
    
    // Wave effect variables
    private var tempView: UIView!
    private let darkWaveLayer = CAShapeLayer()
    private let lightWaveLayer = CAShapeLayer()
    private var offset :CGFloat = 0
    
    private var waveCurvature: CGFloat = 0
    private var waveSpeed: CGFloat = 0
    private var waveHeight: CGFloat = 0
    private var isStarting: Bool = false
    
    public var wavingIsAllowed: Bool = true
    public var animationIsAllowed: Bool = true
    public var delegate: UICWaveTabBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initalizeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initalizeView()
    }
    
    private func initalizeView() {
        
        Bundle.main.loadNibNamed("UICWaveTabBar", owner: self, options: nil)
        contentView.frame = self.bounds
        addSubview(contentView)
        contentView.backgroundColor = darkPurpleColor
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        bigCenterBtnView.backgroundColor = lightPurpleColor
        bigCenterBtnView.layer.cornerRadius = bigCenterBtnView.bounds.width / 2
        bigCenterBtnView.layer.masksToBounds = true
        bigCenterBtnView.layer.borderWidth = 5.0
        bigCenterBtnView.layer.borderColor = darkPurpleColor.cgColor
    }
    
    public func setupIconsAndTitles(iconList: [UIImage], titleList: [String]) {
        self.iconList = iconList
        self.titleList = titleList
        
        setupTabBarButtons()
        
        if wavingIsAllowed {
          startWaveEffect(forView: contentView)
        }
        
        animatePressedButton(buttonTag: 0)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleBadgeNotification(_:)),
                                               name: showBadgeNotification, object: nil)
    }
    
    // Setup button's title and icons
    private func setupTabBarButtons() {
        
        for index in 0 ..< tabBtnIconViewCollection.count {
            let iconView = tabBtnIconViewCollection[index]
            iconView.image = iconList[index].withRenderingMode(.alwaysTemplate)
            iconView.tintColor = .black
            
            
            let titleLabel = tabBtntitleLabelCollection[index]
            if index != 2 {
                titleLabel.text = titleList[index]
                titleLabel.textColor = lightPurpleColor
            } else {
                titleLabel.isHidden = true
            }
        }
        
        tabBtnBadgeLabelCollection.forEach {
            $0.layer.cornerRadius = $0.bounds.height / 2
            $0.layer.masksToBounds = true
            $0.textAlignment = .center
            $0.minimumScaleFactor = 0.55
            $0.isHidden = true
        }
    }
    
    @IBAction fileprivate func actionEvent(_ sender: UIButton) {
        if animationIsAllowed {
            animatePressedButton(buttonTag: sender.tag)
        }
        delegate?.tabChanged(self, toIndex: sender.tag)
    }
    
    @objc private func handleBadgeNotification(_ notification: Notification) {
        
        if let notificationInfo = notification.userInfo as? Dictionary<String, (Int, String)> {
            if let badgeButtonIndex = notificationInfo["index"] {
                let badge = tabBtnBadgeLabelCollection[badgeButtonIndex.0]
                badge.text = badgeButtonIndex.1
                badge.isHidden = false
                badge.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                
                UIView.animate(withDuration: 0.2, animations: {
                    badge.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }) { (_) in
                    badge.transform = .identity
                }
            }
        }
    }
    
    private func animatePressedButton(buttonTag index: Int) {
        
        tabBtnIconViewCollection.forEach {
            $0.transform = .identity
            $0.tintColor = .black
        }
        tabBtntitleLabelCollection.forEach { $0.textColor = lightPurpleColor}
        tabBtnBadgeLabelCollection[index].isHidden = true
        
        let pressedBtnIconView = tabBtnIconViewCollection[index]
        let pressedBtnTitleLabel = tabBtntitleLabelCollection[index]
        
        UIView.animate(withDuration: 0.3, animations: {
            
            pressedBtnIconView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.rotationAnimation(forView: pressedBtnIconView)
            pressedBtnIconView.tintColor = .white
            pressedBtnTitleLabel.textColor = .white
        })
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
    
    private func rotationAnimation(forView: UIView) {
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = 360 * CGFloat(Double.pi/180)
        let innerAnimationDuration : CGFloat = 0.3
        rotationAnimation.duration = Double(innerAnimationDuration)
        rotationAnimation.repeatCount = 0
        forView.layer.add(rotationAnimation, forKey: "rotateInner")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        debugPrint("deinitilizing UICWaveTabBar!")
    }
}

