//
//  Challenge2022Day3Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/2/21.
//

import Foundation

struct Challenge2022Day3Solver: ChallengeSolver {
  static let defaultValue = """
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let lines = inputComponents(from: input)
    switch challengeNumber {
    case .one:
      return getAnswer1(given: lines)
    case .two:
      return getAnswer2(given: lines)
    }
  }

  static private func getAnswer1(given: [String]) -> String {
    return ""
  }

  static private func getAnswer2(given: [String]) -> String {
    return ""
  }
}
