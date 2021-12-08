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
