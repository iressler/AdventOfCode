//
//  AdventOfCodeTests.swift
//  AdventOfCodeTests
//
//  Created by Isaac Ressler on 12/14/21.
//

import XCTest

class AdventOfCodeTests: XCTestCase {
  class var year: ChallengeYear {
    fatalError("Must be implemented by subclass")
  }

  class var input: [ChallengeDay: [ChallengeNumber: String]] {
    fatalError("Must be implemented by subclass")
  }

  class var solution: [[String]] {
    fatalError("Must be implemented by subclass")
  }

  private static func input(day: ChallengeDay, number: ChallengeNumber) -> String {
    return input[day]?[number] ?? ""
  }

  private static func solutions(day: ChallengeDay, number: ChallengeNumber) -> String {
    return solution[day.rawValue-1][number.rawValue-1]
  }

  func test(day: ChallengeDay, number: ChallengeNumber, input: String? = nil) -> (String, String) {
    let challenge = Challenge(year: Self.year, day: day, number: number)
    let solution = Self.solutions(day: day, number: number)
    return (challenge.solution(for: input ?? Self.input(day: day, number: number)), solution)
  }

  func testDay1() throws {
    let challengeOneResults = test(day: .one, number: .one)
    XCTAssertEqual(challengeOneResults.0, challengeOneResults.1)
    let challengeTwoResults = test(day: .one, number: .two)
    XCTAssertEqual(challengeTwoResults.0, challengeTwoResults.1)
  }

  func testDay2() throws {
    let challengeOneResults = test(day: .two, number: .one)
    XCTAssertEqual(challengeOneResults.0, challengeOneResults.1)
    let challengeTwoResults = test(day: .two, number: .two)
    XCTAssertEqual(challengeTwoResults.0, challengeTwoResults.1)
  }

  func testDay3() throws {
    let challengeOneResults = test(day: .three, number: .one)
    XCTAssertEqual(challengeOneResults.0, challengeOneResults.1)
    let challengeTwoResults = test(day: .three, number: .two)
    XCTAssertEqual(challengeTwoResults.0, challengeTwoResults.1)
  }

  func testDay4() throws {
    let challengeOneResults = test(day: .four, number: .one)
    XCTAssertEqual(challengeOneResults.0, challengeOneResults.1)
    let challengeTwoResults = test(day: .four, number: .two)
    XCTAssertEqual(challengeTwoResults.0, challengeTwoResults.1)
  }

  func testDay5() throws {
    let challengeOneResults = test(day: .five, number: .one)
    XCTAssertEqual(challengeOneResults.0, challengeOneResults.1)
    let challengeTwoResults = test(day: .five, number: .two)
    XCTAssertEqual(challengeTwoResults.0, challengeTwoResults.1)
  }

  func testDay6() throws {
    let challengeOneResults = test(day: .six, number: .one)
    XCTAssertEqual(challengeOneResults.0, challengeOneResults.1)
    let challengeTwoResults = test(day: .six, number: .two)
    XCTAssertEqual(challengeTwoResults.0, challengeTwoResults.1)
  }

  func testDay7() throws {
    let challengeOneResults = test(day: .seven, number: .one)
    XCTAssertEqual(challengeOneResults.0, challengeOneResults.1)
    let challengeTwoResults = test(day: .seven, number: .two)
    XCTAssertEqual(challengeTwoResults.0, challengeTwoResults.1)
  }

  func testDay8() throws {
    let challengeOneResults = test(day: .eight, number: .one)
    XCTAssertEqual(challengeOneResults.0, challengeOneResults.1)
    let challengeTwoResults = test(day: .eight, number: .two)
    XCTAssertEqual(challengeTwoResults.0, challengeTwoResults.1)
  }

  func testDay9() throws {
    let challengeOneResults = test(day: .nine, number: .one)
    XCTAssertEqual(challengeOneResults.0, challengeOneResults.1)
    let challengeTwoResults = test(day: .nine, number: .two)
    XCTAssertEqual(challengeTwoResults.0, challengeTwoResults.1)
  }

  func testDay10() throws {
    let challengeOneResults = test(day: .ten, number: .one)
    XCTAssertEqual(challengeOneResults.0, challengeOneResults.1)
    let challengeTwoResults = test(day: .ten, number: .two)
    XCTAssertEqual(challengeTwoResults.0, challengeTwoResults.1)
  }

  func testDay11() throws {
    let challengeOneResults = test(day: .eleven, number: .one)
    XCTAssertEqual(challengeOneResults.0, challengeOneResults.1)
    let challengeTwoResults = test(day: .eleven, number: .two)
    XCTAssertEqual(challengeTwoResults.0, challengeTwoResults.1)
  }

