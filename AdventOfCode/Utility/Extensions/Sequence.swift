//
//  Sequence.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/16/22.
//

import Foundation

extension Sequence {
  func groups(size: Int = 2) -> AnyIterator<[Element]> {
    return AnyIterator(sequence(state: makeIterator(), next: { iter in
      var elements = [Element]()
      while let nextElement = iter.next() {
        elements.append(nextElement)
        if elements.count == size {
          break
        }
      }
      return elements.isNotEmpty ? elements : nil
    }))
  }
}
