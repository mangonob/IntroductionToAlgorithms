//
//  MergeSort.swift
//  IntroductionToAlgorithms
//
//  Created by G on 2021/1/19.
//  Copyright © 2021 mangonob. All rights reserved.
//

class MergeSort<Element: Comparable>: AbstractSequenceSort<Element> {
    override func sorted() -> AnySequence<Element> {
        var array = Array(sequence)
        mergeSort(&array, start: 0, end: array.count)
        return AnySequence(array)
    }
    
    private func mergeSort(_ arr: inout [Element], start: Int, end: Int) {
        if start < end - 1 {
            let mid = (start + end) / 2
            mergeSort(&arr, start: start, end: mid)
            mergeSort(&arr, start: mid, end: end)
            merge(&arr, start: start, mid: mid, end: end)
        }
    }
    
    private func merge(_ arr: inout [Element], start: Int, mid: Int, end: Int) {
        var cached = Array<Element?>(repeating: nil, count: end - start)
        var i = start, j = mid, k = 0
        while k < end - start {
            if (i >= mid) {
                cached[k] = arr[j]
                j += 1
            } else if (j >= end) {
                cached[k] = arr[i]
                i += 1
            } else if (arr[i] <= arr[j]) {
                cached[k] = arr[i]
                i += 1
            } else {
                cached[k] = arr[j]
                j += 1
            }
            k += 1
        }
        
        for i in start..<end {
            arr[i] = cached[i - start]!
        }
    }
}

struct MergeSortRoutine: Routine, Runnable {
    var range: Swift.Range<Int> = 0..<10000
    var size: Int = 10000
    var isPrintResult = true
    
    func run() {
        var array = Array(repeating: 0, count: size);
        for i in 0..<array.count {
            array[i] = rand(from: range.lowerBound, to: range.upperBound)
        }
        let sort = MergeSort(array)
        time("Merge sort \(size) elements") {
            let result = sort.sorted()
            if (isPrintResult) {
                print(Array(result))
            }
        }
    }
    
    static func routine() {
        for i in [100, 1000, 10000, 100000, 1000000] {
            MergeSortRoutine(range: 0..<i, size: i, isPrintResult: false).run()
        }
    }
}
