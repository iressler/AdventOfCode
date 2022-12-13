//
//  Challenge2022Day11Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

private class Monkey: CustomStringConvertible {
  let id: Int
  let divisor: Int
  private(set) var items: [Int]
  private(set) var itemInspectionCount = 0

  private var operation: (Int) -> Int
  private var test: (Int) -> Int

  private static func `operator`(for symbol: String) -> (Int, Int) -> Int {
    switch symbol {
    case "*":
      return { lhs, rhs in
        return lhs * rhs
      }
    case "+":
      return { lhs, rhs in
        return lhs + rhs
      }
    default:
      fatalError("Unknown operator: \(symbol)")
    }
  }

  init(description: [String]) {
    guard description.count == 6 else {
      fatalError("Invalid Monkey description: \(description)")
    }
    let description = description.map({ $0.trimmingCharacters(in: .whitespaces) })

    self.id = Int(description[0].components(separatedBy: " ").last!.removingLast(1))!
    self.items = Array(description[1].removeCharacters(from: CharacterSet(charactersIn: ",")).components(separatedBy: " ").dropFirst(2).map({ Int($0)! }))

    self.divisor = Int(description[3].components(separatedBy: " ")[3])!

    self.operation = {_ in return 0}
    self.test = {_ in return 0}
    // Operation
    let operationComponents = description[2].components(separatedBy: " ")
    let op = Self.operator(for: operationComponents[4])
    let opNum = Int(operationComponents[5])

    self.operation = { worryLevel in
      self.itemInspectionCount += 1
      return op(worryLevel, opNum ?? worryLevel)
    }

    // Test
    let trueMonkeyId = Int(description[4].components(separatedBy: " ").last!)!
    let falseMonkeyId = Int(description[5].components(separatedBy: " ").last!)!

    self.test = { worryLevel in
      return (worryLevel % self.divisor) == 0 ? trueMonkeyId : falseMonkeyId
    }
  }

  func throwItems(decreasesWorry: Bool, using throwItem: (Int, Int) -> Void) {
    for item in items {
      let newWorryLevel = operation(item) / (decreasesWorry ? 3 : 1)
      throwItem(newWorryLevel, test(newWorryLevel))
    }

    items.removeAll()
  }

  func catchItem(worryLevel: Int) {
    self.items.append(worryLevel)
  }

  var description: String {
    "Monkey \(id): \(items)"
  }
}

struct Challenge2022Day11Solver: ChallengeSolver {
  static let defaultValue = """
Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    var monkeys = [Monkey]()
    let lines = inputComponents(from: input, dropEmpty: false)

    var currMonkeyDescription = [String]()

    for line in lines {
      if line.isEmpty {
        monkeys.append(Monkey(description: currMonkeyDescription))
        currMonkeyDescription.removeAll()
      } else {
        currMonkeyDescription.append(line)
      }
    }

    if currMonkeyDescription.isNotEmpty {
      monkeys.append(Monkey(description: currMonkeyDescription))
    }

    switch challengeNumber {
    case .one:
      return getAnswer1(given: monkeys)
    case .two:
      return getAnswer2(given: monkeys)
    }
  }

  static private func getAnswer1(given monkeys: [Monkey]) -> String {
    for _ in 1...20 {
      for monkey in monkeys {
        monkey.throwItems(decreasesWorry: true) { worryLevel, newMonkeyId in
          monkeys[newMonkeyId].catchItem(worryLevel: worryLevel)
        }
      }
//      print(monkeys.map({ $0.description }).joined(separator: "\n"))
    }
    let monkeyInspectionCounts = monkeys.map({ $0.itemInspectionCount }).sorted(by: >)
    return "\(monkeyInspectionCounts[0] * monkeyInspectionCounts[1])"
  }

  static private func getAnswer2(given monkeys: [Monkey]) -> String {
    var monkeyLCM = 1

    for monkey in monkeys {
      monkeyLCM = lowerCommonMultiple(monkeyLCM, monkey.divisor)
//      print("\(monkey.divisor), \(monkeyLCM)")
    }

    for _ in 1...10000 {
      for monkey in monkeys {
        monkey.throwItems(decreasesWorry: false) { worryLevel, newMonkeyId in
          monkeys[newMonkeyId].catchItem(worryLevel: worryLevel % monkeyLCM)
        }
      }
      //      print(monkeys.map({ $0.description }).joined(separator: "\n"))
    }
//    print(monkeys.map({ $0.itemInspectionCount }))
    let monkeyInspectionCounts = monkeys.map({ $0.itemInspectionCount }).sorted(by: >)
    return "\(monkeyInspectionCounts[0] * monkeyInspectionCounts[1])"
  }}
