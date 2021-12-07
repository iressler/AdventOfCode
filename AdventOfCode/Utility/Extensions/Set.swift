//
//  Set.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/7/21.
//

import Foundation

extension Set {
  mutating func insert<C: Collection>(contentsOf other: C) where C.Element == Element {
    for element in other {
      self.insert(element)
    }
  }
}
