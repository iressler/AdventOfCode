//
//  Challenge2021Day7Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2021Day7Solver: ChallengeSolver {
  static let defaultValue = "16,1,2,0,4,2,7,1,2,14"

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let crabs = components(from: input, separators: ",").map({ Int($0)! })

    switch challengeNumber {
    case .one:
      return getAnswer1(given: crabs)
    case .two:
      return getAnswer2(given: crabs)
    }
  }

  struct CrabResult {
    let fuelUsage: Int
    let index: Int
  }

  static private func calculateFuelUsage(given crabs: [Int], using fuelCalculator: (Int) -> Int) -> CrabResult {
    guard crabs.count > 1 else {
      fatalError("Not enough crabs provided")
    }
    let min = crabs.min()!
    let max = crabs.max()!

    var index = -1
    var cost = Int.max

    for i in min...max {
      var newCost = 0
      for crab in crabs {
        newCost += fuelCalculator(abs(crab - i))
      }
      if newCost < cost {
        cost = newCost
        index = i
      }
    }

    return CrabResult(fuelUsage: cost, index: index)
  }

  static private func getAnswer1(given crabs: [Int]) -> String {
    let result = calculateFuelUsage(given: crabs, using: { $0 })

    return "It will cost \(result.fuelUsage) to move all crabs to position: \(result.index)"
  }

  static private func getAnswer2(given crabs: [Int]) -> String {
    let result = calculateFuelUsage(given: crabs, using: { $0 * ($0 + 1) / 2 })

    return "It will cost \(result.fuelUsage) to move all crabs to position: \(result.index)"
  }
}
