//
//  Challenge2021Day19Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2021Day19Solver: ChallengeSolver {
  static let defaultValue1 = """
--- scanner 0 ---
0,2
4,1
3,3

--- scanner 1 ---
-1,-1
-5,0
-2,1
"""

  static let defaultValue = """
--- scanner 0 ---
-1,-1,1
-2,-2,2
-3,-3,3
-2,-3,1
5,6,-4
8,0,7

--- scanner 0 ---
1,-1,1
2,-2,2
3,-3,3
2,-1,3
-5,4,-6
-8,-7,0
"""

  private struct Scanner: CustomStringConvertible {
    var points: [Point]

    init(points: [Point]) {
      self.points = points
    }

    init(pointDescriptions: [String]) {
      self.init(points: pointDescriptions.map({ Point(pointString: $0)! }))
    }

    var description: String {
      String(describing: points)
    }
  }

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let lines = inputComponents(from: input, dropEmpty: false)
    let solver = Day19Of2021(dataSet: lines)
    solver.run()

    var scanners = [Scanner]()
    var currPoints = [Point]()
    for line in lines {
      if let point = Point(pointString: line) {
        currPoints.append(point)
      } else {
        scanners.append(Scanner(points: currPoints))
        currPoints.removeAll()
      }
    }

    scanners.append(Scanner(points: currPoints))

    switch challengeNumber {
    case .one:
      return getAnswer1(given: scanners)
    case .two:
      return getAnswer2(given: scanners)
    }
  }

  static private func getAnswer1(given scanners: [Scanner]) -> String {
    var pointDifferences = [Point: [Scanner]]()

    for scanner in scanners {
      for p1Index in 0..<scanner.points.count {
        let p1 = scanner.points[p1Index]
        for p2Index in (p1Index+1)..<scanner.points.count {
          let p2 = scanner.points[p2Index]
          pointDifferences.appendValue(for: Point(x: abs(p1.x-p2.x), y: abs(p1.y-p2.y), z: abs(p1.z-p2.z)), scanner)
        }
      }
    }

    for point in pointDifferences.keys {
      print("\(point): \(pointDifferences[point]!)")
    }
//    print(pointDifferences)

    return ""
  }

  static private func getAnswer2(given scanners: [Scanner]) -> String {
    return ""
  }
}
