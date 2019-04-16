//
//  UICExpandableTabBar.swift
//  UICWaveTabbar
//
//  Created by Coder ACJHP on 16.04.2019.
//  Copyright © 2019 Coder ACJHP. All rights reserved.
//

import UIKit

protocol UICExpandableCenterTabBarDelegate: AnyObject {
    func expandableCenterTabBar(_ expandableCenterTabBar: UICExpandableCenterTabBar, didSelectIndex: Int)
}

class UICExpandableCenterTabBar: UIView {

    
    private var titleList = [String]()
    private var iconList = [UIImage]()
    public var viewControllerList = [UIViewController]()
    
    private var stackView: UIStackView!
    private let buttonCountLimit: Int8 = 5
    private let fixedTabbarHeight: CGFloat = 49
    
    private enum ButtonState: String {
        case Expanded = "expanded"
        case Collapsed = "collapsed"
    }
    
    private var centerButtonView: UIView?
    private lazy var hideableButtonTop: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 5
        button.setImage(UIImage(named: "info")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleButtonPress(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var hideableButtonMiddle: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 6
        button.setImage(UIImage(named: "home")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleButtonPress(_:)), for: .touchUpInside)
        return button
    }()
    var hideableButtonsContainer: UIView!
    let expandableButtonWidth: CGFloat = 75
    let expandableButtonCollapsedHeight: CGFloat = 75
    let expandableButtonExpandedHeight: CGFloat = 140
    private var expandableButtonTopAnchor: NSLayoutConstraint?
    private var expandableButtonHeightAnchor: NSLayoutConstraint?
    private var centerButtonContainerState: ButtonState = .Collapsed
    
    public weak var delegate: UICExpandableCenterTabBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setupButtonIconsAndTitles(icons: [UIImage], titles: [String]) {
        self.titleList = titles
        self.iconList = icons
        
        configureButtons()
    }
    
    private func configureButtons() {
        
        for (index, image) in iconList.enumerated() {
            
            if index <= buttonCountLimit - 1 {
                
                let minimumFrame = CGRect(x: 0, y: 0, width: 75, height: 75)
                let containerView = UIView(frame: minimumFrame)
                containerView.backgroundColor = .white
                containerView.tag = index
                containerView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(containerView)
                
                let iconView = UIImageView(image: image)
                iconView.contentMode = .scaleAspectFill
                iconView.translatesAutoresizingMaskIntoConstraints = false
                containerView.addSubview(iconView)
                
                let button = UIButton(type: .system)
                button.frame = containerView.frame
                button.setTitle("", for: .normal)
                button.tag = index
                button.translatesAutoresizingMaskIntoConstraints = false
                button.addTarget(self, action: #selector(handleButtonPress(_:)), for: .touchUpInside)
                containerView.addSubview(button)
                
                if index != 2 {
                    let estimatedWidth: CGFloat = bounds.width / CGFloat(buttonCountLimit)
                    containerView.widthAnchor.constraint(equalToConstant: estimatedWidth).isActive = true
                    containerView.heightAnchor.constraint(equalToConstant: fixedTabbarHeight).isActive = true
                    containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
                    containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(index) * estimatedWidth).isActive = true
                
                
                    iconView.widthAnchor.constraint(equalToConstant: 40).isActive = true
                    iconView.heightAnchor.constraint(equalToConstant: 40).isActive = true
                    iconView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
                    iconView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
                    
                    button.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
                    button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
                    button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
                    button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
                }
                adjustCenterButton(view: containerView)
            }
        }
    }
    
