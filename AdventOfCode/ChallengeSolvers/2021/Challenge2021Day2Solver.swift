//
//  ChallengeDay2Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/2/21.
//

import Foundation

struct Challenge2021Day2Solver: ChallengeSolver {
  private enum Direction: String {
    case forward
    case up
    case down
  }

  private struct Command {
    let direction: Direction
    let distance: Int

    init(direction: Direction, distance: Int) {
      self.direction = direction
      self.distance = distance
    }

    init?(direction: String, distance: String) {
      guard let direction = Direction(rawValue: direction), let distance = Int(distance) else {
        return nil
      }
      self.init(direction: direction, distance: distance)
    }
  }

  static let defaultValue: String = "forward 5 down 5 forward 8 up 3 down 8 forward 2"

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let commandStrings = components(from: input)
      .filter({ !$0.isEmpty })

    var commands: [Command] = []
    var index = 0
    while index < commandStrings.count {
      commands.append(Command(direction: commandStrings[index], distance: commandStrings[index + 1])!)
      index += 2
    }

    switch challengeNumber {
    case .one:
      return getAnswer1(given: commands)
    case .two:
      return getAnswer2(given: commands)
    }
  }

  private static func getAnswer1(given commands: [Command]) -> String {
    var distance = 0
    var depth = 0

    for command in commands {
      switch command.direction {
      case .forward:
        distance += command.distance
      case .up:
        depth -= command.distance
      case .down:
        depth += command.distance
      }

    }
    return "\(distance * depth)"
  }

  private static func getAnswer2(given commands: [Command]) -> String {
    var distance = 0
    var depth = 0
    var aim = 0

    for command in commands {
      switch command.direction {
      case .forward:
        distance += command.distance
        depth += (aim * command.distance)
      case .up:
        aim -= command.distance
      case .down:
        aim += command.distance
      }

    }
    return "\(distance * depth)"
  }

}
