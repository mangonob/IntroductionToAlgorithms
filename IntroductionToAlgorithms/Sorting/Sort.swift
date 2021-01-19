//
//  Sort.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2018/7/9.
//  Copyright © 2018年 mangonob. All rights reserved.
//

import Foundation

protocol Sort {
    associatedtype Element: Comparable
    
    func sorted() -> AnySequence<Element>
}

class AbstractSequenceSort<Element: Comparable>: Sort {
    internal var sequence: AnySequence<Element>
    
    init<S: Sequence>(_ s: S) where S.Element == Element {
        sequence = AnySequence(s)
    }
    
    func sorted() -> AnySequence<Element> {
        fatalError()
    }
}

struct SortRoutine: Routine {
    static func routine() {
        InsertSortRoutine.routine()
        QuickSortRoutine.routine()
        MergeSortRoutine.routine()
        HeapSortRoutine.routine()
        ArraySortRoutine.routine()
    }
}
