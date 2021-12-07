//
//  Challenge2020Day2Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/3/21.
//

import Foundation

struct Challenge2020Day2Solver: ChallengeSolver {
  static let defaultValue = """
1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let passwords = inputComponents(from: input)
      .map({ Password(line: $0)! })

    switch challengeNumber {
    case .one:
      return getAnswer1(given: passwords)
    case .two:
      return getAnswer2(given: passwords)
    }
  }

  private struct Password {
    let minLength: Int
    let maxLength: Int
    let character: Character
    let password: String

    init?(line: String) {
      let components = line
        .components(separatedBy: .whitespacesAndNewlines.union(CharacterSet(charactersIn: ":-")))
        .filter({ !$0.isEmpty })
      guard components.count == 4 else {
        return nil
      }
      self.init(minLength: components[0],
                maxLength: components[1],
                character: components[2],
                password: components[3]
      )
    }

    init(minLength: String, maxLength: String, character: String, password: String) {
      guard character.count == 1,
            let minLength = Int(minLength),
            let maxLength = Int(maxLength) else {
        fatalError("Invalid input: \(minLength), \(maxLength), \(character), \(password)")
      }

      self.minLength = minLength
      self.maxLength = maxLength
      self.character = character.first!
      self.password = password
    }
  }

  static private func getAnswer1(given passwords: [Password]) -> String {
    var validPasswordCount = 0
    for password in passwords {
      let charCount = password.password.reduce(into: 0) { partialResult, char in
        if password.character == char {
          partialResult += 1
        }
      }

      if password.minLength <= charCount && charCount <= password.maxLength {
          validPasswordCount += 1
      }
    }
    return "\(validPasswordCount)"
  }

  static private func getAnswer2(given passwords: [Password]) -> String {
    var validPasswordCount = 0
    for password in passwords {
      let firstIndex = password.password.index(password.password.startIndex, offsetBy: password.minLength - 1)
      let firstIndexMatches = password.password[firstIndex] == password.character
      let secondIndex = password.password.index(password.password.startIndex, offsetBy: password.maxLength - 1)
      let secondIndexMatches = password.password[secondIndex] == password.character

      if (firstIndexMatches || secondIndexMatches) && (firstIndexMatches != secondIndexMatches) {
        validPasswordCount += 1
      }

//      if password.minLength <= charCount && charCount <= password.maxLength {
//        validPasswordCount += 1
//      }
    }
    return "\(validPasswordCount)"
  }
}
