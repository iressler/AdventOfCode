//
//  Collection.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/7/21.
//

import Foundation

extension Collection where Element: AdditiveArithmetic {
  func sum() -> Element {
    self.reduce(into: Element.zero, { $0 += $1 })
  }
}

extension Collection where Element: Numeric {
  func product() -> Element {
    self.reduce(into: .zero + 1, { $0 *= $1 })
  }
}

// Could probably generalize this to Index: Numeric (or AdditiveArithmetic?), but that's more complex than necessary.
extension Collection where Index == Int {
  subscript(wrapping index: Index) -> Element {
    return self[index % count]
  }
}
