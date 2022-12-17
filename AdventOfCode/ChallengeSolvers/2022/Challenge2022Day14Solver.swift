//
//  Challenge2022Day14Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

private extension Character {
  static let sandPath: Character = "~"
  static let sand: Character = "o"
  static let rock: Character = "#"
  static let air: Character = "."
  static let sandStart: Character = "+"

  var isAir: Bool {
    return self == .air || self == .sandPath
  }

  var blocksSand: Bool {
    return self == .rock || self == .sand
  }
}

private typealias Path = Array<Point>

extension Path {
  init(pathDescription: String) {
    let pointStrings = pathDescription.components(separatedBy: " -> ")
    self.init(pointStrings.map({ Point(stringLiteral: $0.components(separatedBy: ",").reversed().joined(separator: ",")) }))
  }
}

private class Field {
  static let sandStart = Point(x: 0, y: 500)
  private var mapWidth: Int
  private var hasFloor: Bool
  private(set) var map: [[Character]]

  init(paths: [Path], hasFloor: Bool) {
    // Sand comes in at (0, 500), so maxY is at least 500.
    var maxX = 0
    var maxY = Self.sandStart.y

    for path in paths {
      for point in path {
        maxX = max(maxX, point.x)
        maxY = max(maxY, point.y)
      }
    }

    self.hasFloor = hasFloor
    mapWidth = maxY+1
    // y (width) and x (height) + 1 to account for 0 indexing.
    map = [[Character]](repeating: [Character](repeating: .air, count: maxY+1), count: maxX+1+(hasFloor ? 1 : 0))

    map[Self.sandStart] = .sandStart

    if hasFloor {
      map.append([Character](repeating: .rock, count: mapWidth))
    }

    for path in paths {
      for i in 1..<path.endIndex {
        let startPoint = path[i-1]
        let endPoint = path[i]

        if startPoint.x == endPoint.x {
          for y in min(startPoint.y, endPoint.y)...max(startPoint.y, endPoint.y) {
            map[startPoint.x][y] = .rock
          }
        } else {
          for x in min(startPoint.x, endPoint.x)...max(startPoint.x, endPoint.x) {
            map[x][startPoint.y] = .rock
          }
        }
      }
    }
  }

  // Try to drop another grain of sand into the map. Returns true if the sand ended falling in the map, false if it reached an edge.
  func addSand(markPath: Bool = false) -> Bool {
    var currSandPoint = Self.sandStart

    while currSandPoint.x+1 < map.endIndex {
      let nextSandPoints = [
        Point(x: currSandPoint.x+1, y: currSandPoint.y),
        Point(x: currSandPoint.x+1, y: currSandPoint.y-1),
        Point(x: currSandPoint.x+1, y: currSandPoint.y+1)
      ]
      var sandFell = false
      for nextSandPoint in nextSandPoints {
        // If it reached the end of the map it will either fall forever, or require map growth depending on if there is a floor.
        if nextSandPoint.y < 0 {
          fatalError("This does not account for needing to increment all indicies (just sandStart?) by 1")
          guard hasFloor else {
            return false
          }
          for i in 0..<map.endIndex {
            map[i].prepend(.air)
          }
          map[map.endIndex-1][0] = .rock
          mapWidth += 1

        } else if nextSandPoint.y >= mapWidth {
          guard hasFloor else {
            return false
          }
          for i in 0..<map.endIndex {
            map[i].append(.air)
          }
          // Set before incrementing mapWidth because this is 1 less than mapWidth, which easy to get before incrementing mapWidth.
          map[map.endIndex-1][mapWidth] = .rock
          mapWidth += 1
        }

        if map[nextSandPoint].isAir {
          if markPath {
            map[nextSandPoint] = .sandPath
          }
          currSandPoint = nextSandPoint
          sandFell = true
          break
        } // Else it's sand/rock and the new sand can't go there, continue to the next point.
      }

      if !sandFell {
        map[currSandPoint] = .sand
        return currSandPoint != Self.sandStart
      }
    }
    return false
  }
}

struct Challenge2022Day14Solver: ChallengeSolver {
  static let defaultValue = """
498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let paths = inputComponents(from: input).map({ Path(pathDescription: $0) })

    switch challengeNumber {
    case .one:
      return getAnswer1(given: paths)
    case .two:
      return getAnswer2(given: paths)
    }
  }

  static private func getAnswer1(given paths: [Path]) -> String {
    let field = Field(paths: paths, hasFloor: false)
    var sandAdded = 0
    while field.addSand(markPath: false) {
      sandAdded += 1
    }
    return "\(sandAdded)"
  }

  static private func getAnswer2(given paths: [Path]) -> String {
    let field = Field(paths: paths, hasFloor: true)
    var sandAdded = 0
    repeat {
      sandAdded += 1
    } while field.addSand(markPath: false)
//    print(field.map.fieldDescription())
    return "\(sandAdded)"
  }
}
