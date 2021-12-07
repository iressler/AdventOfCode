//
//  Challenge2020Day4Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2020Day6Solver: ChallengeSolver {
  static let defaultValue = """
abc

a
b
c

ab
ac

a
a
a
a

b
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let groupAnswers = groupedInputComponents(from: input)
//    print(groupAnswers)
    switch challengeNumber {
    case .one:
      return getAnswer1(given: groupAnswers)
    case .two:
      return getAnswer2(given: groupAnswers)
    }
  }

  static private func getAnswer1(given allAnswers: [[String]]) -> String {
    var count = 0

    var currAnswers = Set<String.Element>()
    for groupAnswers in allAnswers {
      for individualsAnswer in groupAnswers {
        currAnswers.insert(contentsOf: Array(individualsAnswer))
      }
//      print("Found \(currAnswers.count) unique answers: \(currAnswers)")
      count += currAnswers.count
      currAnswers.removeAll()
    }
    return "\(count)"
  }

  static private func getAnswer2(given allAnswers: [[String]]) -> String {
    var count = 0

    var currAnswers = [String.Element: Int]()

    for groupAnswers in allAnswers {
      let groupCount = groupAnswers.count
      for individualsAnswer in groupAnswers {
        for answer in individualsAnswer {
          currAnswers.incrementValue(for: answer)
        }
      }

      count += currAnswers.compactMap({ $1 == groupCount }).filter({ $0 }).count
      currAnswers.removeAll()
    }
    return "\(count)"
  }
}
