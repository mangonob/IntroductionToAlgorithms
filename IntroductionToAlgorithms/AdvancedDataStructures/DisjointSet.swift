//
//  DisjointSet.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2019/4/9.
//  Copyright © 2019 BaiYiYuan. All rights reserved.
//

import Foundation

class DisjointSet: CustomStringConvertible {
    var root: Node?
    
    @discardableResult
    func makeSet(_ key: Int) -> Node {
        let node = Node()
        node.key = key
        node.left = node
        node.right = node
        node.parent = node
        
        if let root = root {
            root.insert(node)
        } else {
            self.root = node
        }

        return node
    }
    
    func union(_ node: Node, otherNode: Node) {
        let root = find(node)
        let otherRoot = find(otherNode)
        
        if root === otherRoot {
            return
        }
        
        if root.rank > otherRoot.rank {
            remove(otherRoot)
            root.link(otherRoot)
        } else if root.rank < otherRoot.rank {
            remove(root)
            otherRoot.link(root)
        } else {
            otherRoot.remove()
            root.link(otherRoot)
            root.rank += 1
        }
    }
    
    func remove(_ node: Node) {
        node.remove()
        
        if node.right === node {
            node.right = nil
        }
        
        if let parent = node.parent {
            if parent.child === node  {
                parent.child = node.right
            }
            
            node.parent = nil
        } else {
            if root === node {
                root = node.right
            }
        }
    }

    func find(_ node: Node) -> Node {
        var root = node
        while root.parent !== nil && root.parent !== root {
            root = root.parent!
        }
        return root
    }
    
    var description: String {
        return root?.brothers().map { $0.description }.joined(separator: ", ") ?? "<Empty disjoint set>"
    }
}

extension DisjointSet {
    class Node: CustomStringConvertible {
        var key: Int = 0
        var rank: Int = 0
        weak var left: Node?
        var right: Node?
        weak var parent: Node?
        var child: Node?

        func remove() {
            let left = self.left
            let right = self.right
            left?.right = right
            right?.left = left
        }
        
        func insert(_ node: Node) {
            let right = self.right
            self.right = node
            node.left = self
            right?.left = node
            node.right = right
        }
        
        func link(_ node: Node) {
            node.remove()
            node.left = node
            node.right = node
            
            if let child = self.child {
                child.insert(node)
            } else {
                self.child = node
            }
            
            node.parent = self
        }
        
        func brothers() -> [Node] {
            var brothers = [Node]()
            var current: Node? = self
            repeat {
                brothers.append(current!)
                current = current?.right
            } while (current != nil && current !== self)
            return brothers
        }
        
        var description: String {
            return "[" + posterities().map { $0.key.description }.joined(separator: ", ") + "]"
        }
        
        private func posterities() -> [Node] {
            return (child?.brothers().flatMap { $0.posterities() } ?? []) + [self]
        }
    }
}

extension DisjointSet: Routine {
    static func routine() {
        let set = DisjointSet()
        let node1 = set.makeSet(1)
        let node2 = set.makeSet(2)
        let node3 = set.makeSet(3)
        print(set)
        set.union(node1, otherNode: node2)
        print(set)
        set.union(node1, otherNode: node3)
        print(set)
    }
}
