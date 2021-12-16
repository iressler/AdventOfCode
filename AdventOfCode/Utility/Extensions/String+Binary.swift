//
//  String+Binary.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/16/21.
//

import Foundation

extension String {
  func toBinary(radix: Int = 16) -> String? {
    var binary = ""

    // Because the number may be too big for Int, convert 1 character at a time.
    for char in self {
      guard let charBinary = char.toBinary(radix: radix) else {
        print("Failed to convert \(char) to binary.")
        return nil
      }

      binary.append(charBinary)
    }

    return binary
  }
}

extension Character {
  func toBinary(radix: Int = 16) -> String? {
    guard let base10 = Int(String(self), radix: radix) else {
      return nil
    }

    let minimalBinary = String(base10, radix: 2)

    return String(repeating: "0", count: 4-minimalBinary.count) + minimalBinary
  }
}
