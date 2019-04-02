//
//  KHVector.swift
//  KHWheelMenuView
//
//  Created by Kohey Nishioka on 2019/04/03.
//  Copyright © 2019 kohey. All rights reserved.
//

import UIKit

class KHVector {
    
    class func circlePoint(distance: CGFloat, angle: CGFloat, center: CGPoint) -> CGPoint {
        let dx = distance * cos(angle)
        let dy = distance * sin(angle)
        return CGPoint(x: center.x + dx, y: center.y + dy)
    }
    
}
