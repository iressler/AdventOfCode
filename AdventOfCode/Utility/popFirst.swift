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

  mutating func popFirst(_ k: Int) -> [Element] {
    guard k > 0, k <= count else {
      return []
    }
    let elements = Array(self[startIndex..<index(startIndex, offsetBy: count)])
    self.removeFirst(k)
    return elements
  }

  mutating func popLast() -> Element? {
    guard !isEmpty else {
      return nil
    }
    return removeLast()
  }

  mutating func popLast(_ k: Int) -> [Element] {
    guard k > 0, k <= count else {
      return []
    }
    let elements = Array(self[index(endIndex, offsetBy: -1*k)..<endIndex])
    self.removeLast(k)
    return elements
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

  mutating func popFirst(_ k: Int) -> [Element] {
    guard k > 0, k <= count else {
      return []
    }
    let elements = Array(self[startIndex..<index(startIndex, offsetBy: count)])
    self.removeFirst(k)
    return elements
  }

  mutating func popLast() -> Element? {
    guard !isEmpty else {
      return nil
    }
    return removeLast()
  }

  mutating func popLast(_ k: Int) -> [Element] {
    guard k > 0, k <= count else {
      return []
    }
    let elements = Array(self[index(endIndex, offsetBy: -1*k)..<endIndex])
    self.removeLast(k)
    return elements
  }
}
