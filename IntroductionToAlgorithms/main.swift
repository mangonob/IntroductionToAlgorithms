//
//  main.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2018/7/9.
//  Copyright © 2018年 BaiYiYuan. All rights reserved.
//

import Foundation

let treapTree = TreapTree<Int>()

let total = 100000

var old = Date()
print("Start insert")
for i in 0..<total {
    treapTree.insert(i)
}
print("End insert used: \(Date().timeIntervalSince(old))s")
print(treapTree.minHeight)
print(treapTree.maxHeight)

old = Date()
print("Start remove")
for i in 0..<total {
    treapTree.remove(i)
}
print("End insert used: \(Date().timeIntervalSince(old))s")
