//
//  Collection.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/7/21.
//

import Foundation

// MARK: - Math
extension Collection where Element: AdditiveArithmetic {
  func sum() -> Element {
    self.reduce(into: .zero, { $0 += $1 })
  }
}

extension Collection where Element: Numeric {
  func product() -> Element {
    self.reduce(into: .zero + 1, { $0 *= $1 })
  }
}

// MARK: - Optional Math
extension Collection {
  func min<E: Comparable>() -> E? where Element == Optional<E> {
    return compactMap().min()
  }

  func max<E: Comparable>() -> E? where Element == Optional<E> {
    return compactMap().max()
  }

  func compactMap<E>() -> [E] where Element == Optional<E> {
    return compactMap({ $0 })
  }
}


// MARK: - Adjacency
extension Collection {
  func indicesAdjacent(to index: Int, includeIndex: Bool = false) -> [Int?] {
    var indices = [Int?](repeating: nil, count: 3)

    if index > 0 {
      indices[0] = index - 1
    }

    if index < (count - 1) {
      indices[2] = index + 1
    }

    if includeIndex {
      indices[1] = index
    } // else leave it nil.

    return indices
  }

  func indicesAdjacent(to index: Int, includeIndex: Bool = false) -> [Int] {
    return indicesAdjacent(to: index, includeIndex: includeIndex).compactMap()
  }
}

// MARK: - subscripts
extension Collection {
  subscript(unsafe indexOffset: Int) -> Element {
    return self[index(startIndex, offsetBy: indexOffset)]
  }

  // Can't generalize to anything like Numeric because it needs to divide by and add to an Int.
  subscript(wrapping index: Index) -> Element where Index == Int {
    // Song and dance of repeated remainder math and addition to handle negative indices.
    return self[((index % count) + count) % count]
  }
}

// MARK: - Convenience
extension Collection {
  var isNotEmpty: Bool {
    return !isEmpty
  }
}
