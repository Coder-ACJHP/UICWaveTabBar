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

public let orientationChanged = Notification.Name.init(rawValue: "orientationChanged")

class UICSliderTabBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Mark: - Private variables
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
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
    private var horizontalBarLineLeadingConstraint: NSLayoutConstraint?
    private var horizontalBarLineWidthConstraint: NSLayoutConstraint?
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
            if isBlured { insertSubview(blurView, at: 0) }
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
    
    public var isScrollEnabledForMoreThanFiveElements: Bool = false {
        didSet {
            if isScrollEnabledForMoreThanFiveElements {
                flowLayout.scrollDirection = .horizontal
                collectionView.alwaysBounceHorizontal = isScrollEnabledForMoreThanFiveElements
            }
        }
    }
    
    public var isGlowing: Bool = false {
        didSet {
            if isGlowing {
                itemHighlightedColor = .clear
            }
        }
    }
    public var glowColor: UIColor = .red
    
    private var isRotated: Bool = false
    private let observerKeyPath: String = "contentSize"
    private var lastSelectedItemIndexPath = IndexPath(row: 0, section: 0)
    
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
            collectionView.heightAnchor.constraint(equalToConstant: fixedTabbarHeight),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // Register cell
        collectionView.register(TabItemCell.self, forCellWithReuseIdentifier: cellId)
        // Add notification observer to handle orientation change
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleOrientationChange),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
        // Add observer for fresh content size
        collectionView.addObserver(self, forKeyPath: observerKeyPath, options: [.new], context: nil)
        
        perform(#selector(selectFirstItem), with: nil, afterDelay: 0.3)
    }
    
    // Collection view content resize completed
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let cell = self.collectionView.visibleCells.first as? TabItemCell {
            if self.horizontalBarLineWidthConstraint!.constant != cell.bounds.width {
                self.horizontalBarLineWidthConstraint?.constant = cell.bounds.width
                self.horizontalBarLine.layoutIfNeeded()
                relocateHorizontalBarWith(indexPath: lastSelectedItemIndexPath)
            }
        }
    }
    
    public func setupIconsAndTitles(iconList: [UIImage], titleList: [String]) {
        self.iconList = iconList
        self.titleList = titleList
        collectionView.reloadData()
        
        setupHorizontalBar()
    }

    private func setupHorizontalBar() {
        horizontalBarLine = UIView(frame: .zero)
        horizontalBarLine.backgroundColor = horizontalBarLineColor
        horizontalBarLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarLine)

        horizontalBarLineLeadingConstraint = horizontalBarLine.leftAnchor.constraint(equalTo: leftAnchor)
        horizontalBarLineLeadingConstraint!.isActive = true

        horizontalBarLineWidthConstraint = horizontalBarLine.widthAnchor.constraint(equalToConstant: bounds.width/CGFloat(titleList.count))
        horizontalBarLineWidthConstraint?.isActive = true

        horizontalBarLine.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        horizontalBarLine.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    private func applyGlow(toView: UIView, withColor: UIColor) {
        
        toView.layer.shadowPath = CGPath(roundedRect: toView.bounds, cornerWidth: 5, cornerHeight: 5, transform: nil)
        toView.layer.shadowColor = withColor.cgColor
        toView.layer.shadowOffset = CGSize.zero
        toView.layer.shadowRadius = 10
        toView.layer.shadowOpacity = 1
    }
    
    private func removeGlowAnimation(fromView: UIView) {
        
        fromView.layer.shadowPath = nil
        fromView.layer.shadowColor = UIColor.clear.cgColor
        fromView.layer.shadowOffset = CGSize.zero
        fromView.layer.shadowRadius = 0
        fromView.layer.shadowOpacity = 0
    }
    
    @objc private func selectFirstItem() {
        collectionView.selectItem(at: lastSelectedItemIndexPath, animated: false, scrollPosition: .left)
    }
    
    @objc private func handleOrientationChange() {
        // Reload collection view content to handle content size change
        // When it's finish reloading resize horizontal bar size and position
        // (We can get correct size from content size observer)
        self.flowLayout.invalidateLayout()
        self.collectionView.reloadData()
        self.isRotated = true
    }
    
    private func relocateHorizontalBarWith(indexPath: IndexPath) {
        if let cellAttribs = self.collectionView.layoutAttributesForItem(at: indexPath) {
            let cellFrame = cellAttribs.frame
            let cellFrameInSuperview = collectionView.convert(cellFrame, to: collectionView.superview)
            horizontalBarLineLeadingConstraint?.constant = cellFrameInSuperview.minX
            UIView.animate(withDuration: 0.4, delay: 0.0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 2,
                           options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    public func showBadgeFor(cell index: Int, with text: String) {
        let indexPath = IndexPath(item: index, section: 0)
        if let cell = collectionView.cellForItem(at: indexPath) as? TabItemCell {
            cell.badgeText = text
        }
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
        tabItemCell.selectedTitleColor = selectedTitleColor
        tabItemCell.unSelectedTitleColor = unSelectedTitleColor
        tabItemCell.iconView.image = iconList[indexPath.item].withRenderingMode(.alwaysTemplate)
        tabItemCell.titleLabel.text = titleList[indexPath.item]
        return tabItemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return isScrollEnabledForMoreThanFiveElements ? CGSize(width: frame.width / 5, height: fixedTabbarHeight) : CGSize(width: frame.width / CGFloat(titleList.count), height: fixedTabbarHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // change position and animate horizontalBarLine
        relocateHorizontalBarWith(indexPath: indexPath)
        
        // Remove glow layer from the view
        collectionView.visibleCells.forEach {
            if isGlowing { removeGlowAnimation(fromView: $0.contentView) }
        }
        // Apply glow animation if enabled
        if let currentCell = collectionView.cellForItem(at: indexPath) as? TabItemCell {
            currentCell.badgeText = nil
            if self.isGlowing { self.applyGlow(toView: currentCell.contentView, withColor: self.glowColor) }
        }
        lastSelectedItemIndexPath = indexPath
        delegate?.tabChanged(self, toIndex: indexPath.item)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        relocateHorizontalBarWith(indexPath: lastSelectedItemIndexPath)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        collectionView.removeObserver(self, forKeyPath: observerKeyPath)
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
    var badgeText: String? = nil {
        didSet {
            if badgeText == nil {
                badgeLabel.isHidden = true
            } else {
                badgeLabel.alpha = 0
                badgeLabel.isHidden = false
                UIView.animate(withDuration: 0.5, delay: 0,
                               usingSpringWithDamping: 1,
                               initialSpringVelocity: 2,
                               options: .curveEaseIn, animations: {
                    self.badgeLabel.text = self.badgeText
                    self.badgeLabel.alpha = 1.0
                }, completion: nil)
            }
        }
    }
    
    private var badgeLabel: UIBadgeLabel = {
        let label = UIBadgeLabel(frame: .zero)
        label.backgroundColor = .red
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .white
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            badgeText = nil
            iconView.tintColor = isSelected ? selectedIconColor : unSelectedIconColor
            titleLabel.textColor = isSelected ? selectedTitleColor : unSelectedTitleColor
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? itemHighlightedColor : .clear
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        iconView.tintColor = unSelectedIconColor
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconView)
        
        addSubview(badgeLabel)
        
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
            
            badgeLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 40),
            badgeLabel.heightAnchor.constraint(equalToConstant: 15),
            badgeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            badgeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 15),
        ])
        
        badgeLabel.layer.cornerRadius = 5
        badgeLabel.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UIBadgeLabel: UILabel {
    
    override var intrinsicContentSize: CGSize {
        let originalSize = super.intrinsicContentSize
        return CGSize(width: originalSize.width + 8, height: originalSize.height)
    }
}
