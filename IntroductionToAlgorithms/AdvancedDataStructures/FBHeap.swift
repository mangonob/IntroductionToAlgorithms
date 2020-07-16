//
//  FBHeap.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2019/3/28.
//  Copyright © 2019 mangonob. All rights reserved.
//

import Foundation

fileprivate class FBNode: CustomStringConvertible {
    weak var left: FBNode?
    var right: FBNode?
    weak var parent: FBNode?
    var child: FBNode?
    var isMarked: Bool = false
    var degree: Int = 0
    var key: Int = 0
    
    deinit {
        print("Deinit \(key)")
    }

    init() {
    }
    
    func insert(_ node: FBNode) {
        let right = self.right
        self.right = node
        node.left = self
        right?.left = node
        node.right = right
    }
    
    func union(_ node: FBNode) {
        let left = self.left
        let nodeRight = node.right
        self.left = node
        node.right = self
        left?.right = nodeRight
        nodeRight?.left = left
    }
    
    func remove() {
        let left = self.left
        let right = self.right
        left?.right = right
        right?.left = left
    }
    
    func link(with node: FBNode) {
        node.remove()
        node.left = node
        node.right = node
        
        if let child = self.child {
            child.insert(node)
        } else {
            self.child = node
        }
        
        node.parent = self
        node.isMarked = false
        degree += 1
    }
    
    func swap(with node: FBNode) {
        let t = key
        key = node.key
        node.key = t
        
        let mark = isMarked
        isMarked = node.isMarked
        node.isMarked = mark
        
        let d = degree
        degree = node.degree
        node.degree = d
        
        let c = child
        child = node.child
        child?.parent = self
        node.child = c
        c?.parent = node
    }

    var description: String {
        var description = ""
        description.append(key.description)

        if let child = child {
            description.append(" -> {")
            description.append(child.brothers().map { $0.description }.joined(separator: ", "))
            description.append("}")
        }

        return description
    }
    
    func brothers() -> [FBNode] {
        var brothers = [FBNode]()
        var current: FBNode? = self
        repeat {
            brothers.append(current!)
            current = current?.right
        } while (current != nil && current !== self)
        return brothers
    }
}

class FBHeap: CustomStringConvertible {
    private var min: FBNode?
    private var n: Int = 0
    
    deinit {
        min?.right = nil
    }
    
    init() {
    }
    
    func insert(_ key: Int) {
        let node = FBNode()
        node.key = key
        
        if let min = self.min {
            min.insert(node)
            if node.key < min.key {
                self.min = node
            }
        } else {
            node.left = node
            node.right = node
            min = node
        }

        n += 1
    }
    
    @discardableResult
    func extractMin() -> Int? {
        let z = self.min
        
        if let z = self.min {
            if let zChild = z.child {
                for x in zChild.brothers() {
                    z.left?.insert(x)
                    x.parent = nil
                }
            }
            
            z.remove()
            
            if z === z.right {
                self.min = nil
                z.right = nil
            } else {
                self.min = z.right
                consolidate()
            }
            n -= 1
        }
        
        return z?.key
    }
    
    private func consolidate() {
        let phi = (1 + sqrt(5)) / 2
        let d = Int(log(Double(self.n)) / log(phi))
        var A = [FBNode?](repeating: nil, count: d + 1)
        
        for w in self.min!.brothers() {
            let x = w
            var d = x.degree
            
            while let y = A[d] {
                if x.key > y.key {
                    x.swap(with: y)
                }
                
                x.link(with: y)
                A[d] = nil
                d += 1
            }
            A[d] = x
        }
        
        self.min = nil
        
        for case let node? in A {
            if let min = self.min {
                if node.key < min.key {
                    self.min = node
                }
            } else {
                self.min = node
            }
        }
    }
    
    func minimum() -> Int? {
        return self.min?.key
    }
    
    func union(_ heap: FBHeap) {
        if heap.min == nil {
            return
        }
        
        if min == nil {
            min = heap.min
            n = heap.n
        } else {
            min!.union(heap.min!)
            n += heap.n
            if heap.min!.key < min!.key {
                min = heap.min
            }
            heap.min = nil
            heap.n = 0
        }
    }
    
    fileprivate func decrease(_ node: FBNode, key: Int) {
        precondition(key <= node.key, "New key \(key) is greater than current key \(node.key)")
        
        node.key = key
        let y = node.parent
        if let y = y, key < y.key {
            cut(node, from: y)
            cascadingCut(y)
        }
        
        if node.key < self.min!.key {
            self.min = node
        }
    }

    fileprivate func cut(_ node: FBNode, from: FBNode) {
        node.parent = nil
        from.degree -= 1
        
        node.left = node
        node.right = node
        node.isMarked = false
        self.min?.insert(node)
    }
    
    fileprivate func cascadingCut(_ node: FBNode) {
        if let z = node.parent {
            if z.isMarked {
                cut(node, from: z)
                cascadingCut(z)
            } else {
                z.isMarked = true
            }
        }
    }

    fileprivate func remove(_ node: FBNode) {
        decrease(node, key: .min)
        extractMin()
    }

    var description: String {
        return min?.brothers().map { $0.description }.joined(separator: ", ") ?? "<Empty fabonacci heap>"
    }
}

extension FBHeap: Routine {
    static func routine() {
        print("================  FBHeap routine ================")
        let heap = FBHeap()
        
        for _ in 1000 >>> 1 {
            heap.insert(Int(arc4random() % 1000))
        }
        
        print(heap)

        for _ in 1000 >>> 1 {
            print(heap.extractMin() ?? 0)
            print(heap)
        }
    }
}
