//
//  Utility.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/2/21.
//

import Foundation

extension String {
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

  // There must be a better way to do this.
  func enumeratedStrings() -> EnumeratedSequence<[String]> {
    return Array(self).map({ String($0) }).enumerated()
  }

  func alphabetized() -> String {
    return String(sorted())
  }

  mutating func alphabetize() {
    self = alphabetized()
  }
}
