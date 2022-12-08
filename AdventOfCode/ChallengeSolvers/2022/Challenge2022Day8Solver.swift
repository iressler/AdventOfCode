//
//  Challenge2022Day8Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2022Day8Solver: ChallengeSolver {
  static let defaultValue = """
30373
25512
65332
33549
35390
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let lines = inputComponents(from: input)
    var trees = [[Int]]()

    for line in lines {
      trees.append(Array(line).map({ Int(String($0))! }))
    }
//    print(trees.fieldDescription())
    switch challengeNumber {
    case .one:
      return getAnswer1(given: trees)
    case .two:
      return getAnswer2(given: trees)
    }
  }

  static private func getAnswer1(given trees: [[Int]]) -> String {
    // All of the outside trees are always visible.
    var visibleTreesCount = (trees.count * 2) + (trees[0].count * 2) - 4
    for currTreeX in 1..<(trees.count-1) {
      let currTreeRow = trees[currTreeX]
      for currTreeY in 1..<(currTreeRow.count-1) {
        let currTreeHeight = currTreeRow[currTreeY]


        // If the current tree is not visible from the sides.
        if currTreeRow[currTreeRow.startIndex..<currTreeY].filter({ $0 >= currTreeHeight }).isEmpty ||
            currTreeRow[currTreeY+1..<currTreeRow.endIndex].filter({ $0 >= currTreeHeight}).isEmpty ||
            trees[0..<currTreeX].map({ $0[currTreeY] }).filter({ $0 >= currTreeHeight}).isEmpty ||
            trees[currTreeX+1..<trees.endIndex].map({ $0[currTreeY] }).filter({ $0 >= currTreeHeight}).isEmpty {
          visibleTreesCount += 1
        }
      }
    }
    return "\(visibleTreesCount)"
  }

  private struct ScenicScore {
    var top: Int = 0
    var right: Int = 0
    var bottom: Int = 0
    var left: Int = 0

    var score: Int {
      return top * right * bottom * left
    }
  }

  static private func treesVisible<T: Collection>(in trees: T, maxHeight: Int) -> Int where T.Element == Int {
    var currTreeScore = 0
    for comparisonTreeHeight in trees {
      currTreeScore += 1
      if comparisonTreeHeight >= maxHeight {
        break
      }
    }

    return currTreeScore
  }

  static private func getAnswer2(given trees: [[Int]]) -> String {
    // All of the outside trees always have a scenic score of 0.
    var bestScore = 0
    for currTreeX in 1..<(trees.count-1) {
      let currTreeRow = trees[currTreeX]
      for currTreeY in 1..<(currTreeRow.count-1) {
        let currTreeHeight = currTreeRow[currTreeY]

        let score = treesVisible(in: currTreeRow[0..<currTreeY].reversed(), maxHeight: currTreeHeight) *
        treesVisible(in: currTreeRow[currTreeY+1..<currTreeRow.endIndex], maxHeight: currTreeHeight) *
        treesVisible(in: trees[0..<currTreeX].map({ $0[currTreeY] }).reversed(), maxHeight: currTreeHeight) *
        treesVisible(in: trees[currTreeX+1..<trees.endIndex].map({ $0[currTreeY] }), maxHeight: currTreeHeight)

        if score > bestScore {
          bestScore = score
        }
      }
    }
    return "\(bestScore)"
  }
}
