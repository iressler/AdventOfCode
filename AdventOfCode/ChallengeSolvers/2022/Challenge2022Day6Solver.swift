//
//  Challenge2022Day6Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/5/21.
//

import Foundation

import Collections

struct Challenge2022Day6Solver: ChallengeSolver {
  static let defaultValue = """
mjqjpqmgbljsphdztnvjfqwrcgsmlb
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

  static private func endIndexOfUniqueCharacters(_ input: String, count: Int) -> Int {
    let chars = Array(input)
    guard chars.count >= count else {
      return -1
    }

    var lastCountChars = Deque(chars[0..<count])
    if Set(lastCountChars).count == count {
      return count
    }

    var index = count
    while index <= chars.endIndex {
      let char = chars[index]
      lastCountChars.removeFirst()
      lastCountChars.append(char)
      if Set(lastCountChars).count == count {
        break
      }
      index += 1
    }

    return index
  }

  static private func getAnswer1(given input: [String]) -> String {
    // + 1 to account for 0 based indexing.
    return "\(endIndexOfUniqueCharacters(input.first!, count: 4) + 1)"
  }

  static private func getAnswer2(given input: [String]) -> String {
    // + 1 to account for 0 based indexing.
    return "\(endIndexOfUniqueCharacters(input.first!, count: 14) + 1)"
  }
}
