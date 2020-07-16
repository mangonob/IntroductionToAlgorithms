//
//  MatrixChainOrder.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2019/3/15.
//  Copyright © 2019 mangonob. All rights reserved.
//

import Foundation

class MatrixChainOrder {
    private var lengthes: [Int]
    private var results: [[Int]]
    private var partitions: [[Int]]

    init(_ lengthes: [Int]) {
        self.lengthes = lengthes
        let length = lengthes.count - 1
        self.results = [[Int]](repeating: [Int](repeating: Int.max, count: length), count: length)
        self.partitions = [[Int]](repeating: [Int](repeating: -1, count: length), count: length)
        buildChainOrder()
    }
    
    private func buildChainOrder() {
        let length = lengthes.count - 1
        for distance in 0..<length {
            for start in 0..<(length - distance) {
                let end = start + distance
                guard start != end else {
                    results[start][end] = 0
                    continue
                }
                
                for partition in start..<end {
                    let cost = results[start][partition] + results[partition + 1][end] + lengthes[start] * lengthes[partition + 1] * lengthes[end + 1]
                    if cost < results[start][end] {
                        results[start][end] = cost
                        partitions[start][end] = partition
                    }
                }
            }
        }
    }
}

extension MatrixChainOrder: Routine {
    static func routine() {
        let matrixChainOrder = MatrixChainOrder([30, 35, 15, 5, 10, 20, 25])
        print(matrixChainOrder.results)
        print(matrixChainOrder.partitions)
    }
}
