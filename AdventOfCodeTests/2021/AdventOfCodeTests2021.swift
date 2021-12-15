//
//  AdventOfCodeTests2020.swift
//  AdventOfCodeTests
//
//  Created by Isaac Ressler on 12/14/21.
//

import XCTest

class AdventOfCodeTests2021: AdventOfCodeTests {
  override class var year: ChallengeYear {
    return .twentyTwentyOne
  }

  override class var input: [ChallengeDay: [ChallengeNumber: String]] {
    return inputs
  }

  override class var solution: [[String]] {
    return solutions
  }
}
