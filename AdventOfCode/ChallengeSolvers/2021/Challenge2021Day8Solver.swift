//
//  Challenge2021Day8Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2021Day8Solver: ChallengeSolver {
  struct Input {
    let patterns: [String]
    let outputs: [String]

    init(description: String) {
      let components = description.components(separatedBy: "|")
      guard components.count == 2 else {
        fatalError("Incorrect number of components")
      }

      self.patterns = components.first!.components(separatedBy: .whitespaces).filter({ !$0.isEmpty })
      self.outputs = components.last!.components(separatedBy: .whitespaces).filter({ !$0.isEmpty })

      guard self.patterns.count == 10, self.outputs.count == 4 else {
        fatalError("Not enough patterns \(self.patterns.count) and/or output \(self.outputs.count)")
      }
    }

    func intendedOutputs() -> Int {
      var determinedOutputs = [String: String]()
      var possibleOutputs = [String: [String]]()

      // This always determines the c/f pair, since that is all 1 uses.
      guard let one = patterns.first(where: { $0.count == 2 }) else {
        fatalError("No one pattern")
      }

      var cfPair = [String]()
      for (_, char) in one.enumeratedStrings() {
        possibleOutputs.appendValues(for: char, ["c", "f"])
        cfPair.append(char)
      }

      guard let seven = patterns.first(where: { $0.count == 3 }) else {
        fatalError("No seven pattern")
      }

      // This test always determines a, because it uses a, c, & f, but c & f are used in 1. So whatever isn't used must be a.
      for (_, char) in seven.enumeratedStrings() {
        if possibleOutputs[char] == nil {
          determinedOutputs[char] = "a"
        }
      }

      // This always determines the b/d pair, since it uses b, c, d, & f, but c & f are already paired by 1.
      guard let four = patterns.first(where: { $0.count == 4 }) else {
        fatalError("No four pattern")
      }

      var bdPair = [String]()
      for (_, char) in four.enumeratedStrings() {
        if possibleOutputs[char] == nil {
          possibleOutputs.appendValues(for: char, ["b", "d"])
          bdPair.append(char)
        }
      }

      guard let eight = patterns.first(where: { $0.count == 7 }) else {
        fatalError("No eight pattern")
      }

      var egPair = [String]()
      for (_, char) in eight.enumeratedStrings() {
        if possibleOutputs[char] == nil && determinedOutputs[char] == nil {
          possibleOutputs.appendValues(for: char, ["e", "g"])
          egPair.append(char)
        }
      }

      // All 6 length patterns (0, 6, & 9) contain:
      //  - The a input
      //  - 2 of the cf, bd, and eg input pairs
      //  - A single input from the other input pair.
      //
      // Each of the 0, 6, and 9 are missing an input from a unique pair, which allows determining all of the inputs
      // From them using the pair information from the known number inputs.
      for pattern in patterns where pattern.count == 6 {
        // If it does not contains both parts of the cfPair it must be 6.
        // TODO: Generalize this.
        if !pattern.contains(cfPair.first!) || !pattern.contains(cfPair.last!) {
          for (_, char) in pattern.enumeratedStrings() {
            if determinedOutputs[char] != nil {
              continue
            }
            // This must be the f in the cfPair
            if possibleOutputs[char]!.contains("f") {
              // Update the f char.
              determinedOutputs[char] = "f"
              possibleOutputs[char] = nil

              // The other must be the c char, so update it.
              let (key, _) = possibleOutputs.first(where: { $0.value.contains("c") })!
              determinedOutputs[key] = "c"
              possibleOutputs[key] = nil
              break
            }
          }
          continue
        }

        // If it does not contains both parts of the bdPair it must be 0.
        if !pattern.contains(bdPair.first!) || !pattern.contains(bdPair.last!) {
          for (_, char) in pattern.enumeratedStrings() {
            if determinedOutputs[char] != nil {
              continue
            }
            // This must be the b in the bdPair
            if possibleOutputs[char]!.contains("b") {
              // Update the b char.
              determinedOutputs[char] = "b"
              possibleOutputs[char] = nil

              // The other must be the d char, so update it.
              let (key, _) = possibleOutputs.first(where: { $0.value.contains("d") })!
              determinedOutputs[key] = "d"
              possibleOutputs[key] = nil
              break
            }
          }
          continue
        }

        // Otherwise it must be the 9 (and not contain both parts of the eg pair).
        for (_, char) in pattern.enumeratedStrings() {
          if determinedOutputs[char] != nil {
            continue
          }
          // This must be the g in the egPair
          if possibleOutputs[char]!.contains("g") {
            // Update the g char.
            determinedOutputs[char] = "g"
            possibleOutputs[char] = nil

            // The other must be the e char, so update it.
            let (key, _) = possibleOutputs.first(where: { $0.value.contains("e") })!
            determinedOutputs[key] = "e"
            possibleOutputs[key] = nil
            break
          }
        }
        continue
      }

      return decodeOutputs(using: determinedOutputs.inverted())
    }

    private func code(for number: Int, using codex: [String: String]) -> String {
      // There must be a better way to do this, but it works.
      let codexCode: String
      switch number {
      case 0:
        codexCode = "abcefg"
      case 1:
        codexCode = "cf"
      case 2:
        codexCode = "acdeg"
      case 3:
        codexCode = "acdfg"
      case 4:
        codexCode = "bcdf"
      case 5:
        codexCode = "abdfg"
      case 6:
        codexCode = "abdefg"
      case 7:
        codexCode = "acf"
      case 8:
        codexCode = "abcdefg"
      case 9:
        codexCode = "abcdfg"
      default:
        fatalError("Unsupported number: \(number)")
      }
      var code = ""
      for (_, char) in codexCode.enumeratedStrings() {
        code.append(codex[char]!)
      }
      return code
    }

    private func decodeOutputs(using codex: [String: String]) -> Int {
      var codes = [String]()
      for i in 0..<10 {
        codes.append(code(for: i, using: codex).alphabetized())
      }
      var convertedOutput = ""
      for output in outputs {
        convertedOutput.append("\(codes.firstIndex(of: output.alphabetized())!)")
      }
      return Int(convertedOutput)!
    }
  }

//  static let defaultValue = "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
  static let defaultValue = """
be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let inputs = inputComponents(from: input).map({ Input(description: $0) })

    switch challengeNumber {
    case .one:
      return getAnswer1(given: inputs)
    case .two:
      return getAnswer2(given: inputs)
    }
  }

  static private func getAnswer1(given inputs: [Input]) -> String {
    let validCounts = [2, 4, 3, 7]
    return "\(inputs.flatMap({ $0.outputs.filter({ validCounts.contains($0.count) }) }).count)"
  }

  static private func getAnswer2(given inputs: [Input]) -> String {
    return "\(inputs.map({ $0.intendedOutputs() }).sum())"
  }
}
