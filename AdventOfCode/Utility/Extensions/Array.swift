//
//  Array.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/7/21.
//

import Foundation

extension Array {
  subscript(wrapping index: Index) -> Element {
    return self[((index % count) + count) % count]
  }
}

extension Array where Element: RangeReplaceableCollection {
  init(repeating element: Element.Element, x: Int, y: Int) {
    self.init(repeating: Element.init(repeating: element, count: y), count: x)
  }
}
