//
//  Challenge2020Day16Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2020Day16Solver: ChallengeSolver {
  static let defaultValue = """
class: 1-3 or 5-7
departureRow: 6-11 or 33-44
departureSeat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12
"""


  static let defaultValue1 = """
departureClass: 0-1 or 4-19
departureRow: 0-5 or 8-19
seat: 0-13 or 16-19

your ticket:
11,12,13

nearby tickets:
3,9,18
15,1,5
5,14,9
"""

  private struct Rule: Hashable, CustomStringConvertible {
    let id = UUID()
    let name: String
    let ranges: [ClosedRange<Int>]

    static func == (lhs: Rule, rhs: Rule) -> Bool {
      return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    init?(ruleDescription description: String) {
      let ruleComponents = description.components(separatedBy: .whitespaces)

      self.name = ruleComponents[0].trimmingCharacters(in: .letters.inverted)

      var ranges = [ClosedRange<Int>]()
      for componentIndex in 1..<ruleComponents.count {
        let rangeComponents = ruleComponents[componentIndex].components(separatedBy: "-")
        guard rangeComponents.count == 2,
              let start = Int(rangeComponents[0]),
              let end = Int(rangeComponents[1]) else {
                continue
              }
        ranges.append(start...end)
      }
      self.ranges = ranges
    }

    func contains(_ value: Int) -> Bool {
      for range in ranges {
        if range.contains(value) {
          return true
        }
      }

      return false
    }

    var isDepartureRule: Bool {
      return name.hasPrefix("departure")
    }

    var description: String {
      return "\(name): \(ranges.map({ "\($0.first!)-\($0.last!)" }).joined(separator: ", "))"
    }
  }

  private struct Ticket: Hashable, CustomStringConvertible {
    private let id = UUID()

    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    let values: [Int]

    init(values: [Int]) {
      self.values = values
    }

    init?(valuesString: String) {
      guard !valuesString.isEmpty else {
        return nil
      }
      var values = [Int]()
      for value in valuesString.components(separatedBy: ",") {
        guard let int = Int(value) else {
          return nil
        }
        values.append(int)
      }
      self.init(values: values)
    }

    func invalidValues(for rules: [Rule]) -> [Int] {
      var invalidValues = [Int]()
      for value in values {
        var valueIsValid = false
        for rule in rules {
          if rule.contains(value) {
            valueIsValid = true
            break
          }
        }

        if !valueIsValid {
          invalidValues.append(value)
        }
      }

      return invalidValues
    }

    func validValues(for rule: Rule) -> [Int] {
      return values.filter({ rule.contains($0) })
    }

    var description: String {
      return String(describing: values)
    }
  }

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let defaultValues = ["", defaultValue, defaultValue]
    let lines = inputComponents(from: input, defaultValue: defaultValues[challengeNumber.rawValue], dropEmpty: false)
    var rules = [Rule]()
    var tickets = [Ticket]()

    var i = 0
    repeat {
      rules.append(Rule(ruleDescription: lines[i])!)
      i += 1
    } while !lines[i].isEmpty

    i += 2

    while i < lines.count {
      if let ticket = Ticket(valuesString: lines[i]) {
        tickets.append(ticket)
      }
      i+=1
    }
//    print(rules)
//    print(tickets)
    switch challengeNumber {
    case .one:
      return getAnswer1(given: tickets, rules: rules)
    case .two:
      return getAnswer2(given: tickets, rules: rules)
    }
  }

  static private func getAnswer1(given tickets: [Ticket], rules: [Rule]) -> String {
    // Ignore "my" ticket.
    var allInvalidValues = [Int]()
    for ticket in tickets[1..<tickets.count] {
      allInvalidValues.append(contentsOf: ticket.invalidValues(for: rules))

//      if !invalidValues.isEmpty {
//        print("Ticket \(ticket) is not valid")
//      }
    }
    return "\(allInvalidValues.sum())"
  }

  static private func getAnswer2(given tickets: [Ticket], rules: [Rule]) -> String {
    let myTicket = tickets[0]
    var validTickets = [Ticket]()

    // Find all of the valid tickets (excluding myTicket"
    for ticket in tickets[1..<tickets.count] {
      if ticket.invalidValues(for: rules).isEmpty {
        validTickets.append(ticket)
      }
    }

    // Array of value indices that contain all of the rules that apply to it.
    // After fully initialized rules will be removed as they are placed.
    var orderedRules = [[Rule]](repeating: rules, count: myTicket.values.count)

    // Remove rules from the orderedRules that don't apply to the relevant value in all valid tickets.
    for ticket in validTickets {
      // For every value check all of the rules, and remove any that the value isn't valid for.
      for valueIndex in 0..<ticket.values.count {
        let value = ticket.values[valueIndex]
        // Can't remove in place, collect the indices that need to be removed to remove after looping is done.
        var rulesToRemoveIndices = [Int]()

        // For every rule check if it is valid for the value, and add those that aren't to the list to remove.
        for ruleIndex in 0..<orderedRules[valueIndex].count {
//          print("Checking if Ticket #\(validTickets.firstIndex(of: ticket)!) value #\(i) matches rule #\(ruleIndex)")
          let rule = orderedRules[valueIndex][ruleIndex]
          if !rule.contains(value) {
            rulesToRemoveIndices.append(ruleIndex)
          }
        }

        // If there are rules to remove remove them from orderedRules at the valueIndex.
        if !rulesToRemoveIndices.isEmpty {
          orderedRules.modifyElement(at: valueIndex, using: { $0.remove(at: rulesToRemoveIndices)})
        }
      }
    }

    // Track which rules have already been placed.
    var placedRules = Set<Rule>()

    while !orderedRules.filter({ $0.count > 1 }).isEmpty {
      // Adds to set more than necessary, but does it few enough times the work to reduce the calls isn't worth it.
      for rules in orderedRules where rules.count == 1 {
        placedRules.insert(rules[0])
      }

      for rulesIndex in 0..<orderedRules.count where orderedRules[rulesIndex].count > 1 {
        orderedRules[rulesIndex] = orderedRules[rulesIndex].filter({ !placedRules.contains($0) })
      }
    }

//    print(orderedRules.map({ $0.map({ $0.name }) }))

    let departureValues = orderedRules.enumerated()
      .compactMap({ $1[0].name.hasPrefix("departure") ? $0 : nil  })
      .map({ myTicket.values[$0] })

    return "\(departureValues.product())"
  }
}
