//
//  main.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2018/7/9.
//  Copyright © 2018年 BaiYiYuan. All rights reserved.
//

import Foundation


let tree = BinarySearchTree<Int>()

for _ in 0..<100000 {
    tree.insert(Int(arc4random() % 100000))
}

print(tree)
