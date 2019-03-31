//
//  WheelMenuView.swift
//  KHWheelMenuView
//
//  Created by Kohey Nishioka on 2019/03/31.
//  Copyright © 2019 kohey. All rights reserved.
//

import UIKit

@IBDesignable public final class WheelMenuView: UIView {

    @IBInspectable public var centerButtonRadius: CGFloat = 32 {
        didSet {
            // updateCenterButton()
        }
    }
    
    @IBInspectable public var menuBackGroundColor: UIColor = UIColor(white: 36/255, alpha: 1) {
        didSet {
            menuLayers.forEach {
                $0.fillColor = menuBackGroundColor.cgColor
            }
        }
    }
    
    @IBInspectable public var boarderColor: UIColor = UIColor(white: 0.4, alpha: 1) {
        didSet {
            menuLayers.forEach {
                $0.strokeColor = boarderColor.cgColor
            }
        }
    }

    fileprivate(set) var selectedIndex = 0

    fileprivate var startPoint = CGPoint.zero

    fileprivate var currentAngle: CGFloat {
        let angle = 2 * CGFloat.pi / CGFloat(menuLayers.count)
        return CGFloat(menuLayers.count - selectedIndex) * angle
    }

    fileprivate(set) var menuLayers = [MenuLayer]()
    
    private(set) lazy var menuBaseView: UIView = {
        UIView()
    }()
    
    // MARK: - Initializer
    
    convenience public init(frame: CGRect, tabBarItems: [UITabBarItem]) {
        self.init(frame: frame)
        self.tabBarItems = tabBarItems
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    fileprivate func commonInit() {
        addSubview(menuBaseView)

        menuBaseView.addGestureRecognizer(
            UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        )

        menuBaseView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|",
                                                      options:NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                      metrics: nil,
                                                      views: ["view": menuBaseView]))
                                                      // views: viewDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|",
                                                      options:NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                      metrics: nil,
                                                      views: ["view": menuBaseView]))
                                                      // views: viewDictionary))
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        tabBarItems = [
            UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1),
            UITabBarItem(tabBarSystemItem: .bookmarks, tag: 2),
            UITabBarItem(tabBarSystemItem: .bookmarks, tag: 3),
            UITabBarItem(tabBarSystemItem: .bookmarks, tag: 4),
            UITabBarItem(tabBarSystemItem: .bookmarks, tag: 5),
            UITabBarItem(tabBarSystemItem: .bookmarks, tag: 6),
            UITabBarItem(tabBarSystemItem: .bookmarks, tag: 7),
            UITabBarItem(tabBarSystemItem: .bookmarks, tag: 8)
        ]
    }
    
}


// MARK: - Interface
public extension WheelMenuView {
    
    var tabBarItems: [UITabBarItem] {
        get {
            return menuLayers.map({ $0.tabBarItem })
        }
        set {
            menuLayers.forEach{ $0.removeFromSuperlayer() }
            
            let angle = 2 * CGFloat.pi / CGFloat(newValue.count)
            let firstItemAngle = CGFloat.pi/2
            
            menuLayers = newValue.enumerated().map {
                let startAngle = CGFloat($0.offset) * angle - angle / 2 - firstItemAngle
                let endAngle   = CGFloat($0.offset + 1) * angle - angle / 2 - (CGFloat.pi/2) - 0.005
                let center     = CGPoint(x: bounds.width/2, y: bounds.height/2)
                
                var transform = CATransform3DMakeRotation(angle * CGFloat($0.offset), 0, 0, 1)
                transform = CATransform3DTranslate(transform, 0, -bounds.width/3, 0)
                
                let layer = MenuLayer(
                    center: center,
                    radius: bounds.width/2,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    tabBarItem: $0.element,
                    bounds: bounds,
                    contentsTransform: transform)
                
                layer.tintColor   = tintColor
                layer.strokeColor = boarderColor.cgColor
                layer.fillColor   = menuBackGroundColor.cgColor
                layer.selected    = $0.offset == selectedIndex
                
                menuBaseView.layer.addSublayer(layer)
                
                return layer
            }
        }
    }
    
}

// MARK: - Private
fileprivate extension WheelMenuView {
    
    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self)
        let velocity = sender.velocity(in: self)
        
        switch sender.state {
        case .began:
            startPoint = location
        case .changed: do {
            let radian1 = -atan2(
                startPoint.x - menuBaseView.center.x,
                startPoint.y - menuBaseView.center.y)
            let radian2 = -atan2(
                location.x - menuBaseView.center.x,
                location.y - menuBaseView.center.y)
            
            menuBaseView.transform = menuBaseView.transform.rotated(by: radian2 - radian1)
            
            startPoint = location
        }
        case .ended: do {
            let step: CGFloat = 0.05
            let lastX = location.x + CGFloat(velocity.x * step)
            let lastY = location.y + CGFloat(velocity.y * step)

            let radian1 = -atan2(
                startPoint.x - menuBaseView.center.x,
                startPoint.y - menuBaseView.center.y)
            let radian2 = -atan2(
                lastX - menuBaseView.center.x,
                lastY - menuBaseView.center.y)

            UIView.animate(withDuration: TimeInterval(0.5)) { [unowned self] in
                self.menuBaseView.transform = self.menuBaseView.transform.rotated(by: radian2 - radian1)
            }
            startPoint = location
        }
        default:
            let angle         = (2*CGFloat.pi) / CGFloat(menuLayers.count)
            var menuViewAngle = atan2(menuBaseView.transform.b, menuBaseView.transform.a)
            
            if menuViewAngle < 0 {
                menuViewAngle += (2*CGFloat.pi)
            }
            
            var index = menuLayers.count - Int((menuViewAngle + CGFloat.pi/4) / angle)
            if index == menuLayers.count {
                index = 0
            }
        }
    }
    
}
