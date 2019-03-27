//
//  Stack.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2019/3/27.
//  Copyright © 2019 BaiYiYuan. All rights reserved.
//

import Foundation

class Stack {
    private var memories: UnsafeMutablePointer<Int>
    private var capacity: Int = 0
    private var length: Int = 0

    init(_ capacity: Int = 42) {
        memories = malloc(capacity * MemoryLayout<Int>.stride)!.assumingMemoryBound(to: Int.self)
        self.capacity = capacity
    }

    func push(_ value: Int) {
        if length == capacity {
            realloc()
        }
        
        assert(length < capacity, "Stack overflow.")

        memories.advanced(by: length).pointee = value
        length += 1
    }
    
    @discardableResult
    func pop() -> Int? {
        if length == 0 {
            return nil
        }
        
        if length < capacity / 4 {
            shrink()
        }
        
        let value = memories.advanced(by: length - 1).pointee
        length -= 1
        return value
    }
    
    private func realloc() {
        let newMemories = malloc(capacity * 2 * MemoryLayout<Int>.stride)!.assumingMemoryBound(to: Int.self)
        self.capacity = capacity * 2
        newMemories.assign(from: memories, count: length)
        memories.deallocate()
        memories = newMemories
    }
    
    private func shrink() {
        let newMemories = malloc(capacity / 2 * MemoryLayout<Int>.stride)!.assumingMemoryBound(to: Int.self)
        self.capacity = capacity / 2
        newMemories.assign(from: memories, count: length)
        memories.deallocate()
        memories = newMemories
    }
}

extension Stack: Routine {
    static func routine() {
        let times = [
            10,
            100,
            1000,
            10000,
            100000,
            1000000,
            10000000,
            ]
        
        for t in times {
            print("================ \(t) Times ================")
            let stack = Stack()
            time("Push into Stack") {
                for _ in 0..<t {
                    stack.push(rand(from: 0, to: 100))
                }
            }

            var array = [Int]()
            time("Push into Array") {
                for _ in 0..<t {
                    array.append(rand(from: 0, to: 100))
                }
            }
        }
    }
}
