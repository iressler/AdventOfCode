//
//  MutableCollection.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/16/21.
//

import Foundation

extension MutableCollection {
  mutating func modifyElement(at index: Index, using modifier: (inout Element) -> Void) {
    var element = self[index]
    modifier(&element)
    self[index] = element
  }

  mutating func modifyElement(at index: Index, using modifier: (Element) -> Element) {
    self[index] = modifier(self[index])
  }

  subscript(unsafe indexOffset: Int) -> Element {
    get {
      return self[index(startIndex, offsetBy: indexOffset)]
    }
    set {
      self[index(startIndex, offsetBy: indexOffset)] = newValue
    }
  }
}
