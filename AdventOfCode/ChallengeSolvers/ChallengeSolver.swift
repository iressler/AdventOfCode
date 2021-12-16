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
  static var usedDefaultValue: Bool { get set }
}

extension ChallengeSolver {
  static var usedDefaultValue: Bool {
    get {
      return false
    }
    set {
      
    }
  }
}

extension ChallengeSolver {
  static func inputComponent(from input: String, defaultValue: String? = nil, separators: String, dropEmpty: Bool = true) -> String {
    return self.inputComponents(from: input, defaultValue: defaultValue, separators: separators, dropEmpty: dropEmpty).first!
  }

  static func inputComponents(from input: String, defaultValue: String? = nil, separators: String, dropEmpty: Bool = true) -> [String] {
    return self.inputComponents(from: input, defaultValue: defaultValue, separators: CharacterSet(charactersIn: separators), dropEmpty: dropEmpty)
  }

  static func inputComponent(from input: String, defaultValue: String? = nil, separators: CharacterSet = .newlines, dropEmpty: Bool = true) -> String {
    return self.inputComponents(from: input, defaultValue: defaultValue, separators: separators, dropEmpty: dropEmpty).first!
  }

  static func inputComponents(from input: String, defaultValue: String? = nil, separators: CharacterSet = .newlines, dropEmpty: Bool = true) -> [String] {
    let value: String
    if !input.isEmpty {
      value = input
    } else {
      value = defaultValue ?? self.defaultValue
      usedDefaultValue = true
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

  static func groupedInputComponents(from input: String, defaultValue: String? = nil, separators: String) -> [[String]] {
    return self.groupedInputComponents(from: input, defaultValue: defaultValue, separators: .newlines.union(CharacterSet(charactersIn: separators)))
  }

  static func groupedInputComponents(from input: String, defaultValue: String? = nil, separators: CharacterSet = .newlines) -> [[String]] {
    let lines = inputComponents(from: input, defaultValue: defaultValue, separators: separators, dropEmpty: false)

    var groups = [[String]]()
    var currGroup = [String]()
    for line in lines {
      if line.isEmpty {
        groups.append(currGroup)
        currGroup.removeAll()
      } else {
        currGroup.append(line)
      }
    }

    if !currGroup.isEmpty {
      groups.append(currGroup)
    }

    return groups
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
