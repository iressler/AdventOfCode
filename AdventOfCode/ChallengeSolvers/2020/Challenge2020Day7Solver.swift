//
//  Challenge2020Day7Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2020Day7Solver: ChallengeSolver {
  struct RuleDictionary: CustomStringConvertible {
    struct Rule: CustomStringConvertible {
      let color: String
      let amount: Int

      var description: String {
        return "\(amount) \(color) bag\(amount != 1 ? "s" : "")"
      }
    }

    let contains: [String: [Rule]]
    let containedBy: [String: [String]]

    init(rules: [String]) {
      var allContainsRules = [String: [Rule]]()
      var allContainedByRules = [String: [String]]()

      for ruleString in rules {
        let allBags = ruleString.components(separatedBy: " bags contain ")
        let outerBagColor = allBags.first!
        var contains = [Rule]()

        if allBags.last! != "no other bags." {
          for containedBag in allBags.last!.components(separatedBy: ", ") {
            let bagInfo = containedBag.components(separatedBy: " ")
            let amount = Int(bagInfo.first!)!
            let color = bagInfo[1..<(bagInfo.count - 1)].joined(separator: " ")
            contains.append(Rule(color: color, amount: amount))
          }
        }

        allContainsRules[outerBagColor] = contains

        for bag in contains {
          allContainedByRules.appendValue(for: bag.color, outerBagColor)
        }
      }

      self.contains = allContainsRules
      self.containedBy = allContainedByRules
    }


    var description: String {
      var description = ""
      for (color, rules) in contains {
        let rulesString: String
        if rules.isEmpty {
          rulesString = "no other bags"
        } else {
          rulesString = rules.map({ $0.description }).joined(separator: ", ")
        }
        description.append("\(color) bags contain \(rulesString).\n")
      }
      return description
    }
  }

  private class Node: CustomStringConvertible {
    let bag: RuleDictionary.Rule
    let parent: Node?
    var children: [Node] = []

    init(bag: RuleDictionary.Rule, parent: Node?) {
      self.bag = bag
      self.parent = parent
      parent?.children.append(self)
    }

    var totalBags: Int {
      return (bag.amount * children.map({ $0.totalBags }).sum()) + bag.amount
    }

    var description: String {
      return description(indentationLevel: 0)
    }

    private func description(indentationLevel: Int) -> String {
      var description = "\(String(repeating: "\t", count: indentationLevel))\(bag.amount) \(bag.color) contains:\n"
      for child in children {
        description.append(child.description(indentationLevel: indentationLevel+1))
      }
      return description
    }
  }

  static let defaultValue = """
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
"""

  static let defaultValue2 = """
shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags.
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let rules = RuleDictionary(rules: inputComponents(from: input, defaultValue: challengeNumber == .one ? defaultValue : defaultValue2))
    switch challengeNumber {
    case .one:
      return getAnswer1(given: rules)
    case .two:
      return getAnswer2(given: rules)
    }
  }

  static private func getAnswer1(given rules: RuleDictionary) -> String {
    var checkedBags = Set<String>()

    guard var bagsToCheck = rules.containedBy["shiny gold"] else {
      return "Could not find any bags that can contain a shiny gold bag."
    }

    while let currBag = bagsToCheck.popLast() {
      // If the bag was already checked nothing left to do.
      if checkedBags.contains(currBag) {
        continue
      }

      checkedBags.insert(currBag)
      if let newBags = rules.containedBy[currBag] {
        bagsToCheck.append(contentsOf: newBags.filter({ !checkedBags.contains($0) }))
      }
    }
    print(rules)
    return "\(checkedBags.count)"
  }

  static private func getAnswer2(given rules: RuleDictionary) -> String {
    let bagsTree = Node(bag: RuleDictionary.Rule(color: "shiny gold", amount: 1), parent: nil)

    guard var bagsToCheck = rules.contains["shiny gold"]?.map({ Node(bag: $0, parent: bagsTree) }) else {
      return "Could not find any bags that can contain a shiny gold bag."
    }

    while let currBagNode = bagsToCheck.popLast() {
      // If the bag was already checked nothing left to do.
      guard let newNodes = rules.contains[currBagNode.bag.color]?.map({ Node(bag: $0, parent: currBagNode) }) else {
        continue
      }
      bagsToCheck.append(contentsOf: newNodes)
    }

    // - 1 because this isn't counting the outer bag.
    return "\(bagsTree.totalBags - 1)"
  }
}
