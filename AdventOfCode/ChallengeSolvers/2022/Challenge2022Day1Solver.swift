//
//  Challenge2022Day1Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/2/21.
//

import Foundation

struct Challenge2022Day1Solver: ChallengeSolver {
  static let defaultValue = """
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let lines = inputComponents(from: input, dropEmpty: false)
    switch challengeNumber {
    case .one:
      return getAnswer1(given: lines)
    case .two:
      return getAnswer2(given: lines)
    }
  }

  static private func calorieSums(given calorieCounts: [String]) -> [Int] {
    guard !calorieCounts.isEmpty else {
      return []
    }

    var index = 0
    var currCount = 0
    var calorieSums = [Int]()

    while index < calorieCounts.endIndex {
      while index < calorieCounts.endIndex {
        let line = calorieCounts[index]
        //        print("Line at #\(index): \(line)")
        index += 1
        if line.isEmpty {
          break
        }
        //        print("Adding \(Int(line)!) to \(currCount) to get \(currCount + Int(line)!)")
        currCount += Int(line)!
      }

      calorieSums.append(currCount)
//      print("Ended counting at \(currCount)")
      currCount = 0
    }
    return calorieSums.sorted(by: >)
  }

  static private func getAnswer1(given calorieCounts: [String]) -> String {
    return String(calorieSums(given: calorieCounts).first!)
  }

  static private func getAnswer2(given calorieCounts: [String]) -> String {
    return String(calorieSums(given: calorieCounts)[0..<3].sum())
  }
}
