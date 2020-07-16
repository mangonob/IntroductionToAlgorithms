//
//  BTree.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2019/3/20.
//  Copyright © 2019 mangonob. All rights reserved.
//

import Foundation

typealias BTreeSearchResult = (node: BTree, indexOfKey: Int)
fileprivate let t = 3

class BTree: CustomStringConvertible {
    fileprivate static var null = BTree()
    
    fileprivate lazy var c = Children(tree: self)
    fileprivate lazy var key = Key(tree: self)

    fileprivate lazy var keys: [Int] = [Int](repeating: 0, count: t * 2 - 1)
    fileprivate lazy var children = [BTree](repeating: BTree.null , count: t * 2)
    
    var isLeaf: Bool = false
    var n: Int = 0
    
    func search(_ key: Int) -> BTreeSearchResult? {
        var i = 0
        while i < n && key > self.key[i] {
            i += 1
        }
        
        if i < n && key == self.key[i] {
            return (self, i)
        } else if isLeaf {
            return nil
        } else {
            c[i].read()
            return c[i].search(key)
        }
    }
    
    static func create() -> BTree {
        let root = BTree()
        root.isLeaf = true
        root.n = 0
        root.write()
        return root
    }
    
    private func splitChild(_ index: Int) {
        let z = BTree.create()
        let y = c[index]
        z.isLeaf = y.isLeaf
        z.n = t - 1
        
        for j in 0 <<< t - 2 {
            z.key[j] = y.key[t + j]
        }
        
        if !z.isLeaf {
            for j in 0..<t {
                z.c[j] = y.c[t + j]
            }
        }
        
        y.n = t - 1
        
        for j in n >>> index + 1 {
            c[j + 1]  = c[j]
        }
        c[index + 1] = z
        
        for j in n - 1 >>> index {
            key[j + 1] = key[j]
        }
        key[index] = y.key[t - 1]
        
        n += 1

        write()
        y.write()
        z.write()
    }
    
    func inset(_ key: Int) -> BTree {
        guard search(key) == nil else {
            return self
        }
        
        if n == 2 * t - 1 {
            let s = BTree.create()
            s.isLeaf = false
            s.n = 0
            s.c[0] = self
            s.splitChild(0)
            s.insetNotFull(key)
            return s
        } else {
            insetNotFull(key)
            return self
        }
    }

    private func insetNotFull(_ key: Int) {
        var i = n - 1
        
        if isLeaf {
            while i >= 0 && key < self.key[i] {
                self.key[i + 1] = self.key[i]
                i -= 1
            }
            self.key[i + 1] = key
            n += 1
            write()
        } else {
            while i >= 0 && key < self.key[i] {
                i -= 1
            }
            i += 1
            c[i].read()
            if c[i].n == 2 * t - 1 {
                splitChild(i)
                if key > self.key[i] {
                    i += 1
                }
            }
            c[i].insetNotFull(key)
        }
    }

    func remove(_ key: Int) -> BTree {
        removeAux(key)
        return n == 0 && !isLeaf ? c[0] : self
    }
    
    private func removeAux(_ key: Int) {
        var i = 0
        while i < n && self.key[i] < key {
            i += 1
        }
        
        let haveKey = i < n && self.key[i] == key
        
        if isLeaf && haveKey {
            for j in i + 1 <<< n - 1 {
                self.key[j - 1] = self.key[j]
                c[j] = self.c[j + 1]
            }
            n -= 1
        } else if !isLeaf && haveKey {
            if c[i].n >= t {
                let prev = c[i].max()
                self.key[i] = prev
                c[i].removeAux(prev)
            } else if c[i + 1].n >= t {
                let next = c[i + 1].min()
                self.key[i] = next
                c[i + 1].removeAux(next)
            } else {
                merge(i)
                c[i].removeAux(key)
            }
        } else if !isLeaf && !haveKey {
            if c[i].n >= t {
                c[i].removeAux(key)
            } else {
                let brother = i == 0 ? 1 : i - 1
                if c[brother].n >= t {
                    if brother > i {
                        takeRight(i)
                    } else {
                        takeLeft(i)
                    }
                    c[i].removeAux(key)
                } else {
                    let left = Swift.min(i, brother)
                    merge(left)
                    c[left].removeAux(key)
                }
            }
        } /** else key is not exist in this tree. */
    }
    
