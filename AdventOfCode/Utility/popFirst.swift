//
//  popFirst.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/17/21.
//

import Foundation

// Array's SubSequence is not self, so it needs a custom implementation.
extension Array {
  mutating func popFirst() -> Element? {
    guard !isEmpty else {
      return nil
    }
    return removeFirst()
  }
}

// Useful for types such as ArraySlice.
extension BidirectionalCollection where SubSequence == Self {
  mutating func popFirst() -> Element? {
    guard !isEmpty else {
      return nil
    }
    return removeFirst()
  }
}
