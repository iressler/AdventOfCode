//
//  Array+3d.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/15/21.
//

import Foundation

// 3d collections must be a Z indexed group of X,Y indexed collections.
extension Collection where Index == Int,
                           Element: Collection, Element.Index == Index,
                           Element.Element: Collection, Element.Element.Index == Index {
  func fieldDescription(separator: String = " ", xyRotated: Bool = false) -> String {
    var result = ""
    let fieldDescriptions = self.map({ $0.fieldDescription(separator: separator, rotated: xyRotated) })
    for fieldIndex in 0..<fieldDescriptions.count {
      result.append("z: \n\(fieldIndex):\n\(fieldDescriptions[fieldIndex])")
    }
    return result
  }

// Supports non mutable collections, e.g. let bindings?
  subscript(point: Point) -> Element.Element.Element  {
    return self[point.z][point.x][point.y]
  }
}

extension MutableCollection where Index == Int,
                                  Element: MutableCollection, Element.Index == Index,
                                  Element.Element: MutableCollection, Element.Element.Index == Index {
  subscript(point: Point) -> Element.Element.Element  {
    get {
      return self[point.z][point.x][point.y]
    }
    set {
      self[point.z][point.x][point.y] = newValue
    }
  }

  func pointsAdjacent(to point: Point, includeDiagonals: Bool = false) -> [Point] {
    var adjacentPoints = self[point.z].pointsAdjacent(to: point, includeDiagonals: includeDiagonals)

    if point.z > 0 {
      let newPoint = Point(x: point.x, y: point.y, z: point.z-1, w: point.w)
      adjacentPoints.append(newPoint)
      if includeDiagonals {
        adjacentPoints.append(contentsOf: self[newPoint.z].pointsAdjacent(to: newPoint, includeDiagonals: true))
      }
    }

    if point.z < (count-1) {
      let newPoint = Point(x: point.x, y: point.y, z: point.z+1, w: point.w)
      adjacentPoints.append(newPoint)
      if includeDiagonals {
        adjacentPoints.append(contentsOf: self[newPoint.z].pointsAdjacent(to: newPoint, includeDiagonals: true))
      }
    }

    return adjacentPoints
  }
}
