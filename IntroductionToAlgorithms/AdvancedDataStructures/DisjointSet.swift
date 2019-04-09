//
//  DisjointSet.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2019/4/9.
//  Copyright © 2019 BaiYiYuan. All rights reserved.
//

import Foundation

class DisjointSet {
    
    func makeSet(_ key: Int) -> Node {
        let node = Node()
        return node
    }
    
    func union(_ node: Node, otherNode: Node) {
    }
    
    func find(_ node: Node) -> Node {
        fatalError()
    }
}

extension DisjointSet {
    class Node {
        var key: Int = 0
        weak var parent: Node?
    }
}

extension DisjointSet: Routine {
    static func routine() {
        let set = DisjointSet()
        print(set)
    }
}
