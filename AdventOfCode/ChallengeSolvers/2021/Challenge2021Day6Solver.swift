//
//  Challenge2021Day6Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/5/21.
//

import Foundation

struct Challenge2021Day6Solver: ChallengeSolver {
  static let defaultValue = "3,4,3,1,2"

  struct Fish: CustomStringConvertible {
    static let daysUntilReproductionAfterReproducing = 6
    static let newFishDaysUntilReproduction = 8
    var daysUntilReproduction: Int = Self.newFishDaysUntilReproduction

    // returns true if reproduced
    mutating func dayPassed() -> Bool {
      if daysUntilReproduction == 0 {
        daysUntilReproduction = Self.daysUntilReproductionAfterReproducing
        return true
      }
      daysUntilReproduction -= 1
      return false
    }

    var description: String {
      return "\(daysUntilReproduction)"
    }
  }

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let fishes = inputComponents(from: input, separators: ",").map({ Fish(daysUntilReproduction: Int($0)!)})

    switch challengeNumber {
    case .one:
      return getAnswer1(given: fishes)
    case .two:
      return getAnswer2(given: fishes)
    }
  }

  // This grows exponentially, so works for 80, but not 256 as required for challenge 2.
  static private func getAnswer1(given fishes: [Fish]) -> String {
    var allFish = fishes
    for _ in 0..<80 {
      var newFishCount = 0
      for fishIndex in 0..<allFish.count {
        var currFish = allFish[fishIndex]
        if currFish.dayPassed() {
          newFishCount += 1
        }
        allFish[fishIndex] = currFish
      }
      allFish.append(contentsOf: [Fish](repeating: Fish(), count: newFishCount))
    }
    return "\(allFish.count)"
  }

  // This could answer challenge 1 better than the current implementation,
  // however keeping both around since I used different solutions.
  static private func getAnswer2(given fishes: [Fish]) -> String {
    let maxDays = max(Fish.daysUntilReproductionAfterReproducing, Fish.newFishDaysUntilReproduction) + 1
    var counts = [Int](repeating: 0, count: maxDays)
    for fish in fishes {
      counts[fish.daysUntilReproduction] += 1
    }

    for day in 0..<256 {
      if day < 20 {
        print("day #\(day): \(counts.reduce(into: 0, { $0 += $1})): \(counts)")
      }
      var newCounts = [Int](repeating: 0, count: maxDays)
      for i in 0..<(maxDays-1) {
        newCounts[i] = counts[i+1]
      }
      newCounts[(Fish.daysUntilReproductionAfterReproducing)] += counts[0]
      newCounts[(maxDays-1)] = counts[0]
      counts = newCounts
    }
    return "\(counts.reduce(into: 0, { $0 += $1}))"
  }
}
