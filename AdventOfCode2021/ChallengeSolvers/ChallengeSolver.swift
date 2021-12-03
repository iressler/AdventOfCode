//
//  ChallengeSolver.swift
//  AdventOfCode2021
//
//  Created by Isaac Ressler on 12/2/21.
//

import Foundation

protocol ChallengeSolver {
  static func getAnswer(challengeNumber: ChallengeNumber, input: String) -> String
}


// Prototype solver implementation.
//struct ChallengeDaySolver: ChallengeSolver {
//  static func getAnswer(challengeNumber: ChallengeNumber, input: String) -> String {
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
