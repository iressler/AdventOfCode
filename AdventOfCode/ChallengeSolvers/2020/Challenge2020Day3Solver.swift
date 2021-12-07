//
//  Challenge2020Day3Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/3/21.
//

import Foundation

struct Challenge2020Day3Solver: ChallengeSolver {
  static let defaultValue = """
..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let trees = inputComponents(from: input)
      .map({ Array($0) })

    switch challengeNumber {
    case .one:
      return getAnswer1(given: trees)
    case .two:
      return getAnswer2(given: trees)
    }
  }

  static private func getAnswer1(given trees: [[String.Element]]) -> String {
    return "\(treesHit(for: Slope(verticalSlope: 1, horizontalSlope: 3), given: trees))"
  }

  struct Slope {
    let verticalSlope: Int
    let horizontalSlope: Int
  }

  static private func treesHit(for slope: Slope, given trees: [[String.Element]]) -> Int {
    var h = 0
    var v = 0

    var treesHit = 0

    while v < trees.count {
//      print("======================================")
      let space = trees[v][wrapping: h]
//
//      for rowIndex in 0..<trees.count {
//        var rowOutput = ""
//        for spaceIndex in 0..<trees[rowIndex].count {
//          if rowIndex == v && spaceIndex == h {
//            if space.isTree {
//              rowOutput.append("X")
//            } else {
//              rowOutput.append("O")
//            }
//          } else {
//            rowOutput.append(trees[rowIndex][wrapping: spaceIndex])
//          }
//        }
//        if rowIndex == v {
//          rowOutput.append(" <===========")
//        }
////        print(rowOutput)
//      }

      if space.isTree {
        treesHit += 1
      }
      h = (((h + slope.horizontalSlope) % trees[0].count) + trees[0].count) % trees[0].count
//      print(h)
      v += slope.verticalSlope
    }

    return treesHit
  }

  static private func getAnswer2(given trees: [[String.Element]]) -> String {
    let v1h1 = treesHit(for: Slope(verticalSlope: 1, horizontalSlope: 1), given: trees)
    let v1h3 = treesHit(for: Slope(verticalSlope: 1, horizontalSlope: 3), given: trees)
    let v1h5 = treesHit(for: Slope(verticalSlope: 1, horizontalSlope: 5), given: trees)
    let v1h7 = treesHit(for: Slope(verticalSlope: 1, horizontalSlope: 7), given: trees)
    let v2h1 = treesHit(for: Slope(verticalSlope: 2, horizontalSlope: 1), given: trees)
    return "\(v1h1 * v1h3 * v1h5 * v1h7 * v2h1)"
  }
}

private extension String.Element {
  var isTree: Bool {
    return self == "#"
  }
}

extension Array {
  subscript(wrapping index: Index) -> Element {
    return self[((index % count) + count) % count]
  }
}
