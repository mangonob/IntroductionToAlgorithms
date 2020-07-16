//
//  HashTable.swift
//  IntroductionToAlgorithms
//
//  Created by G on 2020/7/15.
//  Copyright © 2020 mangonob. All rights reserved.
//

import Foundation

class HashTable<K: Hashable, V> {
    subscript(key: K) -> V? {
        get {
            fatalError()
        }
        set {
        }
    }
}

class HashTableRoutine: Routine {
    static let capcity = 1 << 16
    static let factor = UInt(Double(UInt.max) * (sqrt(5) - 1) / 2)
    
    static func hashValue(_ key: Int) -> Int {
        let key = UInt(bitPattern: key)
        return Int(bitPattern: (key &* Self.factor & UInt.max) >> 48)
    }
    
    static func routine() {
        for i in 0..<10000 {
            print(Self.hashValue(i))
        }
    }
}
