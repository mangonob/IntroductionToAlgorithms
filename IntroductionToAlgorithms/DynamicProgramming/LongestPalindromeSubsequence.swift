//
//  LongestPalindromeSubsequence.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2019/3/18.
//  Copyright © 2019 mangonob. All rights reserved.
//

import Foundation

class LPS: LCS {
    init(_ s1: [Character]) {
        super.init(s1, s1.reversed())
    }
    
    override class func routine() {
        let lps = LPS(["c", "h", "a", "r", "a", "c", "t", "e", "r"])
        print(lps.results)
        print(lps.solves)
        print(lps.subsequence())
    }
}
