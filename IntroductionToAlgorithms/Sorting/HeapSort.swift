//
//  HeapSort.swift
//  IntroductionToAlgorithms
//
//  Created by G on 2021/1/19.
//  Copyright © 2021 mangonob. All rights reserved.
//

class HeapSort<Element: Comparable>: AbstractSequenceSort<Element> {
    struct Heap<T: Sequence> {
        var array: T
        var heapSize: Int
    }
    
    override func sorted() -> AnySequence<Element> {
        var array = Array(sequence)
        heapSort(&array)
        return AnySequence(array)
    }
    
    private func parent(_ c: Int) -> Int {
        return (c - 1) / 2
    }
    
    private func left(_ c: Int) -> Int {
        return 2 * c + 1
    }
    
    private func right(_ c: Int) -> Int {
        return 2 * (c + 1)
    }
    
    private func heapSort(_ arr: inout [Element]) {
        buildMaxHeap(&arr)
        var size = arr.count
        while size > 0 {
            arr.swapAt(0, size - 1)
            size -= 1
            maxHeapify(&arr, size: size, at: 0)
        }
    }

    /**
     * Max heapify
     * - Parameter arr: heap data
     * - Parameter size: heap size
     */
    private func maxHeapify(_ arr: inout [Element], size: Int, at i: Int) {
        let l = left(i)
        let r = right(i)
        
        if (l < size && arr[l] > arr[i] && (r >= size || arr[l] >= arr[r])) {
            arr.swapAt(i, l)
            maxHeapify(&arr, size: size, at: l)
        } else if (r < size && arr[r] > arr[i] && (l >= size || arr[r] >= arr[l])) {
            arr.swapAt(i, r)
            maxHeapify(&arr, size: size, at: r)
        }
    }
    
    private func buildMaxHeap(_ arr: inout [Element]) {
        var i = arr.count / 2 - 1
        while i >= 0 {
            maxHeapify(&arr, size: arr.count, at: i)
            i -= 1
        }
    }
}

struct HeapSortRoutine: Routine, Runnable {
    var range: Swift.Range<Int> = 0..<10000
    var size: Int = 10000
    var isPrintResult = true
    
    func run() {
        var array = Array(repeating: 0, count: size);
        for i in 0..<array.count {
            array[i] = rand(from: range.lowerBound, to: range.upperBound)
        }
        let sort = HeapSort(array)
        time("Heap sort \(size) elements") {
            let result = sort.sorted()
            if (isPrintResult) {
                print(Array(result))
            }
        }
    }
    
    static func routine() {
        for i in [100, 1000, 10000, 100000, 1000000] {
            HeapSortRoutine(range: 0..<i, size: i, isPrintResult: false).run()
        }
    }
}
