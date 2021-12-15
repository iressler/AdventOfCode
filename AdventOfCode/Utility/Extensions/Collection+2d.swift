//
//  Array+2d.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/15/21.
//

import Foundation

extension Collection where Element: Collection, Element.Index == Index, Index == Int {
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
        components[i].append(description(for: value[i]))
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

// Supports non mutable collections, e.g. let bindings?
extension Collection where Element: Collection, Element.Index == Index, Index == Int {
  subscript(point: Point) -> Element.Element {
    return self[point.x][point.y]
  }
}

extension MutableCollection where Element: MutableCollection, Element.Index == Index, Index == Int {
  subscript(point: Point) -> Element.Element {
    get {
      return self[point.x][point.y]
    }
    set {
      self[point.x][point.y] = newValue
    }
  }

  func pointsAdjacent(to point: Point, includeDiagonals: Bool = false) -> [Point] {
    var adjacentPoints = [Point]()
    let xCanGoDown = point.x > 0
    let xCanGoUp = point.x < (count-1)
    let yCanGoDown = point.y > 0
    let yCanGoUp = point.y < (self[point.x].count-1)

    if yCanGoUp {
      let upY = point.y + 1
      adjacentPoints.append(Point(x: point.x, y: upY, z: point.z))

      // Check the 2 diagonals to the right if including diagonals.
      if includeDiagonals {
        if xCanGoDown {
          adjacentPoints.append(Point(x: point.x-1, y: upY, z: point.z))
        }
        if xCanGoUp {
          adjacentPoints.append(Point(x: point.x+1, y: upY, z: point.z))
        }
      }
    }

    if yCanGoDown {
      let downY = point.y - 1
      adjacentPoints.append(Point(x: point.x, y: downY, z: point.z))

      // Check the 2 diagonals to the left if including diagonals.
      if includeDiagonals {
        if xCanGoDown {
          adjacentPoints.append(Point(x: point.x-1, y: downY, z: point.z))
        }
        if xCanGoUp {
          adjacentPoints.append(Point(x: point.x+1, y: downY, z: point.z))
        }
      }
    }

    if xCanGoUp {
      adjacentPoints.append(Point(x: point.x+1, y: point.y, z: point.z))
    }

    if xCanGoDown {
      adjacentPoints.append(Point(x: point.x-1, y: point.y, z: point.z))
    }

    return adjacentPoints
  }
}
