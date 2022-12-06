//
//  Challenge2022Day2Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/2/21.
//

import Foundation

enum Shape {
  enum Result: Int {
    case win = 6
    case tie = 3
    case lose = 0

    static func result(from char: String) -> Result {
      switch char {
      case "X":
        return .lose
      case "Y":
        return .tie
      case "Z":
        return .win
      default:
        fatalError("Unknown result character: \(char)")
      }
    }
  }

  case rock
  case paper
  case scisors

  static func shape(from char: String) -> Shape {
    switch char {
    case "A", "X":
      return .rock
    case "B", "Y":
      return .paper
    case "C", "Z":
      return .scisors
    default:
      fatalError("Unknown shape character: \(char)")
    }
  }

  var score: Int {
    switch self {
    case .rock:
      return 1
    case .paper:
      return 2
    case .scisors:
      return 3
    }
  }

  func result(against other: Shape) -> Result {
    switch self {
    case .rock:
      switch other {
      case .rock:
        return .tie
      case .paper:
        return .lose
      case .scisors:
        return .win
      }
    case .paper:
      switch other {
      case .rock:
        return .win
      case .paper:
        return .tie
      case .scisors:
        return .lose
      }
    case .scisors:
      switch other {
      case .rock:
        return .lose
      case .paper:
        return .win
      case .scisors:
        return .tie
      }
    }
  }

  var losesTo: Shape {
    switch self {
    case .rock:
      return .paper
    case .paper:
      return .scisors
    case .scisors:
      return .rock
    }
  }

  var winsAgainst: Shape {
    switch self {
    case .rock:
      return .scisors
    case .paper:
      return .rock
    case .scisors:
      return .paper
    }
  }
}

struct Challenge2022Day2Solver: ChallengeSolver {
  static let defaultValue = """
A Y
B X
C Z
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

  static private func getAnswer1(given input: [String]) -> String {
    var totalScore = 0
    for line in input {
      let chars = line.components(separatedBy: " ")
      guard chars.count == 2 else {
        fatalError("Invalid number of shapes in: \(chars)")
      }

      let opponentShape = Shape.shape(from: chars.first!)
      let playerShape = Shape.shape(from: chars.last!)

      let score = playerShape.score + playerShape.result(against: opponentShape).rawValue
      print(score)
      totalScore += score
    }
    return "\(totalScore)"
  }

  static private func getAnswer2(given input: [String]) -> String {
    var totalScore = 0
    for line in input {
      let chars = line.components(separatedBy: " ")
      guard chars.count == 2 else {
        fatalError("Invalid number of shapes in: \(chars)")
      }

      let opponentShape = Shape.shape(from: chars.first!)
      let result = Shape.Result.result(from: chars.last!)

      let playerShape: Shape
      switch result {
      case .win:
        playerShape = opponentShape.losesTo
      case .tie:
        playerShape = opponentShape
      case .lose:
        playerShape = opponentShape.winsAgainst
      }

      let score = playerShape.score + result.rawValue
      print(score)
      totalScore += score
    }
    return "\(totalScore)"
  }
}
