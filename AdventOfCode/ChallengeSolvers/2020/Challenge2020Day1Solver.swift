//
//  Challenge2020Day1Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/3/21.
//

import Foundation

struct Challenge2020Day1Solver: ChallengeSolver {
  static let defaultValue = "1721 979 366 299 675 1456"

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let entries = components(from: input)
      .compactMap({ (subString: String) -> Int? in
        guard !subString.isEmpty else {
          return nil
        }
        return Int(subString)
      })

    switch challengeNumber {
    case .one:
      return getAnswer1(given: entries)
    case .two:
      return getAnswer2(given: entries)
    }
  }

  static private func getAnswer1(given entries: [Int]) -> String {
    for entry1 in entries {
      for entry2 in entries {
        if entry1 + entry2 == 2020 {
          return "\(entry1 * entry2)"
        }
      }
    }

    return "Failed to find numbers that meet the criteria"
  }

  static private func getAnswer2(given entries: [Int]) -> String {
    for entry1 in entries {
      for entry2 in entries {
        for entry3 in entries {
          if entry1 + entry2 + entry3 == 2020 {
            return "\(entry1 * entry2 * entry3)"
          }
        }
      }
    }
    return "Failed to find numbers that meet the criteria"
  }
}
