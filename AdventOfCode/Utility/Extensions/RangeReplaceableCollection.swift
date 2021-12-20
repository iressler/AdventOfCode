//
//  RangeReplaceableCollection.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/7/21.
//

import Foundation

extension RangeReplaceableCollection {
  mutating func prepend(_ element: Element) {
    self.insert(element, at: startIndex)
  }
}

extension RangeReplaceableCollection where Index == Int {
  mutating func remove(at indicesToRemove: [Int]) {
    self = Self(self.enumerated().compactMap({ indicesToRemove.contains($0) ? nil : $1 }))
extension RangeReplaceableCollection {
  mutating func insert(_ newValue: Element, at indexOffset: Int) {
    self.insert(newValue, at: index(startIndex, offsetBy: indexOffset))
  }
  mutating func remove(at indexOffset: Int) {
    self.remove(at: index(startIndex, offsetBy: indexOffset))
  }

  mutating func remove(at indexOffsets: [Int]) {
    self = Self(self.enumerated().compactMap({ indexOffsets.contains($0) ? nil : $1 }))
  }
}
