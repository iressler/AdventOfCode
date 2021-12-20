//
//  RangeReplaceableCollection+4d.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/20/21.
//

import Foundation

extension RangeReplaceableCollection where Element: RangeReplaceableCollection,
                                           Element.Element: RangeReplaceableCollection,
                                           Element.Element.Element: RangeReplaceableCollection {
  init(repeating element: Element.Element.Element.Element, w: Int, z: Int, x: Int, y: Int) {
    self.init(
      repeating: Element.init(
        repeating: Element.Element.init(
          repeating: Element.Element.Element.init(
            repeating: element,
            count: w),
          count: z),
        count: y),
      count: x
    )
  }
}

extension RangeReplaceableCollection where Self: MutableCollection,
                                           Element: MutableRangeReplaceableCollection,
                                           Element.Element: MutableRangeReplaceableCollection,
                                           Element.Element.Element: MutableRangeReplaceableCollection {
  mutating func grow(repeating defaultValue: Element.Element.Element.Element, by count: Int = 1) {
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
      self.append(Element(repeating: Element.Element(repeating: Element.Element.Element(repeating: defaultValue, count: 1), count: 1), count: 1))
      return
    }

    // Grow all sub Collections.
    for i in 0..<count {
      self[unsafe: i].grow(repeating: defaultValue)
    }

    let newElement = Element(
      repeating: Element.Element(
        repeating: Element.Element.Element(
          repeating: defaultValue,
          count: first!.first!.first!.count),
        count: first!.first!.count),
      count: first!.count)

    // Shortcut to append/prepend if count is 1.
    if count > 1 {
      prepend(contentsOf: [Element](repeating: newElement, count: count))
      append(contentsOf: [Element](repeating: newElement, count: count))
    } else {
      prepend(newElement)
      append(newElement)
    }
  }

  mutating func shrink() {
    // Removing elements require to collection to not be empty, so check before each removal.
    guard !isEmpty else {
      return
    }
    removeFirst()
    guard !isEmpty else {
      return
    }
    self.remove(at: count-1)

    // Don't need to check if empty because if so this will do nothing.
    for i in 0..<count {
      self[unsafe: i].shrink()
    }
  }
}
