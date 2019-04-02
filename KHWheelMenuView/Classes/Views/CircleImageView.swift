//
//  CircleImageView.swift
//  KHWheelMenuView
//
//  Created by Kohey Nishioka on 2019/04/03.
//  Copyright © 2019 kohey. All rights reserved.
//

import UIKit

final class CircleImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = UIImage(named: "Gp_py25h_400x400")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(image: UIImage(named: "Gp_py25h_400x400"))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        commonInit()
    }
    
    func commonInit() {
//        let layer = CALayer()
//        layer.cornerRadius = self.bounds.width/2
//
//        // 内接円の半径
//        let radius = bounds.width < bounds.height ? (bounds.width/2.0) : (bounds.height/2.0)
//
//        let circle = UIBezierPath(arcCenter: self.center,
//                                  radius: radius,
//                                  startAngle: 0.0,
//                                  endAngle: 2*CGFloat.pi,
//                                  clockwise: true)
//        // 内側の色
//        // UIColor.lightGray.setFill()
//        // 内部の色を塗りつぶす
//        // circle.fill()
//        // 線の色
//        UIColor.black.setStroke()
//        // 線の太さ
//        circle.lineWidth = 2.0
//        // 線の色
//        circle.stroke()

        self.layer.masksToBounds = true
        self.layer.cornerRadius = bounds.width/2
    }
    
    
}
