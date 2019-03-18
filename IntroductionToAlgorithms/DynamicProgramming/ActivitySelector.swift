//
//  ActivitySelector.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2019/3/19.
//  Copyright © 2019 BaiYiYuan. All rights reserved.
//

import Foundation

struct Range {
    var start: Int
    var end: Int
}

class ActivitySelector {
    private var ranges: [Range]
    private var prices: [Double]
    private var costs: [[Double]]
    private var results: [[Int]]

    init(_ ranges: [Range], prices: [Double]) {
        self.ranges = [Range(start: 0, end: 0)] + ranges
        self.prices = [0] + prices
        let length = self.ranges.count + 1
        self.costs = [[Double]](repeating: [Double](repeating: 0, count: length), count: length)
        self.results = [[Int]](repeating: [Int](repeating: 0, count: length), count: length)
        solve()
    }
    
    private func solve() {
        let n = ranges.count - 1
        
        for j in 0...(n + 1) {
            for i in (0...j).reversed() {
                var k = i + 1
                while k <= j - 1 {
                    if ranges[k].start <= ranges[i].end && ranges[k].end >= ranges[i].start {
                        let cost = costs[i][k] + costs[k][j] + prices[k]
                        if cost > costs[i][j] {
                            costs[i][j] = cost
                            results[i][j] = k
                        }
                    }
                    k += 1
                }
            }
        }
    }
}

extension ActivitySelector: Routine {
    static func routine() {
        let ranges = [
            Range(start: 1, end: 4),
            Range(start: 3, end: 5),
            Range(start: 0, end: 6),
            Range(start: 5, end: 7),
            Range(start: 3, end: 9),
            Range(start: 5, end: 9),
            Range(start: 6, end: 10),
            Range(start: 8, end: 11),
            Range(start: 8, end: 12),
            Range(start: 2, end: 14),
            Range(start: 12, end: 16)
        ]

        let activitySelector = ActivitySelector(ranges, prices: ranges.map { Double($0.end - $0.start) })
        print(activitySelector.costs)
        print(activitySelector.results)
    }
}
