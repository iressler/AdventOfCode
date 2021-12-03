//
//  ChallengeDay1.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/2/21.
//

import Foundation

struct Challenge2021Day1Solver: ChallengeSolver {
  static func solution(number: ChallengeNumber, for input: String) -> String {
    let depthReadings: [Int]
    if input.isEmpty {
      depthReadings = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]
      printDefaultValueMessage(depthReadings)
    } else {
      depthReadings = input
        .components(separatedBy: .whitespacesAndNewlines.union(CharacterSet(charactersIn: ",")))
        .compactMap({ (subString: String) -> Int? in
          guard !subString.isEmpty else {
            return nil
          }
          return Int(subString)
        })
    }
    switch number {
    case .one:
      return getAnswer1(given: depthReadings)
    case .two:
      return getAnswer2(given: depthReadings)
    }
  }

  static private func getAnswer1(given depthReadings: [Int]) -> String {
    guard !depthReadings.isEmpty else {
      return "0"
    }
    var previousReading = depthReadings.first!
    var numberOfIncreases = 0

    for depthReading in depthReadings {
      if depthReading > previousReading {
        numberOfIncreases += 1
      }
      previousReading = depthReading
    }
    return "\(numberOfIncreases)"
  }

  static private func getAnswer2(given depthReadings: [Int]) -> String {
    guard depthReadings.count > 3 else {
      return "0"
    }

    var numberOfIncreases = 0

    for index in 3..<depthReadings.count {
      if depthReadings[index] > depthReadings[index - 3] {
        numberOfIncreases += 1
      }
    }
    return "\(numberOfIncreases)"
  }
}
