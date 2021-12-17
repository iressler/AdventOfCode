//
//  RangeReplaceableCollection.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/7/21.
//

import Foundation

extension RangeReplaceableCollection where Element: RangeReplaceableCollection {
  init(repeating element: Element.Element, x: Int, y: Int) {
    self.init(repeating: Element.init(repeating: element, count: y), count: x)
  }
}

extension RangeReplaceableCollection where Index == Int {
  mutating func remove(at indicesToRemove: [Int]) {
    self = Self(self.enumerated().compactMap({ indicesToRemove.contains($0) ? nil : $1 }))
  }
}
