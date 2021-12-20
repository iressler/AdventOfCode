//
//  Array+2d.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/15/21.
//

import Foundation

// MARK: - Field Description.
extension Collection where Element: Collection {
  private func components(rotated: Bool) -> [[String]] {
    guard !isEmpty else {
      return []
    }

    if !rotated {
      return self.map({ $0.map({ description(for: $0) }) })
    }

    var components = [[String]](repeating: [], count: first!.count)
    for i in 0..<first!.count {
      for value in self {
        components[i].append(description(for: value[unsafe: i]))
      }
    }
    return components
  }

  private func description(for value: Element.Element) -> String {
    if let int = value as? Int {
      return int == 0 ? "." : String(describing: int)
    } else if let bool = value as? Bool {
      return bool ? "#" : "."
    } else {
      return String(describing: value)
    }
  }

  func fieldDescription(separator: String = " ", rotated: Bool = false) -> String {
    var components = self.components(rotated: rotated)

    var maxLength = 0
    var minLength = Int.max
    for row in components {
      for value in row {
        maxLength = Swift.max(maxLength, value.count)
        minLength = Swift.min(minLength, value.count)
      }
    }

    // If there is any difference in value lengths add padding to make them consistent.
    if minLength != maxLength {
      for x in 0..<components.count {
        for y in 0..<components[x].count {
          var value = components[x][y]
          for i in 0..<(maxLength - value.count) {
            // Keep the value as close to the middle as possible, preferring a leading separator.
            if i % 2 == 0 {
              value = separator + value
            } else {
              value = value + separator
            }
          }
          components[x][y] = value
        }
      }
    }
    return components.map({ $0.joined(separator: separator) }).joined(separator: "\n")
  }
}

// MARK: - Point adjacency
extension Collection where Element: Collection {
  // Because a collection of non-collection values only has 1 dimension need to convert into a two dimensional point.
  private func pointsAdjacent(to point: Point, atX x: Int, includeDiagonals: Bool, includeCenterPoint: Bool) -> [Point?] {
    // If the x does not match the point, anything adjacent to x is diagonal.
    let xMatchesPoint = (point.x == x)

    // If x matches the point need to use includeCenterPoint to determine whether to include the center point.
    let includeIndex: Bool = xMatchesPoint ? includeCenterPoint : true

    let adjacentPoints: [Point?]

    // If x does not match the point and diagonals are not included then only need to check the Point (x, point.y).
    if !xMatchesPoint && !includeDiagonals {
      // The points are always diagonal to the point here, so do not need to check includeCenterPoint.
      var newPoint: Point? = point
      if self[unsafe: x].count > point.y {
        newPoint!.x = x
      } else {
        newPoint = nil
      }
      // Surround with nil to indicate not including the points beside x.
      adjacentPoints = [nil, newPoint, nil]
    // Else including points beside x (whether diagonal or adjacent to the point).
    } else {
      adjacentPoints = self[unsafe: x].indicesAdjacent(to: point.y, includeIndex: includeIndex).map { (y: Int?) -> Point? in
        guard let y = y else {
          return nil
        }

        var newPoint = point
        newPoint.x = x
        newPoint.y = y
        return newPoint
      }
    }
    return adjacentPoints
  }

  func pointsAdjacent(to point: Point, includeDiagonals: Bool = false, includePoint: Bool = false) -> [Point?] {
    var adjacentPoints = [Point?]()

    // Always pass true for includeCenterPoint in x(+/-)1 because that will be a point adjacent to the provided point.
    if point.x > 0 {
      adjacentPoints.append(contentsOf: pointsAdjacent(to: point,
                                                       atX: point.x-1,
                                                       includeDiagonals: includeDiagonals,
                                                       includeCenterPoint: true))
    } else {
      adjacentPoints.append(contentsOf: [Point?](repeating: nil, count: 3))
    }

    adjacentPoints.append(contentsOf: pointsAdjacent(to: point,
                                                     atX: point.x,
                                                     includeDiagonals: includeDiagonals,
                                                     includeCenterPoint: includePoint))
    if !includePoint {
      adjacentPoints.remove(at: adjacentPoints.count-2)
    }

    if (point.x+1) < count {
      adjacentPoints.append(contentsOf: pointsAdjacent(to: point,
                                                       atX: point.x+1,
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
extension Collection where Element: Collection {
  // Supports non mutable collections, e.g. let bindings?
  subscript(point: Point) -> Element.Element {
    return self[unsafe: point.x][unsafe: point.y]
  }

  func contains(point: Point) -> Bool {
    return point.x >= 0 && point.y >= 0 &&
    point.x < count && point.y < self[unsafe: point.x].count
  }
}
