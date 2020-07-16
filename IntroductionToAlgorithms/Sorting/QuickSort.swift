//
//  QuickSort.swift
//  IntroductionToAlgorithms
//
//  Created by G on 2021/1/18.
//  Copyright © 2021 mangonob. All rights reserved.
//

import Foundation

class QuickSort<Element: Comparable>: AbstractSequenceSort<Element> {
    @discardableResult
    override func sorted() -> AnySequence<Element> {
        var arr = Array(sequence)
        quickSort(&arr, start: 0, end: arr.count)
        return AnySequence(arr)
    }
    
    private func quickSort(_ arr: inout [Element], start: Int, end: Int) {
        guard end - start > 1  else { return }
        let middle = partition(&arr, start: start, end: end)
        quickSort(&arr, start: start, end: middle)
        quickSort(&arr, start: middle + 1, end: end)
    }
    
    /**
     * Partition array into two parts
     *
     *           mid       current
     *            |           |
     * | 3, 4, 2, 9, 8, 7, 6, 3, 6, 4, 5, (5) |
     */
    private func partition(_ arr: inout [Element], start: Int, end: Int) -> Int {
        guard end - start > 1 else { return 0 }
        arr.swapAt(rand(from: start, to: end - 1), end - 1)
        let pivot = arr[end - 1]
        var current = start, mid = start
        while current < end - 1 {
            if arr[current] > pivot {
                current += 1
            } else {
                arr.swapAt(mid, current)
                mid += 1
                current += 1
            }
        }
        arr.swapAt(mid, end - 1)
        return mid
    }
}

struct QuickSortRoutine: Routine, Runnable {
    var range: Swift.Range<Int> = 0..<10000
    var size: Int = 10000
    var isPrintResult = true

    func run() {
        var array = Array(repeating: 0, count: size);
        for i in 0..<array.count {
            array[i] = rand(from: range.lowerBound, to: range.upperBound)
        }
        let sort = QuickSort(array)
        time("Quick sort \(size) elements") {
            let result = sort.sorted()
            if (isPrintResult) {
                print(Array(result))
            }
        }
    }
    
    static func routine() {
        for i in [100, 1000, 10000, 100000, 1000000] {
            QuickSortRoutine(range: 0..<i, size: i, isPrintResult: false).run()
        }
    }
}
