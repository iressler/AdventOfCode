//
//  Challenge2020Day9Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2020Day9Solver: ChallengeSolver {
  static var usedDefaultValue: Bool = false

  private static var preambleLength: Int {
    return usedDefaultValue ? 5 : 25
  }

  static let defaultValue = """
35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let lines = inputComponents(from: input).map({ Int($0)! })
    switch challengeNumber {
    case .one:
      return getAnswer1(given: lines)
    case .two:
      return getAnswer2(given: lines)
    }
  }

  static private func XmasWeakness(in numbers: [Int]) -> Int {
    var startIndex = 0

    for index in preambleLength..<numbers.count {
      let newNumber = numbers[index]
      let endIndex = startIndex + preambleLength
      var matched = false
      for i in numbers[startIndex..<endIndex] {
        for j in numbers[startIndex..<endIndex] {
          if i == j {
            continue
          }
          if i + j == newNumber {
            matched = true
            break
          }
        }
        if matched {
          break
        }
      }
      if !matched {
        return newNumber
      }
      startIndex += 1
    }

    return -1
  }

  static private func getAnswer1(given numbers: [Int]) -> String {
    return "\(XmasWeakness(in: numbers))"
  }

  static private func getAnswer2(given numbers: [Int]) -> String {
    let weakness = XmasWeakness(in: numbers)

    var startIndex: Int = 0
    var endIndex: Int = 0
    var sum: Int = numbers[0]

    while sum != weakness {
      // When the number is too small add the next number to the range.
      if sum < weakness {
        endIndex += 1
      } else {
        // When the number is too big remove the first number from the range.
        startIndex += 1
      }
      sum = numbers[startIndex...endIndex].sum()
    }

    let results = numbers[startIndex..<endIndex].sorted()

    return "\(results.first! + results.last!)"
  }
}
