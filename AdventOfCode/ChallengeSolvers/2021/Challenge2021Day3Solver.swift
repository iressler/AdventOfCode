//
//  ChallengeDay3Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/2/21.
//

import Foundation

private extension String {
  // from: https://kalkicode.com/binary-to-decimal-conversion-in-swift
  func binaryToDecimal() -> Int {
    let number = Array(self);
    // Assuming that number contains 0,1s
    // Used to store result
    var result: Int = 0;
    var bit: Int = 0;
    var n: Int = number.count - 1;
    // Display Binary number
//    print("Binary : ", num, terminator: "");
    // Execute given number in reverse order
    while (n >= 0)
    {
      if (number[n] == "1")
      {
        // When get binary 1
        result += (1 << (bit));
      }
      n = n - 1;
      // Count number of bits
      bit += 1;
    }
    return result
//    // Display decimal result
//    print("  Decimal :  ",result);
  }
}

struct Challenge2021Day3Solver: ChallengeSolver {
  static let defaultValue: String = "00100 11110 10110 10111 10101 01111 00111 11100 10000 11001 00010 01010"

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let binary = components(from: input)
      .filter({ !$0.isEmpty })

    switch challengeNumber {
    case .one:
      return getAnswer1(given: binary)
    case .two:
      return getAnswer2(given: binary)
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
    return "\(gamma.binaryToDecimal() * epsilon.binaryToDecimal())"
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
      if num[num.index(num.startIndex, offsetBy: i)] == "0" {
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

    return "\(ogr.binaryToDecimal() * c02.binaryToDecimal())"
  }
}
