//
//  Utilities.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2019/3/14.
//  Copyright © 2019 BaiYiYuan. All rights reserved.
//

import Foundation

func time(_ label: String, handler: () -> Void) {
    let current = Date()
    handler()
    print(String(format: "\(label) use %fs.", Date().timeIntervalSince(current)))
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
