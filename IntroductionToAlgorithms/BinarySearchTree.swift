//
//  BinarySearchTree.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2018/7/23.
//  Copyright © 2018年 BaiYiYuan. All rights reserved.
//

import Foundation

class BinarySearchTreeNode<T: Comparable & CustomStringConvertible> {
    typealias Node = BinarySearchTreeNode<T>
    
    var parent: Node?
    var left: Node?
    var right: Node?
    var key: T?
    
    init(_ key: T? = nil, parent: Node? = nil, left: Node? = nil, right: Node? = nil) {
        self.key = key
        self.parent = parent
        self.left = left
        self.right = right
    }
    
    func min() -> Node? {
        return self.left?.min() ?? self
    }
    
    func max() -> Node? {
        return self.right?.max() ?? self
    }
    
    typealias Handler = (Node) -> Void
    func inorder(_ handler: Handler?) {
        left?.inorder(handler)
        handler?(self)
        right?.inorder(handler)
    }
    
    func prevorder(_ handler: Handler?) {
        handler?(self)
        left?.prevorder(handler)
        right?.prevorder(handler)
    }
    
    func postorder(_ handler: Handler?) {
        left?.postorder(handler)
        right?.postorder(handler)
        handler?(self)
    }
    
    func successor() -> Node? {
        if let right = right {
            return right.min()
        } else {
            var parent: Node? = self.parent
            var children: Node? = self
            
            while parent != nil && parent?.right === children {
                children = parent
                parent = parent?.parent
            }
            
            return parent
        }
    }
    
    func predecessor() -> Node? {
        if let left = left {
            return left.max()
        } else {
            var parent: Node? = self.parent
            var children: Node? = self
            
            while parent != nil && parent?.left === children {
                children = parent
                parent = parent?.parent
            }
            
            return parent
        }
    }

}

class BinarySearchTree<T: Comparable & CustomStringConvertible >: CustomStringConvertible {
    /** Binary search tree node */
    typealias Node = BinarySearchTreeNode<T>
    
    var root: Node?
    
    @discardableResult
    func insert(_ key: T) -> Node? {
        if let root = root {
            return insert(key, in: root)
        } else {
            root = Node(key)
            return root
        }
    }
    
    @discardableResult
    private func insert(_ key: T, `in` node: Node?) -> Node? {
        guard let node = node,
            let nodeKey = node.key else { return nil }
        
        if key == nodeKey {
            return nil
        } else if key < nodeKey, let left = node.left {
            return insert(key, in: left)
        } else if key < nodeKey /* left is nil */{
            let newNode = Node(key, parent: node)
            node.left = newNode
            return newNode
        } else if key > nodeKey, let right = node.right {
            return insert(key, in: right)
        } else {
            let newNode = Node(key, parent: node)
            node.right = newNode
            return newNode
        }
    }
    
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
    
    func min() -> Node? {
        return root?.min()
    }

    func max() -> Node? {
        return root?.max()
    }

    func remove(_ key: T) {
    }
    
    var height: Int {
        return height(of: root)
    }

    private func height(of node: Node?) -> Int {
        guard let node = node else { return 0 }
        return Swift.max(height(of: node.left), height(of: node.right)) + 1
    }
    
    var count: Int {
        return count(of: root)
    }
    
    private func count(of node: Node?) -> Int {
        guard let node = node else { return 0 }
        return count(of: node.left) + count(of: node.right) + 1
    }

    var description: String {
        var nodes = [Node]()
        root?.inorder { nodes.append($0) }
        return "[" + nodes.map{ $0.key?.description ?? "nil" }.joined(separator: ", ") + "]"
    }
}
