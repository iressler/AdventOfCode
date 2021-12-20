//
//  MutableCollection+2d.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/20/21.
//

import Foundation

extension MutableCollection where Element: MutableCollection {
  subscript(point: Point) -> Element.Element {
    get {
      return self[unsafe: point.x][unsafe: point.y]
    }
    set {
      self[unsafe: point.x][unsafe: point.y] = newValue
    }
  }
}
