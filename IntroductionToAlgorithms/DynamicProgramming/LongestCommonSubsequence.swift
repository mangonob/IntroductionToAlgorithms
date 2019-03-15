//
//  LongestCommonSubsequence.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2019/3/15.
//  Copyright © 2019 BaiYiYuan. All rights reserved.
//

import Foundation

enum Arrow: String, CustomStringConvertible {
    case none = " "
    case left = "←"
    case up = "↑"
    case leftUp = "↖︎"
    
    var description: String {
        return rawValue
    }
}

class LCS {
    private var s1: [Character]
    private var s2: [Character]
    private var results: [[Int]]
    private var solves: [[Arrow]]
    
    init(_ s1: [Character], _ s2: [Character]) {
        self.s1 = s1
        self.s2 = s2
        let length1 = s1.count + 1
        let length2 = s2.count + 1
        results = [[Int]](repeating: [Int](repeating: 0, count: length2), count: length1)
        solves = [[Arrow]](repeating: [Arrow](repeating: .none, count: length2), count: length1)
        
        solveLCS()
    }
    
    private func solveLCS() {
        let length1 = s1.count + 1
        let length2 = s2.count + 1
        
        // Dynamic programming
        for i in 0..<length1 {
            for j in 0..<length2 {
                if i == 0 || j == 0 {
                    results[i][j] = 0
                } else {
                    if s1[i - 1] == s2[j - 1] {
                        solves[i][j] = .leftUp
                        results[i][j] = results[i-1][j-1] + 1
                    } else if results[i-1][j] > results[i][j-1] {
                        solves[i][j] = .left
                        results[i][j] = results[i-1][j]
                    } else {
                        solves[i][j] = .up
                        results[i][j] = results[i][j-1]
                    }
                }
            }
        }
        // End dynamic programming
    }
}

extension LCS: Routine {
    static func routine() {
        let lcs = LCS(["A", "B", "C", "B", "D", "A", "B"], ["B", "D", "C", "A", "B", "A"])
        print(lcs.results)
        print(lcs.solves)
    }
}
