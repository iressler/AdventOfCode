//
//  ChallengeDay3Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/2/21.
//

import Foundation

struct Challenge2021Day3Solver: ChallengeSolver {
  static let defaultValue: String = """
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let lines = inputComponents(from: input)
      .filter({ !$0.isEmpty })

    switch challengeNumber {
    case .one:
      return getAnswer1(given: lines)
    case .two:
      return getAnswer2(given: lines)
    }
  }

  static private func getAnswer1(given binary: [String]) -> String {
    var gamma = ""
    var epsilon = ""

    for i in 0..<binary.first!.count {
      let result = binaryCount(of: binary, at: i)

      if result.countOf0 > result.countOf1 {
        gamma.append("0")
        epsilon.append("1")
      } else {
        gamma.append("1")
        epsilon.append("0")
      }
    }
    return "\(Int(gamma, radix: 2)! * Int(epsilon, radix: 2)!)"
  }

  private struct BinaryCount {
    var countOf0: Int = 0
    var countOf1: Int = 0

    var maxNum: Int? {
      if countOf0 > countOf1 {
        return 0
      } else if countOf1 > countOf0 {
        return 1
      } else {
        return nil
      }
    }

    var minNum: Int? {
      if let maxNum = self.maxNum {
        return (maxNum == 1) ? 0 : 1
      } else {
        return nil
      }
    }
  }

    static private func binaryCount(of binary: [String], at i: Int) -> BinaryCount {
    var result = BinaryCount()

    for num in binary {
      if num[unsafeCharacter: i] == "0" {
        result.countOf0 += 1
      } else {
        result.countOf1 += 1
      }
    }
      return result
  }

  static private func getAnswer2(given binary: [String]) -> String {
    var ogr = ""
    var c02 = ""

    let updateOGR = { (result: BinaryCount) in
      guard ogr.count < binary.first!.count else {
        return
      }

      ogr += "\(result.maxNum ?? 1)"
      let filteredBinary = binary.filter({ $0.hasPrefix(ogr) })
      if filteredBinary.count == 1 {
        ogr = filteredBinary.first!
      }
    }

    let updateC02 = { (result: BinaryCount) in
      guard c02.count < binary.first!.count else {
        return
      }

      c02 += "\(result.minNum ?? 0)"
      let filteredBinary = binary.filter({ $0.hasPrefix(c02) })
      if filteredBinary.count == 1 {
        c02 = filteredBinary.first!
      }
    }

    for i in 0..<binary.first!.count {
      // Could probably improve this to only loop through
      if ogr.count < binary.first!.count {
        updateOGR(binaryCount(of: binary.filter({ $0.hasPrefix(ogr) }), at: i))
      }
      if c02.count < binary.first!.count {
        updateC02(binaryCount(of: binary.filter({ $0.hasPrefix(c02) }), at: i))
      }
    }

    return "\(Int(ogr, radix: 2)! * Int(c02, radix: 2)!)"
  }
}
