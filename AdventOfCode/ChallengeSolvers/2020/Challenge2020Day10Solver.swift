//
//  Challenge2020Day10Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2020Day10Solver: ChallengeSolver {
  static let defaultValue1 = """
16
10
15
5
1
11
7
19
6
12
4
"""
  static let defaultValue = """
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let lines = inputComponents(from: input).map({ Int($0)! })
    switch challengeNumber {
    case .one:
      return getAnswer1(given: lines)
    case .two:
      return getAnswer2(given: lines)
    }
  }

  static private func getAnswer1(given joltages: [Int]) -> String {
    var sorted = joltages.sorted()
    // The outlet provides 0 joltages.
    sorted.prepend(0)
    // Start with a gap at index 3 because the laptop is assumed to take 3 more than the highest joltage.
    // Have an extra leading 0 to make the (already complex) math simpler.
    var gaps = [0, 0, 0, 1]

    for i in 1..<sorted.count {
      gaps[sorted[i] - sorted[i-1]] += 1
    }

    return "\(gaps[1] * gaps[3])"
  }

  // Must cache, otherwise have to recalculate too many numbers too many times.
  static private var chainsFromJoltage = [Int: Int]()

  // assumes joltages are sorted.
  static private func numberOfPossibleChains(startingAt index: Int, in joltages: [Int]) -> Int {
    let startingJoltage = joltages[index]

    if let chainCount = chainsFromJoltage[startingJoltage] {
      return chainCount
    }

    guard index < (joltages.count - 1) else {
      chainsFromJoltage[startingJoltage] = 1
      return 1
    }

    var chainCounts = 0
    for newIndex in (index+1)...(index+3) {
      guard newIndex < joltages.count && joltages[newIndex] - joltages[index] <= 3 else {
        continue
      }
      chainCounts += numberOfPossibleChains(startingAt: newIndex, in: joltages)
    }
    chainsFromJoltage[startingJoltage] = chainCounts
    return chainCounts
  }

  static private func getAnswer2(given joltages: [Int]) -> String {
    var sorted = joltages.sorted()
    // The outlet provides 0 joltages.
    sorted.prepend(0)

    return "\(numberOfPossibleChains(startingAt: 0, in: sorted))"
  }
}
