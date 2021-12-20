//
//  Collection+4d.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/15/21.
//

import Foundation

// MARK: - Field Description
// 4d collections must be a W indexed Collection of Z indexed collections of X,Y indexed collections.
extension Collection where Element: Collection, Element.Element: Collection, Element.Element.Element: Collection {
  func fieldDescription(separator: String = " ", xyRotated: Bool = false) -> String {
    var result = ""
    let fieldDescriptions = self.map({ $0.fieldDescription(separator: separator, xyRotated: xyRotated) })
    for fieldIndex in 0..<fieldDescriptions.count {
      result.append("\nw: \(fieldIndex):\n\(fieldDescriptions[fieldIndex])")
    }
    return result
  }
}

// MARK: - Adjacency
extension Collection where Element: Collection, Element.Element: Collection, Element.Element.Element: Collection {
  private func pointsAdjacent(to point: Point, atW w: Int, includeDiagonals: Bool, includeCenterPoint: Bool) -> [Point?] {
    // If the x does not match the point, anything adjacent to z is diagonal.
    let wMatchesPoint = (point.w == w)

    // If z matches the point need to use includeCenterPoint to determine whether to include the center point.
    // Otherwise always include it because it must be adjacent to the point.
    let includePoint: Bool = wMatchesPoint ? includeCenterPoint : true

    let adjacentPoints: [Point?]

    // If z does not match the point and diagonals are not included then only need to check the Point (z, point.x, point.y).
    if !wMatchesPoint && !includeDiagonals {
      // The points are always diagonal to the point here, so do not need to check includeCenterPoint.
      // 26 because there are 26 adjacent points in the z, x, y coordinate space, which is what this is effectively reproducing.
      let adjacentPointCount = 26
      var tempAdjacentPoints = [Point?](repeating: nil, count: adjacentPointCount+1)
      var newPoint: Point? = point
      if self[unsafe: w].count > point.w {
        newPoint!.w = w
      } else {
        newPoint = nil
      }
      tempAdjacentPoints[adjacentPointCount/2] = newPoint
      adjacentPoints = tempAdjacentPoints
      // Else including points beside x (whether diagonal or adjacent to the point).
    } else {
      adjacentPoints = self[unsafe: w].pointsAdjacent(to: point,
                                                      includeDiagonals: includeDiagonals,
                                                      includePoint: includePoint)
        .map { (newPoint: Point?) -> Point? in
          guard var newPoint = newPoint else {
            return nil
          }

          newPoint.w = w
          return newPoint
        }
    }

    return adjacentPoints
  }

  func pointsAdjacent(to point: Point, includeDiagonals: Bool = false, includePoint: Bool = false) -> [Point?] {
    var adjacentPoints = [Point?]()

    // Always pass true for includeCenterPoint in w(+/-)1 because that will be a point adjacent to the provided point.
    if point.w > 0 {
      adjacentPoints.append(contentsOf: pointsAdjacent(to: point,
                                                       atW: point.w-1,
                                                       includeDiagonals: includeDiagonals,
                                                       includeCenterPoint: true))
    } else {
      adjacentPoints.append(contentsOf: [Point?](repeating: nil, count: 3))
    }

    adjacentPoints.append(contentsOf: pointsAdjacent(to: point,
                                                     atW: point.w,
                                                     includeDiagonals: includeDiagonals,
                                                     includeCenterPoint: includePoint))

    if (point.w+1) < count {
      adjacentPoints.append(contentsOf: pointsAdjacent(to: point,
                                                       atW: point.w+1,
                                                       includeDiagonals: includeDiagonals,
                                                       includeCenterPoint: true))
    } else {
      adjacentPoints.append(contentsOf: [Point?](repeating: nil, count: 3))
    }

    return adjacentPoints
  }

  func pointsAdjacent(to point: Point, includeDiagonals: Bool = false, includePoint: Bool = false) -> [Point] {
    return pointsAdjacent(to: point, includeDiagonals: includeDiagonals).compactMap()
  }
}

// MARK: -
extension Collection where Element: Collection, Element.Element: Collection, Element.Element.Element: Collection {
  // Supports non mutable collections, e.g. let bindings?
  subscript(point: Point) -> Element.Element.Element.Element  {
    return self[unsafe: point.w][unsafe: point.z][unsafe: point.x][unsafe: point.y]
  }

  func contains(point: Point) -> Bool {
    return point.z >= 0 && point.w >= 0 && point.x >= 0 && point.y >= 0 && point.z < count &&
    point.w < self[unsafe: point.z].count && point.x < self[unsafe: point.z][unsafe: point.w].count &&
    point.y < self[unsafe: point.z][unsafe: point.w][unsafe: point.x].count
  }
}
