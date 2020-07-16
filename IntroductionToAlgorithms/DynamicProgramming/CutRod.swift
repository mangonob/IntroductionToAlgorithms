//
//  CutRod.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2018/10/19.
//  Copyright © 2018年 mangonob. All rights reserved.
//

import Foundation

class CutRod {
    private var prices: [Int]
    
    init(prices: [Int]) {
        assert(prices.count >= 2, "Length of prices must grater than 2.")
        self.prices = prices
    }
    
    @discardableResult
    func memorizedCutRod(_ length: Int) -> Int {
        assert(length >= 0, "Length of rod must not negative.")
        var memorized = [Int](repeating: 0, count: length + 1)
        return cutRod(length, memorized: &memorized)
    }
    
    private func cutRod(_ length: Int, memorized: inout [Int]) -> Int {
        if length <= 0 {
            return 0
        } else if length >= 0 && length < memorized.count && memorized[length] > 0 {
            return memorized[length]
        } else {
            var total = length < prices.count ? prices[length] : 0
            
            var left = 1
            while (left <= length / 2) {
                defer {
                    left += 1
                }
                
                total = max(
                    total,
                    cutRod(left, memorized: &memorized) + cutRod(length - left, memorized: &memorized)
                )
            }
            
            memorized[length] = total
            return total
        }
    }
    
    @discardableResult
    func bottomUpCutRod(_ length: Int) -> Int {
        assert(length >= 0, "Length of rod must not negative.")

        var totalPrices = [Int](repeating: 0, count: length + 1)

        for current in 0...length {
            if current == 0 {
                continue
            }
            
            var total = current < prices.count ? prices[current] : 0
            
            var left = 1
            while (left <= current / 2) {
                defer {
                    left += 1
                }
                
                total = max(
                    total,
                    totalPrices[left] + totalPrices[current - left]
                )
            }
            
            totalPrices[current] = total
        }
        
        return totalPrices[length]
    }
}

extension CutRod: Routine {
    static func routine() {
        let cutRod = CutRod(prices: [0, 1, 5, 8, 9, 10, 17, 17, 20, 24, 30])
        
        for length in [3, 300, 3000, 30000] {
            time("Cut rod length \(length) bottom up") {
                cutRod.bottomUpCutRod(length)
            }
            
            time("Cut rod length \(length) memorized") {
                cutRod.bottomUpCutRod(length)
            }
        }
    }
}
