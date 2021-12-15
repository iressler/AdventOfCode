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
  let z: Int

  // 2 complete initializers because I'm not sure how to guarantee one doesn't infinite loop instead of calling the other.
  init(x: Int, y: Int, z: Int = -1) {
    self.x = x
    self.y = y
    self.z = z
  }

  init(x: Int, y: Int, z: Int? = nil) {
    self.x = x
    self.y = y
    self.z = z ?? -1
  }
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

  // pointString must be formatted "x,y" or "x,y,z", or either of those reversed if rotated is true.
  init?(pointString: String, rotated: Bool = false) {
    let coordinates = pointString.components(separatedBy: ",")

    guard let first = Int(coordinates[0]), let second = Int(coordinates[1]) else {
      return nil
    }
    let third: Int?
    if coordinates.count > 2 {
      third = Int(coordinates[2])
    } else {
      third = nil
    }

    if rotated {
      if let third = third {
        self.init(x: third, y: second, z: first)
      } else {
        self.init(x: second, y: first)
      }
    } else {
      self.init(x: first, y: second, z: third)
    }
  }
}

extension Point: CustomStringConvertible {
  var description: String {
    var description = "\(x),\(y)"
    if z >= 0 {
      description += ",\(z)"
    }
    return description
  }
}
