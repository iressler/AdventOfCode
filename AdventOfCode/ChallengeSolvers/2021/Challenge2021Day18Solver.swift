//
//  Challenge2021Day18Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

protocol SnailNumeric: AnyObject {
  var id: UUID { get }
  var value: Int { get }
  var parent: Challenge2021Day18Solver.SnailNumber? { get set }

  func split() -> Challenge2021Day18Solver.SnailNumber?

  var depth: Int { get }

  var numberThatShouldExplode: Challenge2021Day18Solver.SnailNumber? { get }

  var magnitude: Int { get }

  // Returns a copy without a parent set.
  func copy() -> SnailNumeric
}

extension SnailNumeric {
  var depth: Int {
    var depth = 0
    var currNode: SnailNumeric = self
    while let parentNode = currNode.parent {
      depth += 1
      currNode = parentNode
    }
    return depth
  }

  func split() -> Challenge2021Day18Solver.SnailNumber? {
    fatalError("Split should not be called on this type!!")
  }
}

struct Challenge2021Day18Solver: ChallengeSolver {
  static let defaultValue0 = "[5,[[[[[9,8],1],2],3],4]]"
  static let defaultValue1 = "[[[[[9,8],1],2],3],4]"
  static let defaultValue2 = "[7,[6,[5,[4,[3,2]]]]]"
  static let defaultValue3 = "[[6,[5,[4,[3,2]]]],1]"
  static let defaultValue4 = "[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]"
  static let defaultValue5 = "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]"

  static let defaultValue6 = """
[1,1]
[2,2]
[3,3]
[4,4]
[5,5]
[6,6]
"""

  static let defaultValue7 = """
[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
[7,[5,[[3,8],[1,4]]]]
[[2,[2,2]],[8,[8,1]]]
[2,9]
[1,[[[9,3],9],[[9,0],[0,7]]]]
[[[5,[7,4]],7],1]
[[[[4,2],2],6],[8,7]]
"""

  static let defaultValue = """
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
"""

  class SnailInt: SnailNumeric, ExpressibleByIntegerLiteral, CustomStringConvertible {
    var id = UUID()

    var value: Int
    var parent: SnailNumber?

    init(_ value: Int) {
      self.value = value
    }

    required convenience init(integerLiteral value: Int) {
      self.init(value)
    }

    convenience init?(_ description: String) {
      guard let value = Int(description) else {
        return nil
      }
      self.init(value)
    }

    let numberThatShouldExplode: Challenge2021Day18Solver.SnailNumber? = nil

    func split() -> SnailNumber? {
      guard self.value >= 10 else {
        return nil
      }
      let newX: Int = value / 2
      return SnailNumber(x: newX, y: value - newX)
    }

    var magnitude: Int {
      return value
    }

    func copy() -> SnailNumeric {
      return SnailInt(value)
    }

    var description: String {
      return String(describing: value)
    }
  }

  class SnailNumber: SnailNumeric, CustomStringConvertible {
    let id = UUID()
    var x: SnailNumeric
    var y: SnailNumeric

    var parent: SnailNumber?

    init(x: SnailNumeric, y: SnailNumeric) {
      self.x = x
      self.y = y

      self.x.parent = self
      self.y.parent = self
    }

    convenience init(x: Int, y: Int) {
      self.init(x: SnailInt(x), y: SnailInt(y))
    }

    convenience init(description descriptionString: String) {
      var description = descriptionString
      // Start with an invalid number for padding, since Int(0) == Int(-0)
      var matches = [SnailNumber(x: -1, y: -1)]
      let regex = try! NSRegularExpression(pattern: "\\[-?[0-9]+,-?[0-9]+\\]", options: [])
      while let match = regex.firstMatch(in: description, options: [], range: NSRange(location: 0, length: description.utf16.count)) {
//        print(description[match.range])
        let components = description[match.range][unsafe: 1..<match.range.length-1].components(separatedBy: ",")
        description.replaceSubstring(at: match.range, with: "-\(matches.count)")
//        print(description)
        let x = Int(components[0])!
        let y = Int(components[1])!

        let xSnailNumber: SnailNumeric
        let ySnailNumber: SnailNumeric

        if x >= 0 {
          xSnailNumber = SnailInt(x)
        } else {
          xSnailNumber = matches[abs(x)]
        }

        if y >= 0 {
          ySnailNumber = SnailInt(y)
        } else {
          ySnailNumber = matches[abs(y)]
        }

        matches.append(SnailNumber(x: xSnailNumber, y: ySnailNumber))
      }
      self.init(x: matches.last!.x, y: matches.last!.y)
    }

    func replace(child: SnailNumeric, with newChild: SnailNumeric) {
      newChild.parent = self
      if x.id == child.id {
        self.x = newChild
      } else {
        self.y = newChild
      }
    }

    var numberThatShouldExplode: Challenge2021Day18Solver.SnailNumber? {
      // If there are any children that should explode explode them first.
      if let num = x.numberThatShouldExplode ?? y.numberThatShouldExplode {
        return num
      } else if depth >= 4 {
        return self
      }
      return nil
    }

    // [[[[[9,8],1],2],3],4]
    // [5,[[[[[9,8],1],2],3],4]]
    private var lhsNeighbor: SnailInt? {
      var currNode: SnailNumber = self
      var parentNode: SnailNumber?
      while let parent = currNode.parent {
        let yIsCurrNode = parent.y.id == currNode.id
        currNode = parent
        // Break if the y is the current node, because there is a number to the left.
        if yIsCurrNode {
          parentNode = currNode
          break
        }
      }

      guard let parentNode = parentNode else {
        return nil
      }

      var childNode = parentNode.x

      while let newNode = (childNode as? SnailNumber)?.y{
        childNode = newNode
      }

      if let int = childNode as? SnailInt {
        return int
      } else if let number = childNode as? SnailNumber {
        return (number.y as! SnailInt)
      }
      fatalError("Unexpected child Node: \(childNode)")
    }

