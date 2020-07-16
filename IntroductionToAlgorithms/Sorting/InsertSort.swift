//
//  InsertSort.swift
//  IntroductionToAlgorithms
//
//  Created by G on 2021/1/18.
//  Copyright © 2021 mangonob. All rights reserved.
//

import Foundation

class InsertSort<Element: Comparable>: AbstractSequenceSort<Element> {
    override func sorted() -> AnySequence<Element> {
        var array = Array(sequence)
        var i = 1
        while i < array.count {
            let ei = array[i]
            
            var j = i - 1
            while j >= 0 && array[j] > ei {
                array[j + 1] = array[j]
                j -= 1
            }
            array[j + 1] = ei

            i += 1
        }
        return AnySequence(array)
    }
}

struct InsertSortRoutine: Runnable, Routine {
    var range: Swift.Range<Int> = 0..<10000
    var size: Int = 10000
    var isPrintResult = true

    func run() {
        var array = Array(repeating: 0, count: size);
        for i in 0..<array.count {
            array[i] = rand(from: range.lowerBound, to: range.upperBound)
        }
        let sort = InsertSort(array)
        time("Insert sort \(size) elements") {
            let result = sort.sorted()
            if (isPrintResult) {
                print(Array(result))
            }
        }
    }
    
    static func routine() {
        for i in [100, 1000, 10000, 20000, 30000] {
            InsertSortRoutine(range: 0..<i, size: i, isPrintResult: false).run()
        }
    }
}
