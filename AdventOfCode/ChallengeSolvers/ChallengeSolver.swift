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
  static func inputComponents(from input: String, separators: String, dropEmpty: Bool = true) -> [String] {
    return self.inputComponents(from: input, separators: .newlines.union(CharacterSet(charactersIn: separators)), dropEmpty: dropEmpty)
  }

  static func inputComponents(from input: String, separators: CharacterSet = .newlines, dropEmpty: Bool = true) -> [String] {
    let value: String
    if !input.isEmpty {
      value = input
    } else {
      value = defaultValue
      printDefaultValueMessage(value)
    }

    return components(from: value, separators: separators, dropEmpty: dropEmpty)

  }

  static func components(from string: String, separators: CharacterSet = .newlines, dropEmpty: Bool = true) -> [String] {
    let lines = string.components(separatedBy: separators)
    if dropEmpty {
      return lines.filter({ !$0.isEmpty })
    } else {
      return lines
    }
  }
}

// Prototype solver implementation.

//struct ChallengeDaySolver: ChallengeSolver {
//  static let defaultValue = """
//"""
//
//  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
//    let lines = components(from: input)
//    switch challengeNumber {
//    case .one:
//      return getAnswer1(given: lines)
//    case .two:
//      return getAnswer2(given: lines)
//    }
//  }
//
//  static private func getAnswer1(given: [String]) -> String {
//    return ""
//  }
//
//  static private func getAnswer2(given: [String]) -> String {
//    return ""
//  }
//}
