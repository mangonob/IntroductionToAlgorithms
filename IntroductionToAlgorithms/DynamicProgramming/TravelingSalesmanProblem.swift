//
//  Traveling Salesman Problem.swift
//  IntroductionToAlgorithms
//
//  Created by 高炼 on 2019/3/18.
//  Copyright © 2019 mangonob. All rights reserved.
//

import Foundation

struct Coord: CustomStringConvertible {
    var x: Float
    var y: Float
    
    var description: String {
        return "(\(x), \(y))"
    }
}

class TSP {
    private var coords: [Coord]
    private var costs: [[Float]]
    
    init(_ coords: [Coord]) {
        self.coords = coords.sorted { $0.x < $1.x }
        let length = coords.count
        costs = [[Float]](repeating: [Float](repeating: .infinity, count: length), count: length)
        solveTSP()
    }
    
    private func dist(_ i: Int, _ j: Int) -> Float {
        let coord1 = coords[i]
        let coord2 = coords[j]
        return sqrt(pow(coord1.x - coord2.x, 2) + pow(coord1.y - coord2.y, 2))
    }
    
    private func solveTSP(){
        let length = coords.count
        solveTSP(length - 1, length - 1)
    }
    
    @discardableResult
    private func solveTSP(_ start: Int, _ end: Int) -> Float {
        if start > end {
            return solveTSP(end, start)
        }
        
        if costs[start][end] != .infinity {
            return costs[start][end]
        }
        
        if start == 0 && end <= 1 {
            costs[start][end] = dist(0, end)
        } else if start < end - 1 {
            costs[start][end] = solveTSP(start, end - 1) + dist(end - 1, end)
        } else {
            for i in 0..<end {
                costs[start][end] = min(
                    costs[start][end],
                    solveTSP(start, i) + dist(i, end)
                )
            }
        }
        
        return costs[start][end]
    }
}

extension TSP: Routine {
    static func routine() {
        let tsp = TSP([
            Coord(x: 1, y: 0),
            Coord(x: 2, y: 3),
            Coord(x: 0, y: 6),
            Coord(x: 5, y: 4),
            Coord(x: 6, y: 1),
            Coord(x: 7, y: 5),
            Coord(x: 8, y: 2),
            ])
        
        print(tsp.costs)
    }
}
