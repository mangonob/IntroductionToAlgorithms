//
//  LinkedDisjointSet.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2019/4/8.
//  Copyright © 2019 BaiYiYuan. All rights reserved.
//

import Foundation

class LinkedSetNode: CustomStringConvertible {
    var key: Int = 0
    weak var set: LinkedSet!
    var next: LinkedSetNode?
    
    deinit {
        print("Deinit \(self)")
    }
    
    var description: String {
        return key.description
    }
}

class LinkedSet: CustomStringConvertible {
    var head: LinkedSetNode?
    var n: Int = 0
    weak var tail: LinkedSetNode?
    weak var left: LinkedSet?
    var right: LinkedSet?
    
    func insert(with set: LinkedSet) {
        let right = self.right
        self.right = set
        set.left = self
        right?.left = set
        set.right = right
    }
    
    func remove() {
        let left = self.left
        let right = self.right
        left?.right = right
        right?.left = left
    }
    
    deinit {
        print("Deinit \(self)")
    }
    
    var description: String {
        var elements = [LinkedSetNode]()
        
        var current = head
        while current != nil {
            elements.append(current!)
            current = current?.next
        }
        
        return "[" + elements.map {$0.description}.joined(separator: ", ") + "]"
    }
}

class LinkedDisjointSet: CustomStringConvertible {
    var linked: LinkedSet?

    func makeSet(_ key: Int) -> LinkedSetNode {
        let node = LinkedSetNode()
        node.key = key
        
        let set = LinkedSet()
        set.head = node
        set.tail = node
        set.left = set
        set.right = set
        set.n = 1
        node.set = set
        
        if let linked = linked {
            linked.left?.insert(with: set)
        } else {
            linked = set
        }
        
        return node
    }
    
    func union(_ node: LinkedSetNode, with otherNode: LinkedSetNode) {
        let set = find(node)
        let otherSet = find(otherNode)
        
        if set === otherSet {
            return
        }
        
        if set.n < otherSet.n {
            union(otherNode, with: node)
        }
        
        remove(otherSet)
        
        set.tail?.next = otherSet.head
        set.tail = otherSet.tail
        
        var current = otherSet.head
    
        while current != nil {
            current!.set = set
            current = current?.next
        }
    }

    func find(_ node: LinkedSetNode) -> LinkedSet {
        return node.set
    }
    
    func remove(_ set: LinkedSet) {
        set.remove()
        
        if set === linked {
            linked = set.right
        }
        
        if set.right === set  {
            set.right = nil
        }
    }
    
    var description: String {
        var sets = [LinkedSet]()
        
        var current = linked
        
        while current != nil {
            sets.append(current!)
            if current?.right === linked {
                break
            }
            current = current!.right
        }
        
        return "{" + sets.map { $0.description }.joined(separator: ", ") + "}"
    }
}

extension LinkedDisjointSet: Routine {
    static func routine() {
        let disjointSet = LinkedDisjointSet()
        let node1 = disjointSet.makeSet(1)
        let node2 = disjointSet.makeSet(2)
        let node3 = disjointSet.makeSet(3)
        print(disjointSet)
        disjointSet.union(node2, with: node3)
        print(disjointSet)
        disjointSet.union(node1, with: node2)
        print(disjointSet)
    }
}
