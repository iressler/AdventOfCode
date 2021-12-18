//
//  Challenge2020Day12Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2020Day12Solver: ChallengeSolver {
  private struct Instruction: CustomStringConvertible {
    enum Direction: String {
      case north = "N"
      case south = "S"
      case east = "E"
      case west = "W"
      case turnLeft = "L"
      case turnRight = "R"
      case forward = "F"
    }

    let direction: Direction
    let amount: Int

    init(direction: Direction, amount: Int) {
      self.direction = direction
      self.amount = amount
    }

    init?(description: String) {
      guard let direction = Direction(rawValue: description[unsafe: 0]),
            let amount = Int(description[unsafe: 1..<description.count]) else {
        return nil
      }
      self.init(direction: direction, amount: amount)
    }

    var description: String {
      return direction.rawValue + String(describing: amount)
    }
  }

  static let defaultValue1 = """
R90
R180
R270
L90
L180
L270
"""

  static let defaultValue = """
F10
N3
F7
R90
F11
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let instructions = inputComponents(from: input).map({ Instruction(description: $0)! })
    switch challengeNumber {
    case .one:
      return getAnswer1(given: instructions)
    case .two:
      return getAnswer2(given: instructions)
    }
  }

  private struct Ship: CustomStringConvertible {
    enum Direction: CaseIterable, Equatable {
      case north
      case south
      case east
      case west

      init?(_ instructionDirection: Instruction.Direction) {
        switch instructionDirection {
        case .north:
          self = .north
        case .south:
          self = .south
        case .east:
          self = .east
        case .west:
          self = .west
        default:
          return nil
        }
      }

      static let allCases: [Direction] = [.north, .east, .south, .west]

      mutating func rotateLeft(by amount: Int) {
        self = Self.allCases[wrapping: Self.allCases.firstIndex(of: self)! - Int(amount / 90)]
      }

      mutating func rotateRight(by amount: Int) {
        rotateLeft(by: abs(360-amount))
//        self = Self.allCases[wrapping: Self.allCases.firstIndex(of: self)! + Int(amount / 90)]
      }

      var instructionDirection: Instruction.Direction {
        switch self {
        case .north:
          return .north
        case .south:
          return .south
        case .east:
          return .east
        case .west:
          return .west
        }
      }
    }

    var wayPoint = Point(x: 1, y: 10)
    var location = Point(x: 0, y: 0)
    var facing: Direction = .east


    private mutating func moveShip(_ direction: Direction, _ amount: Int) {
      switch direction {
      case .north:
        moveShip(x: amount)
      case .south:
        moveShip(x: -amount)
      case .east:
        moveShip(y: amount)
      case .west:
        moveShip(y: -amount)
      }
    }

    private mutating func moveWaypoint(_ direction: Direction, _ amount: Int) {
      switch direction {
      case .north:
        moveWaypoint(x: amount)
      case .south:
        moveWaypoint(x: -amount)
      case .east:
        moveWaypoint(y: amount)
      case .west:
        moveWaypoint(y: -amount)
      }
    }

    private mutating func moveShip(x: Int? = nil, y: Int? = nil) {
      if let x = x {
        location.x += x
      }
      if let y = y {
        location.y += y
      }
      moveWaypoint(x: x, y: y)
    }

    private mutating func moveWaypoint(x: Int? = nil, y: Int? = nil) {
      if let x = x {
        wayPoint.x += x
      }
      if let y = y {
        wayPoint.y += y
      }
    }

    private mutating func rotateWaypointLeft(by amount: Int) {
      rotateWaypointRight(by: abs(360-amount))
    }

    private mutating func rotateWaypointRight(by amount: Int) {
      var currWaypoint = wayPoint

      // Probably a better way to do it than individual 90 degree rotations, but this works.
      for _ in 0..<Int(amount/90) {
        let xDifference = abs(location.x - currWaypoint.x) * (location.x > currWaypoint.x ? -1 : 1)
        let yDifference = abs(location.y - currWaypoint.y) * (location.y > currWaypoint.y ? -1 : 1)
        currWaypoint = Point(x: location.x + -yDifference, y: location.y + xDifference)
      }

      wayPoint = currWaypoint
    }

    mutating func follow(shipInstructions instructions: [Instruction]) {
      for instruction in instructions {
        follow(shipInstruction: instruction)
      }
    }

    private mutating func follow(shipInstruction instruction: Instruction) {
      switch instruction.direction {
      case .north, .south, .east, .west:
        self.moveShip(Direction(instruction.direction)!, instruction.amount)
      case .turnLeft:
        facing.rotateLeft(by: instruction.amount)
      case .turnRight:
        facing.rotateRight(by: instruction.amount)
      case .forward:
        follow(shipInstruction: Instruction(direction: facing.instructionDirection, amount: instruction.amount))
      }
    }

    private mutating func follow(waypointInstruction instruction: Instruction) {
      switch instruction.direction {
      case .north, .south, .east, .west:
        self.moveWaypoint(Direction(instruction.direction)!, instruction.amount)
      case .turnLeft:
        rotateWaypointLeft(by: instruction.amount)
      case .turnRight:
        rotateWaypointRight(by: instruction.amount)
      case .forward:
        // Calculate the amount/direction the ship needs to move to get to the waypoint
        let xDifference = abs(location.x - wayPoint.x) * (location.x > wayPoint.x ? -1 : 1)
        let yDifference = abs(location.y - wayPoint.y) * (location.y > wayPoint.y ? -1 : 1)
        // Move that distance as many times as the instructions says to all at once.
        moveShip(x: xDifference * instruction.amount, y: yDifference * instruction.amount)
      }
//      print(self)
    }

    mutating func follow(waypointInstructions instructions: [Instruction]) {
      for instruction in instructions {
        follow(waypointInstruction: instruction)
      }
    }

    var description: String {
      return "\(location), facing: \(facing), waypoint: \(wayPoint)"
    }
  }

  static private func getAnswer1(given instructions: [Instruction]) -> String {
    var ship = Ship()
    ship.follow(shipInstructions: instructions)

    print("Ship ended at: \(ship.location)")
    return "\(abs(ship.location.x) + abs(ship.location.y))"
  }

  static private func getAnswer2(given instructions: [Instruction]) -> String {
    var ship = Ship()
    ship.follow(waypointInstructions: instructions)

    print("Ship ended at: \(ship.location)")
    return "\(abs(ship.location.x) + abs(ship.location.y))"
  }
}
