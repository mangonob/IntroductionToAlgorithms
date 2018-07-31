//
//  RedBlackTree.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2018/7/31.
//  Copyright © 2018年 BaiYiYuan. All rights reserved.
//

import Foundation

class RedBlackTree<T: TreeElement>: BinarySearchTree<T> {
    @discardableResult
    internal func leftRotate(_ node: Node?) -> Node? {
        guard let node = node,
            let right = node.right else { return nil }
        
        /*
         * swap color with node and right.
         * color of right should always be red
         */
        right.color = node.color
        node.color = .red

        if let parent = node.parent {
            if parent.left === node {
                parent.left = right
            } else /* node is the right child of parent */ {
                parent.right = right
            }
            right.parent = parent
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
    internal func rightRotate(_ node: Node?) -> Node? {
        guard let node = node,
            let left = node.left else { return nil }
        
        /*
         * swap color with node and right.
         * color of left should always be red
         */
        left.color = node.color
        node.color = .red
        
        if let parent = node.parent {
            if parent.left === node {
                parent.left = left
            } else /* node is the right child of parent */ {
                parent.right = left
            }
            left.parent = parent
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
    
    private func flipColor(_ node: Node?) {
        node?.left?.color = .black
        node?.right?.color = .black
        node?.color = .red
    }
    
    override func insert(_ key: T) {
        super.insert(key)
        root?.color = .black
    }
    
    @discardableResult
    override func insert(_ key: T, in node: BinarySearchTreeNode<T>?, withParent parent: BinarySearchTreeNode<T>?) -> BinarySearchTreeNode<T> {
        guard var node = node,
            let nodeKey = node.key else {
                return Node(key, parent: parent, color: .red)
        }
        
        if key < nodeKey {
            node.left = insert(key, in: node.left, withParent: node)
        } else if key > nodeKey {
            node.right = insert(key, in: node.right, withParent: node)
        }
        
        if let left = node.left, let right = node.right, left.isRed && right.isRed {
            flipColor(node)
        }
        
        if let right = node.right, right.isRed {
            node = leftRotate(node)!
        }
        
        if let left = node.left, let leftLeft = node.left?.left, left.isRed && leftLeft.isRed {
            node = rightRotate(node)!
        }
        
        return node
    }

    private func fixUp(_ node: Node?) {
        root?.color = .black
    }
}
