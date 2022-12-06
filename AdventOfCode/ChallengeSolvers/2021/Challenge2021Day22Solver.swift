//
//  Challenge2021Day22Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2021Day22Solver: ChallengeSolver {
  static let defaultValue0 = """
on x=10..12,y=10..12,z=10..12
on x=11..13,y=11..13,z=11..13
off x=9..11,y=9..11,z=9..11
on x=10..10,y=10..10,z=10..10
"""

  static let defaultValue = """
on x=-20..26,y=-36..17,z=-47..7
on x=-20..33,y=-21..23,z=-26..28
on x=-22..28,y=-29..23,z=-38..16
on x=-46..7,y=-6..46,z=-50..-1
on x=-49..1,y=-3..46,z=-24..28
on x=2..47,y=-22..22,z=-23..27
on x=-27..23,y=-28..26,z=-21..29
on x=-39..5,y=-6..47,z=-3..44
on x=-30..21,y=-8..43,z=-13..34
on x=-22..26,y=-27..20,z=-29..19
off x=-48..-32,y=26..41,z=-47..-37
on x=-12..35,y=6..50,z=-50..-2
off x=-48..-32,y=-32..-16,z=-15..-5
on x=-18..26,y=-33..15,z=-7..46
off x=-40..-22,y=-38..-28,z=23..41
on x=-16..35,y=-41..10,z=-47..6
off x=-32..-23,y=11..30,z=-14..3
on x=-49..-5,y=-3..45,z=-29..18
off x=18..30,y=-20..-8,z=-3..13
on x=-41..9,y=-7..43,z=-33..15
on x=-54112..-39298,y=-85059..-49293,z=-27449..7877
on x=967..23432,y=45373..81175,z=27513..53682
"""

  struct Instruction: CustomStringConvertible {
    let state: Bool
    let minX: Int
    let maxX: Int
    let minY: Int
    let maxY: Int
    let minZ: Int
    let maxZ: Int

    init(description: String) {
      let topLevelComponents = description.components(separatedBy: .whitespaces)
      state = (topLevelComponents.first! == "on")

      let numbers = topLevelComponents.last!.removeCharacters(from: "xyz=").components(separatedBy: ",")

      let xNumbers = numbers[0].components(separatedBy: "..")
      minX = Int(xNumbers[0])!
      maxX = Int(xNumbers[1])!

      let yNumbers = numbers[1].components(separatedBy: "..")
      minY = Int(yNumbers[0])!
      maxY = Int(yNumbers[1])!

      let zNumbers = numbers[2].components(separatedBy: "..")
      minZ = Int(zNumbers[0])!
      maxZ = Int(zNumbers[1])!
    }

    var description: String {
      return "\(state ? "on" : "off") x:\(minX)...\(maxX), y: \(minY)...\(maxY), z: \(minZ)...\(maxZ)"
    }
  }

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let instructions = inputComponents(from: input).map({ Instruction(description: $0) })
    switch challengeNumber {
    case .one:
      return getAnswer1(given: instructions)
    case .two:
      return getAnswer2(given: instructions)
    }
  }

  static private func getAnswer1(given instructions: [Instruction]) -> String {
    var map = [[[Bool]]](repeating: false, z: 101, x: 101, y: 101)
    for instruction in instructions {
      let minX = max(instruction.minX, -50) + 50
      let maxX = min(instruction.maxX, 50) + 50
      let minY = max(instruction.minY, -50) + 50
      let maxY = min(instruction.maxY, 50) + 50
      let minZ = max(instruction.minZ, -50) + 50
      let maxZ = min(instruction.maxZ, 50) + 50
      guard minX < maxX && minY < maxY && minZ < maxZ else {
        print("Skipping instruction: \(instruction)")
        continue
      }
      for x in minX...maxX {
        for y in minY...maxY {
          for z in minZ...maxZ {
            map[x][y][z] = instruction.state
          }
        }
      }
    }
    return "\(map.map({ $0.map({ $0.filter({ $0 }).count }).sum() }).sum())"
  }

  static private func getAnswer2(given instructions: [Instruction]) -> String {
//    let map =
    var minX = Int.max
    var maxX = Int.min
    var minY = Int.max
    var maxY = Int.min
    var minZ = Int.max
    var maxZ = Int.min

    for instruction in instructions {
      minX = min(minX, instruction.minX)
      maxX = max(maxX, instruction.maxX)
      minY = min(minY, instruction.minY)
      maxY = max(maxY, instruction.maxY)
      minZ = min(minZ, instruction.minZ)
      maxZ = max(maxZ, instruction.maxZ)
    }
    return "x:\(minX)...\(maxX), y: \(minY)...\(maxY), z: \(minZ)...\(maxZ)"
//    return ""
  }
}

extension String {

  func removeCharacters(from forbiddenChars: CharacterSet) -> String {
    let passed = self.unicodeScalars.filter { !forbiddenChars.contains($0) }
    return String(String.UnicodeScalarView(passed))
  }

  func removeCharacters(from: String) -> String {
    return removeCharacters(from: CharacterSet(charactersIn: from))
  }
}
