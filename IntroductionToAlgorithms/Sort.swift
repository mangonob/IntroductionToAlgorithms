//
//  Sort.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2018/7/9.
//  Copyright © 2018年 BaiYiYuan. All rights reserved.
//

import Foundation

class Sort {
    func sort<T: Comparable>(_ arr: inout [T]) { fatalError("Have not implement.")}
}

class QuickSort: Sort {
    override func sort<T>(_ arr: inout [T]) where T : Comparable {
        quickSort(UnsafeMutablePointer<T>.init(&arr), count: arr.count)
    }
    
    private func quickSort<T: Comparable>(_ arr: UnsafeMutablePointer<T>, count: Int) {
        guard count > 1 else { return }
        let middle = partition(arr, count: count)
        quickSort(arr, count: middle)
        quickSort(arr + middle + 1, count: count - middle - 1)
    }
    
    private func partition<T: Comparable>(_ arr: UnsafeMutablePointer<T>, count: Int) -> Int {
        guard count > 1 else { return 0 }
        let randIndex = Int(arc4random()) % count
        if randIndex != count - 1 {
            swap(&arr[randIndex], &arr[count - 1])
        }

        /** (lower, upper] grater than center or empty */
        let center = arr[count - 1]
        var lower = -1
        for upper in 0..<count-1 {
            if arr[upper] <= center {
                lower += 1
                if lower != upper {
                    swap(&arr[lower], &arr[upper])
                }
            }
        }
        arr[lower + 1] = center
        return lower + 1
    }
    
    static func main() {
        let quickSort = QuickSort()
        
        let value: UInt32 = 1000000
        var arr: [Int] = (0..<value).map { _ in Int(arc4random() % value) }
        let date = Date()
        quickSort.sort(&arr)
        print("Quick sort \(value) int values use \(Date().timeIntervalSince(date))s")
    }
}

