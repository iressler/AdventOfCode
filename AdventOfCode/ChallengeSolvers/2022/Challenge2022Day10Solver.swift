//
//  Challenge2022Day10Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

private struct Register {
  enum Instruction {
    case addx(Int)
    case noop

    var cycles: Int {
      switch self {
      case .addx:
        return 2
      case .noop:
        return 1
      }
    }

    static func instruction(from line: String) -> Instruction {
      let components = line.components(separatedBy: " ")
      switch components.first! {
      case "noop":
        return .noop
      case "addx":
        return .addx(Int(components[1])!)
      default:
        fatalError("Unknown instruction: \(line)")
      }
    }
  }

  private(set) var cycles = 0
  private(set) var value = 1
  private let recordCycleCount: Int
  private(set) var signalStrengths = [Int]()
  private(set) var screen = [[Character]]()

  private var nextCycleToRecord: Int

  init(recordingEvery recording: Int) {
    self.recordCycleCount = recording
    self.nextCycleToRecord = 20
  }

  mutating func executeAndRecord(_ instruction: Instruction) {
    cycles += instruction.cycles

    if cycles >= nextCycleToRecord {
      signalStrengths.append(value * nextCycleToRecord)
      nextCycleToRecord += recordCycleCount
    }
    if case .addx(let value) = instruction {
      self.value += value
    }
  }

  private func point(for cycleCount: Int) -> Point {
    return Point(x: cycleCount / 40, y: cycleCount % 40)
  }

  private func printSpritePosition() {
    var row = [Character](repeating: ".", count: 40)

    for i in (value-1)...(value+1) {
      if i >= 0 && i < 40 {
        row[i] = "#"
      }
    }
    print(row.map({ String($0) }).joined(separator: ""))
  }

  private func printScreen() {
    print(screen.fieldDescription(separator: ""))
  }

  mutating func executeAndDraw(_ instruction: Instruction) {
    let row = cycles / 40
    // row+1 to account for addx instructions that wrap.
    if (row+1) >= screen.count {
      screen.append([Character](repeating: ".", count: 40))
    }

    print("\n==============================================")
    printSpritePosition()
    print("----------------------------------------------")
    printScreen()
    for cycleOffset in 0..<instruction.cycles {
      let point = point(for: cycles + cycleOffset)
      if abs(value - point.y) <= 1 {
        screen[point] = "#"
      }
    }
    print("----------------------------------------------")
    printScreen()
    print("==============================================\n")

    cycles += instruction.cycles
    if case .addx(let value) = instruction {
      self.value += value
    }

  }
}

struct Challenge2022Day10Solver: ChallengeSolver {
  static let defaultValue = """
addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let instructions = inputComponents(from: input)
      .map({ Register.Instruction.instruction(from: $0) })
    switch challengeNumber {
    case .one:
      return getAnswer1(given: instructions)
    case .two:
      return getAnswer2(given: instructions)
    }
  }

  static private func getAnswer1(given instructions: [Register.Instruction]) -> String {
    var register = Register(recordingEvery: 40)
    for instruction in instructions {
      register.executeAndRecord(instruction)
    }
    print(register.signalStrengths)
    return "\(register.signalStrengths.sum())"
  }

  static private func getAnswer2(given instructions: [Register.Instruction]) -> String {
    var register = Register(recordingEvery: 40)
    for instruction in instructions {
      register.executeAndDraw(instruction)
    }
//    print(register.signalStrengths)
    print(register.screen.count)
    for row in register.screen {
      print(row.count)
    }
    return "\(register.screen.fieldDescription())"
  }
}
