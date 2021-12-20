//
//  MutableCollection+4d.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/20/21.
//

import Foundation

extension MutableCollection where Element: MutableCollection,
                                  Element.Element: MutableCollection,
                                  Element.Element.Element: MutableCollection {
  subscript(point: Point) -> Element.Element.Element.Element  {
    get {
      return self[unsafe: point.w][unsafe: point.z][unsafe: point.x][unsafe: point.y]
    }
    set {
      self[unsafe: point.w][unsafe: point.z][unsafe: point.x][unsafe: point.y] = newValue
    }
  }
}
