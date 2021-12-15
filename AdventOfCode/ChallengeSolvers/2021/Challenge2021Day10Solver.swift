//
//  Challenge2021Day10Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

private extension String {
  var isChunkOpenChar: Bool {
    return ["[", "(", "{", "<"].contains(self)
  }

  var isChunkCloseChar: Bool {
    return ["]", ")", "}", ">"].contains(self)
  }

  enum ChunkType {
    case bracket
    case parenthesis
    case angleBracket
    case squareBracket

    var illegalCharPoints: Int {
      switch self {
      case .bracket:
        return 1197
      case .parenthesis:
        return 3
      case .angleBracket:
        return 25137
      case .squareBracket:
        return 57
      }
    }

    var completionCharPoints: Int {
      switch self {
      case .bracket:
        return 3
      case .parenthesis:
        return 1
      case .angleBracket:
        return 4
      case .squareBracket:
        return 2
      }
    }
  }

  var chunkType: ChunkType {
    switch self {
    case "{", "}":
      return .bracket
    case "(", ")":
      return .parenthesis
    case "<", ">":
      return .angleBracket
    case "[", "]":
      return .squareBracket
    default:
      fatalError("Unsupported character")
    }
  }
}

struct Challenge2021Day10Solver: ChallengeSolver {
  static let defaultValue = """
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let lines = inputComponents(from: input).map({ $0.toArray()})
    switch challengeNumber {
    case .one:
      return getAnswer1(given: lines)
    case .two:
      return getAnswer2(given: lines)
    }
  }

  static private func getAnswer1(given lines: [[String]]) -> String {
    var points = 0
    var currentChunkTypes = [String.ChunkType]()
    for line in lines {
      currentChunkTypes.removeAll()
      for char in line {
        // If it's an open char add it to the current Chunk info and continue
        if char.isChunkOpenChar {
          currentChunkTypes.append(char.chunkType)

        } else if char.chunkType != currentChunkTypes.popLast() {
          points += char.chunkType.illegalCharPoints
          break
        }
      }
    }
    return "\(points)"
  }

  static private func getAnswer2(given lines: [[String]]) -> String {
    var allPoints = [Int]()
    var currentChunkTypes = [String.ChunkType]()
    for line in lines {
      currentChunkTypes.removeAll()
      var lineIsCorrupted = false
      for char in line {
        // If it's an open char add it to the current Chunk info and continue
        if char.isChunkOpenChar {
          currentChunkTypes.append(char.chunkType)
        } else if char.chunkType != currentChunkTypes.popLast() {
          lineIsCorrupted = true
          break
        }
      }
      if !lineIsCorrupted {
        var points = 0
        while let type = currentChunkTypes.popLast() {
          points = (points * 5) + type.completionCharPoints
        }
        allPoints.append(points)
      }
    }
    return "\(allPoints.sorted()[allPoints.count / 2])"
  }
}