    private func adjustCenterButton(view: UIView) {
        
        if view.tag == 2 {
            
            var tempButton: UIButton?
            view.layer.cornerRadius = view.bounds.height / 2
            view.layer.masksToBounds = true
            view.layer.borderWidth = 4
            view.layer.borderColor = UIColor.yellow.cgColor
            centerButtonView = view
            
            let estimatedWidth: CGFloat = bounds.width / CGFloat(buttonCountLimit)
            
            view.widthAnchor.constraint(equalToConstant: expandableButtonWidth).isActive = true
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(view.tag) * estimatedWidth).isActive = true
            expandableButtonTopAnchor = view.topAnchor.constraint(equalTo: topAnchor, constant: fixedTabbarHeight - expandableButtonCollapsedHeight)
            expandableButtonTopAnchor?.isActive = true
            expandableButtonHeightAnchor = view.heightAnchor.constraint(equalToConstant: expandableButtonCollapsedHeight)
            expandableButtonHeightAnchor?.isActive = true
            
            view.subviews.forEach { (innerView) in
                if innerView.isKind(of: UIImageView.self) && innerView.tag == 0 {
                    if let iconView = innerView as? UIImageView {
                        
                        NSLayoutConstraint.activate([
                            iconView.widthAnchor.constraint(equalToConstant: 40),
                            iconView.heightAnchor.constraint(equalToConstant: 40),
                            iconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                            iconView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
                            ])
                    }
                } else {
                    
                    tempButton = innerView as? UIButton
                    
                    NSLayoutConstraint.activate([
                        innerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                        innerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                        innerView.heightAnchor.constraint(equalToConstant: expandableButtonExpandedHeight / 3),
                        innerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                    ])
                }
            }
            view.layoutSubviews()
            view.resignFirstResponder()
            self.adjustHideableButtonsOn(view: view, bottomButton: tempButton!)
        }
    }
    
    private func adjustHideableButtonsOn(view: UIView, bottomButton: UIButton) {
        
        let height = (expandableButtonExpandedHeight / 3) * 2 - 5
        hideableButtonsContainer = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: height))
        hideableButtonsContainer.isUserInteractionEnabled = true
        hideableButtonsContainer.translatesAutoresizingMaskIntoConstraints = false
        hideableButtonsContainer.addSubview(hideableButtonTop)
        hideableButtonsContainer.addSubview(hideableButtonMiddle)
        view.addSubview(hideableButtonsContainer)
        
        NSLayoutConstraint.activate([
            hideableButtonsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hideableButtonsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hideableButtonsContainer.topAnchor.constraint(equalTo: view.topAnchor),
            hideableButtonsContainer.bottomAnchor.constraint(equalTo: bottomButton.topAnchor, constant: -5),
            
            hideableButtonTop.leadingAnchor.constraint(equalTo: hideableButtonsContainer.leadingAnchor),
            hideableButtonTop.trailingAnchor.constraint(equalTo: hideableButtonsContainer.trailingAnchor),
            hideableButtonTop.topAnchor.constraint(equalTo: hideableButtonsContainer.topAnchor,constant: 5),
            hideableButtonTop.heightAnchor.constraint(equalToConstant: height / 2),
            
            hideableButtonMiddle.leadingAnchor.constraint(equalTo: hideableButtonsContainer.leadingAnchor),
            hideableButtonMiddle.trailingAnchor.constraint(equalTo: hideableButtonsContainer.trailingAnchor),
            hideableButtonMiddle.bottomAnchor.constraint(equalTo: hideableButtonsContainer.bottomAnchor),
            hideableButtonMiddle.heightAnchor.constraint(equalToConstant: height / 2)
        ])
        hideableButtonsContainer.isHidden = true
    }
    
    private func animateCenterButton() {
        
        let differenceBetweenOldAndNew: CGFloat = expandableButtonExpandedHeight - expandableButtonCollapsedHeight
        
        if centerButtonContainerState == .Collapsed {
            
            expandableButtonHeightAnchor?.constant = expandableButtonExpandedHeight
            expandableButtonTopAnchor?.constant = expandableButtonTopAnchor!.constant - differenceBetweenOldAndNew
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.layoutIfNeeded()
            }) { (_) in
                self.manageCenterButtonContent(state: .Expanded)
                self.centerButtonContainerState = .Expanded
            }
            
        } else {
            
            expandableButtonHeightAnchor?.constant = 75
            expandableButtonTopAnchor?.constant = expandableButtonTopAnchor!.constant + differenceBetweenOldAndNew
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
                self.manageCenterButtonContent(state: .Collapsed)
            }) { (_) in
                self.centerButtonContainerState = .Collapsed
            }
        }
    }
    
    private func manageCenterButtonContent(state: ButtonState) {
        
        if state == .Expanded {
            UIView.transition(with: hideableButtonsContainer, duration: 0.4, options: .transitionCrossDissolve, animations: {
                self.hideableButtonsContainer.isHidden = false
            }, completion: nil)
        } else {
            UIView.transition(with: hideableButtonsContainer, duration: 0.3, options: .curveEaseOut, animations: {
                self.hideableButtonsContainer.isHidden = true
            }, completion: nil)
        }
    }
    
    
    @objc fileprivate func handleButtonPress(_ sender: UIButton) {
        
        if sender.tag == 2 {
            animateCenterButton()
        }
        
        if sender.tag < viewControllerList.count {
            centerButtonView!.layer.borderColor = viewControllerList[sender.tag].view.backgroundColor?.cgColor
        }
        
        delegate?.expandableCenterTabBar(self, didSelectIndex: sender.tag)
    }
    
    // This func will allow us to receive touch event from expanded menu else
    // no touch event is received
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else { continue }
            return result
        }
        return nil
    }
}
