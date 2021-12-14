//
//  Point.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/7/21.
//

import Foundation

struct Point {
  let x: Int
  let y: Int
}

// Allow row/column to be aliases for x/y.
extension Point {
  var row: Int { x }
  var column: Int { y }

  init(row: Int, column: Int) {
    self.init(x: row, y: column)
  }
}

extension Point: Hashable {
}

extension Point: ExpressibleByStringLiteral {
  init(stringLiteral value: String) {
    self.init(pointString: value)!
  }

  init?(pointString: String, rotated: Bool = false) {
    let coordinates = pointString.components(separatedBy: ",")
    guard coordinates.count == 2,
          let firstStr = coordinates.first,
          let first = Int(firstStr),
          let lastStr = coordinates.last,
          let last = Int(lastStr)
    else {
      return nil
    }
    if rotated {
      self.init(x: last, y: first)
    } else {
      self.init(x: first, y: last)
    }
  }
}

extension Point: CustomStringConvertible {
  var description: String {
    return "\(row),\(column)"
  }
}