    private var rhsNeighbor: SnailInt? {
      var currNode: SnailNumber = self
      var parentNode: SnailNumber?
      while let parent = currNode.parent {
        let xIsCurrNode = parent.x.id == currNode.id
        currNode = parent
        // Break if the y is the current node, because there is a number to the left.
        if xIsCurrNode {
          parentNode = currNode
          break
        }
      }

      guard let parentNode = parentNode else {
        return nil
      }

      var childNode = parentNode.y

      while let newNode = (childNode as? SnailNumber)?.x{
        childNode = newNode
      }

      if let int = childNode as? SnailInt {
        return int
      } else if let number = childNode as? SnailNumber {
        return (number.x as! SnailInt)
      }
      fatalError("Unexpected child Node: \(childNode)")
    }

    private func explode(_ numberThatShouldExplode: SnailNumber) {
//      print("Before explode:   \(self)")
//      print(numberThatShouldExplode)
      if let leftNeighbor = numberThatShouldExplode.lhsNeighbor {
        leftNeighbor.value += numberThatShouldExplode.x.value
//        print("After lhs update: \(self)")
//        print(leftNeighbor)
      }

      if let rightNeighbor = numberThatShouldExplode.rhsNeighbor {
        rightNeighbor.value += numberThatShouldExplode.y.value
//        print(rightNeighbor)
//        print("After rhs update: \(self)")
      }

      numberThatShouldExplode.parent!.replace(child: numberThatShouldExplode, with: SnailInt(0))
//      print("After explode:    \(self)")
    }

    private var isLeafNumber: Bool {
      return (x as? SnailInt) != nil && (y as? SnailInt) != nil
    }

    // Useful for debugging broken parent - child relationships.
    var brokenConnection: Bool {
      var snailNumbers = [self]
      while let snailNumber = snailNumbers.popLast() {
        if snailNumber.id != self.id && snailNumber.parent == nil {
          return true
        }

        for newSnailNumber in [snailNumber.y, snailNumber.x] {
          if let number = newSnailNumber as? SnailNumber {
            snailNumbers.append(number)
          } else if let int = newSnailNumber as? SnailInt {
            if int.parent == nil {
              return true
            }
          } else {
            fatalError("What is the new SnailNumber: \(newSnailNumber)")
          }
        }
      }
      return false
    }

    func reduce() {
      while true {
//        print(self)
        var snailNumbers: [SnailNumeric] = [self]
        var changed = false
        // Only split the first number if no explosions occur.
        // Because a split may cause explosions to occur that would change the following splits.
        var numberToSplit: SnailInt?
        while let snailNumeric = snailNumbers.popLast() {
          // Used for debugging broken child-parent relationships.
//          guard !self.brokenConnection else {
//            fatalError("Things are busted")
//          }

          // Don't explode non-leaf nodes, because their subNodes need to be exploded first.
          if let snailNumber = snailNumeric as? SnailNumber {
            if snailNumber.isLeafNumber && snailNumber.depth >= 4 {
              explode(snailNumber)
              changed = true
//              print("Exploded into: \(self)")
              break
//            } else {
//              print("               \(self)")
            }
            snailNumbers.append(contentsOf: [snailNumber.y, snailNumber.x])
          } else if numberToSplit == nil, let snailInt = snailNumeric as? SnailInt, snailInt.value >= 10 {
            numberToSplit = snailInt
          }
        }

        // If no explosions were performed check if there are any splits or if the SnailNumber is reduced.
        if !changed {
          // Split the SnailNumber if there is a SnailNumber to split.
          if let numberToSplit = numberToSplit {
            numberToSplit.parent!.replace(child: numberToSplit, with: numberToSplit.split()!)
//            print("Split into:    \(self)")
          // Otherwise no more explosions or splits left, done reducing.
          } else {
            break
          }
        }
      }
    }

    func add(_ snailNumber: SnailNumeric) -> SnailNumber {
      let newNumber = SnailNumber(x: copy(), y: snailNumber.copy())
      newNumber.reduce()
      return newNumber
    }

    // Not sure why internal?
    internal var value: Int {
      return x.value + y.value
    }

    var magnitude: Int {
      return (3 * x.magnitude) + (2 * y.magnitude)
    }

    func copy() -> SnailNumeric {
      return SnailNumber(x: x.copy(), y: y.copy())

    }

    var description: String {
      return "[\(x),\(y)]"
    }
  }

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let snailNumbers = inputComponents(from: input).map({ SnailNumber(description: $0) })
    switch challengeNumber {
    case .one:
      return getAnswer1(given: snailNumbers)
    case .two:
      return getAnswer2(given: snailNumbers)
    }
  }

  static private func getAnswer1(given snailNumbers: [SnailNumber]) -> String {
    let totalSumSnailNumber = snailNumbers[1..<snailNumbers.count].reduce(snailNumbers[0]) { partialResult, nextSnailNumber in
      return partialResult.add(nextSnailNumber)
    }
    print(totalSumSnailNumber)
    return "\(totalSumSnailNumber.magnitude)"
  }

  static private func getAnswer2(given snailNumbers: [SnailNumber]) -> String {
    var maxMagnitude = 0
    for lhs in snailNumbers {
      for rhs in snailNumbers {
        if lhs.id == rhs.id {
          continue
        }

        maxMagnitude = max(maxMagnitude, lhs.add(rhs).magnitude)
      }
    }
    return "\(maxMagnitude)"
  }
}
