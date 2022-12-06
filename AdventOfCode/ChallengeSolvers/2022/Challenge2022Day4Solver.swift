//
//  Challenge2022Day4Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/4/21.
//

import Foundation

private struct Section {
  let range: ClosedRange<Int>

  init(_ range: ClosedRange<Int>) {
    self.range = range
  }

  init?(lowerBound: Int, upperBound: Int) {
    guard lowerBound <= upperBound else {
      print("\(lowerBound) is not less than \(upperBound)")
      return nil
    }
    self.init(lowerBound...upperBound)
  }

  init?(rangeString: String) {
    let bounds = rangeString.components(separatedBy: "-")
    guard let lowerBound = Int(bounds[0]), let upperBound = Int(bounds[1]) else {
      print("Did not get valid bounds: \(bounds)")
      return nil
    }
    self.init(lowerBound: lowerBound, upperBound: upperBound)
  }

  func fullyContains(_ other: Section) -> Bool {
    return self.range.contains(other.range.lowerBound) && self.range.contains(other.range.upperBound)
  }

  func overlaps(with other: Section) -> Bool {
    return self.range.contains(other.range.lowerBound) || self.range.contains(other.range.upperBound) ||
    other.range.contains(self.range.lowerBound) || other.range.contains(self.range.upperBound)
  }
}

struct Challenge2022Day4Solver: ChallengeSolver {
  static let defaultValue = """
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let lines = inputComponents(from: input).map({ line in
      let rangeStrings = line.components(separatedBy: ",")
      return (Section(rangeString: rangeStrings[0])!, Section(rangeString: rangeStrings[1])!)
    })
    switch challengeNumber {
    case .one:
      return getAnswer1(given: lines)
    case .two:
      return getAnswer2(given: lines)
    }
  }

  static private func range(from input: String) -> ClosedRange<Int> {
    let bounds = input.components(separatedBy: "-")
    let lowerBound = Int(bounds[0])!
    let upperBound = Int(bounds[1])!
    return lowerBound...upperBound
  }

  static private func getAnswer1(given sections: [(Section, Section)]) -> String {
    var fullyContainedSections = 0
    for (firstSection, secondSection) in sections {
      if firstSection.fullyContains(secondSection) || secondSection.fullyContains(firstSection) {
        fullyContainedSections += 1
      }
    }
    return "\(fullyContainedSections)"
  }

  static private func getAnswer2(given sections: [(Section, Section)]) -> String {
    var overlappingSections = 0
    for (firstSection, secondSection) in sections {

      if firstSection.overlaps(with: secondSection) {
        overlappingSections += 1
      }
    }
    return "\(overlappingSections)"
  }
}
