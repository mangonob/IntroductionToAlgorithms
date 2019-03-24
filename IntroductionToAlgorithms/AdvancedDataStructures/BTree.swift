//
//  BTree.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2019/3/20.
//  Copyright © 2019 BaiYiYuan. All rights reserved.
//

import Foundation

typealias BTreeSearchResult = (node: BTree, indexOfKey: Int)
fileprivate let t = 1000

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
        
        for j in index + 1 <<< n {
            c[j + 1]  = c[j]
        }
        c[index + 1] = z
        
        for j in index <<< n - 1 {
            key[j + 1] = key[j]
        }
        key[index] = y.key[t - 1]
        
        n += 1

        write()
        y.write()
        z.write()
    }
    
    func inset(_ key: Int) -> BTree {
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

    func read() {
    }
    
    func write() {
    }
    
    var description: String {
        var description = "["
        description.append((0..<n).map { key[$0].description }.joined(separator: ","))
        description.append("]")
        
        if !isLeaf {
            description.append(" -> {")
            description.append((0...n).map { c[$0].description }.joined(separator: ","))
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
        time("Inset element into B-Tree") {
            for i in 0..<1000000 {
                tree = tree.inset(i)
            }
        }
    }
}
