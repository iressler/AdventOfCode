//
//  Challenge2021Day7Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2021Day13Solver: ChallengeSolver {
  static let defaultValue = """
6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5
"""

  struct Sheet: CustomStringConvertible {
    struct Fold {
      enum Direction: String {
        case horizontal
        case vertical
      }

      let direction: Direction
      let value: Int

      init(column: Int) {
        self.direction = .vertical
        self.value = column
      }

      init(row: Int) {
        self.direction = .horizontal
        self.value = row
      }
    }

    var points: [[Bool]]
    private var folds: [Fold]

    init(points: [Point], folds: [Fold]) {
      self.folds = folds.reversed()
      self.points = [[Bool]](repeating: false, x: points.map({ $0.x }).max()! + 1, y: points.map({ $0.y }).max()! + 1)
      for point in points {
        self.points[point.x][point.y] = true
      }
    }

    @discardableResult
    mutating func fold() -> Bool {
      guard let fold = folds.popLast() else {
        print("No more folds")
        return false
      }
      switch fold.direction {
      case .vertical:
//        print("Folding vertically at \(fold.value)")
        foldVertical(column: fold.value)
      case .horizontal:
//        print("Folding horizontally at \(fold.value)")
        foldHorizontal(row: fold.value)
      }
      return true
    }

    mutating private func foldVertical(column: Int) {
      for j in 0..<column {
        for i in 0..<points.count {
          let mirroredJ = column + (column - j)
          points[i][j] = points[i][j] || points[i][mirroredJ]
        }
      }

      let columnCount = points[0].count

      for i in 0..<points.count {
        points[i] = points[i].dropLast(columnCount - column)
      }
    }

    mutating private func foldHorizontal(row: Int) {
      for i in 0..<row {
        let mirroredI = points.count - i - 1
        for j in 0..<points[i].count {
          points[i][j] = points[i][j] || points[mirroredI][j]
        }
      }

      self.points.removeLast(points.count - row)
    }

    var description: String {
      return points.map({ $0.map({ $0 ? "#" : "." }).joined(separator: "")} ).joined(separator: "\n")
    }
  }

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let lines = inputComponents(from: input)

    var points = [Point]()

    var folds = [Sheet.Fold]()

    for line in lines {
      if let point = Point(pointString: line, rotated: true) {
        points.append(point)
      } else if !line.isEmpty {
        let components = line.components(separatedBy: " ").last!.components(separatedBy: "=")
        let newFold: Sheet.Fold
        if components.first == "x" {
          newFold = Sheet.Fold(column: Int(components.last!)!)
        } else {
          newFold = Sheet.Fold(row: Int(components.last!)!)
        }
        folds.append(newFold)
      }
    }

    let sheet = Sheet(points: points, folds: folds)

    switch challengeNumber {
    case .one:
      return getAnswer1(given: sheet)
    case .two:
      return getAnswer2(given: sheet)
    }
  }

  static private func getAnswer1(given sheet: Sheet) -> String {
    var sheet = sheet
    sheet.fold()
    print(sheet)

    return "\(sheet.points.map({ $0.filter({ $0 } ).count }).sum())"
  }

  static private func getAnswer2(given sheet: Sheet) -> String {
    var sheet = sheet
    while sheet.fold() {}

    // TODO: It would be cool to convert the description into text, but that doesn't seem easy.
    return sheet.description
  }
}
