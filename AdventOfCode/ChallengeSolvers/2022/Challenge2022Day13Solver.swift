//
//  Challenge2022Day13Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

private enum Value: CustomStringConvertible {
  case array([Value])
  case int(Int)

  var description: String {
    switch self {
    case .array(let array):
      return "\(array)"
    case .int(let int):
      return "\(int)"
    }
  }

  static func value(from description: String) -> Value {
    let valueJSON = try! JSONSerialization.jsonObject(with: description.data(using: .utf8)!)
    return valueArray(from: valueJSON as! [Any])
  }

  private static func valueArray(from valueArray: [Any]) -> Value {
    if let intArray = valueArray as? [Int] {
      return .array(intArray.map({ .int($0) }))
    } else {
      return .array(valueArray.map { value in
        if let int = value as? Int {
          return .int(int)
        } else if let array = value as? [Any] {
          return self.valueArray(from: array)
        } else {
          fatalError("Bad type from: \(value)")
        }
      })
    }
  }
}

extension Value: Comparable {
  static func < (lhs: Value, rhs: Value) -> Bool {
    // If the values are equal neither can be less than the other.
    if lhs == rhs {
      return false
    }

    switch (lhs, rhs) {
    case (.int(let lhsInt), .int(let rhsInt)):
      return lhsInt < rhsInt
    case (.int, .array):
      return .array([lhs]) < rhs
    case (.array, .int):
      return lhs < .array([rhs])
    case (.array(let lhsArray), .array(let rhsArray)):
      for i in 0..<min(lhsArray.count, rhsArray.count) {
        if lhsArray[i] < rhsArray[i] {
          return true
        } else if lhsArray[i] > rhsArray[i] {
          return false
        }
      }

      return lhsArray.count < rhsArray.count
    }

  }

  public static func == (_ lhs: Value, _ rhs: Value) -> Bool {
    switch (lhs, rhs) {
    case (.int(let lhsInt), .int(let rhsInt)):
      return lhsInt == rhsInt
    case (.int, .array(let rhsArray)):
      return [lhs] == rhsArray
    case (.array(let lhsArray), .int):
      return lhsArray == [rhs]
    case (.array(let lhsArray), .array(let rhsArray)):
      return lhsArray == rhsArray
    }
  }

}

struct Challenge2022Day13Solver: ChallengeSolver {
  static let defaultValue = """
[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let values = inputComponents(from: input)
      .map({ Value.value(from: $0) })

    switch challengeNumber {
    case .one:
      return getAnswer1(given: values)
    case .two:
      return getAnswer2(given: values)
    }
  }

  static private func getAnswer1(given values: [Value]) -> String {
    guard values.count % 2 == 0 else {
      fatalError("Need an even number of values.")
    }

    var sum = 0
    var packetIndex = 1
    for subValues in values.groups(size: 2) {
      if subValues[0] < subValues[1] {
        sum += packetIndex
      }
      packetIndex += 1
    }

    return "\(sum)"
  }

  static private func getAnswer2(given values: [Value]) -> String {
    let dividerPackets = [Value.value(from: "[[2]]"), Value.value(from: "[[6]]")]
    let packets = (values + dividerPackets).sorted()

    return "\(dividerPackets.map({ packets.firstIndex(of: $0)! + 1 }).product())"
  }}
