//
//  Utilities.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2019/3/14.
//  Copyright © 2019 BaiYiYuan. All rights reserved.
//

import Foundation

func time(_ label: String, handler: () -> Void) {
    let current = Date()
    handler()
    print(String(format: "\(label) use %fs.", Date().timeIntervalSince(current)))
}
