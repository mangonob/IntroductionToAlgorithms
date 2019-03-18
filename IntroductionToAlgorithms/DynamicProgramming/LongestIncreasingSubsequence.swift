//
//  LongestIncreasingSubsequence.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2019/3/18.
//  Copyright © 2019 BaiYiYuan. All rights reserved.
//

import Foundation

class LIS: LCS {
    init(_ s: [Character]) {
        super.init(s, s.sorted())
    }
    
    override class func routine() {
        let lis = LIS(["6", "1", "5", "2", "4", "3"])
        print(lis.results)
        print(lis.solves)
        print(lis.subsequence())
    }
}
