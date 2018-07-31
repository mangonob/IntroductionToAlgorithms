//
//  main.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2018/7/9.
//  Copyright © 2018年 BaiYiYuan. All rights reserved.
//

import Foundation


let tree = BinarySearchTree<Int>()

for i in 0..<1000 {
    tree.insert(i)
}

print(tree.height)

let rbTree = RedBlackTree<Int>()

for i in 0..<1000 {
    rbTree.insert(i)
}

print(rbTree.height)
