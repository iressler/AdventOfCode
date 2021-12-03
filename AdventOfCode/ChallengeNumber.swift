//
//  ChallengeNumber.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/2/21.
//

import Foundation
import ArgumentParser

enum ChallengeNumber: Int, CaseIterable {
  case one = 1
  case two = 2
}

extension ChallengeNumber: Comparable {
  static func < (lhs: ChallengeNumber, rhs: ChallengeNumber) -> Bool {
    return lhs.rawValue < rhs.rawValue
  }
}

extension ChallengeNumber: ExpressibleByArgument {
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

