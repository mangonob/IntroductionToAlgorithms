//
//  RedBlackTree.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2018/7/31.
//  Copyright © 2018年 mangonob. All rights reserved.
//

import Foundation

class RedBlackTree<T: TreeElement>: BinarySearchTree<T> {
    fileprivate lazy var Nil = Node()
    
    @discardableResult
    internal func leftRotate(_ node: Node?) -> Node? {
        guard let node = node, node !== Nil,
            let right = node.right, right !== Nil else { return nil }
        
        /*
         * swap color with node and right.
         * color of right should always be red
         */
        right.color = node.color
        node.color = .red
        
        if let parent = node.parent, parent !== Nil {
            if parent.left === node {
                parent.left = right
            } else /* node is the right child of parent */ {
                parent.right = right
            }
            right.parent = parent
        } else {
            root = right
            right.parent = Nil
        }
        
        node.right = right.left
        right.left?.parent = node
        right.left = node
        node.parent = right
        
        return right
    }
    
    @discardableResult
    internal func rightRotate(_ node: Node?) -> Node? {
        guard let node = node, node !== Nil,
            let left = node.left, left !== Nil else { return nil }
        
        /*
         * swap color with node and right.
         * color of left should always be red
         */
        left.color = node.color
        node.color = .red
        
        if let parent = node.parent, parent !== Nil {
            if parent.left === node {
                parent.left = left
            } else /* node is the right child of parent */ {
                parent.right = left
            }
            left.parent = parent
        } else {
            root = left
            left.parent = Nil
        }
        
        node.left = left.right
        left.right?.parent = node
        left.right = node
        node.parent = left
        
        return left
    }

    private func flipColor(_ node: Node?) {
        node?.left?.color = .black
        node?.right?.color = .black
        node?.color = .red
    }
    
    override func transplant(_ node: BinarySearchTreeNode<T>?, with otherNode: BinarySearchTreeNode<T>?) {
        guard let node = node else { return }
        if node.parent === Nil {
            root = otherNode
            otherNode?.parent = Nil
        } else if node === node.parent?.left /* node is left child */ {
            node.parent?.left = otherNode
        } else /* node is right child */ {
            node.parent?.right = otherNode
        }
        otherNode?.parent = node.parent
    }
    
    override func min(of node: BinarySearchTreeNode<T>?) -> BinarySearchTreeNode<T>? {
        if let left = node?.left, left !== Nil {
            return min(of: left)
        }
        return node
    }

    override func max(of node: BinarySearchTreeNode<T>?) -> BinarySearchTreeNode<T>? {
        if let right = node?.right, right !== Nil {
            return max(of: right)
        }
        return node
    }
    
    override func successor(of node: BinarySearchTreeNode<T>?) -> BinarySearchTreeNode<T>? {
        if let right = node?.right, right !== Nil {
            return min(of: right)
        } else {
            var parent = node?.parent
            var child = node
            
            while parent != nil && parent !== Nil && parent?.right === child {
                child = parent
                parent = parent?.parent
            }
            
            return parent
        }
    }
    
    override func predecessor(of node: BinarySearchTreeNode<T>?) -> BinarySearchTreeNode<T>? {
        if let left = node?.left, left !== Nil {
            return max(of: left)
        } else {
            var parent = node?.parent
            var child = node
            
            while parent != nil && parent !== Nil && parent?.left === child {
                child = parent
                parent = parent?.parent
            }
            
            return parent
        }
    }
    
    var blackHeight: Int {
        return maxBlackHeight
    }

    var minBlackHeight: Int {
        return minBlackHeight(of: root)
    }
    
    public func minBlackHeight(of node: Node?) -> Int {
        guard let node = node, node !== Nil else { return 0 }
        
        guard let left = node.left, let right = node.right else {
            fatalError() /** Leaf node must have both left and right children. */
        }
        
        let l = left.isBlack ? 1 : 0
        let r = right.isBlack ? 1 : 0
        return Swift.min(minBlackHeight(of: node.left) + l, minBlackHeight(of: node.right) + r)
    }
    
