//
//  Challenge2021Day7Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2021Day15Solver: ChallengeSolver {
  static let defaultValue1 = """
18111
11181
88881
"""
  static let defaultValue = """
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let riskLevels = inputComponents(from: input).map({ $0.toArray().map({ Int($0)! }) })
    switch challengeNumber {
    case .one:
      return getAnswer1(given: riskLevels)
    case .two:
      return getAnswer2(given: riskLevels)
    }
  }

  static private func lowestRiskPath(given riskLevels: [[Int]], risks: [Point: Int]) -> [Point] {
    let lastPoint = Point(x: riskLevels.count-1, y: riskLevels.first!.count-1)

    var path = [lastPoint]
    var nextPoint = lastPoint

    var riskCosts = riskLevels

    for (point, value) in risks {
      riskCosts[point] = value
    }

    while nextPoint != Point(x: 0, y: 0) {
      let adjacentPoints = riskLevels.pointsAdjacent(to: nextPoint)
      let sorted = adjacentPoints.sorted { lhs, rhs in
        riskCosts[lhs] < riskCosts[rhs]
      }
      path.append(sorted.first!)
      nextPoint = sorted.first!
    }

//    print(riskCosts.fieldDescription())
//    print(Array(path.reversed()))

    return path.reversed()
  }



  static private func riskFor(map riskLevels: [[Int]]) -> Int {
    let startingPoint = Point(x: 0, y: 0)
    var risks = [startingPoint: 0]
    var pointsToCheck = [startingPoint]

    var alreadyCheckedPoints: Set<Point> = Set(arrayLiteral: startingPoint)

    while !pointsToCheck.isEmpty {
      let nextPoint = pointsToCheck.removeFirst()
      for adjacentPoint in riskLevels.pointsAdjacent(to: nextPoint) {
        var risk = riskLevels[adjacentPoint] + risks[nextPoint]!
        if let existingRisk = risks[adjacentPoint] {
          // If the risk is now lower recheck it.
          if risk < existingRisk && alreadyCheckedPoints.contains(adjacentPoint) {
            pointsToCheck.append(adjacentPoint)
          }
          risk = min(risk, existingRisk)
        }

        if !alreadyCheckedPoints.contains(adjacentPoint) {
          pointsToCheck.append(adjacentPoint)
          alreadyCheckedPoints.insert(adjacentPoint)
        }
        //          print("risk \(nextPoint) -> \(adjacentPoint) = \(risk)")
        risks[adjacentPoint] = risk
      }
    }

//    var pathField = riskLevels.map({ $0.map({ " \($0) " }) })
//
//    for point in lowestRiskPath(given: riskLevels, risks: risks) {
//      pathField[point] = "[\(pathField[point][unsafe: 1])]"
//    }
//
//    print(pathField.fieldDescription())

    return risks[Point(x: riskLevels.count-1, y: riskLevels.first!.count-1)]!
  }

  static private func getAnswer1(given riskLevels: [[Int]]) -> String {
    return "\(riskFor(map: riskLevels))"
  }

  static private func getAnswer2(given riskLevels: [[Int]]) -> String {
    // Make super risk levels be 5 times the size in both x and y directions by repeating riskLevels.
    var superRiskLevels: [[Int]] = riskLevels.map({ row in
      return row + row + row + row + row
    })
    superRiskLevels = superRiskLevels + superRiskLevels + superRiskLevels + superRiskLevels + superRiskLevels

    // Because it wraps around to 1 and not 0 the remainder math gets annoying.
    // e.g. i % 9 goes 0 - 8 instead of 1 - 9, however the issue is that 1-8 are correct, so + 1 breaks everything.
    // This works out to something like (untested) `var x = i % 9; if x == 0 { x = 1 }`, which is painful.
    let valueMap = [
      1: 1,
      2: 2,
      3: 3,
      4: 4,
      5: 5,
      6: 6,
      7: 7,
      8: 8,
      9: 9,
      10: 1,
      11: 2,
      12: 3,
      13: 4,
      14: 5,
      15: 6,
      16: 7,
      17: 8,
      18: 9
    ]
    // Pre-calculate to avoid potential re-calculation (not guaranteed to O(1)?
    // I forget when it's O(1) vs O(n), and that may matter at this scale.
    let divisor = riskLevels.count

    // Increment the risks by the relevant amounts based on how far away from 0,0 they are.
    for x in 0..<superRiskLevels.count {
      for y in 0..<superRiskLevels[x].count {
        let increment = Int(x/divisor) + Int(y/divisor)
        if increment > 0 {
          superRiskLevels[x][y] = valueMap[superRiskLevels[x][y] + increment]!
        }
      }
    }

    return "\(riskFor(map: superRiskLevels))"
  }
}