    private func merge(_ index: Int) {
        let y = c[index]
        let z = c[index + 1]

        for i in index + 2 <<< n {
            c[i - 1] = c[i]
        }
        y.key[y.n] = key[index]
        y.c[y.n + 1] = z.c[0]
        y.n += 1
        for i in index + 1 <<< n - 1 {
            key[i - 1] = key[i]
        }
        n -= 1
        
        for i in 0 <<< z.n - 1 {
            y.key[i + y.n] = z.key[i]
            y.c[i + y.n + 1] = z.c[i + 1]
        }
        y.n += z.n
    }
    
    private func takeLeft(_ index: Int) {
        if index == 0 {
            return
        }
        
        let y = c[index]
        let z = c[index - 1]
        
        for i in y.n - 1 >>> 0 {
            y.key[i + 1] = y.key[i]
        }
        for i in y.n >>> 0 {
            y.c[i + 1] = y.c[i]
        }
        y.key[0] = key[index - 1]
        key[index - 1] = z.key[z.n - 1]
        y.c[0] = z.c[z.n]
        
        y.n += 1
        z.n -= 1
    }

    private func takeRight(_ index: Int) {
        if index == n {
            return
        }
        
        let y = c[index]
        let z = c[index + 1]
        
        y.key[y.n] = key[index]
        key[index] = z.key[0]
        y.n += 1
        y.c[y.n] = z.c[0]

        for i in 1 <<< z.n - 1 {
            z.key[i - 1] = z.key[i]
        }
        for i in 1 <<< z.n {
            z.c[i - 1] = z.c[i]
        }
        
        z.n -= 1
    }

    func min() -> Int {
        if isLeaf {
            return key[0]
        } else {
            return c[0].min()
        }
    }
    
    func max() -> Int {
        if isLeaf {
            return key[n - 1]
        } else {
            return c[n].max()
        }
    }

    func read() {
    }
    
    func write() {
    }
    
    private func check() {
        var keys = Set<Int>()
        for i in 0 <<< n - 1 {
            keys.insert(key[i])
        }
        
        var children = Set<Int>()
        for i in 0 <<< n {
            children.insert(identifier(c[i]))
        }
        
        assert(keys.count == n, "Keys not unique.")
        assert(isLeaf || children.count == n + 1, "Children not unique.")
        
        if !isLeaf {
            for i in 0 <<< n - 1 {
                let next = c[i + 1].min()
                let prev = c[i].max()
                assert(prev <= key[i])
                assert(next >= key[i])
            }
        }
    }

    var description: String {
        var description = "["
        description.append((0..<n).map { key[$0].description }.joined(separator: ", "))
        description.append("]")
        
        if !isLeaf {
            description.append(" -> {")
            description.append((0...n).map { c[$0].description }.joined(separator: ", "))
            description.append("}")
        }
        
        return description
    }
    
    func description(maxDepth: Int) -> String {
        var description = "["
        description.append((0..<n).map { key[$0].description }.joined(separator: ", "))
        description.append("]")
        
        if !isLeaf && maxDepth > 0 {
            description.append(" -> {")
            description.append((0...n).map { c[$0].description(maxDepth: maxDepth - 1) }.joined(separator: ", "))
            description.append("}")
        }
        
        return description
    }
}

extension BTree {
    fileprivate struct Children {
        weak var tree: BTree!
        
        subscript(index: Int) -> BTree {
            get {
                return tree.children[index]
            }
            set {
                tree.children[index] = newValue
            }
        }
    }
    
    fileprivate struct Key {
        weak var tree: BTree!
        
        subscript(index: Int) -> Int {
            get {
                return tree.keys[index]
            }
            set {
                tree.keys[index] = newValue
            }
        }
    }
}

extension BTree: Routine {
    static func routine() {
        var tree = BTree.create()
        
        for _ in 0..<1000 {
            tree = tree.inset(rand(from: 0, to: 500))
        }

        for _ in 0..<1000 {
            tree = tree.remove(rand(from: 0, to: 500))
        }
        
        print(tree)
    }
}
