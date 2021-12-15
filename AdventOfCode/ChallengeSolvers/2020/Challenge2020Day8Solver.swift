//
//  Challenge2020Day8Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2020Day8Solver: ChallengeSolver {
  enum Command {
    case nop(Int)
    case acc(Int)
    case jmp(Int)

    init(description: String) {
      let components = description.components(separatedBy: .whitespaces)
      guard components.count == 2 else {
        fatalError("Invalid command description: \(description)")
      }

      guard let value = Int(components.last!) else {
        fatalError("Invalid command count: \(components.last!)")
      }

      switch components.first! {
      case "nop":
        self = .nop(value)
      case "acc":
        self = .acc(value)
      case "jmp":
        self = .jmp(value)
      default:
        fatalError("Unrecognized command: \(components.first!)")
      }
    }
  }

  static let defaultValue = """
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let commands = inputComponents(from: input).map({ Command(description: $0) })
    switch challengeNumber {
    case .one:
      return getAnswer1(given: commands)
    case .two:
      return getAnswer2(given: commands)
    }
  }

  static private func getAnswer1(given commands: [Command]) -> String {
    var accumulator = 0
    var index = 0
    var executedCommandsIndices = Set<Int>()
    while index >= 0 && index < commands.count {
      if executedCommandsIndices.contains(index) {
        break
      }
      executedCommandsIndices.insert(index)
      let command = commands[index]
      var indexIncrementAmount: Int = 1
      switch command {
      case .nop:
        break
      case .acc(let value):
        accumulator += value
      case .jmp(let value):
        indexIncrementAmount = value
      }
      index += indexIncrementAmount
    }
    return "\(accumulator)"
  }

  static private func getAnswer2(given commands: [Command]) -> String {
    for i in 0..<commands.count {
      var modifiedCommands = commands
      switch commands[i] {
      case .acc:
        // Do not change any acc commands.
        continue
      case .jmp(let value):
        modifiedCommands[i] = .nop(value)
      case .nop(let value):
        modifiedCommands[i] = .jmp(value)
      }

      var accumulator = 0
      var index = 0
      var executedCommandsIndices = Set<Int>()
      var isInfiniteLoop = false
      while index >= 0 && index < modifiedCommands.count {
        if executedCommandsIndices.contains(index) {
          isInfiniteLoop = true
          break
        }
        executedCommandsIndices.insert(index)
        let command = modifiedCommands[index]
        var indexIncrementAmount: Int = 1
        switch command {
        case .nop:
          break
        case .acc(let value):
          accumulator += value
        case .jmp(let value):
          indexIncrementAmount = value
        }
        index += indexIncrementAmount
      }
      if !isInfiniteLoop {
        return "\(accumulator)"
      }
    }
    return "No change found to break infinite loop."
  }
}
