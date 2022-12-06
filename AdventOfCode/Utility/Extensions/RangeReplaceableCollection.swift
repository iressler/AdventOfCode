//
//  RangeReplaceableCollection.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/7/21.
//

import Foundation

// Use to make Generic extensions easier to read/write by reducing line/"where x" length
typealias MutableRangeReplaceableCollection = MutableCollection & RangeReplaceableCollection

extension RangeReplaceableCollection where Self: MutableCollection {
  mutating func grow(repeating defaultValue: Element, by count: Int = 1) {
    // Validate count.
    guard count > 0 else {
      if count < 0 {
        fatalError("Invalid count supplied")
      }
      // else count == 0, which is valid but means nothing to change.
      return
    }

    // Shortcut if empty and create a new Collection of the required size full of the default value.
    guard !isEmpty else {
      self = Self(repeating: defaultValue, count: count)
      return
    }

    // Shortcut to append/prepend if count is 1.
    if count > 1 {
      prepend(contentsOf: [Element](repeating: defaultValue, count: count))
      append(contentsOf: [Element](repeating: defaultValue, count: count))
    } else {
      prepend(defaultValue)
      append(defaultValue)
    }
  }

  mutating func shrink(by count: Int = 1) {
    // Removing elements require to collection to not be empty, so check before each removal.
    guard !isEmpty else {
      return
    }

    // If count includes all of the elements just remove everything and return.
    guard (2 * count) < self.count else {
      self.removeAll()
      return
    }

    self.removeFirst(count)
    self.removeLast(count)
  }
}

extension RangeReplaceableCollection {
  mutating func insert(_ newElement: Element, at indexOffset: Int) {
    self.insert(newElement, at: index(startIndex, offsetBy: indexOffset))
  }

  mutating func insert<C: Collection>(contentsOf newElements: C, at indexOffset: Int) where C.Element == Element {
    self.insert(contentsOf: newElements, at: index(startIndex, offsetBy: indexOffset))
  }

  mutating func prepend(_ element: Element) {
    self.insert(element, at: startIndex)
  }

  mutating func prepend<C: Collection>(contentsOf newElements: C) where C.Element == Element {
    self.insert(contentsOf: newElements, at: startIndex)
  }

  mutating func remove(at indexOffset: Int) {
    self.remove(at: index(startIndex, offsetBy: indexOffset))
  }

  mutating func removeLast(_ k: Int) {
    // If the count covers all of the elements just remove everything and return.
    guard k < count else {
      removeAll()
      return
    }
    for _ in 0..<k {
      remove(at: count-1)
    }
  }

  mutating func remove(at indexOffsets: [Int]) {
    self = Self(self.enumerated().compactMap({ indexOffsets.contains($0) ? nil : $1 }))
  }
}

// MARK: - Splitting
extension RangeReplaceableCollection {
  func splitInHalf() -> [Self] {
    let ct = self.count
    let half = index(startIndex, offsetBy: ct / 2)

    let leftSplit = self[startIndex ..< half]
    let rightSplit = self[half ..< endIndex]
    return [Self(leftSplit), Self(rightSplit)]
  }
}
