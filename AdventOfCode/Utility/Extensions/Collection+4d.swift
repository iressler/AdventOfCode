//
//  Collection+4d.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/15/21.
//

import Foundation

// 4d collections must be a W indexed Collection of Z indexed collections of X,Y indexed collections.
extension Collection where Index == Int,
                           Element: Collection, Element.Index == Index,
                           Element.Element: Collection, Element.Element.Index == Index,
                           Element.Element.Element: Collection, Element.Element.Element.Index == Index {
  func fieldDescription(separator: String = " ", xyRotated: Bool = false) -> String {
    var result = ""
    let fieldDescriptions = self.map({ $0.fieldDescription(separator: separator, xyRotated: xyRotated) })
    for fieldIndex in 0..<fieldDescriptions.count {
      result.append("\nw: \(fieldIndex):\n\(fieldDescriptions[fieldIndex])")
    }
    return result
  }

  // Supports non mutable collections, e.g. let bindings?
  subscript(point: Point) -> Element.Element.Element.Element  {
    return self[point.w][point.z][point.x][point.y]
  }
}

extension MutableCollection where Index == Int,
                                  Element: MutableCollection, Element.Index == Index,
                                  Element.Element: MutableCollection, Element.Element.Index == Index,
                                  Element.Element.Element: MutableCollection, Element.Element.Element.Index == Index {
  subscript(point: Point) -> Element.Element.Element.Element  {
    get {
      return self[point.w][point.z][point.x][point.y]
    }
    set {
      self[point.w][point.z][point.x][point.y] = newValue
    }
  }

  func pointsAdjacent(to point: Point, includeDiagonals: Bool = false) -> [Point] {
    var adjacentPoints = self[point.w].pointsAdjacent(to: point, includeDiagonals: includeDiagonals)

    if point.w > 0 {
      let newPoint = Point(x: point.x, y: point.y, z: point.z, w: point.w-1)
      adjacentPoints.append(newPoint)
      if includeDiagonals {
        adjacentPoints.append(contentsOf: self[newPoint.w].pointsAdjacent(to: newPoint, includeDiagonals: true))
      }
    }

    if point.w < (count-1) {
      let newPoint = Point(x: point.x, y: point.y, z: point.z, w:point.w+1)
      adjacentPoints.append(newPoint)
      if includeDiagonals {
        adjacentPoints.append(contentsOf: self[newPoint.w].pointsAdjacent(to: newPoint, includeDiagonals: true))
      }
    }

    return adjacentPoints
  }
}
