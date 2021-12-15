//
//  Challenge2021Day11Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2021Day11Solver: ChallengeSolver {
  static let defaultValue = """
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let energyLevels = inputComponents(from: input).map({ $0.toArray().map({ Int($0)! }) })
    switch challengeNumber {
    case .one:
      return getAnswer1(given: energyLevels)
    case .two:
      return getAnswer2(given: energyLevels)
    }
  }

  // Returns the number of flashes caused by updating the energy.
  static private func updateEnergy(at point: Point, in energyLevels: inout [[Int]]) -> [Point] {
    var pointsThatFlashed = [Point]()
    energyLevels[point.y][point.x] += 1
    // Must be exactly 9 to prevent multiple flashes per turn.
    if energyLevels[point.y][point.x] == 10 {
      pointsThatFlashed.append(point)
      for y in point.y-1...point.y+1 {
        // If the y index is invalid skip it completely.
        guard y >= 0 && y < energyLevels.count else {
          continue
        }
        for x in point.x-1...point.x+1 {
          // If the x index is invalid skip it completely.
          guard x >= 0 && x < energyLevels[y].count else {
            continue
          }

          // If x and y are the same as the point continue so this doesn't update the point again.
          guard y != point.y || x != point.x else {
            continue
          }
          pointsThatFlashed.append(contentsOf: updateEnergy(at: Point(x: x, y: y), in: &energyLevels))
        }
      }
    }

    return pointsThatFlashed
  }

  static private func getAnswer1(given energyLevels: [[Int]]) -> String {
    var energyLevelsUpdated = energyLevels
    var flashesCount = 0
    for _ in 0..<100 {
      var pointsThatFlashed = [Point]()
      for y in 0..<energyLevelsUpdated.count {
        for x in 0..<energyLevelsUpdated.count {
          pointsThatFlashed.append(contentsOf: updateEnergy(at: Point(x: x, y: y), in: &energyLevelsUpdated))
        }
      }
      for point in pointsThatFlashed {
        energyLevelsUpdated[point.y][point.x] = 0
      }
      flashesCount += pointsThatFlashed.count
      pointsThatFlashed.removeAll()
    }
    return "\(flashesCount)"
  }

  static private func getAnswer2(given energyLevels: [[Int]]) -> String {
    let totalOctopuses = energyLevels.count * energyLevels[0].count
    var energyLevelsUpdated = energyLevels

    for index in 0..<Int.max {
      var pointsThatFlashed = [Point]()
      for y in 0..<energyLevelsUpdated.count {
        for x in 0..<energyLevelsUpdated.count {
          pointsThatFlashed.append(contentsOf: updateEnergy(at: Point(x: x, y: y), in: &energyLevelsUpdated))
        }
      }
      for point in pointsThatFlashed {
        energyLevelsUpdated[point.y][point.x] = 0
      }
      if pointsThatFlashed.count == totalOctopuses {
        return "\(index + 1)"
      }
      pointsThatFlashed.removeAll()
    }
    return "Reached \(Int.max) loops without all of them flashing."
  }
}
