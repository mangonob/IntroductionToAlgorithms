//
//  ArraySort.swift
//  IntroductionToAlgorithms
//
//  Created by G on 2021/1/19.
//  Copyright © 2021 mangonob. All rights reserved.
//

struct ArraySortRoutine: Routine, Runnable {
    var range: Swift.Range<Int> = 0..<10000
    var size: Int = 10000
    var isPrintResult = true

    func run() {
        var array = Array(repeating: 0, count: size);
        for i in 0..<array.count {
            array[i] = rand(from: range.lowerBound, to: range.upperBound)
        }
        time("Swift.Array sort \(size) elements") {
            let result = array.sorted()
            if (isPrintResult) {
                print(Array(result))
            }
        }
    }
    
    static func routine() {
        for i in [100, 1000, 10000, 100000, 1000000] {
            ArraySortRoutine(range: 0..<i, size: i, isPrintResult: false).run()
        }
    }
}
