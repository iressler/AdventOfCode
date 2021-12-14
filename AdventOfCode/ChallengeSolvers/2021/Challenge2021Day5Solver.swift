//
//  Challenge2021Day5Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/4/21.
//

import Foundation

struct Challenge2021Day5Solver: ChallengeSolver {
  struct Map: CustomStringConvertible {
    private let points: [(Point, Point)]
    private(set) var vents: [[Int]]

    init(ventMap: [String]) {
      var points = [(Point, Point)]()
      var maxY = 0
      var maxX = 0
      for line in ventMap {
        let coordinates = line.components(separatedBy: " -> ")
        let startPoint = Point(pointString: coordinates.first!)!
        let endPoint = Point(pointString: coordinates.last!)!
        maxX = max(maxX, max(startPoint.x, endPoint.x))
        maxY = max(maxY, max(startPoint.y, endPoint.y))
        points.append((startPoint, endPoint))
      }

      self.points = points
      // maxX/Y + 1 to account for = indexing.
      self.vents = Array<[Int]>.init(repeating: Array<Int>.init(repeating: 0, count: maxX + 1), count: maxY + 1)
    }

    public mutating func addVents(includeDiagonals: Bool) {
      for (startPoint, endPoint) in points {
        addVents(from: startPoint, to: endPoint, includeDiagonals: includeDiagonals)
      }
    }

    private mutating func addVents(from startPoint: Point, to endPoint: Point, includeDiagonals: Bool) {
      if startPoint.y == endPoint.y {
        addYLine(on: startPoint.y, from: startPoint.x, to: endPoint.x)
      } else if startPoint.x == endPoint.x {
        addXLine(on: startPoint.x, from: startPoint.y, to: endPoint.y)
      } else if includeDiagonals {
        addDiagonalLine(from: startPoint, to: endPoint)
      }
    }

    private mutating func addYLine(on y: Int, from: Int, to: Int) {
      for i in min(from, to)...max(from, to) {
        vents[y][i] += 1
      }
    }

    private mutating func addXLine(on x: Int, from: Int, to: Int) {
      for i in min(from, to)...max(from, to) {
        vents[i][x] += 1
      }
    }

    typealias Updater = (Int) -> Int
    private mutating func addDiagonalLine(from startPoint: Point, to endPoint: Point) {
      let add: (Int) -> Int = { $0 + 1 }
      let subtract: (Int) -> Int = { $0 - 1 }

      let xOperator = startPoint.x > endPoint.x ? subtract : add
      let yOperator = startPoint.y > endPoint.y ? subtract : add

      func shouldContinue(_ currPoint: Point) -> Bool {
        if startPoint.y < endPoint.y {
          return currPoint.y <= endPoint.y
        } else {
          return currPoint.y >= endPoint.y
        }
      }

//      print("Adding diagonal line from \(startPoint) -> \(endPoint)")
      var currPoint = startPoint
      while shouldContinue(currPoint) {
//        print("Adding diagonal line at \(currPoint)")
        vents[currPoint.y][currPoint.x] += 1
        currPoint = Point(x: xOperator(currPoint.x), y: yOperator(currPoint.y))
      }
    }

    var description: String {
      return "\n" + vents.fieldDescription()
    }
  }

  static let defaultValue = """
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let map = Map(ventMap: inputComponents(from: input))
//    print(map)
    switch challengeNumber {
    case .one:
      return getAnswer1(given: map)
    case .two:
      return getAnswer2(given: map)
    }
  }

  static private func numberOfDangerousVents(in map: Map) -> Int {
    return map.vents.reduce(into: 0) { partialResult, row in
      partialResult += row.filter({ $0 >= 2 }).count
    }
  }

  static private func getAnswer1(given map: Map) -> String {
    var map = map
    map.addVents(includeDiagonals: false)
//    print(map)
    return "\(numberOfDangerousVents(in: map))"
  }

  static private func getAnswer2(given map: Map) -> String {
    var map = map
    map.addVents(includeDiagonals: true)
//    print(map)
    return "\(numberOfDangerousVents(in: map))"
  }
}
