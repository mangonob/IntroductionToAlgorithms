//
//  Hashtable.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2018/7/13.
//  Copyright © 2018年 BaiYiYuan. All rights reserved.
//

import Foundation


class Hashtable<Key: Hashable, Value>: Sequence {
    var table: [Value?]
    typealias Element = Value?

    init(capacity: Int) {
        table = [Value?](repeating: nil, count: capacity)
    }

    subscript(index: Key) -> Value? {
        get {
            return table.isEmpty ? nil : table[index.hashValue]
        }
        set {
            guard !table.isEmpty && index.hashValue < table.count
                else { return }

            table[index.hashValue] = newValue
        }
    }
}
