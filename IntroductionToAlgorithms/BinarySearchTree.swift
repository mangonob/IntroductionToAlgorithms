//
//  BinarySearchTree.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2018/7/23.
//  Copyright © 2018年 BaiYiYuan. All rights reserved.
//

import Foundation

typealias TreeElement = Comparable & CustomStringConvertible
class BinarySearchTreeNode<T: TreeElement> {
    typealias Node = BinarySearchTreeNode<T>

    var parent: Node?
    var left: Node?
    var right: Node?
    var key: T?
    
    enum Color: Int {
        case red
        case black
    }
    
    var color: Color = .black
    
    var isRed: Bool {
        return color == .red
    }
    
    var isBlack: Bool {
        return !isRed
    }

    init(_ key: T? = nil, parent: Node? = nil, left: Node? = nil, right: Node? = nil, color: Color = .black) {
        self.key = key
        self.parent = parent
        self.left = left
        self.right = right
        self.color = color
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

class BinarySearchTree<T: TreeElement>: CustomStringConvertible, CustomDebugStringConvertible {
    /** Binary search tree node */
    typealias Node = BinarySearchTreeNode<T>
    
    var root: Node?
    
    func insert(_ key: T) {
        root = insert(key, in: root, withParent: nil)
    }
    
    /**
     - parameter key: key value to insert.
     - parameter node: Root node to insert to.
     - returns: Node you pass into or a new node to insert.
     */
    @discardableResult
    internal func insert(_ key: T, `in` node: Node?, withParent parent: Node?) -> Node {
        guard let node = node,
            let nodeKey = node.key else {
                return Node(key, parent: parent, color: .red)
        }
        
        if key < nodeKey {
            node.left = insert(key, in: node.left, withParent: node)
        } else if key > nodeKey {
            node.right = insert(key, in: node.right, withParent: node)
        }
        
        return node
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

    internal func transplant(_ node: Node?, with otherNode: Node?) {
        guard let node = node else { return }
        if node.parent == nil {
            root = otherNode
        } else if node === node.parent?.left /* node is left child */ {
            node.parent?.left = otherNode
        } else /* node is right child */ {
            node.parent?.right = otherNode
        }
        otherNode?.parent = node.parent
    }
    
    @discardableResult
    func remove(_ key: T) -> Bool {
        guard let node = search(key) else {
            return false
        }
        
        if node.left == nil {
            transplant(node, with: node.right)
        } else if node.right == nil {
            transplant(node, with: node.left)
        } else /* both have left and right child */{
            guard let successor = node.right?.min() else { return false }
            transplant(successor, with: successor.right)
            transplant(node, with: successor)
            successor.left = node.left
            successor.left?.parent = successor
            successor.right = node.right
            successor.right?.parent = successor
        }

        return true
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
    
    var debugDescription: String {
        func edge(of node: Node?, length: Int = 1) -> String {
            var unit = "-"
            if let node = node, node.isRed {
                unit = "="
            }
            return [String](repeating: unit, count: length).joined()
        }
        
        var nodes = [Node]()
        root?.prevorder { nodes.append($0) }
        let nodesDescription = nodes.map({ (node) -> String in
            let left = node.left?.key?.description ?? "nil"
            let right = node.right?.key?.description ?? "nil"
            let key = node.key?.description ?? "nil"
            let parent = node.parent?.key?.description ?? "root"
            return [parent, "\(edge(of: node, length: 2))", "(", left, "<\(edge(of: node.left))", key, "\(edge(of: node.right))>", right, ")"].joined(separator: " ")
        })
        return "[" + nodesDescription.joined(separator: ", ") + "]"
    }
}