    var maxBlackHeight: Int {
        return maxBlackHeight(of: root)
    }
    
    public func maxBlackHeight(of node: Node?) -> Int {
        guard let node = node, node !== Nil else { return 0 }
        
        guard let left = node.left, let right = node.right else {
            fatalError() /** Leaf node must have both left and right children. */
        }
        
        let l = left.isBlack ? 1 : 0
        let r = right.isBlack ? 1 : 0
        return Swift.max(maxBlackHeight(of: node.left) + l, maxBlackHeight(of: node.right) + r)
    }
    
    override func insert(_ key: T) {
        root = insert(key, in: root, withParent: Nil)
        root?.color = .black
    }

    @discardableResult
    override func insert(_ key: T, in node: BinarySearchTreeNode<T>?, withParent parent: BinarySearchTreeNode<T>?) -> BinarySearchTreeNode<T> {
        guard var node = node, node !== Nil,
            let nodeKey = node.key else {
                return Node.init(key, parent: parent, left: Nil, right: Nil, color: .red)
        }
        
        if key < nodeKey {
            node.left = insert(key, in: node.left, withParent: node)
        } else if key > nodeKey {
            node.right = insert(key, in: node.right, withParent: node)
        }
        
        if let left = node.left, let leftLeft = node.left?.left, left.isRed && leftLeft.isRed {
            node = rightRotate(node)!
        } else if let left = node.left, let leftRight = node.left?.right, left.isRed && leftRight.isRed {
            leftRotate(left)
            node = rightRotate(node)!
        } else if let right = node.right, let rightRight = node.right?.right, right.isRed && rightRight.isRed {
            node = leftRotate(node)!
        } else if let right = node.right, let rightLeft = node.right?.left, right.isRed && rightLeft.isRed {
            rightRotate(right)
            node = leftRotate(node)!
        }
        
        if let left = node.left, let right = node.right, left.isRed && right.isRed {
            flipColor(node)
        }

        return node
    }
    
    @discardableResult
    override func remove(_ key: T) -> Bool {
        guard let node = search(key) else {
            return false
        }
        
        var badNode: Node? = nil

        if node.left === Nil {
            if node.isBlack { badNode = node.right }
            transplant(node, with: node.right)
        } else if node.right === Nil {
            if node.isBlack { badNode = node.left }
            transplant(node, with: node.left)
        } else /* both have left and right child */{
            guard let successor = successor(of: node) else { return false }
            if successor.isBlack { badNode = successor.right }

            transplant(successor, with: successor.right)
            transplant(node, with: successor)
            successor.color = node.color
            successor.left = node.left
            successor.left?.parent = successor
            successor.right = node.right
            successor.right?.parent = successor
        }
        
        if let badNode = badNode {
            removeFixUp(badNode)
        }

        return true
    }

    private func removeFixUp(_ node: Node?) {
        guard let node = node else { return }
        
        if node.isRed {
            node.color = .black
            return
        }

        guard let parent = node.parent,
            let brother = node.brother else { return }
        
        if brother.isRed /** nephew must be black */ {
            if brother === parent.left {
                rightRotate(parent)
            } else /* brother === parent.right */{
                leftRotate(parent)
            }
            /** new brother must be black */
            removeFixUp(node)
            return
        }

        if brother.left!.isBlack && brother.right!.isBlack
            /** all nephew is black */
        {
            brother.color = .red
            removeFixUp(parent)
            return
        }

        if brother === parent.left && brother.left!.isBlack && brother.right!.isRed {
            leftRotate(brother)
        } else if brother === parent.right && brother.right!.isBlack && brother.left!.isRed {
            rightRotate(brother)
        }
        
        parent.left?.color = .red
        parent.right?.color = .red
        
        let rotated = node === parent.left ? leftRotate(parent) : rightRotate(parent)
        rotated?.left?.color = .black
        rotated?.right?.color = .black
        node.color = .black
    }
}
