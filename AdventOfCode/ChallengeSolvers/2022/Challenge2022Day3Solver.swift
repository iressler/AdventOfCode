//
//  Challenge2022Day3Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/2/21.
//

import Foundation


private extension Character {
  var priorityScore: Int {
//    guard count == 1 else {
//      fatalError("Too long for a priorityScore: \(self)")
//    }
    return ["-", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
            "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
      .firstIndex(of: self)!
  }
}
struct Challenge2022Day3Solver: ChallengeSolver {
  static let defaultValue = """
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let lines = inputComponents(from: input)
    switch challengeNumber {
    case .one:
      return getAnswer1(given: lines)
    case .two:
      return getAnswer2(given: lines)
    }
  }

  static private func getAnswer1(given rucksacks: [String]) -> String {
    var priorities = 0
    for rucksack in rucksacks {
      let compartments = Array(rucksack).splitInHalf().map({ Set($0) })
      let intersection = compartments.first!.intersection(compartments.last!)
      guard intersection.count == 1 else {
        fatalError("No intersection in: \(compartments)")
      }
      priorities += intersection.first!.priorityScore
    }

    return "\(priorities)"
  }

  static private func getAnswer2(given rucksacks: [String]) -> String {
    var priorities = 0
    var index = 0
    while index < rucksacks.endIndex {
      let items = [rucksacks[index], rucksacks[index + 1], rucksacks[index + 2]].map({ Set($0) })
      let intersection = items[0].intersection(items[1]).intersection(items[2])
      guard intersection.count == 1 else {
        fatalError("No intersection in: \(items)")
      }
      priorities += intersection.first!.priorityScore
      index += 3
    }

    return "\(priorities)"
  }
}
