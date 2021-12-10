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

  init?(pointString: String) {
    let coordinates = pointString.components(separatedBy: ",")
    guard coordinates.count == 2,
          let xStr = coordinates.last,
          let x = Int(xStr),
          let yStr = coordinates.first,
          let y = Int(yStr)
    else {
      return nil
    }
    self.init(x: x, y: y)
  }
}

extension Point: CustomStringConvertible {
  var description: String {
    return "\(row),\(column)"
  }
}
