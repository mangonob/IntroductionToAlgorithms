//
//  Utilities.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2019/3/14.
//  Copyright © 2019 mangonob. All rights reserved.
//

import Foundation

@discardableResult
func time(_ label: String, handler: () -> Void) -> TimeInterval {
    let current = Date()
    handler()
    let time = Date().timeIntervalSince(current)
    print(String(format: "\(label) used %fs.", time))
    return time
}

protocol PrettyPrint {
    var prettyDescription: String { get }
}

func pprint(_ items: [PrettyPrint])  {
    for item in items {
        print(item.prettyDescription)
    }
}

extension Array: PrettyPrint where Element: PrettyPrint {
    var prettyDescription: String {
        var description = "[\n"
        for item in self {
            description.append("\(item.prettyDescription),\n")
        }
        description.append("]")
        return description
    }
}

extension Int: PrettyPrint {
    var prettyDescription: String {
        return description
    }
}

infix operator >>> : RangeFormationPrecedence
infix operator <<< : RangeFormationPrecedence

extension Int {
    static func >>>(lhs: Int, rhs: Int) -> [Int] {
        if lhs >= rhs {
            return [Int](rhs...lhs).reversed()
        } else {
            return []
        }
    }

    static func <<<(lhs: Int, rhs: Int) -> [Int] {
        if lhs <= rhs {
            return [Int](lhs...rhs)
        } else {
            return []
        }
    }
}

func randf() -> Double {
    return Double(arc4random()) / Double(UInt32.max)
}

func rand(from: Int, to: Int) -> Int {
    return Int(Double(to - from) * randf()) + from
}

func identifier(_ x: AnyObject) -> Int {
    return Int(bitPattern: ObjectIdentifier(x))
}
