//
//  ChallengeDay1.swift
//  AdventOfCode2021
//
//  Created by Isaac Ressler on 12/2/21.
//

import Foundation

struct ChallengeDay1Solver {
  static func getAnswer(challengeNumber: ChallengeNumber, input: String) -> String {
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
    switch challengeNumber {
    case .one:
      return ChallengeDay1Solver().getAnswer1(given: depthReadings)
    case .two:
      return ChallengeDay1Solver().getAnswer2(given: depthReadings)
    }
  }

  private init() {
  }

  private func getAnswer1(given depthReadings: [Int]) -> String {
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

  private func getAnswer2(given depthReadings: [Int]) -> String {
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
