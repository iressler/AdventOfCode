//
//  Challenge2020Day11Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2020Day11Solver: ChallengeSolver {
  private struct Layout: CustomStringConvertible {
    enum Position: String {
      case floor = "."
      case emptySeat = "L"
      case occupiedSeat = "#"

      var isOccupied: Bool {
        return self == .occupiedSeat
      }
    }

    private var layout: [[Position]]

    var occupiedSeats: Int {
      return layout.map({ $0.filter({ $0.isOccupied }).count }).sum()
    }

    init(layout: [String]) {
      self.layout = layout.map({ $0.map({ Layout.Position(rawValue: String($0))! }) })
    }

    typealias AdjacentSeatsCountClosure = (Point, [[Position]]) -> Int

    // Returns true if there was a change.
    mutating private func runOnce(adjacentSeatCount: AdjacentSeatsCountClosure, maxOccupiedSeats: Int) -> Bool {
      var newLayout = layout
      for x in 0..<layout.count {
        for y in 0..<layout[x].count {
          let point = Point(x: x, y: y)
          if layout[point] == .floor {
            continue
          }
          let numberOccupiedSeats = adjacentSeatCount(point, layout)
          if layout[point].isOccupied {
            if numberOccupiedSeats >= maxOccupiedSeats {
              newLayout[point] = .emptySeat
            } // else it stays occupied.
          } else if numberOccupiedSeats == 0 {
            newLayout[point] = .occupiedSeat
          }
        }
      }

      let didChange = layout == newLayout

      // Doesn't do anything if they are the same because the newLayout was never modified, so it's the same object (CoW).
      layout = newLayout

      return didChange
    }

    // Returns the number of runs necessary to stop running.
    @discardableResult
    mutating func runUntilNoChange(lineOfSight: Bool = false) -> Int {
      var count = 0
      let adjacentSeatCount: (Point, [[Position]]) -> Int
      let maxOccupiedSeats: Int

      if lineOfSight {
        adjacentSeatCount = { point, layout in
          var numVisibleSeatsOccupied = 0
          for x in -1...1 {
            for y in -1...1 {
              if x == 0 && y == 0 {
                continue
              }
              var currPoint = Point(x: point.x + x, y: point.y + y)
              while layout.contains(point: currPoint) {
                if layout[currPoint] == .floor {
                  currPoint.x += x
                  currPoint.y += y
                } else {
                  if layout[currPoint].isOccupied {
                    numVisibleSeatsOccupied += 1
                  }
                  break
                }
              }
            }
          }
          return numVisibleSeatsOccupied
        }
        maxOccupiedSeats = 5
      } else {
        adjacentSeatCount = { point, layout in
          layout.pointsAdjacent(to: point, includeDiagonals: true).filter({ layout[$0].isOccupied }).count
        }
        maxOccupiedSeats = 4
      }

//      print("\(count):")
//      print(self)
      while !runOnce(adjacentSeatCount: adjacentSeatCount, maxOccupiedSeats: maxOccupiedSeats) {
        count += 1
//        print("\(count):")
//        print(self)
      }
      return count
    }

    var description: String {
      return layout.map({ $0.map({ $0.rawValue }) }).fieldDescription()
    }
  }


  static let defaultValue = """
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let layout = Layout(layout: inputComponents(from: input))
    switch challengeNumber {
    case .one:
      return getAnswer1(given: layout)
    case .two:
      return getAnswer2(given: layout)
    }
  }

  static private func getAnswer1(given layout: Layout) -> String {
    var layout = layout
    layout.runUntilNoChange()
//    print(layout)
    return "\(layout.occupiedSeats)"
  }

  static private func getAnswer2(given layout: Layout) -> String {
    var layout = layout
    layout.runUntilNoChange(lineOfSight: true)
//    print(layout)
    return "\(layout.occupiedSeats)"  }
}
