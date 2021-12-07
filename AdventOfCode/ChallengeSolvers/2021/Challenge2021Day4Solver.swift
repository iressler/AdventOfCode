//
//  Challenge2021Day4Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/4/21.
//

import Foundation

struct Challenge2021Day4Solver: ChallengeSolver {
  struct BingoGame {
    struct Board: Equatable, CustomStringConvertible {
      private struct Point: CustomStringConvertible {
        let row: Int
        let column: Int

        var description: String {
          return "\(row), \(column)"
        }
      }

      struct Entry: CustomStringConvertible {
        let number: Int
        var marked: Bool = false

        init(_ number: Int) {
          self.number = number
        }

        static private let numberFormatter : NumberFormatter = {
          let formatter = NumberFormatter()
          formatter.numberStyle = .decimal
          formatter.minimumIntegerDigits = 2
          return formatter
        }()
        var description: String {
          return "\(Self.numberFormatter.string(from: NSNumber(value: number))!)\(marked ? "☑" : "□")"
        }
      }

      var entries: [[Entry]]

      static var boardsCreated = 0
      private var boardID: Int
      private var enableLogging: Bool = false

      init(lines: [String]) {
        self.boardID = Self.boardsCreated
        Self.boardsCreated += 1
//        print("components: \(lines.map({ $0.components(separatedBy: .whitespaces) }))")
        self.entries = lines.map({ $0.components(separatedBy: .whitespaces).filter({ !$0.isEmpty }).map({ Entry(Int($0)!) }) })
      }

      private func log(_ log: String) {
        if enableLogging {
          print("board #\(boardID): \(log)")
        }
      }

      mutating func markEntry(number: Int) -> Bool {
//        if boardID == 0 {
//          enableLogging = true
//        }
        defer {
          enableLogging = false
        }
        log("Searching for number: \(24)")
        guard let point = pointForEntryMatching(number) else {
          log("did not find number")
          return false
        }
        log("Found number at: \(point)")
        return isWinning(updatedPoint: point)
      }

      private mutating func pointForEntryMatching(_ number: Int) -> Point? {
        for row in 0..<entries.count {
          for column in 0..<entries[row].count {
            let entry = entries[row][column]
            if entry.number == number {
              entries[row][column].marked = true
              return Point(row: row, column: column)
            }
          }
        }
        return nil
      }

      private func isWinning(updatedPoint point: Point) -> Bool {
        // If the entire row is marked
        if isWinningRowAt(index: point.row) {
          log("Won via row")
          return true
        }

        if IsWinningColumnAt(index: point.column) {
          log("Won via column")
          return true
        }

//        if point.row == (entries.count / 2) && point.column == (entries.count / 2) {
//          return isWinningDiagonal1() || isWinningDiagonal2()
//        } else if point.row == point.column {
//          return isWinningDiagonal1()
//        } else if point.row + point.column == (entries.count - 1) {
//          return isWinningDiagonal2()
//        }
        log("did not win")
        return false
      }

      private func isWinningRowAt(index: Int) -> Bool {
        log("checking row: \(entries[index])")
        return entries[index].first(where: { !$0.marked }) == nil
      }

      private func IsWinningColumnAt(index: Int) -> Bool {
        for row in entries {
          if !row[index].marked {
            return false
          }
        }
        return true
      }

      private func isWinningDiagonal1() -> Bool {
        for i in 0..<entries.count {
          if !entries[i][i].marked {
            return false
          }
        }
        return true
      }

      private func isWinningDiagonal2() -> Bool {
        for i in 0..<entries.count {
          if !entries[i][entries.count - i - 1].marked {
            return false
          }
        }
        return true
      }

      static func == (lhs: Board, rhs: Board) -> Bool {
        return lhs.boardID == rhs.boardID
      }

      var description: String {
        return "\n" + entries.map({ "\($0)" }).joined(separator: "\n")
      }
    }

    let numbers: [Int]
    private(set) var boards: [Board]
    private(set) var wonBoards: [Board] = []

    private var lastNumberCalledIndex: Int = -1

    var lastNumberCalled: Int {
      return numbers[lastNumberCalledIndex]
    }

    init(numbers: [Int], boards: [Board]) {
      self.numbers = numbers
      self.boards = boards
    }

    private mutating func callNextNumber() {
      // Increment in advance to make math easier.
      lastNumberCalledIndex += 1
      let number = numbers[lastNumberCalledIndex]
//      print("Calling #\(number)")

      var notWinningBoards = [Board]()
      for i in 0..<boards.count {
        var board = boards[i]
        if board.markEntry(number: number) {
          wonBoards.append(board)
        } else {
          notWinningBoards.append(board)
        }
      }
      self.boards = notWinningBoards
    }

    mutating func runUntil(wins: Int) {
      let wins = wins > 0 ? wins : boards.count
      while wonBoards.count < wins {
        callNextNumber()
      }
    }
  }

  static let defaultValue = """
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let groupedLines = groupedInputComponents(from: input)

    guard groupedLines.count > 1 else {
      fatalError("Not enough input provided")
    }

    let numbers = groupedLines.first!.first!.components(separatedBy: ",").map({ Int($0)! })


    let boards = groupedLines[1..<groupedLines.count].map({ BingoGame.Board(lines: $0) })
    let game = BingoGame(numbers: numbers, boards: boards)

    switch challengeNumber {
    case .one:
      return getAnswer1(given: game)
    case .two:
      return getAnswer2(given: game)
    }
  }

  static private func answer(for board: BingoGame.Board, in game: BingoGame) -> Int {
    let sum = board.entries.reduce(into: 0) { partialResult, row in
      partialResult += row.filter({ !$0.marked }).map({ $0.number }).reduce(into: 0, { $0 += $1 })
    }

    return sum * game.lastNumberCalled
  }

  static private func getAnswer1(given game: BingoGame) -> String {
    // Make it mutable.
    var game = game
    game.runUntil(wins: 1)

    return "\(answer(for: game.wonBoards.first!, in: game))"
  }

  static private func getAnswer2(given game: BingoGame) -> String {
    // Make it mutable.
    var game = game
    game.runUntil(wins: -1)

    return "\(answer(for: game.wonBoards.last!, in: game))"
  }
}
