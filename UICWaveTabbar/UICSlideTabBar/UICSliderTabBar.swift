//
//  UICSliderTabBar.swift
//  UICWaveTabbar
//
//  Created by Coder ACJHP on 5.04.2019.
//  Copyright © 2019 Coder ACJHP. All rights reserved.
//

import UIKit

protocol UICSliderTabBarDelegate: class {
    func tabChanged(_ tabBarView: UICSliderTabBar, toIndex: Int)
}

class UICSliderTabBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Mark: - Private variables
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: effect)
        return blurView
    }()
    
    private var backgroundImageView: UIImageView = {
        let imgView = UIImageView(frame: .zero)
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    private var horizontalBarLine: UIView!
    
    private let cellId: String = "CustomCellId"
    private let fixedTabbarHeight: CGFloat = 49
    private var horizontalBarLineConstraint: NSLayoutConstraint?
    public var delegate: UICSliderTabBarDelegate?
    
    private var titleList = [String]()
    private var iconList = [UIImage]()
    
    // Mark: - Public variables
    public var selectedIconColor: UIColor = .red
    public var unSelectedIconColor: UIColor = .black
    public var selectedTitleColor: UIColor = .red
    public var unSelectedTitleColor: UIColor = .black
    public var horizontalBarLineColor: UIColor = .red
    public var itemHighlightedColor: UIColor = UIColor.init(white: 0.5, alpha: 1)
    
    public var isBlured: Bool = false {
        didSet {
            insertSubview(blurView, at: 0)
        }
    }
    
    public var backgroundImage: UIImage? = nil {
        didSet {
            if !isBlured {
                insertSubview(backgroundImageView, at: 0)
            }
        }
    }
    
    public var barBackgroundColor: UIColor = .white {
        didSet {
            self.backgroundColor = barBackgroundColor
        }
    }
    
    
    // Mark: - Lifecyle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initalizeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initalizeView()
    }
    
    fileprivate func initalizeView() {
        
        self.backgroundColor = barBackgroundColor
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalTo: widthAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: fixedTabbarHeight),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        collectionView.register(TabItemCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    public func setupIconsAndTitles(iconList: [UIImage], titleList: [String]) {
        self.iconList = iconList
        self.titleList = titleList
        collectionView.reloadData()
        
        setupHorizontalBar()
        
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
    }
    
    private func setupHorizontalBar() {
        
        horizontalBarLine = UIView(frame: .zero)
        horizontalBarLine.backgroundColor = horizontalBarLineColor
        horizontalBarLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarLine)
        
        horizontalBarLineConstraint = horizontalBarLine.leftAnchor.constraint(equalTo: leftAnchor)
        horizontalBarLineConstraint!.isActive = true
        NSLayoutConstraint.activate([
            horizontalBarLine.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            horizontalBarLine.widthAnchor.constraint(equalToConstant: bounds.width/CGFloat(titleList.count)),
            horizontalBarLine.heightAnchor.constraint(equalToConstant: 4),
        ])
    }
    
    // Mark: - Deleaget & Datasource functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tabItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TabItemCell
        tabItemCell.itemHighlightedColor = itemHighlightedColor
        tabItemCell.selectedIconColor = selectedIconColor
        tabItemCell.unSelectedIconColor = unSelectedIconColor
        tabItemCell.iconView.image = iconList[indexPath.item].withRenderingMode(.alwaysTemplate)
        tabItemCell.titleLabel.text = titleList[indexPath.item]
        return tabItemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / CGFloat(titleList.count), height: fixedTabbarHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // change position and animate horizontalBarLine
        let posiXForBarLine = CGFloat(indexPath.item) * frame.width / CGFloat(titleList.count)
        horizontalBarLineConstraint?.constant = posiXForBarLine
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
        
        delegate?.tabChanged(self, toIndex: indexPath.item)
    }
    
}

// Mark: - CollectionView cell
class TabItemCell: UICollectionViewCell {
    
    let titleLabel = UILabel()
    let iconView = UIImageView()
    var selectedIconColor: UIColor = .red
    var unSelectedIconColor: UIColor = .black
    var selectedTitleColor: UIColor = .red
    var unSelectedTitleColor: UIColor = .black
    var itemHighlightedColor: UIColor = .clear
    
    override var isSelected: Bool {
        didSet {
            iconView.tintColor = isSelected ? selectedIconColor : unSelectedIconColor
            titleLabel.textColor = isSelected ? selectedTitleColor : unSelectedTitleColor
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            titleLabel.textColor = isHighlighted ? .white : selectedTitleColor
            iconView.tintColor = isHighlighted ? .white : selectedIconColor
            backgroundColor = isHighlighted ? itemHighlightedColor : .clear
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        iconView.tintColor = unSelectedIconColor
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconView)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 11)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 25),
            iconView.heightAnchor.constraint(equalToConstant: 25),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 15),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
