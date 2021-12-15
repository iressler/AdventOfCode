//
//  ChallengeDay.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/2/21.
//

import Foundation

enum ChallengeDay: Int, CaseIterable {
  case one = 1
  case two
  case three
  case four
  case five
  case six
  case seven
  case eight
  case nine
  case ten
  case eleven
  case twelve
  case thirteen
  case fourteen
  case fifteen
  case sixteen
  case seventeen
  case eighteen
  case nineteen
  case twenty
  case twentyOne
  case twentyTwo
  case twentyThree
  case twentyFour
  case twentyFive

  private static var solvers: [ChallengeSolver.Type] = [
    Challenge2021Day1Solver.self,
    Challenge2021Day2Solver.self,
    Challenge2021Day3Solver.self
  ]
  var solver: ChallengeSolver.Type {
    return Self.solvers[rawValue - 1]
  }
}

extension ChallengeDay: Comparable {
  static func < (lhs: ChallengeDay, rhs: ChallengeDay) -> Bool {
    return lhs.rawValue < rhs.rawValue
  }
}

// The argument parser doesn't work in testing environments, so exclude this from testing builds.
#if !TESTING
import ArgumentParser

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
#endif
