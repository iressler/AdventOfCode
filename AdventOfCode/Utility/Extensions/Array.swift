//
//  Array.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/7/21.
//

import Foundation

extension Array {
  subscript(wrapping index: Index) -> Element {
    return self[((index % count) + count) % count]
  }
}

extension Array where Element: RangeReplaceableCollection {
  init(repeating element: Element.Element, x: Int, y: Int) {
    self.init(repeating: Element.init(repeating: element, count: y), count: x)
  }
}

extension Array where Element: Collection, Element.Index == Index {
  private func components(rotated: Bool) -> [[String]] {
    guard !isEmpty else {
      return []
    }

    if !rotated {
      return self.map({ $0.map({ description(for: $0) }) })
    }
    var components = [[String]](repeating: [], count: first!.count)
//    var components = [[String]](repeating: "", x: first!.count, y: count)
    for i in 0..<first!.count {
      for value in self {
        components[i].append(description(for: value[i]))
      }
    }
    return components
  }

  private func description(for value: Any) -> String {
    if let int = value as? Int {
      return int == 0 ? "." : String(describing: int)
    } else if let bool = value as? Bool {
      return bool ? "#" : "."
    } else {
      return String(describing: value)
    }
  }

  func fieldDescription(separator: String = " ", rotated: Bool = false) -> String {
    return components(rotated: rotated).map({ $0.joined(separator: separator) }).joined(separator: "\n")
  }
}

extension Array where Element: MutableCollection, Element.Index == Index {
  subscript(point: Point) -> Element.Element  {
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
      adjacentPoints.append(Point(x: point.x, y: upY))

      // Check the 2 diagonals to the right if including diagonals.
      if includeDiagonals {
        if xCanGoDown {
          adjacentPoints.append(Point(x: point.x-1, y: upY))
        }
        if xCanGoUp {
          adjacentPoints.append(Point(x: point.x+1, y: upY))
        }
      }
    }

    if yCanGoDown {
      let downY = point.y - 1
      adjacentPoints.append(Point(x: point.x, y: downY))

      // Check the 2 diagonals to the left if including diagonals.
      if includeDiagonals {
        if xCanGoDown {
          adjacentPoints.append(Point(x: point.x-1, y: downY))
        }
        if xCanGoUp {
          adjacentPoints.append(Point(x: point.x+1, y: downY))
        }
      }
    }

    if xCanGoUp {
      adjacentPoints.append(Point(x: point.x+1, y: point.y))
    }

    if xCanGoDown {
      adjacentPoints.append(Point(x: point.x-1, y: point.y))
    }

    return adjacentPoints
  }
}
