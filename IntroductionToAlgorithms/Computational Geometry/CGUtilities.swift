//
//  CGUtilities.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2018/9/30.
//  Copyright © 2018年 BaiYiYuan. All rights reserved.
//

import Foundation

enum PointDirection: Int {
    case clockwise
    case counterclockwise
    case collinear
}

func CGDirection(_ point1: CGPoint, _ point2: CGPoint) -> PointDirection {
    let det = point1.x * point2.y - point1.y * point2.x
    
    if det > 0 {
        return PointDirection.counterclockwise
    } else if det < 0 {
        return PointDirection.clockwise
    } else {
        return PointDirection.collinear
    }
}