  func testDay12() throws {
    let challengeOneResults = test(day: .twelve, number: .one)
    XCTAssertEqual(challengeOneResults.0, challengeOneResults.1)
    let challengeTwoResults = test(day: .twelve, number: .two)
    XCTAssertEqual(challengeTwoResults.0, challengeTwoResults.1)
  }

  func testDay13() throws {
    let challengeOneResults = test(day: .thirteen, number: .one)
    XCTAssertEqual(challengeOneResults.0, challengeOneResults.1)
    let challengeTwoResults = test(day: .thirteen, number: .two)
    XCTAssertEqual(challengeTwoResults.0, challengeTwoResults.1)
  }

  func testDay14() throws {
    let challengeOneResults = test(day: .fourteen, number: .one)
    XCTAssertEqual(challengeOneResults.0, challengeOneResults.1)
    let challengeTwoResults = test(day: .fourteen, number: .two)
    XCTAssertEqual(challengeTwoResults.0, challengeTwoResults.1)
  }

  func testDay15() throws {
    let challengeOneResults = test(day: .fifteen, number: .one)
    XCTAssertEqual(challengeOneResults.0, challengeOneResults.1)
    let challengeTwoResults = test(day: .fifteen, number: .two)
    XCTAssertEqual(challengeTwoResults.0, challengeTwoResults.1)
  }

  func testDay16() throws {
    let challengeOneResults = test(day: .sixteen, number: .one)
    XCTAssertEqual(challengeOneResults.0, challengeOneResults.1)
    let challengeTwoResults = test(day: .sixteen, number: .two)
    XCTAssertEqual(challengeTwoResults.0, challengeTwoResults.1)
  }

  func testDay17() throws {
    let challengeOneResults = test(day: .seventeen, number: .one)
    XCTAssertEqual(challengeOneResults.0, challengeOneResults.1)
    let challengeTwoResults = test(day: .seventeen, number: .two)
    XCTAssertEqual(challengeTwoResults.0, challengeTwoResults.1)
  }

  func testDay18() throws {
    let challengeOneResults = test(day: .eighteen, number: .one)
    XCTAssertEqual(challengeOneResults.0, challengeOneResults.1)
    let challengeTwoResults = test(day: .eighteen, number: .two)
    XCTAssertEqual(challengeTwoResults.0, challengeTwoResults.1)
  }

  func testDay19() throws {
    let challengeOneResults = test(day: .nineteen, number: .one)
    XCTAssertEqual(challengeOneResults.0, challengeOneResults.1)
    let challengeTwoResults = test(day: .nineteen, number: .two)
    XCTAssertEqual(challengeTwoResults.0, challengeTwoResults.1)
  }

  func testDay20() throws {
    let challengeOneResults = test(day: .twenty, number: .one)
    XCTAssertEqual(challengeOneResults.0, challengeOneResults.1)
    let challengeTwoResults = test(day: .twenty, number: .two)
    XCTAssertEqual(challengeTwoResults.0, challengeTwoResults.1)
  }

  func testDay21() throws {
    let challengeOneResults = test(day: .twentyOne, number: .one)
    XCTAssertEqual(challengeOneResults.0, challengeOneResults.1)
    let challengeTwoResults = test(day: .twentyOne, number: .two)
    XCTAssertEqual(challengeTwoResults.0, challengeTwoResults.1)
  }

  func testDay22() throws {
    let challengeOneResults = test(day: .twentyTwo, number: .one)
    XCTAssertEqual(challengeOneResults.0, challengeOneResults.1)
    let challengeTwoResults = test(day: .twentyTwo, number: .two)
    XCTAssertEqual(challengeTwoResults.0, challengeTwoResults.1)
  }

  func testDay23() throws {
    let challengeOneResults = test(day: .twentyThree, number: .one)
    XCTAssertEqual(challengeOneResults.0, challengeOneResults.1)
    let challengeTwoResults = test(day: .twentyThree, number: .two)
    XCTAssertEqual(challengeTwoResults.0, challengeTwoResults.1)
  }

  func testDay24() throws {
    let challengeOneResults = test(day: .twentyFour, number: .one)
    XCTAssertEqual(challengeOneResults.0, challengeOneResults.1)
    let challengeTwoResults = test(day: .twentyFour, number: .two)
    XCTAssertEqual(challengeTwoResults.0, challengeTwoResults.1)
  }

  func testDay25() throws {
    let challengeOneResults = test(day: .twentyFive, number: .one)
    XCTAssertEqual(challengeOneResults.0, challengeOneResults.1)
    let challengeTwoResults = test(day: .twentyFive, number: .two)
    XCTAssertEqual(challengeTwoResults.0, challengeTwoResults.1)
  }
}
