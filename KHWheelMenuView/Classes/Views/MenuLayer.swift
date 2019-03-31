//
//  MenuLayer.swift
//  KHWheelMenuView
//
//  Created by Kohey Nishioka on 2019/03/31.
//  Copyright © 2019 kohey. All rights reserved.
//

import UIKit

final class MenuLayer: CAShapeLayer {

    let tabBarItem: UITabBarItem
    
    var tintColor: UIColor = UIColor.red {
        didSet {
            // updateContents()
        }
    }
    
    var selected = false {
        didSet {
            // updateContents()
        }
    }
    
    fileprivate let disableColor = UIColor(white: 0.4, alpha: 1)
    
    fileprivate let contentsLayer: CALayer
    
    fileprivate let arcLayer: CAShapeLayer
    
    // MARk; - Initializer
    
    init(center: CGPoint,
         radius: CGFloat,
         startAngle: CGFloat,
         endAngle: CGFloat,
         tabBarItem: UITabBarItem,
         bounds: CGRect,
         contentsTransform: CATransform3D
    ) {
        self.tabBarItem = tabBarItem
        
        let scale    = UIScreen.main.scale
        let arcWidth = CGFloat(5)
        
        let bezierPath = UIBezierPath()
        bezierPath.addArc(withCenter: center,
                          radius: bounds.width/2 - arcWidth/2,
                          startAngle: startAngle-0.01,
                          endAngle: endAngle+0.01,
                          clockwise: true)
        
        arcLayer             = CAShapeLayer()
        arcLayer.path        = bezierPath.cgPath
        arcLayer.lineWidth   = arcWidth
        arcLayer.fillColor   = UIColor.clear.cgColor
        
        contentsLayer                    = CALayer()
        contentsLayer.frame              = bounds
        contentsLayer.contentsGravity    = CALayerContentsGravity.center
        contentsLayer.contentsScale      = scale
        contentsLayer.transform          = contentsTransform
        contentsLayer.rasterizationScale = scale
        contentsLayer.shouldRasterize    = true
        
        super.init()
        
        let path = UIBezierPath()
        path.addArc(withCenter: center,
                    radius: bounds.width/2,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: true)
        path.addLine(to: center)
        
        self.path          = path.cgPath
        lineWidth          = 1
        rasterizationScale = scale
        shouldRasterize    = true
        
        updateContents()
        
        addSublayer(contentsLayer)
        addSublayer(arcLayer)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func updateContents() {
        if selected {
            contentsLayer.contents = tabBarItem.selectedImage?.cgImage
            arcLayer.strokeColor = tintColor.cgColor
        } else {
            contentsLayer.contents = tabBarItem.image?.cgImage
            arcLayer.strokeColor = UIColor.clear.cgColor
        }
    }

}
