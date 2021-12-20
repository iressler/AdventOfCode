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

extension Collection {
  func min<E: Comparable>() -> E? where Element == Optional<E> {
    return compactMap().min()
  }

  func max<E: Comparable>() -> E? where Element == Optional<E> {
    return compactMap().max()
  }
}

// Could probably generalize this to Index: Numeric (or AdditiveArithmetic?), but that's more complex than necessary.
extension Collection where Index == Int {
  subscript(wrapping index: Index) -> Element {
    // Song and dance of repeated remainder math and addition to handle negative indices.
    return self[((index % count) + count) % count]
  }
}

extension Collection {
  func compactMap<E>() -> [E] where Element == Optional<E> {
    return compactMap({ $0 })
  }
}
