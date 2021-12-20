//
//  Challenge2020Day18Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2020Day18Solver: ChallengeSolver {
  static let defaultValue = """
1 + 2 * 3 + 4 * 5 + 6
1 + (2 * 3) + (4 * (5 + 6))
1 + (2 * 3) + ((5 + 6) * 4)
2 * 3 + (4 * 5)
5 + (8 * 3 + 9 + 3 * 4 * 3)
5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))
((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2
"""

  private enum MathOperator: String {
    case startParenthesis = "("
    case endParenthesis = ")"
    case addition = "+"
    case multiplication = "*"
  }

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let equations = inputComponents(from: input).map { equation in
      return equation
        .replacingOccurrences(of: "(", with: " ( ")
        .replacingOccurrences(of: ")", with: " ) ")
        .components(separatedBy: .whitespaces)
        .filter({ !$0.isEmpty })
    }

    switch challengeNumber {
    case .one:
      return getAnswer1(given: equations)
    case .two:
      return getAnswer2(given: equations)
    }
  }

  static private let numberFormatter : NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumIntegerDigits = 2
    return formatter
  }()

  static private func string(from value: Int) -> String {
    return numberFormatter.string(from: NSNumber(value: value))!
  }

  static private func compute(mathEquation: [String], hasPrecedence: Bool) -> Int {
    var mathEquation = mathEquation
    var currEquation = [String]()

    while let nextChar = mathEquation.popFirst() {
      if case .endParenthesis = MathOperator(rawValue: nextChar) {
          var subEquation = [String]()
        while let nextChar = currEquation.popLast(), nextChar != MathOperator.startParenthesis.rawValue {
            // Prepend to get it back in "forwards" order.
            subEquation.prepend(nextChar)
//            subEquation.append(nextChar)
          }
          currEquation.append(String(compute(subMathEquation: subEquation, hasPrecedence: hasPrecedence)))
      } else {
        currEquation.append(nextChar)
      }
    }

    return compute(subMathEquation: currEquation, hasPrecedence: hasPrecedence)
  }

  static private func compute(subMathEquation: [String], hasPrecedence: Bool) -> Int {
    if hasPrecedence {
      var mathEquation = subMathEquation
      applyOperator(.addition, to: &mathEquation)
      applyOperator(.multiplication, to: &mathEquation)
      guard mathEquation.count == 1 else {
        fatalError("Failed applying operators")
      }
      return Int(mathEquation.first!)!
    }
    return compute(subMathEquation: subMathEquation)
  }

  // subMathEquation must only be numbers and operators
  static private func applyOperator(_ op: MathOperator, to subMathEquation: inout [String]) {
    while let opIndex = subMathEquation.firstIndex(of: op.rawValue) {
      let firstNumber = Int(subMathEquation[opIndex - 1])!
      let lastNumber = Int(subMathEquation[opIndex + 1])!
      let newNumber: String
      switch op {
      case .addition:
        newNumber = "\(firstNumber + lastNumber)"
      case .multiplication:
        newNumber = "\(firstNumber * lastNumber)"
      default:
        fatalError("Unsupported operator: \(op.rawValue)")
      }
      subMathEquation.replaceSubrange(opIndex-1...opIndex+1, with: [newNumber])
    }
  }

  static private func compute(subMathEquation: [String]) -> Int {
    // Don't think this can be hit?
    guard !subMathEquation.isEmpty else {
      return 0
    }

    var mathEquation = subMathEquation

    var currValue = Int(mathEquation.popFirst()!)!


    // Solve from the back to give left precedence.
    // This works because everything to the right of an operator is always solved before the left.
    while let currElement = mathEquation.popFirst() {
      guard let operation = MathOperator(rawValue: currElement) else {
        fatalError("Unsupported char: \(currElement)")
      }

//      print("Going to sub-process: \(string(from: currValue)) \(currElement) on \(mathEquation)")
      switch operation {
        // start and end parenthesis are reversed because the equation is solved backwards.
      case .startParenthesis:
//        print("Done  sub-processing: \(string(from: currValue)) \(currElement) on \(mathEquation)")
        return currValue
      case .endParenthesis:
        // Why does addition work, or doesn't it?
        currValue += Int(mathEquation.popFirst()!)!
      case .addition:
        currValue += Int(mathEquation.popFirst()!)!
      case .multiplication:
        currValue *= Int(mathEquation.popFirst()!)!
      }
//      print("Done  sub-processing: \(string(from: currValue)) \(currElement) on \(mathEquation)")
    }

    return currValue
  }

  static private func getAnswer1(given equations: [[String]]) -> String {
    return "\(equations.map({ compute(mathEquation: $0, hasPrecedence: false) }).sum())"
//    return "\(compute(mathEquation: components))" // 26,508
  }

  static private func getAnswer2(given equations: [[String]]) -> String {
    return "\(equations.map({ compute(mathEquation: $0, hasPrecedence: true) }).sum())"
  }
}
