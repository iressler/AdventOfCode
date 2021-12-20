//
//  Challenge2021Day9Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2021Day9Solver: ChallengeSolver {
  static let defaultValue = """
2199943210
3987894921
9856789892
8767896789
9899965678
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let depths: [[Int]] = inputComponents(from: input).map({ $0.toArray().map({ Int($0)! }) })

    switch challengeNumber {
    case .one:
      return getAnswer1(given: depths)
    case .two:
      return getAnswer2(given: depths)
    }
  }

  static private func getAnswer1(given depths: [[Int]]) -> String {
    var riskLevelSum = 0
    let maxRow = depths.count - 1
    for y in 0..<depths.count {
      let row = depths[y]
      let maxColumn = row.count - 1

      for x in 0..<row.count {
        let depth = row[x]
        if (y > 0 && depth >= depths[y-1][x]) ||
            (y < maxRow && depth >= depths[y+1][x]) ||
        (x > 0 && depth >= row[x-1]) ||
        (x < maxColumn && depth >= row[x+1]){
          continue
        }
        riskLevelSum += (depth + 1)
      }
    }
    return "\(riskLevelSum)"
  }

  private struct Basin {
    var points = Set<Point>()
  }

  static private func basin(for point: Point, using depths: [[Int]]) -> Basin? {
    let depth = depths[point]
    guard depth < 9 else {
      return nil
    }

    var newBasin = Basin(points: [point])

    var adjacentPoints: [Point] = depths.pointsAdjacent(to: point)

    while let adjacentPoint = adjacentPoints.popLast() {
      guard !newBasin.points.contains(adjacentPoint) else {
        continue
      }

      if depths[adjacentPoint] < 9 {
        newBasin.points.insert(adjacentPoint)
        adjacentPoints.append(contentsOf: depths.pointsAdjacent(to: adjacentPoint))
      }
    }

    return newBasin
  }

  static private func getAnswer2(given depths: [[Int]]) -> String {
    print(depths.fieldDescription())
    var pointsToBasin = [Point: Basin]()
    var basins = [Basin]()
    for x in 0..<depths.count {
      let row = depths[x]
      for y in 0..<row.count {
        let point = Point(x: x, y: y)
        // If the point has already been assigned to a basin break
        guard pointsToBasin[point] == nil else {
          continue
        }

        if let basin = basin(for: point, using: depths) {
          basins.append(basin)
          for point in basin.points {
            pointsToBasin[point] = basin
          }
        }
      }
    }

    let sortedBasins = basins.sorted { lhs, rhs in
      return lhs.points.count > rhs.points.count
    }
    return "\(sortedBasins[0].points.count * sortedBasins[1].points.count * sortedBasins[2].points.count)"
  }
}
