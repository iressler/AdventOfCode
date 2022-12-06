//
//  ChallengeYear.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/3/21.
//

import Foundation

enum ChallengeYear: Int, CaseIterable {
  case twentyTwenty = 2020
  case twentyTwentyOne = 2021
  case twentyTwentyTwo = 2022
}

extension ChallengeYear: Comparable {
  static func < (lhs: ChallengeYear, rhs: ChallengeYear) -> Bool {
    return lhs.rawValue < rhs.rawValue
  }
}

// The argument parser doesn't work in testing environments, so exclude this from testing builds.
#if !TESTING
import ArgumentParser

extension ChallengeYear: ExpressibleByArgument {
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
