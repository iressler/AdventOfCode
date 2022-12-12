//
//  Challenge2022Day9Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

private struct Step: CustomStringConvertible {
  enum Direction: String {
    case Up = "U"
    case Right = "R"
    case Down = "D"
    case Left = "L"
  }

  let direction: Direction
  let distance: Int

  var description: String {
    return "\(direction.rawValue) \(distance)"
  }
}

private extension Point {
  mutating func move(_ direction: Step.Direction) {
    switch direction {
    case .Up:
      self.x += 1
    case .Right:
      self.y += 1
    case .Down:
      self.x -= 1
    case .Left:
      self.y -= 1
    }
  }
}

private extension Step {
  init(description: String) {
    let components = description.components(separatedBy: " ")
    guard components.count == 2,
          let direction = Direction(rawValue: components[0]),
          let distance = Int(components[1]) else {
      fatalError("Invalid Step components: \(description)")
    }
    self.init(direction: direction, distance: distance)
  }
}

struct Challenge2022Day9Solver: ChallengeSolver {
  static let defaultValue = """
R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let steps = inputComponents(from: input)
      .map({ Step(description: $0) })
    switch challengeNumber {
    case .one:
      return getAnswer1(given: steps)
    case .two:
      return getAnswer2(given: steps)
    }
  }

  static private func printField(head: Point, tail: Point) {
    let start = Point(x: 0, y: 0)
    let minX = min(start.x, head.x, tail.x)
    let maxX = max(start.x, head.x, tail.x, 4)
    let minY = min(start.y, head.y, tail.y)
    let maxY = max(start.y, head.y, tail.y, 5)
    var field = [[Character]](repeating: [Character](repeating: ".", count: maxY-minY+1), count: maxX-minX+1)
    field[start] = "s"
    field[head] = "H"
    field[tail] = "T" 
    print(field.fieldDescription())
  }

  static private func simulateRope(knotCount: Int, steps: [Step]) -> Int {
    guard knotCount >= 2 else {
      fatalError("Minimum 2 knots.")
    }
    var points = [Point](repeating: Point(x: 0, y: 0), count: knotCount)
    var tailPoints = Set<Point>()

    for step in steps {
//      print(step)
      for _ in 0..<step.distance {
        points[0].move(step.direction)
        for i in 1..<knotCount {
          let head = points[i-1]
          var tail = points[i]
          let xDist = head.x - tail.x
          let yDist = head.y - tail.y

          if abs(xDist) > 1 || abs(yDist) > 1 {
            if abs(xDist) > 0 {
              tail.x += xDist > 0 ? 1 : -1
            }

            if abs(yDist) > 0 {
              tail.y += yDist > 0 ? 1 : -1
            }
            points[i] = tail
          } else {
            // once a knot doesn't move none of the following knots will.
            break
          }
        }

        tailPoints.insert(points.last!)
//        printField(head: head, tail: tail)
//        print("\n==============================\n")
      }
//      return ""
    }

    return tailPoints.count
  }

  static private func getAnswer1(given steps: [Step]) -> String {
    return "\(simulateRope(knotCount: 2, steps: steps))"
//    var head = Point(x: 0, y: 0)
//    var tail = Point(x: 0, y: 0)
//
//    var tailPoints = Set<Point>()
//
//    for step in steps {
////      print(step)
//      for _ in 0..<step.distance {
//        head.move(step.direction)
//        let xDist = head.x - tail.x
//        let yDist = head.y - tail.y
//
//        if abs(xDist) > 1 || abs(yDist) > 1 {
//          if abs(xDist) > 0 {
//            tail.x += xDist > 0 ? 1 : -1
//          }
//
//          if abs(yDist) > 0 {
//            tail.y += yDist > 0 ? 1 : -1
//          }
//        }
//        tailPoints.insert(tail)
////        printField(head: head, tail: tail)
////        print("\n==============================\n")
//      }
////              return ""
//    }
//
//    return "\(tailPoints.count)"
  }

  static private func getAnswer2(given steps: [Step]) -> String {
    return "\(simulateRope(knotCount: 10, steps: steps))"
  }
}
