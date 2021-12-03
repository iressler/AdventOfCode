//
//  ChallengeSolver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/2/21.
//

import Foundation

protocol ChallengeSolver {
  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String
  static var defaultValue: String { get }
}

extension ChallengeSolver {
  static func components(from input: String) -> [String] {
    let value: String
    if !input.isEmpty {
      value = input
    } else {
      value = defaultValue
      printDefaultValueMessage(value)
    }
    return value.components(separatedBy: .whitespacesAndNewlines.union(CharacterSet(charactersIn: ",")))
  }
}

// Prototype solver implementation.
//struct ChallengeDaySolver: ChallengeSolver {
//  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
//    switch challengeNumber {
//    case .one:
//      return getAnswer1(given: input)
//    case .two:
//      return getAnswer2(given: input)
//    }
//  }
//
//  static private func getAnswer1(given: String) -> String {
//    return ""
//  }
//
//  static private func getAnswer2(given: String) -> String {
//    return ""
//  }
//}
