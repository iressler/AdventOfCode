//
//  Challenge2021Day21Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

protocol Dice {
  var totalRolls: Int { get }
  mutating func roll3Times() -> Int
}

struct Challenge2021Day21Solver: ChallengeSolver {
  static let defaultValue = """
Player 1 starting position: 4
Player 2 starting position: 8
"""

  static let defaultValue1 = """
Player 1 starting position: 6
Player 2 starting position: 8
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let players = inputComponents(from: input).map({ Player(position: Int($0.components(separatedBy: .whitespaces).last!)!) })
    switch challengeNumber {
    case .one:
      return getAnswer1(given: players)
    case .two:
      return getAnswer2(given: players)
    }
  }

  struct Player: Hashable, CustomStringConvertible {
    private(set) var position: Int
    private(set) var score: Int = 0

    init(position: Int) {
      self.position = position
    }

    mutating func moveForward(by amount: Int) {
      position += amount

      while position > 10 {
        position -= 10
      }
      score += position
    }

    var description: String {
      return "(\(position), \(score))"
    }
  }

  struct DeterministicDie: Dice {
    private var lastRoll: Int = 0
    private(set) var totalRolls: Int = 0

    mutating func roll3Times() -> Int {
      var result: Int = 0
      for _ in 0..<3 {
        roll()
        result += lastRoll
      }
      return result
    }

    private mutating func roll() {
      lastRoll += 1
      if lastRoll == 101 {
        lastRoll = 1
      }
      totalRolls += 1
    }
  }

  static private func getAnswer1(given players: [Player]) -> String {
    var players = players
    var die = DeterministicDie()
    while players.scores.max()! < 1000 {
      for i in 0..<players.count {
        players[i].moveForward(by: die.roll3Times())
        if players[i].score >= 1000 {
          break
        }
      }
    }

    return "\(players.scores.min()! * die.totalRolls)"
  }

  struct GameState: Hashable, CustomStringConvertible {
    var players: [Player]
    var currPlayerTurn: Int

    var hasWinner: Int? {
      if players.first!.score >= 21 {
        return 0
      } else if players.last!.score >= 21 {
        return 1
      } else {
        return nil
      }
    }

    mutating func roll(result: Int) {
      players[currPlayerTurn].moveForward(by: result)

//      var oldPlayerTurn = currPlayerTurn
      currPlayerTurn = abs(currPlayerTurn-1)
//      print(currPlayerTurn)
    }

    var description: String {
//      return "\(currPlayerTurn): \(players)"
      return "(\(players.first!.position), \(players.last!.position), \(players.first!.score), \(players.last!.score), \(currPlayerTurn+1))"
    }
  }

  static let diceRollProbabilities = [0, 0, 0, 1, 3, 6, 7, 6, 3, 1]
//  static let diceRollProbabilities = [0, 0, 1, 2, 1]

  static var didPrint = false
  static private func getAnswer2(given players: [Player]) -> String {
    var cache = [GameState(players: players, currPlayerTurn: 0): 1]
    var wins = [Int](repeating: 0, count: players.count)
    var i = 0

//    var printedWin = false
    var printed = false

    while !cache.isEmpty {
//      print(cache.count)
      let cacheCount = cache.count
      func safeprint(_ line: Any) {
        if !didPrint && cacheCount > 5000 {
          printed = true
          print(line)
        }
      }

      if !didPrint && cacheCount > 5000 {
        for (game, gameCount) in cache {
          safeprint("(\(game.description), \(gameCount))")
        }
      }

//      if i == 4 {
//      safeprint("===============================")
//      if !didPrint && cache.count > 500 && cache.count < 5000 {
//        didPrint = true
//        var values = [(GameState, Int)]()
//        // Can't make enumeration work?
//        for (key, value) in cache {
//          values.append((key, value))
//        }
//
//        print(values.map({ "(\($0.description), \($1))" }).joined(separator: "\n"))
//        for string in strings {
//          print(string)
//        }
//        let sortedCache = cache.enumerated().sorted { lhs, rhs -> Bool in
//        }
//        for (game, gameCount) in sortedCache {
//
//        }
//      }
      safeprint(cache.count)
//      safeprint(cache)
//      safeprint("===============================")
//      if i >= 2 {
//        var results = [Int: [(GameState, Int)]]()
//
//        for (game, gameCount) in cache {
//          results.appendValue(for: game.players.first!.score, (game, gameCount))
//        }
//
//        printDivider()
//        for (key, value) in results {
//          print("\(key): \(value.map({ $1 }).sum()): \(value)")
//        }
//        printDivider()
//      }
      i+=1
      var j = 0
      var newCache = [GameState: Int]()
      while let (game, gameCount) = cache.popFirst() {
        // 3...9 because the minimum of the 3 rolls is 3, and the max is 9.
        for roll in 3...9 {
          var currGame = game
//          let currPlayerID = "p\(currGame.currPlayerTurn+1)"
          currGame.roll(result: roll)
          let totalGamesInCurrGameState = gameCount * diceRollProbabilities[roll]
          if let winner = game.hasWinner {
            wins[winner] += totalGamesInCurrGameState
//            safeprint("(\(game.description), \(gameCount)) \(currPlayerID) rolling a \(roll) made win \(totalGamesInCurrGameState) times.")
//            print("Player #\(winner+1) won \(totalGamesInCurrGameState) more times.")
          } else {
            newCache.incrementValue(for: currGame, by: totalGamesInCurrGameState)
//            safeprint("(\(game.description), \(gameCount)) \(currPlayerID) rolling a \(roll) made \(currGame) become: \(newCache[currGame]!)")
          }
        }
        j += 1
      }
      safeprint(newCache.count)
      if !didPrint {
        didPrint = printed
      }
      cache = newCache
    }

      // There must be a better way to do this.
//      for roll1 in 1...3 {
//        for roll2 in 1...3 {
//          for roll3 in  1...3 {
//            for roll4 in 1...3 {
//              for roll5 in 1...3 {
//                for roll6 in 1...3 {
//                  var currPlayers = players
//                  let rollTotals = [roll1 + roll2 + roll3, roll4 + roll5 + roll6]
//                  for playerIndex in 0..<currPlayers.count {
//                    currPlayers[playerIndex].moveForward(by: rollTotals[playerIndex])
//                    totalRolls += 3
//                    if currPlayers[playerIndex].score >= 21 {
//                      wins[playerIndex] += gameCount
//                      break
//                    }
//                  }
//
//                  if currPlayers.scores.max()! < 21 {
//                    let existingValue = cache[currPlayers] ?? 0
//                    cache[currPlayers] = existingValue + gameCount + 1
//                    print("\(existingValue) + \(gameCount) + 1 = \(existingValue + gameCount + 1)")
//                  }
//                  i += 1
//                }
//              }
//            }
//          }
//        }
//      }
//    }
    return "\(wins.max()!)"
  }
}

private extension Collection where Element == Challenge2021Day21Solver.Player {
  var scores: [Int] {
    map({ $0.score })
  }
}
