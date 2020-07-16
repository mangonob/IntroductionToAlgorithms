//
//  TreapTree.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2018/8/14.
//  Copyright © 2018年 mangonob. All rights reserved.
//

import Foundation

class TreapTreeNode<T: TreeElement> {
    typealias Node = TreapTreeNode<T>
    var key: T?
    var left: Node?
    var right: Node?
    var parent: Node?
    var proprity: UInt32 = arc4random() % UInt32.max
    
    init(_ key: T? = nil, left: Node? = nil, right: Node? = nil, parent: Node? = nil, proprity: UInt32? = nil) {
        self.key = key
        self.left = left
        self.right = right
        self.parent = parent
        if let proprity = proprity { self.proprity = proprity }
    }
}

class TreapTree<T: TreeElement> {
    typealias Node = TreapTreeNode<T>
    
    private lazy var Nil = Node(proprity: UInt32.max)
    lazy var root: Node? = Nil
    
    @discardableResult
    func search(_ key: T) -> Node? {
        return search(key, in: root)
    }
    
    @discardableResult
    private func search(_ key: T, `in` node: Node?) -> Node? {
        guard let node = node,
            let nodeKey = node.key else { return nil }
        
        if key == nodeKey {
            return node
        } else if key < nodeKey {
            return search(key, in: node.left)
        } else {
            return search(key, in: node.right)
        }
    }
    
    @discardableResult
    private func leftRotate(_ node: Node?) -> Node? {
        guard let node = node,
            let right = node.right else { return nil }
        
        if let parent = node.parent {
            if node === parent.left {
                parent.left = right
                right.parent = parent
            } else /** node is a right child */ {
                parent.right = right
                right.parent = parent
            }
        } else {
            root = right
            right.parent = nil
        }
        
        node.right = right.left
        right.left?.parent = node
        right.left = node
        node.parent = right

        return right
    }
    
    @discardableResult
    private func rightRotate(_ node: Node?) -> Node? {
        guard let node = node,
            let left = node.left else { return nil }
        
        if let parent = node.parent {
            if node === parent.left {
                parent.left = left
                left.parent = parent
            } else /** node is a right child */ {
                parent.right = left
                left.parent = parent
            }
        } else {
            root = left
            left.parent = nil
        }
        
        node.left = left.right
        left.right?.parent = node
        left.right = node
        node.parent = left

        return left
    }
    
    func transplant(_ node: Node?, with otherNode: Node?) {
        guard let node = node else { return }
        if node.parent == nil {
            root = otherNode
        } else if node.parent?.left === node {
            node.parent?.left = otherNode
        } else if node.parent?.right === node {
            node.parent?.right = otherNode
        }
        otherNode?.parent = node.parent
    }
    
    func insert(_ key: T) {
        root = insert(key, in: root, withParent: nil)
    }
    
    func min(of node: Node?) -> Node? {
        guard let node = node, node !== Nil else {
            return nil
        }
        
        return min(of: node.left)
    }
    
    func max(of node: Node?) -> Node? {
        guard let node = node, node !== Nil else {
            return nil
        }
        
        return max(of: node.right)
    }
    
    func isHeap() -> Bool {
        return isHeap(root)
    }
    
    var height: Int {
        return maxHeight
    }
    
    var maxHeight: Int {
        return maxHeight(of: root)
    }
    
    private func maxHeight(of node: Node?) -> Int {
        guard let node = node, node !== Nil else { return 0 }
        return Swift.max(maxHeight(of: node.left), maxHeight(of: node.right)) + 1
    }
    
    var minHeight: Int {
        return minHeight(of: root)
    }
    
    private func minHeight(of node: Node?) -> Int {
        guard let node = node, node !== Nil else { return 0 }
        return Swift.min(minHeight(of: node.left), minHeight(of: node.right)) + 1
    }
    
    private func isHeap(_ node: Node?) -> Bool {
        guard let node = node else {
            return false
            
        }
        let result = node === Nil ||
            isHeap(node.left) && isHeap(node.right) &&
            node.proprity <= node.left!.proprity && node.proprity <= node.right!.proprity
        if !result {
            fatalError()
        }
        return result
    }
    
    func successor(of node: Node?) -> Node? {
        if let right = node?.right, right !== Nil {
            return min(of: right)
        } else {
            var parent = node?.parent
            var child = node
            
            while parent != nil && child === parent!.right {
                child = parent
                parent = parent?.parent
            }
            
            return parent
        }
    }
    
    func predecessor(of node: Node?) -> Node? {
        if let left = node?.left, left !== Nil {
            return max(of: left)
        } else {
            var parent = node?.parent
            var child = node
            
            while parent != nil && child === parent!.left {
                child = parent
                parent = parent?.parent
            }
            
            return parent
        }
    }

    @discardableResult
    private func insert(_ key: T, `in` node: Node?, withParent parent: Node?) -> Node? {
        guard var node = node, node !== Nil,
            let nodeKey = node.key else {
            return Node.init(key, left: Nil, right: Nil, parent: parent)
        }
        
        if nodeKey == key {
            return node
        } else if key > nodeKey {
            node.right = insert(key, in: node.right, withParent: node)
        } else /** key < nodeKey */ {
            node.left = insert(key, in: node.left, withParent: node)
        }
        
        if node.proprity > node.left!.proprity {
            node = rightRotate(node)!
        } else if node.proprity > node.right!.proprity {
            node = leftRotate(node)!
        }
        
        return node
    }
    
    func remove(_ key: T) {
        guard let node = search(key) else { return }
        
        if node.left === Nil {
            transplant(node, with: node.right)
        } else if node.right === Nil {
            transplant(node, with: node.left)
        } else {
            guard let successor = successor(of: node) else { return }
            transplant(successor, with: successor.right)
            transplant(node, with: successor)
            successor.left = node.left
            node.left?.parent = successor
            successor.right = node.right
            node.right?.parent = successor
            
            while successor.proprity > successor.left!.proprity || successor.proprity > successor.right!.proprity {
                if successor.left!.proprity < successor.right!.proprity {
                    rightRotate(successor)
                } else {
                    leftRotate(successor)
                }
            }
        }
    }
}
