//
//  AdventOfCodeTests2020.swift
//  AdventOfCodeTests
//
//  Created by Isaac Ressler on 12/14/21.
//

import XCTest

class AdventOfCodeTests2020: AdventOfCodeTests {
  override class var year: ChallengeYear {
    return .twentyTwenty
  }

  override class var input: [ChallengeDay: [ChallengeNumber: String]] {
    return inputs
  }

  override class var solution: [[String]] {
    return solutions
  }

  override func testDay4() throws {
    let challengeOneResults = test(day: .four, number: .one)
    XCTAssertEqual(challengeOneResults.0, challengeOneResults.1)
    let challengeTwoValidResults = test(day: .four, number: .two, input: "valid")
    XCTAssertEqual(challengeTwoValidResults.0, "4")
    let challengeTwoInvalidResults = test(day: .four, number: .two, input: "invalid")
    XCTAssertEqual(challengeTwoInvalidResults.0, "0")
  }
}
