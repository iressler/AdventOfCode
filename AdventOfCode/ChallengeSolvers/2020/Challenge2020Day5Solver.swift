//
//  Challenge2020Day5Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2020Day5Solver: ChallengeSolver {
  private struct Ticket: CustomStringConvertible {
    static func location(from code: String, max: Int) -> Int {
      var locationMin = 0
      var locationMax = max
      for char in code {
//        print("min: \(locationMin), max: \(locationMax)")
        let change = ((locationMax + 1) - locationMin) / 2
        switch char {
        case "F", "L":
          locationMax -= change
        case "B", "R":
          locationMin += change
        default:
          fatalError("Unexpected code character: \(char)")
        }
      }
//      print("final min: \(locationMin), max: \(locationMax)")
      if locationMin != locationMax {
        fatalError("Failed to determine row from \(code)")
      }
      return locationMax
    }

    var id: Int {
      return (self.row * 8) + self.column
    }

    let row: Int
    let column: Int

    init(code: String) {
      let rowCode = code.substring(starting: 0, length: 7)
      let columnCode = code.substring(starting: 7)

      self.row = Self.location(from: rowCode, max: 127)
      self.column = Self.location(from: columnCode, max: 7)
    }

    var description: String {
      return "#\(id): row \(row), column: \(column)"
    }
  }
  static let defaultValue = """
BFFFBBFRRR
FFFBBBFRRR
BBFFBBFRLL
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let tickets = inputComponents(from: input).map({ Ticket(code: $0) })
    switch challengeNumber {
    case .one:
      return getAnswer1(given: tickets)
    case .two:
      return getAnswer2(given: tickets)
    }
  }

  static private func getAnswer1(given tickets: [Ticket]) -> String {
    return "\(tickets.map({ $0.id }).max()!)"
  }

  static private func getAnswer2(given tickets: [Ticket]) -> String {
    let ids = tickets.map({ $0.id }).sorted()
    for i in 0..<(ids.count-1) {

      if ids[i+1] != (ids[i] + 1) {
        return "\(ids[i] + 1)"
      }
    }
    return "Did not find a missing seat."
  }
}
