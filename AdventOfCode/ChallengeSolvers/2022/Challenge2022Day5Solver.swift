//
//  Challenge2022Day5Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/4/21.
//

import Foundation

import Collections

private typealias Stack = Deque<String>

extension Deque {
  mutating func popLast(_ k: Int) -> [Element] {
    guard k > 0, k <= count else {
      return []
    }
    let elements = Array(self[index(endIndex, offsetBy: -1*k)..<endIndex])
    self.removeLast(k)
    return elements
  }
}

private struct Instruction {
  let createCount: Int
  let initialStack: Int
  let destinationStack: Int

  init?(_ line: String) {
    var words = line.components(separatedBy: " ")
    guard let createCount = Int(words[1]), let initialStack = Int(words[3]), let destinationStack = Int(words[5]) else {
      return nil
    }
    self.createCount = createCount
    self.initialStack = initialStack
    self.destinationStack = destinationStack
  }
}

struct Challenge2022Day5Solver: ChallengeSolver {
  static let defaultValue = """
    [D]
[N] [C]
[Z] [M] [P]
 1   2   3

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    var lines = inputComponents(from: input)
    var stacks: Array<Stack> = [Stack()]

    while let line = lines.popFirst() {
      let chars = Array(line)
      if chars[1] == "1" {
        break
      }
      var charIndex = 1
      while charIndex < chars.endIndex {
        let char = chars[charIndex]
        if char != " " {
          let stackIndex = (charIndex + 3) / 4
          while stackIndex >= stacks.endIndex {
            stacks.append(Stack())
          }
          stacks[stackIndex].prepend(String(char))
        }
        charIndex += 4
      }
    }

    let instructions = lines.map({ Instruction($0)! })

    switch challengeNumber {
    case .one:
      return getAnswer1(given: stacks, instructions: instructions)
    case .two:
      return getAnswer2(given: stacks, instructions: instructions)
    }
  }

  private static func printStacks(_ stacks: [Stack]) {
    for stack in stacks {
      print(stack.joined(separator: ""))
    }
  }

  static private func getAnswer1(given stacks: [Stack], instructions: [Instruction]) -> String {
    var stacks = stacks
//    printStacks(stacks)
    for instruction in instructions {
//      print(instruction)
      for _ in 0..<instruction.createCount {
        stacks[instruction.destinationStack].append(stacks[instruction.initialStack].popLast()!)
      }
//      printStacks(stacks)
    }
    return stacks.map({$0.last ?? ""}).joined()
  }

  static private func getAnswer2(given stacks: [Stack], instructions: [Instruction]) -> String {
    var stacks = stacks
//    printStacks(stacks)
    for instruction in instructions {
//      print(instruction)
      let movingBoxes = stacks[instruction.initialStack].popLast(instruction.createCount)
      stacks[instruction.destinationStack].append(contentsOf: movingBoxes)
//      printStacks(stacks)
    }
    return stacks.map({$0.last ?? ""}).joined()
  }
}
