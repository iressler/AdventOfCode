//
//  ChallengeDay.swift
//  AdventOfCode2021
//
//  Created by Isaac Ressler on 12/2/21.
//

import Foundation
import ArgumentParser

enum ChallengeDay: Int, CaseIterable {
  case one = 1
  case two

  private static var solvers: [ChallengeSolver.Type] = [ChallengeDay1Solver.self, ChallengeDay2Solver.self]
  var solver: ChallengeSolver.Type {
    return Self.solvers[rawValue - 1]
  }
}

extension ChallengeDay: Comparable {
  static func < (lhs: ChallengeDay, rhs: ChallengeDay) -> Bool {
    return lhs.rawValue < rhs.rawValue
  }
}

extension ChallengeDay: ExpressibleByArgument {
  init?(argument: String) {
    guard let rawValue = Int(argument) else {
      return nil
    }
    self.init(rawValue: rawValue)
  }

  static var allValueStrings: [String] {
    return allCases.map({ String($0.rawValue) })
  }
}
