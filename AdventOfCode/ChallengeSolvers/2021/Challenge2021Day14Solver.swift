//
//  Challenge2021Day14Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2021Day14Solver: ChallengeSolver {
  static let defaultValue = """
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    var lines = inputComponents(from: input)
    let equation = lines.removeFirst()
    var formulas = [String: String]()
    for line in lines {
      let components = line.components(separatedBy: " -> ")
      guard components.count == 2 else {
        print("Bad components: \(line)")
        continue
      }
      formulas[components.first!] = components.last!
    }

    switch challengeNumber {
    case .one:
      return getAnswer1(given: equation, formulas: formulas)
    case .two:
      return getAnswer2(given: equation, formulas: formulas)
    }
  }



  static private func getAnswer1(given template: String, formulas: [String: String]) -> String {
    var template = template
    for _ in 0..<10 {
      var newTemplate = ""
      for index in 0..<(template.count-1) {
        newTemplate.append(template[unsafe: index])
        let compound = template.substring(starting: index, length: 2)
        if let newElement = formulas[compound] {
          newTemplate.append(newElement)
        }
      }
      newTemplate.append(template.last!)
      template = newTemplate
    }

    var elementCounts = [String.Element: Int]()
    for char in template {
      elementCounts.incrementValue(for: char, by: 1)
    }
    let counts = elementCounts.values
    let max = counts.max()!
    let min = counts.min()!
    return "\(max - min)"
  }

  static private func getAnswer2(given template: String, formulas: [String: String]) -> String {
    // The string gets exponentially longer as it loops, but the components hit a ceiling pretty fast.
    // The limited number of elements means there is a limited number of pairs, which limits the calculations per loop.
    // Can solve answer 1, but keeping separate because that's how they were solved.
    var components = [String: Int]()
    for i in 0..<(template.count-1) {
      components.incrementValue(for: template.substring(starting: i, length: 2), by: 1)
    }

    for _ in 0..<40 {
      let existingComponents = components.filter({ $1 > 0 })
      for component in existingComponents.keys {
        if let newElement = formulas[component] {
          let count = existingComponents[component]!
          components.decrementValue(for: component, by: count)
          components.incrementValue(for: String(component.first!) + newElement, by: count)
          components.incrementValue(for: newElement + String(component.last!), by: count)
        }
      }
    }

    // Need to increase the count of the last character by 1 because it isn't counted in the loop below
    var elementCounts = [template.last!: 1]
    for (component, count) in components {
      elementCounts.incrementValue(for: component.first!, by: count)
    }

    let counts = elementCounts.values
    let max = counts.max()!
    let min = counts.min()!
    return "\(max - min)"
  }
}

private extension Dictionary where Key == String, Value == Int {
  func nonZeroElements() -> Self {
    return filter({ $1 > 0 })
  }
}
